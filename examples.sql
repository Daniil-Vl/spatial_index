-- 1) Дропаем индексы, которые были созданы автоматически
--    в процессе импорта данных утилитой osm2pgsql
DROP INDEX IF EXISTS planet_osm_line_way_idx;
DROP INDEX IF EXISTS planet_osm_point_way_idx;
DROP INDEX IF EXISTS planet_osm_roads_way_idx;
DROP INDEX IF EXISTS planet_osm_polygon_way_idx;

-- 2) Расстояние между точками (в метрах)
SELECT st_distance(
               (SELECT st_transform(way, 3587) FROM planet_osm_point WHERE osm_id = 5546742983),
               (SELECT st_transform(way, 3587) FROM planet_osm_point WHERE osm_id = 5900730041)
       ) AS distance;

-- 3) Получаем точки внутри МатМеха имеющие названия
EXPLAIN ANALYSE
SELECT osm_id, name, st_astext(st_transform(way, 4326)) AS coords
FROM planet_osm_point
WHERE name IS NOT NULL
  AND st_within(way, (SELECT way FROM planet_osm_polygon WHERE name = 'Математико-механический факультет СПбГУ'));

-- 4) Получаем локации, которые содержатся в Старом Петергофе
EXPLAIN ANALYSE
SELECT osm_id, name
FROM planet_osm_polygon
WHERE name IS NOT NULL
  AND st_contains((SELECT way FROM planet_osm_polygon WHERE name = 'Петергоф'), way);

-- 5) Создаем индексы
CREATE INDEX IF NOT EXISTS planet_osm_point_way_idx ON planet_osm_point USING GIST (way);
CREATE INDEX IF NOT EXISTS planet_osm_polygon_way_idx ON planet_osm_polygon USING GIST (way);

-- 6) Проверяем команды еще раз




