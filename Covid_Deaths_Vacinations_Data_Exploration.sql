select location, date, total_cases, new_cases,total_deaths, population 
from coviddeaths
order by 1,2;

-- total cases Vs total deaths
select location, date, total_cases, total_deaths ,  (total_deaths/total_cases)*100 as PercentageDeaths
from coviddeaths
where location like '%states%'
order by 2;


-- total cases Vs Population

select location, date, total_cases, population ,  (total_cases/population)*100 as PercentofPopluationInfected
from coviddeaths
where location like '%states%'
order by 2 desc;

-- Looking at countries with highest infection rate compared to population

select location,population, max(total_cases) as higheshinfectioncount,max((total_cases)/population)*100 as PercentofPopluationInfected
from coviddeaths
where continent != ''
group by location, population
order by 1,2 desc;

-- location with highest death count
select location , max(cast(total_deaths as decimal)) as totaldeathcount
from coviddeaths
where continent != ''
group by location
order by 1,2 desc;

--  continent with highest death count

select continent , max(cast(total_deaths as decimal)) as totaldeathcount
from coviddeaths
where continent != ''
group by continent
order by 1,2 desc;


--  global numbers
-- total vaccinations Vs populatons
select dea.continent,dea.location,dea.date,dea.population,vcc.new_vaccinations  from coviddeaths dea
inner join covidvaccinations vcc
on dea.location = vcc.location and dea.date = vcc.date
where  dea.continent != '';
