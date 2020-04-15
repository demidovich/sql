--
-- Generate random word
--
CREATE OR REPLACE FUNCTION random_word(
    length integer) 
RETURNS text LANGUAGE plpgsql IMMUTABLE AS $$
BEGIN

    RETURN array_to_string(array(
        SELECT SUBSTRING('abcdefghjkmnpqrstuvwxyz' FROM floor(random() * 31)::int + 1 FOR 1)
        FROM generate_series(1, $1)
    ), '');

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
    buffer text[];
BEGIN

    IF input_text IS null THEN
        RETURN input_text;
    END IF;

    FOREACH word IN ARRAY regexp_split_to_array(input_text, ' ') LOOP
        word   := random_word(length(word) + 1);
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
