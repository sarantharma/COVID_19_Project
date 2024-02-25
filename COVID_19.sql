--select * from COVID19_PROJECT..CovidDeaths order by 3,4

--select * from COVID19_PROJECT..CovidVaccinations order by 3,4

-- Select Data the we are going to be using
--Select  Location, date, total_cases, new_cases, total_deaths, population from COVID19_PROJECT..CovidDeaths ORDER BY 1, 2;

-- Looking at Total Cases vs Total Deaths
-- Showa likelihood of dying if you have convid in your country
--Select  Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage FROM COVID19_PROJECT..CovidDeaths
--WHERE location like '%Canada%'
--ORDER BY 1, 2;

-- Looking at Tootal Cases vs Population
--Select  Location, date, total_cases, population, (total_cases/population)*100 AS CasePercentage FROM COVID19_PROJECT..CovidDeaths
--WHERE location like '%Canada%'
--ORDER BY 1, 2;

-- Looking at countries with highest infection ratetcompared to population 
--Select  location,population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 AS InfectedPercentage 
--FROM COVID19_PROJECT..CovidDeaths
--GROUP BY location, population
--ORDER BY InfectedPercentage DESC

-- Showing countries with highest death count per population
--Select  location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
--FROM COVID19_PROJECT..CovidDeaths
--WHERE continent IS NOT NULL
--GROUP BY location, population
--ORDER BY TotalDeathCount DESC


-- Showing Continents with highest death count per population
--Select  location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
--FROM COVID19_PROJECT..CovidDeaths
--WHERE continent IS NULL
--GROUP BY location
--ORDER BY TotalDeathCount DESC

-- Global Numbers 
--Select date, SUM(new_cases), SUM(CAST(new_deaths AS INT)), SUM(CAST(new_deaths AS INT))/ SUM(new_cases)*100 AS DeathPercentage 
--FROM COVID19_PROJECT..CovidDeaths
--WHERE continent IS NOT NULL
--GROUP BY date
--ORDER BY 1, 2;

-- Looking at total population vs vaccination
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 

--SUM(CAST(vac.new_vaccinations AS INT)) OVER 
--(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated

--FROM COVID19_PROJECT..CovidVaccinations vac
--JOIN COVID19_PROJECT..CovidDeaths dea
--ON vac.location = dea.location AND vac.date = dea.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 2,3 ;

-- USE CTE

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 

SUM(CAST(vac.new_vaccinations AS INT)) OVER 
(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated

FROM COVID19_PROJECT..CovidVaccinations vac
JOIN COVID19_PROJECT..CovidDeaths dea
ON vac.location = dea.location AND vac.date = dea.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3 
)
SELECT *, (RollingPeopleVaccinated/population)*100 FROM PopvsVac;