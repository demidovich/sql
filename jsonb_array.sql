--
-- Replace or add value to jsonb array
--
CREATE OR REPLACE FUNCTION jsonb_array_set(
	input_json_array jsonb,
	current_value text default null,
	new_value text default null) 
RETURNS jsonb AS $$
DECLARE
	buffer text[];
BEGIN

	IF jsonb_typeof(input_json_array) != 'array' THEN
		RETURN input_json_array;
	END IF;

	IF new_value IS NULL THEN
		RETURN input_json_array;
	END IF;

	IF array_position(buffer, current_value) IS NULL THEN
		RETURN input_json_array;
	END IF;

	buffer := ARRAY(SELECT jsonb_array_elements_text(input_json_array));

	IF current_value IS NOT NULL THEN
		SELECT array_remove(buffer, current_value) INTO buffer;
	END IF;

	SELECT array_append(buffer, new_value) INTO buffer;

	SELECT ARRAY(SELECT DISTINCT elem FROM unnest(buffer) AS elem ORDER BY elem) INTO buffer;

	RETURN array_to_json(buffer);

END;
	$$ LANGUAGE PLPGSQL;

--
-- Delete value from jsonb array
--
CREATE OR REPLACE FUNCTION jsonb_array_remove(
	input_json_array jsonb,
	delete_value text)
RETURNS jsonb AS $$
DECLARE
	buffer text[];
BEGIN

	IF jsonb_typeof(input_json_array) != 'array' THEN
		RETURN input_json_array;
	END IF;

	IF delete_value IS NULL THEN
		RETURN input_json_array;
	END IF;

	buffer := ARRAY(SELECT jsonb_array_elements_text(input_json_array));

	SELECT array_remove(buffer, delete_value) INTO buffer;

	RETURN array_to_json(buffer);

END;
	$$ LANGUAGE PLPGSQL;