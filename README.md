# Sql Postgres

## jsonb

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

## obfuscate data

* **random_word (integer)**: generate random word
* **obfuscate_text (text)**: obfuscate text processing while preserving word length and space
* **obfuscate_text_upper (text)**: uppercase obfuscated text
* **obfuscate_text_ucfirst (text)**: obfuscated text with first char in uppercase

### random_word
USAGE:

```
SELECT random_word(5);
 random_word 
-------------
 bfjxw
```

### obfuscate_text
USAGE:

```
SELECT obfuscate_text('This is private data');
  obfuscate_text   
-------------------
 rmfg n huukrc hhn
```

### obfuscate_text_upper
USAGE:

```
SELECT obfuscate_text_upper('This is private data');
 obfuscate_text_upper  
-----------------------
 DHYFX DFX DXXUZQH SMA
```

### obfuscate_text_ucfirst
USAGE:

```
SELECT obfuscate_text_ucfirst('This is private data');
 obfuscate_text_ucfirst 
------------------------
 Fufrq Xwz Fcaz Gpdb
```

