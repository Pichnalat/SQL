/*Queries used for Tableau Project*/

--All table from CovidDeaths
Select *
From PortfolioProject..CovidDeaths
order by 3,4

--All table from CovidVaccinations
Select *
From PortfolioProject..CovidVaccinations
Order by 3,4

--Data that we are going to use
Select Location,date, total_cases,new_cases,total_deaths,population
From PortfolioProject..CovidDeaths
Order by 1,2

--Total cases vs Total Deaths
Select Location,date, total_cases,new_cases,total_deaths,(total_deaths/total_cases) *100 As DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2

--Total cases vs Total Population in USA
Select Location,date, total_cases,Population,(total_cases/Population) *100 As PercentagePopulationInfected
From PortfolioProject..CovidDeaths
Where location like '%States%' and continent is not null
Order by 1,2

--Countries with Highest infection rate compared to population (Table4)
Select Location,Population, MAX(total_cases) As HighestInfectionCount,Max(total_cases/Population) *100 As PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location,Population
Order by PercentPopulationInfected desc

--Countries with Highest infection rate compared to population (Table3)
Select Location,Population,date, MAX(total_cases) As HighestInfectionCount,Max(total_cases/Population) *100 As PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location,Population,date
Order by PercentPopulationInfected desc


--Countries with Highest Death Count per population 
Select Location, MAX(total_cases ) As TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location
Order by TotalDeathCount desc

--Break down by continent (Table2)
Select Location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
and location not like '%income'
Group by Location
order by TotalDeathCount desc



--Showing continents with the highest death count per population
Select continent, Max(total_deaths/Population) *100 As TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount desc

--Global numbers(Table1)
Select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/sum(new_cases) *100 As DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2 

--Total population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.date) 
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3







