Select *
From PortfolioProject..CovidDeaths
Order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--Order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2

--Looking at Total Cases VS Total Deaths
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Order by 1,2

--Looking at Total Cases VS Total Deaths in Greece
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%greece%'
Order by 1,2

--Looking at Total Cases VS Population
--Shows what percentage of population got covid
Select location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Order by 5        --Shows the increase of Death Percentage 

--Looking at countries with highest infection rate compared to population
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases)/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by location, population
Order by 4 desc       --Shows the highest number first

--Shows countries with highest death count per population
Select location, MAX(cast(total_deaths as int)) as HighestDeathCount		--we turned it into INT
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location
Order by 2 desc  

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount  -- ауноуса   BUT desc(жхимоуса)

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc

--CONTINENT
Select location, MAX(cast(total_deaths as int)) as HighestDeathCount		--we turned it into INT
From PortfolioProject..CovidDeaths
Where continent is null
Group by location
Order by 2 desc 

Select date, SUM(new_cases), SUM(cast(new_deaths as int))	--new_cases are float BUT new_deaths are varchar SO change to int

--Shows for each day
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100
	as NEWDeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group by date
Order by 1,2

--Shows the total_new
Select SUM(new_cases) as total_new_cases, SUM(cast(new_deaths as int)) as total_new_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100
	as NEWDeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2

--Shows the TOTAL
Select SUM(total_cases) as total_cases, SUM(cast(total_deaths as int)) as total_deaths, SUM(cast(total_deaths as int))/SUM(total_cases)*100
	as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2


--JOIN THE TWO TABLES
Select *
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

--Looking at Total Population vs Total Vaccinaions
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) 
	OVER (Partition by dea.location order by dea.location, dea.date) as SUMVaccinatedPeople
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

--USE CTE
With PopvsVac (Continent, Location, Date, Population, New_vaccinations, SUMVaccinatedPeople)
as(
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) 
	OVER (Partition by dea.location order by dea.location, dea.date) as SUMVaccinatedPeople
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null --and dea.location like '%greece%' or dea.location like '%bulgaria%'
)
Select*, (SUMVaccinatedPeople/Population)*100
From PopvsVac


--TEMP TABLE
Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
SUMVaccinatedPeople numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) 
	OVER (Partition by dea.location order by dea.location, dea.date) as SUMVaccinatedPeople
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null 
Select*, (SUMVaccinatedPeople/Population)*100
From #PercentPopulationVaccinated


--Creating view to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) 
	OVER (Partition by dea.location order by dea.location, dea.date) as SUMVaccinatedPeople
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null 

Select *
From PercentPopulationVaccinated




