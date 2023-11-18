
Select *
From PortfoliioProject..CovidDeaths
order by 3,4

--Select *
--From PortfoliioProject..CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfoliioProject..CovidDeaths
order by 1,2


--Looking at Total Cases vs Total Deaths
--Shows Likelihood of dying if you contract covid in your country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DdeathPercentage
From PortfoliioProject..CovidDeaths
Where location = 'India'
order by 1,2


--Looking at Total cases vs Population
--Shows what percentage of population got covid

Select Location, date, total_cases, population, (total_cases/population)*100 as DdeathPercentage
From PortfoliioProject..CovidDeaths
Where location = 'India'
order by 1,2


--Looking at countries with highest infection rate compared to population

Select Location, MAX(total_cases) as HighestInfectionCount, population, MAX((total_cases/population))*100 
as PercentOfPopulatioonInfected
From PortfoliioProject..CovidDeaths
--Where location = 'India'
Group by location, population
order by PercentOfPopulatioonInfected desc


--Showing Countries with Highest Death Count Per Population

Select Location, MAX(cast(total_deaths as int)) as TotalDeathsCount
From PortfoliioProject..CovidDeaths
--Where location = 'India'
Where continent is not null
Group by location
order by TotalDeathsCount desc

--LET'S BREAK THINGS DOWN CONTINENT
--Showing the Continent with the Highest death count per Population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathsCount
From PortfoliioProject..CovidDeaths
--Where location = 'India'
Where continent is not null
Group by continent
order by TotalDeathsCount desc


--Global numbers


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100  as DeathPercentage
From PortfoliioProject..CovidDeaths
--Where location = 'India'
Where continent is not null
--Group by date
order by 1,2


--Looking at total population vs vaccination

Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location,
dea.date) as RollingPeopleVaccinated
From PortfoliioProject..CovidDeaths dea
Join PortfoliioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 1,2,3


--USE CTE

With PopvsVac (Continent, Location, Date, Population, new_vaccinations,RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location,
dea.date) as RollingPeopleVaccinated
From PortfoliioProject..CovidDeaths dea
Join PortfoliioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 1,2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


--Creating view to store data for later visualizations

Create view PopvsVac as
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location,
dea.date) as RollingPeopleVaccinated
From PortfoliioProject..CovidDeaths dea
Join PortfoliioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 1,2,3

Select * from PopvsVac