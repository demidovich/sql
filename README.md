# Sql Postgres

My postgres functions. 

* **jsonb_array_set (jsonb_array, value, new_value)**: add or replace jsonb array value
* **jsonb_array_remove (jsonb_array, value)**: remove value from jsonb array 

### jsonb_array_set 
USAGE:

```
SELECT jsonb_array_set('["a","b","c"]'::jsonb, 'b', 'd');
 jsonb_array_set 
-----------------
 ["a", "c", "d"]

SELECT jsonb_array_set('["a","b","c"]'::jsonb, null, 'd');
   jsonb_array_set    
----------------------
 ["a", "b", "c", "d"]
```

BULLETPROOF:

```
SELECT jsonb_array_set('["a","b","c"]'::jsonb, 'c');
 jsonb_array_set 
-----------------
 ["a", "b", "c"]

SELECT jsonb_array_set('["a","b","c"]'::jsonb, 'c', 'c');
 jsonb_array_set 
-----------------
 ["a", "b", "c"]

SELECT jsonb_array_set('["a","b","c"]'::jsonb, 'd', 'e');
 jsonb_array_set 
-----------------
 ["a", "b", "c"]
```

### jsonb_array_remove
USAGE:

```
SELECT jsonb_array_remove('["a","b","c"]'::jsonb, 'c');
 jsonb_array_remove 
--------------------
 ["a", "b"]
```

BULLETPROOF:

```
SELECT jsonb_array_remove('["a","b","c"]'::jsonb, 'd');
 jsonb_array_remove 
--------------------
 ["a", "b", "c"]

SELECT jsonb_array_remove('{"a":"1","b":"2","c":"3"}'::jsonb, 'a');
       jsonb_array_remove       
--------------------------------
 {"a": "1", "b": "2", "c": "3"}
```