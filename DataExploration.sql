select *
From PortfolioProject..CovidDeaths
order by 3,4

select Location,Date , total_cases,new_cases,total_deaths,population
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

-- Total Cases vs Total deaths
select Location,Date ,population, total_cases,total_deaths, (CONVERT(int, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

-- Total Cases vs the Population
select Location,Date ,population, total_cases, (CONVERT(float, total_cases) /NULLIF(CONVERT(float, population), 0))*100 as CasePercentage
From PortfolioProject..CovidDeaths
Where location like '%Canada%'
order by 1,2

select Location,population, MAX(CONVERT(float, total_cases)) as HighestCases, MAX(CONVERT(float, total_cases) /NULLIF(CONVERT(float, population), 0))*100 as CasePercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location,population
order by CasePercentage desc

select Location, MAX(CONVERT(int, total_deaths)) as HighestDeathCounrt
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location
order by HighestDeathCounrt desc

select date ,SUM(new_cases) as GlobalTotalCases, SUM(CONVERT(int, new_deaths)) as GlobalTotalDeaths, SUM(CONVERT(int, new_deaths)) / SUM(NULLIF(CONVERT(float, new_cases),0))*100 as GlobalDeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group by date
order by 1,2

select SUM(new_cases) as GlobalTotalCases, SUM(CONVERT(int, new_deaths)) as GlobalTotalDeaths, SUM(CONVERT(int, new_deaths)) / SUM(NULLIF(CONVERT(float, new_cases),0))*100 as GlobalDeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

select location,SUM(new_deaths) as GlobalTotalCases, SUM(CONVERT(int, new_deaths)) as GlobalTotalDeaths, SUM(CONVERT(int, new_deaths)) / SUM(NULLIF(CONVERT(float, new_cases),0))*100 as GlobalDeathPercentage
From PortfolioProject..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International','High income','Upper middle income','Lower middle income','Low income')
Group by location
order by GlobalDeathPercentage desc

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International','High income','Upper middle income','Lower middle income','Low income')
Group by location
order by TotalDeathCount desc

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc


Select * 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date

Select dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) as TotalVaccinationsEveryDate
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
and vac.new_vaccinations is not null
Order by 1,2

With PopVsVac(Continent, location, date,population, new_vaccinations, TotalVaccinationsEveryDate)
as
(
Select dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) as TotalVaccinationsEveryDate
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
and vac.new_vaccinations is not null
)
Select *, (TotalVaccinationsEveryDate/population)*100 as TotalVaccinationPercentage
from PopVsVac

Create View PercentageOfVaccinations as
Select dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) as TotalVaccinationsEveryDate
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
and vac.new_vaccinations is not null

Select * 
From PercentageOfVaccinations

Create View HighestDeathCount as 
select Location, MAX(CONVERT(int, total_deaths)) as HighestDeathCounrt
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location

Create View GlobalDeathPercentage as
select SUM(new_cases) as GlobalTotalCases, SUM(CONVERT(int, new_deaths)) as GlobalTotalDeaths, SUM(CONVERT(int, new_deaths)) / SUM(NULLIF(CONVERT(float, new_cases),0))*100 as GlobalDeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null

Create View TotalPercentageofCasesCanada as
select Location,Date ,population, total_cases, (CONVERT(float, total_cases) /NULLIF(CONVERT(float, population), 0))*100 as CasePercentage
From PortfolioProject..CovidDeaths
Where location like '%Canada%'

