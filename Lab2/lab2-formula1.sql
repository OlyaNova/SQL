-- Новацкая Ольга Юрьевна
-- Вариант 1
-- Описание соревнования автогонок класса Формула-1.
-- Включает в себя: календарь чемпионата, список автогонщиков,
-- составы команд, результаты соревнований. 

-- Таблица автогонщиков
-- Состоит из первичного ключа, фамилии, имени, даты рождения, 
-- страны и количества побед гонщика
CREATE TABLE drivers (
    driver_id SERIAL PRIMARY KEY,
	last_name varchar(64) NOT NULL,
	first_name varchar(64) NOT NULL,
	birth_date date NOT NULL, 
	country varchar(64) NOT NULL,
	wins integer DEFAULT 0 CHECK (wins >= 0)
);

-- Таблица команды 
-- Первичный ключ, название команды,
-- производитель мотора, страна
CREATE TABLE teams (
    team_id SERIAL PRIMARY KEY,
    team_name varchar(100) NOT NULL UNIQUE,
    engine_manufacturer varchar(100) NOT NULL,
    country varchar(64) NOT NULL
);

-- Календарь гран-при
-- Первичный ключ, название гран-при, номер среди других гран-при,
-- дата проведения, год проведения(для ограничения по стране),
-- страна, место проведения

CREATE TABLE calendar (
    grand_pri_id SERIAL PRIMARY KEY,
    gp_name varchar(100) NOT NULL,
    season_round integer NOT NULL,
    gp_date date NOT NULL,
    season_year integer NOT NULL,
    country varchar(64) NOT NULL,
    track varchar(100) NOT NULL,
    UNIQUE (country, season_year)
);

-- Состав команды
-- внешний ключ к таблице calendar, внешний ключ к teams,
-- внешний ключ к drivers, роль гонщика (основной или запасной),
-- номер машины, первичный ключ
CREATE TABLE team_lineups (
    grand_pri_id integer NOT NULL REFERENCES calendar(grand_pri_id),
    team_id integer NOT NULL REFERENCES teams(team_id), 
    driver_id integer NOT NULL REFERENCES drivers(driver_id),
    roles varchar(64) NOT NULL,      
    car_number integer,             
    PRIMARY KEY (grand_pri_id, team_id, driver_id)
);
-- Результаты результаты по каждому гонщику
-- внешник ключ к calendar, внешний ключ к drivers,
-- место, количество очков, время гонки, причина схода,
-- количество кругов лидирования, прервичный ключ
CREATE TABLE results (
    grand_pri_id integer NOT NULL REFERENCES calendar(grand_pri_id),
    driver_id integer NOT NULL REFERENCES drivers(driver_id),
    finish_position integer,
    points integer NOT NULL DEFAULT 0,
    race_time interval,
    dnf_reason varchar(200),
    leading_laps integer NOT NULL DEFAULT 0,
    PRIMARY KEY (grand_pri_id, driver_id)
);

--TRUNCATE TABLE results, team_lineups, calendar, teams, drivers RESTART IDENTITY CASCADE;

-- Гонщики
INSERT INTO drivers(last_name, first_name, birth_date, country, wins) VALUES
('Иванов', 'Иван', '1998-01-10', 'Россия', 2),
('Петров', 'Пётр', '1997-05-20', 'Россия', 0),
('Сидорова', 'Анна', '2000-03-03', 'Беларусь', 1),
('Ким', 'Алексей', '1999-09-09', 'Казахстан', 0),
('Смирнов', 'Максим', '1996-12-12', 'Беларусь', 3),
('Тестов', 'Тест', '2001-01-01', 'Тест_страна', 0);;

-- Команды
INSERT INTO teams(team_name, engine_manufacturer, country) VALUES
('команда1', 'Honda', 'Россия'),
('команда2', 'Ferrari', 'Беларусь');

-- Календарь
INSERT INTO calendar(gp_name, season_round, gp_date, season_year, country, track) VALUES
('гран-при1', 1, '2024-03-02', 2024, 'Россия', 'Трасса1'),
('гран-при2', 2, '2024-03-09', 2024, 'Беларусь', 'Трасса2'),
('гран-при3', 3, '2024-03-16', 2024, 'Казахстан', 'Трасса3'),
('гран-при4', 4, '2024-03-23', 2024, 'Грузия', 'Трасса4'),
('гран-при5', 5, '2024-03-30', 2024, 'Армения', 'Трасса5');

