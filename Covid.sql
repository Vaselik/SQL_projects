/*
COVID DATA FROM 24th of February 2020 TILL 3rd of July 2021
*/

--1.
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
Order by 5            --Shows the increase of Death Percentage 


--2.
--Shows countries with highest death count per population AND the percentage of the infected population

Select location, MAX(cast(total_deaths as int)) as HighestDeathCount		
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location
Order by 2 desc  --We want the highest number first

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc

Select location, MAX(cast(total_deaths as int)) as HighestDeathCount		
From PortfolioProject..CovidDeaths
Where continent is null
Group by location
Order by 2 desc 


--3.
--Shows the percentage of deaths

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null 
--Group By date
order by 1,2


-- We take these out 
-- European Union is part of Europe etc.

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount  


--4.
--Join the two tables: CovidDeaths and CovidVaccinations

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


--5.
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


--6.
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


--7.
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