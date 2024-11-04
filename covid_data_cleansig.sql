Select * 
From portfolioproject..CovidDeaths
Where continent is not null
order by 3,4

Select * 
From portfolioproject..Covidvaccination
order by 3,4

--Select data that we are going to be used

Select Location, date, total_cases, new_cases, total_deaths, population
From portfolioproject..CovidDeaths
order by 1,2


--total cases vs total deaths
--shows likelyhood of dying if you contract covid in your country 
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as PercentPopulationInfected
From portfolioproject..CovidDeaths
where location like '%states'
order by 1,2

--looking at the total cases vs population
--looking what % of population got covid
Select Location, date, total_cases, population, (total_cases/population)*100 as populationratio
From portfolioproject..CovidDeaths
where location like '%yemen'
order by 1,2

SELECT Location, Date, total_cases, Population, 
       (total_cases / Population)*10000 AS population_ratio
FROM portfolioproject..CovidDeaths
WHERE Location LIKE '%yemen'
  AND total_cases = (SELECT MAX(total_cases) 
                     FROM portfolioproject..CovidDeaths AS sub
                     WHERE sub.Location = portfolioproject..CovidDeaths.Location)
ORDER BY Location, Date;

SELECT Location, Date, total_cases, Population, 
(total_cases / Population) * 10000 AS population_ratio
FROM portfolioproject..CovidDeaths AS main
WHERE total_cases = (SELECT MAX(total_cases)
                     FROM portfolioproject..CovidDeaths AS sub
                     WHERE sub.Location = main.Location)
ORDER BY Location, Date;


Select Location, Population, date, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as 
PercentPopulationInfected
From portfolioproject..CovidDeaths
group by Location, Population, date
order by PercentPopulationInfected desc

--showing the countries with hiegest death count per population
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From portfolioproject..CovidDeaths
Where continent is not null
group by Location
order by TotalDeathCount desc

--let's break things down by continent

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From portfolioproject..CovidDeaths
Where continent is  null
group by location
order by TotalDeathCount desc

--GLOBAL NUmBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)* 100 as DeathPercentage
--total_cases, total_deaths, (total_deaths/total_cases)*100
From portfolioproject..CovidDeaths
where continent is not null
--Group by date
order by 1,2



Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From
portfolioproject..CovidDeaths dea
Join portfolioproject..Covidvaccination vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--Using CTE

With PopvsVac (Continent, Location, date, population, new_vaccination, RollingPeopleVaccinated)
as(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From
portfolioproject..CovidDeaths dea
Join portfolioproject..Covidvaccination vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)Select *, (RollingPeopleVaccinated/population)*100 as persentage
From PopvsVac 

--temp0 table 
Drop Table if exists PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into  PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(NUMERIC(18, 0), vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From
portfolioproject..CovidDeaths dea
Join portfolioproject..Covidvaccination vac
On dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
Select *, (RollingPeopleVaccinated/population)*100 
From PercentPopulationVaccinated
						
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From portfolioproject..CovidDeaths
where continent is null
and location not in('World', 'Eurpeon Union', 'International')
Group by location 
order by TotalDeathCount desc

																		


-- creating view to store data for later visualization
Create View PercentPopulationVaccinated_views as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From
portfolioproject..CovidDeaths dea
Join portfolioproject..Covidvaccination vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3


SELECT * FROM PercentPopulationVaccinated_views;

-- to rem
IF OBJECT_ID('PercentPopulationVaccinated_view', 'V') IS NOT NULL
    DROP VIEW PercentPopulationVaccinated_view;
