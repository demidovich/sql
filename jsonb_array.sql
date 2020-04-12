--
-- Replace or add value to jsonb array
--
create or replace function jsonb_array_set(
    input_json_array jsonb,
    current_value text default null,
    new_value text default null) 
returns jsonb 
language plpgsql immutable as $$
declare
    buffer text[];
begin

    if jsonb_typeof(input_json_array) != 'array' then
        return input_json_array;
    end if;

    if new_value is null then
        return input_json_array;
    end if;

    if array_position(buffer, current_value) is null then
        return input_json_array;
    end if;

    buffer := array(select jsonb_array_elements_text(input_json_array));

    if current_value is not null then
        select array_remove(buffer, current_value) into buffer;
    end if;

    select array_append(buffer, new_value) into buffer;

    select array(select distinct elem from unnest(buffer) as elem order by elem) into buffer;

    return array_to_json(buffer);

end;
$$;

--
-- delete value from jsonb array
--
create or replace function jsonb_array_remove(
    input_json_array jsonb,
    delete_value text)
returns jsonb 
language plpgsql immutable as $$
declare
    buffer text[];
begin

    if jsonb_typeof(input_json_array) != 'array' then
        return input_json_array;
    end if;

    if delete_value is null then
        return input_json_array;
    end if;

    buffer := array(select jsonb_array_elements_text(input_json_array));

    select array_remove(buffer, delete_value) into buffer;

    return array_to_json(buffer);

end;
$$;