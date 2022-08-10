select *
from PortfolioProject..Covid_deaths
order by 3,4

--select *
--From PortfolioProject..Covid_vaccinations
--order by 3,4

--Selecting data to use
select location,date, Total_cases, new_cases, total_deaths, population
from PortfolioProject..Covid_deaths
order by 1,2

--Looking at total cases vs total deaths
select location,date, Total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..Covid_deaths
where location like '%South Africa%'
order by 1,2

-- total cases vs Population
-- shows total percentage of infected indiviuals in a population in South africa
select location,date, population, Total_cases, (total_cases/population)*100 as InfectionPercentage
from PortfolioProject..Covid_deaths
where location like '%South Africa%'
order by 1,2

-- shows total percentage of infected indiviuals in a population in the world
select location,date, population, Total_cases, (total_cases/population)*100 as InfectionPercentage
from PortfolioProject..Covid_deaths
order by 1,2

--Highest infection rate in population
select location, population, max(Total_cases) as HighestInfectionCount, (max(total_cases)/population)*100 as InfectionPercentage
from PortfolioProject..Covid_deaths
Group by location, population
order by InfectionPercentage desc

--Countries with the Higest death count
--casting changes data types
Select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..Covid_deaths
Where continent is not null  --Eliminates entire continents & filters on countries only
Group by location
order by TotalDeathCount desc


--Continents with the Higest death count
Select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..Covid_deaths
Where continent is null 
Group by location
order by TotalDeathCount desc

Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..Covid_deaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc

--global death percentage
Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathPercentage
from PortfolioProject..Covid_deaths
where continent is not null
order by 1,2

select *
from PortfolioProject..Covid_deaths dea
join PortfolioProject..Covid_Vaccinations vac
	ON DEA.location =vac.location
	and dea.date = vac.date

	--total populations vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..Covid_deaths dea
join PortfolioProject..Covid_Vaccinations vac
	ON DEA.location =vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3


--partitioning lists
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as rollingCount
From PortfolioProject..Covid_deaths dea
join PortfolioProject..Covid_Vaccinations vac
	ON DEA.location =vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3

