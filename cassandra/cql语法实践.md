```sql
-- create table
 CREATE TABLE users (
   user_id text PRIMARY KEY,
   first_name text,
   last_name text,
   emails set<text>
 );
 ```
 ```sql
--insert data
 INSERT INTO users (user_id, first_name, last_name, emails)
 VALUES('frodo', 'Frodo', 'Baggins', {'f@baggins.com', 'baggins@gmail.com'});
 INSERT INTO users (user_id, first_name, last_name, emails)
 VALUES('gongice', '龚', '世文', {'gshiwen@gmail.com'});
 ```
 ```sql
-- use set/updata
 -- add
 UPDATE users
 SET emails = emails + {'gongice@qq.com'} WHERE user_id = 'gongice';
 -- remove
 UPDATE users
 SET emails = emails - {'f@baggins.com'} WHERE user_id = 'frodo';
 -- remove all
 UPDATE users SET emails = {} WHERE user_id = 'frodo';
 DELETE emails FROM users WHERE user_id = 'frodo';
 ```
 ```sql
-- use list
 ALTER TABLE users ADD top_places list<text>;
 UPDATE users  SET top_places = [ 'rivendell', 'rohan' ] WHERE user_id = 'frodo';
 -- add front
 UPDATE users  SET top_places = [ 'the shire' ] + top_places WHERE user_id = 'frodo';
 -- add back
 UPDATE users  SET top_places = top_places + [ 'mordor' ] WHERE user_id = 'frodo';
 -- add by index
 UPDATE users SET top_places[2] = 'riddermark' WHERE user_id = 'frodo';
 -- remove
 UPDATE users  SET top_places = top_places - ['riddermark'] WHERE user_id = 'frodo';
 DELETE top_places[3] FROM users WHERE user_id = 'frodo';
 ```
```sql
-- use map
 ALTER TABLE users ADD todo map<timestamp, text>;
 -- put
 UPDATE users
    SET todo =
    { '2012-9-24' : 'enter mordor','2014-10-2 12:00' : 'throw ring into mount doom' }
  WHERE user_id = 'frodo';
 -- update
 UPDATE users SET todo['2014-10-2 12:00'] = 'throw my precious into mount doom'  WHERE user_id = 'frodo';
 -- add
 UPDATE users SET todo = todo + { '2013-9-22 12:01' : 'birthday wishes to Bilbo', '2013-10-1 18:00': 'Check into Inn of Pracing Pony'} WHERE user_id='frodo';
 -- remove
 UPDATE users SET todo=todo - {'2013-9-22 12:01','2013-10-01 18:00:00-0700'} WHERE user_id='frodo';
 ```
 ```sql
 -- use ttl
 UPDATE users USING TTL 30  SET todo['2012-10-1'] = 'find water' WHERE user_id = 'frodo'
 ```
 ```sql
 -- query
 select * from users;
 ```
