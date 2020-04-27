-- 
-- Cluster ID generator
-- По мотивам решения Instagram
--
-- Один сервер > Одна база > Одна сущность > Одна секунда > 65536 идентификаторов
-- Первым идет timestamp. Хвост после него без нарушения уникальности существующих id 
-- можно перестроить как угодно. Это может понадобиться для включения в ключ 
-- дополнительных данных или флагов. Локальная последовательность используется для 
-- обеспечения уникальности в рамках одной секунды.
-- shard_id содержит номер шарда
--
CREATE OR REPLACE FUNCTION shard_uniqid(IN sequence_name text) 
RETURNS bigint LANGUAGE plpgsql AS $$
DECLARE

    -- Сдвигаем эпоху
    -- 2020-01-01 00:00:00 1577826000

    now_seconds bigint;
    our_epoch   bigint := 1577826000;
    shard_id    int := 1;
    serial_id   bigint;
    unique_id   bigint;

BEGIN

    SELECT nextval(sequence_name) INTO serial_id;
    SELECT floor(extract(epoch FROM clock_timestamp())) INTO now_seconds;

    -- 2  unused reserve
    -- 31 seconds
    -- 15 shards 32k
    -- 16 sequence 65k

    unique_id := 0                                      << (64 - 2);
    unique_id := unique_id | ((now_seconds - our_epoch) << (64 - 2 - 31));
    unique_id := unique_id | (shard_id                  << (64 - 2 - 31 - 15));
    unique_id := unique_id | ((serial_id % 65536)       << (64 - 2 - 31 - 15 - 16));

    -- RAISE NOTICE 'time      %', (now_seconds - our_epoch);
    -- RAISE NOTICE 'shard_id  %', shard_id;
    -- RAISE NOTICE 'serial_id %', serial_id;

    RETURN unique_id;

END;
$$;

--
-- Extract shard_id from UNIQUE ID
--
CREATE OR REPLACE FUNCTION shard_uniqid_fetch(
    in id bigint, 
    out ts timestamp, 
    out shard_id bigint, 
    out serial_id bigint)
LANGUAGE plpgsql AS $$
DECLARE
    ts_int bigint;
BEGIN

    ts_int    := (id >> (64 - 2 - 31))           & 2147483647; -- 31 bit, 0x7FFFFFFF
    shard_id  := (id >> (64 - 2 - 31 - 15))      & 32767;      -- 15 bit, 0x7FFF
    serial_id := (id >> (64 - 2 - 31 - 15 - 16)) & 65535;      -- 16 bit, 0xFFFF

    ts := to_timestamp(ts_int + 1577826000);

    -- RAISE NOTICE 'time      %', time + 1577826000;
    -- RAISE NOTICE 'shard_id  %', shard_id;
    -- RAISE NOTICE 'serial_id %', serial_id;

END;
$$;