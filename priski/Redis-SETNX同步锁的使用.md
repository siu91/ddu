- 最近项目中有这样一个问题：

      1）、A、B两个服务都会对redis定时进行大量读写，阻塞风险很高
      2）、想实现类似一个队列的方式排队获取读写权
      3）、进程间通信比较麻烦

      查阅了一些文档发现 redis SetNx 就能很好的满足这样的场景功能


 利用 redis setNX(set if not exist) 实现同步锁设计, setNX -> set success return 1 else return 0。

- 逻辑代码
```java
多个进程竞争获取锁： A B C -> lock
<p>
竞锁流程（假设资源空闲情况下）：
<p>
1、A 请求 lock ， setNX(lock,sys_time + expire_millis + 1),A 请求到锁的同时，把 锁的 value设为过期的时间
2、过期时间内 B和C 同时请求锁 setNX(...),发现锁已经被其他线程占用
这时B 和 C会 获取 锁的过期时间
若果过期，B 和 C 会强行获取锁 getSet(lock,sys_time + expire_millis + 1),getSet是同步的,B 和 C 只有一个会先获得锁
未过期/未获得锁： 会在超时时间内以随机频率再次请求锁，直到超时时间耗尽
```
- ***Talk is cheap, show you the code~***
 - Redis同步锁 `RedisLock`
  ```Java
  public class RedisLock {
    private static Logger logger = LogManager.getLogger(RedisLock.class.getName());

    /**
     * 默认的请求频率
     */
    private static final int DEFAULT_REQUEST_INTERVAL_MILLIS = 1000;
    private static final Random RANDOM = new Random();

    private RedisRecClient redisClient;
    /**
     * Lock key
     */
    private String lock_key = "rec_sys_lock";

    /**
     * 锁超时时间，防止线程在入锁以后，无限的执行等待
     */
    private int expire_millis = 30 * 1000;

    /**
     * 请求锁等待时间，防止线程饥饿
     */
    private int request_timeout_mills = 10 * 1000;

    private volatile boolean locked = false;
    private volatile String locked_expire_millis_str;


    /**
     * get lock.
     *
     * @return true if lock is acquired, false acquire timeout
     */
    public synchronized boolean lock() {
        int timeout = request_timeout_mills;
        while (timeout >= 0) {
            // 1、获取锁
            long expires = System.currentTimeMillis() + expire_millis + 1;// 时效时间设置为 当前时间 + expire_millis + 1
            String expiresStr = String.valueOf(expires); //锁到期时间
            if (this.setNX(lock_key, expiresStr)) {
                // lock acquired
                locked = true;
                locked_expire_millis_str = expiresStr;
                return true;
            }

            // 2、 如果1获取不到锁，是被其他线程获取了， 判断锁是否过期
            String current_lock_value_time = this.get(lock_key); //redis里的时间
            if (current_lock_value_time != null && Long.parseLong(current_lock_value_time) < System.currentTimeMillis()) {
                //过期时：获取上一个锁到期时间，并设置现在的锁到期时间（只有一个线程才能获取上一个线上的设置时间，因为jedis.getSet是同步的）
                String oldValueStr = this.getSet(lock_key, expiresStr);
                if (oldValueStr != null && oldValueStr.equals(current_lock_value_time)) {
                    locked = true;
                    locked_expire_millis_str = expiresStr;
                    return true;
                }
            }

            // 3、 如果1和2获取不到锁，随机频率再次请求锁
            logger.info("lock request will be timeout in " + timeout / 1000 + " s");
            int interval = DEFAULT_REQUEST_INTERVAL_MILLIS * Math.max(RANDOM.nextInt(10), 1);
            timeout -= interval;
            try {
                Thread.sleep(interval);
            } catch (InterruptedException e) {
                logger.info("InterruptedException:" + e.getCause());
            }

        }
        return false;
    }


    /**
     * release lock.
     * <p>
     * 已知问题：
     * A 获得锁 过期设为30s
     * 在30秒内 A 并没有释放锁（没有执行完成操作）
     * 这时 B 因为 A 已经过期，可以获得到锁，重新设置 30s过期时间
     * 恰好 A 执行完 unlock 就会把 B的锁释放
     */
    public synchronized void unlock() {
        if (locked) {
            redisClient.del(lock_key);
            locked = false;
        }
    }

    /**
     * 多线程情况下：
     * 每个线程在取得锁时保存自己的过期时间，当要释放锁时进行比较，避免释放了其他线程的锁
     *
     * @param expire_millis_str_when_get_lock
     */
    public synchronized void unlock(String expire_millis_str_when_get_lock) {
        if (locked && expire_millis_str_when_get_lock.equals(locked_expire_millis_str)) {
            redisClient.del(lock_key);
            locked = false;
        }
    }

    /**
     * 多进程情况下：
     * 每个进程都单独维护自己的过期时间，不会冲突，只要与redis中的过期时间比较即可
     */
    public synchronized void unlockInProgress() {
        if (locked) {
            String current = this.get(lock_key);
            if (current != null && current.equals(locked_expire_millis_str)) {
                redisClient.del(lock_key);
            }

            locked = false;
        }
    }

}
 ```
