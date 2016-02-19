- 最近项目中有这样一个场景：
 - 在原始日志数据中记录着用户的活动轨迹：`用户+时间+位置`
 - 需要实时捕获`用户在某个位置出现事件`
 - 需要实时捕获`用户在某个位置的滞留事件`


 `用户在某个位置出现事件`捕获比较容易，只要根据位置场景捕获即可。`用户在某个位置的滞留事件`就需要考虑延时事件的处理，于是考虑到使用`DelayQueue`+`Redis记录延时时间内的用户轨迹`来处理。
- 逻辑代码
```java
// 1、判断捕获事件为：DELAY_LOCATION（位置延迟事件） ? 2 : RETURN
// 2、判断 用户是否已经在LOCATION ? 3 : 判断 【标志位】不存在 ?RETURN: 更新【标志位】
// 3、(if 【标志位】不存在 ? 设置【标志位】&& 封装成对象存入延迟队列: 更新【标志位】) &&  将参数捕获存入Redis(链表结构保存)
// 4、监听延迟队列，延时时间到了，判断【标志位】状态 捕获 ? isCapture = true : do nothing
// 5、删除【标志位】
```
- ***Talk is cheap, show you the code~***
 - 延时事件类 `DelayEvent`
  ```Java
  public DelayEvent(String userId,String eventId,String storeTablename,String startValue,long timeStamp,long delayTime,JedisCluster jc,int expire,String dynamicArgs) {
		super();
		this.userId=userId;
		this.eventId=eventId;
		this.storeTablename=storeTablename;
		this.startValue=startValue;
		this.timeStamp=timeStamp;
		// 都转为转为 NANOSECONDS
		this.delayTime = TimeUnit.NANOSECONDS.convert(delayTime,TimeUnit.MILLISECONDS) + System.nanoTime();
	    this.jc=jc;
	    this.expire= expire;
	}
	@Override
	public void run() {
		final String flag=this.jc.get(this.userId+this.eventId);
		if (flag != null) {
			if (!flag.contains(FALSE)) {
				this.jc.setex(storeTablename + userId + ":" + eventId,this.expire, startValue);
			} else {
				Log.info("[DelayEvent] "+"不符合捕获条件：" + eventId + ":" + userId + ":" + flag);
			}
			this.jc.del(this.userId+this.eventId);
			Log.info("[DelayEvent] "+"删除标志位：" +this.userId+this.eventId+ ":" + flag);
		} else {
			Log.error("[DelayEvent] "+"标志位不存在："  + this.userId+this.eventId);
		}
	}

	@Override
	public long getDelay(TimeUnit unit) {
		return unit.convert(delayTime - System.nanoTime(), TimeUnit.NANOSECONDS);
	}
}
 ```
 - 延时监听类`DelayListener`
  ```Java
  public DelayListener(DelayQueue<DelayEvent> events) {
  		super();
  		this.events = events;
  	}

  	@Override
  public void run() {
  		try {
  			com.nl.util.log.Log.info("[DelayListener] 开始……");
  			while (!Thread.interrupted()) {
  				events.take().run();
  			}
  		} catch (InterruptedException e) {
  			e.printStackTrace();
  		}

  	}
  }
  ```
 - 主处理逻辑
  ```Java
			// 1、判断捕获事件为：DELAY_LOCATION（位置延迟事件） ? 2 : RETURN
			if (strExpression != null && strExpression.startsWith("DELAY_LOCATION"))
				final String info[] =   trExpression.split(GlobalConst.DEFAULT_SEPARATOR);
				String tablename = null;
				final long now=System.currentTimeMillis();
				int delayTime;
				if (info.length == 3) {
					if (CommonUtil.isNumeric(info[1])) {
						delayTime = Integer.parseInt(info[1]);
						tablename = info[2];
					} else {
						LOG.info("Worng Expression:" + strExpression);
						continue;
					}
				} else {
					LOG.info("Worng Expression:" + strExpression);
					continue;
				}
				String field = "";
				for (final String expressionParam : expressionParams) {
					field = field + fields.get(this.fieldsName.get(expressionParam));
				}
				final String k = key+eventId;
				final String v = this.redisCluster.get(k);
				// 2、判断 用户是否已经在LOCATION ? 3 : 判断 【标志位】不存在 ?RETURN: 更新【标志位】
				if (this.redisCluster.hexists(tablename, field)) {
					if (v != null) {
						this.redisCluster.append(k,TRUE);
						//this.redisCluster.getSet(key, value)
					}
						this.redisCluster.set(k, TRUE);
            // 3、(if 【标志位】不存在 ? 设置【标志位】&& 封装成对象存入延迟队列: 更新【标志位】)
						events.put(new DelayEvent(key, eventId,
								this.storeTablename, field, now,
								TimeUnit.MINUTES.toMillis(delayTime),
								this.redisCluster, this.exprie,dynamicArgs.toString()));
					}
				} else {
					if (v != null) {
						this.redisCluster.append(k,FALSE);
					} else {
						continue;
					}
				}
			} else {
				LOG.info("Other Expression can not support:" + strExpression);
				continue;
			}
  ```
- 总结
 - 处理延时事件场景可以很好利用`DelayQueue` ，注意重写`long getDelay(TimeUnit unit)`方法的实现。
 - redis记录用户在延时时间内的轨迹时用`hexists(tablename, field)`判断 ；记录时用`append(k,FALSE)`方法,而不是取出来拼接再`set`
