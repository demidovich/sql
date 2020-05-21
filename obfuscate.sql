--
-- Generate random word
--
-- CREATE OR REPLACE FUNCTION random_word(
--     length integer) 
-- RETURNS text LANGUAGE plpgsql IMMUTABLE AS $$
-- BEGIN

--     RETURN array_to_string(array(
--         SELECT SUBSTRING('abcdefghjkmnpqrstuvwxyz' FROM floor(random() * 31)::int + 1 FOR 1)
--         FROM generate_series(1, $1)
--     ), '');

-- END;
-- $$;

--
-- Generate random word
--
CREATE OR REPLACE FUNCTION word_by_hash(
    hash text,
    length integer) 
RETURNS text LANGUAGE plpgsql IMMUTABLE AS $$
DECLARE
    hash_length integer;
BEGIN

    hash_length := length(hash);

    IF length > hash_length THEN
        hash := REPEAT(hash, CEIL(length / hash_length)::integer);
    END IF;

    RETURN SUBSTRING(hash from 1 for length);

END;
$$;

--
-- Obfuscate text processing while preserving word length and space
--
CREATE OR REPLACE FUNCTION obfuscate_text(
    input_text text default null) 
RETURNS text LANGUAGE plpgsql IMMUTABLE AS $$
DECLARE
    word text;
    hash text;
    buffer text[];
BEGIN

    IF input_text IS null THEN
        RETURN input_text;
    END IF;

    hash := md5(input_text);

    FOREACH word IN ARRAY regexp_split_to_array(input_text, ' ') LOOP
        word   := word_by_hash(hash, length(word));
        buffer := array_append(buffer, word);
    END LOOP;

    RETURN array_to_string(buffer, ' ');

END;
$$;

--
-- Uppercase obfuscated text
--
CREATE OR REPLACE FUNCTION obfuscate_text_upper(
    input_text text default null) 
RETURNS text LANGUAGE plpgsql IMMUTABLE AS $$
DECLARE
    buffer text;
BEGIN

    RETURN upper(obfuscate_text(input_text));

END;
$$;

--
-- Obfuscated text with first char in uppercase
--
CREATE OR REPLACE FUNCTION obfuscate_text_ucfirst(
    input_text text default null) 
RETURNS text LANGUAGE plpgsql IMMUTABLE AS $$
BEGIN

    RETURN initcap(obfuscate_text(input_text));

END;
$$;
