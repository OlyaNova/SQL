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