-- Составы команд
INSERT INTO team_lineups(grand_pri_id, team_id, driver_id, roles, car_number) VALUES
(1, 1, 1, 'основной', 11),   
(1, 1, 2, 'основной', 12),  
(1, 2, 3, 'основной', 21), 
(1, 2, 5, 'основной', 22),   
(1, 2, 6, 'запасной', NULL),
(2, 1, 1, 'основной', 11),
(2, 1, 4, 'основной', 14),
(2, 1, 2, 'запасной', NULL),
(2, 2, 3, 'основной', 21),
(2, 2, 5, 'основной', 22),
(3, 1, 2, 'основной', 12),
(3, 1, 4, 'основной', 14),
(3, 1, 1, 'запасной', NULL),
(3, 2, 3, 'основной', 21),
(3, 2, 5, 'основной', 22),
(4, 1, 1, 'основной', 11),
(4, 1, 2, 'основной', 12),
(4, 2, 3, 'основной', 21),
(4, 2, 5, 'основной', 22),
(5, 1, 4, 'основной', 14),
(5, 1, 2, 'основной', 12),
(5, 2, 3, 'основной', 21),
(5, 2, 5, 'основной', 22);

-- результаты
INSERT INTO results(grand_pri_id, driver_id, finish_position, points, race_time, dnf_reason, leading_laps) VALUES
(1, 1, 1, 25, '01:10:40', NULL, 12),
(1, 3, 2, 18, '01:10:40', NULL, 3),
(1, 5, 3, 15, '01:10:15', NULL, 0),
(1, 2, NULL, 0, NULL, 'неизвестно', 0),
(1, 4, 4, 12, '01:12:50', NULL, 0),
(2, 3, 1, 25, '01:05:20', NULL, 8),
(2, 4, 2, 18, '01:05:50', NULL, 6),
(2, 1, 3, 15, '01:06:10', NULL, 1),
(2, 5, NULL, 0, NULL, 'сломалась машина', 0),
(2, 2, 4, 12, '01:07:00', NULL, 0),
(3, 4, 1, 18, '01:20:00', NULL, 20),
(3, 2, 2, 15, '01:20:30', NULL, 2),
(3, 3, 3, 12, '01:21:00', NULL, 0),
(3, 5, 4, 10, '01:21:40', NULL, 0),
(3, 1, NULL, 0, NULL, 'перегрев', 0),
(4, 5, 1, 25, '01:09:30', NULL, 9),
(4, 1, 2, 18, '01:10:10', NULL, 5),
(4, 3, 3, 15, '01:11:00', NULL, 0),
(4, 2, 4, 12, '01:11:50', NULL, 0),
(4, 4, 5, 10, '01:12:40', NULL, 0),
(5, 2, 1, 25, '01:18:10', NULL, 4),
(5, 3, 2, 18, '01:18:40', NULL, 3),
(5, 4, 3, 15, '01:19:20', NULL, 1),
(5, 1, 4, 12, '01:20:00', NULL, 0),
(5, 5, NULL, 0, NULL, 'неизвестно', 0);


-- Задание 2
-- Выберите всех гонщиков, которые заняли первое место,
-- но заработали меньше 26 очков, 
-- отсортировав данные по убыванию кругов лидирования.
SELECT
  d.driver_id,
  d.last_name,
  d.first_name,
  r.points
FROM results r
JOIN drivers d ON d.driver_id = r.driver_id
WHERE r.finish_position = 1
  AND r.points < 26
ORDER BY r.leading_laps DESC;

-- Выберите имена и фамилии всех гонщиков и общее количество их очков,
-- набранных по результатам гонок, и расставьте их в порядке убывания.
SELECT
  d.last_name,
  d.first_name,
  SUM(r.points) AS total_points
FROM drivers d
JOIN results r ON r.driver_id = d.driver_id
GROUP BY d.driver_id, d.last_name, d.first_name
ORDER BY total_points DESC;






