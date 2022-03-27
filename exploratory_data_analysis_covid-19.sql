-- create a table named covid_death that includes 8 fields: iso_code, date, total_cases, new_cases, total_deaths, new_deaths, icu_patients and hosp_patients:

CREATE TABLE `portfolio_project`.`covid_death` (
    `iso_code` VARCHAR(10) NOT NULL,
    `date` DATE NOT NULL,
    `total_cases` BIGINT(20),
    `new_cases` INT,
    `total_deaths` INT,
    `new_deaths` INT,
    `icu_patients` INT,
    `hosp_patients` INT,
    PRIMARY KEY (`iso_code` , `date`)
);

-- create a table named geo_info that includes 4 fields: iso_code, continent, name, population

CREATE TABLE `portfolio_project`.`geo_info` (
    `iso_code` VARCHAR(10) NOT NULL,
    `continent` VARCHAR(15),
    `name` VARCHAR(35),
    `population` BIGINT(20),
    PRIMARY KEY (`iso_code`)
);

-- create a table named covid_vaccination that includes 8 fields: iso_code, date, people_vaccinated, people_fully_vaccinated, total_boosters, new_vaccinations, new_vaccinations_smoothed, people_vaccinated_smoothed

CREATE TABLE `portfolio_project`.`covid_vaccination` (
  `iso_code` varchar(10) NOT NULL,
  `date` datetime NOT NULL,
  `people_vaccinated` BIGINT(20),
  `people_fully_vaccinated` BIGINT(20),
  `total_boosters` BIGINT(20),
  `new_vaccinations` INT,
  `new_vaccinations_smoothed` INT,
  `people_vaccinated_smoothed` INT,
  PRIMARY KEY (`iso_code`,`date`);
);

-- Daily infection fatality rate in New Zealand, Feb 28, 2020 to Mar 19, 2022
-- Infection fatality rate = deaths / cases

SELECT 
    iso_code,
    date,
    total_cases,
    total_deaths,
    ROUND((total_deaths / total_cases) * 100, 2) AS death_percentage
FROM
    covid_death
WHERE
    iso_code = 'NZL'
ORDER BY date;

--  Daily infection rate of COVID-19 in New Zealand, Feb 28, 2020 to Mar 19, 2022
--  Infection rate = cases / population

SELECT 
    iso_code,
    date,
    total_cases,
    population,
    ROUND((total_cases / population) * 100, 2) AS infection_percentage
FROM
    covid_death
        INNER JOIN
    geo_info USING (iso_code)
WHERE
    iso_code = 'NZL'
ORDER BY date;

-- Percentage of population infected with COVID-19 by country, Mar 19, 2022

SELECT 
    name,
    population,
    ROUND((MAX(total_cases) / population) * 100, 2) AS pct_population_infected
FROM
    covid_death
        INNER JOIN
    geo_info USING (iso_code)
WHERE continent IS NOT NULL
GROUP BY name , population
ORDER BY pct_population_infected DESC;

-- Highest daily reported deaths by country, Mar 19, 2022

SELECT 
    name, population,
    MAX(new_deaths) cnt_new_death
FROM
    covid_death
        INNER JOIN
    geo_info USING (iso_code)
WHERE continent IS NOT NULL
GROUP BY name;

-- Mortality rate and probability of dying by country, Mar 19, 2022
-- For example, as of Mar 19, 2022, 211814 people are reported to have died due to COVID-19 out of a total population of 3339415 in Peru. 
-- This correspond to a 0.63% mortality rate to date, or 1 death very 157 people.

SELECT 
    name, population, MAX(total_deaths) total_deaths,
    ROUND((MAX(total_deaths) / population) * 100, 2) pct_mortality_rate,
    FLOOR(population / MAX(total_deaths)) probability_dying
FROM
    covid_death
        INNER JOIN
    geo_info USING (iso_code)
WHERE continent IS NOT NULL
GROUP BY name
ORDER BY pct_mortality_rate DESC;	
