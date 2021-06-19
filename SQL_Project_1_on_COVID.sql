-- Data Exploration on COVID 19 records--


Select * from Project_Protfolio..[Covid-deaths]
where continent is not null
order by 3,4

--Select * from Project_Protfolio..covidvaccinations
--where continent is not null
--order by 3,4

-- Select Data that are going to be started with--

Select location,date,total_cases,new_cases,total_deaths,population
from Project_Protfolio..[Covid-deaths] order by 1,2

--Total Cases vs Total deaths--
--Shows chance of dying if you contract covid in your country--

Select location,date,total_cases,total_deaths,round((total_deaths/total_cases)*100,2) AS death_Percentage
from Project_Protfolio..[Covid-deaths]
where location like '%ndia' and continent is not null --country name can be vary
order by 1,2

--Total Cases vs Population--
--shows percentage of population infected by covid in your country--

Select location,date,population,total_cases,(total_cases/population)*100 AS population_Percentage
from Project_Protfolio..[Covid-deaths]
where location like '%ndia' and continent is not null
order by 1,2

--Countries with highest infection rate compared to population--

Select location,population,max(total_cases) AS Highest_infection_count ,max((total_cases/population))*100 AS population_Percentage
from Project_Protfolio..[Covid-deaths]
--where location like '%ndia'
where continent is not null
Group by location,population
order by population_Percentage desc

--countries with highest death count per population--

Select location,max(cast(total_deaths AS int)) AS total_death_count
from Project_Protfolio..[Covid-deaths]
where continent is not null
group by location
order by total_death_count desc

--Breaking Data by Continent--

--Continent with highest death count per population--

Select continent,max(cast(total_deaths AS int)) AS total_death_count
from Project_Protfolio..[Covid-deaths]
where continent is not null
group by continent
order by total_death_count desc

--Showing Globaly--

Select date,sum(new_cases) AS total_cases ,sum(cast(new_deaths AS int)) AS total_deaths, sum(cast(new_deaths AS int))/sum(new_cases)*100 AS death_percentage
from Project_Protfolio..[Covid-deaths]
--where location like '%ndia'
where continent is not null
Group by date
order by 1,2

--Total no of Cases golbaly--

Select sum(new_cases) AS total_cases ,sum(cast(new_deaths AS int)) AS total_deaths, sum(cast(new_deaths AS int))/sum(new_cases)*100 AS death_percentage
from Project_Protfolio..[Covid-deaths]
--where location like '%ndia'
where continent is not null
--Group by date
order by 1,2

--Total Population VS Vaccination--
--shows population percentage that has recieved at least one dose of vaccine--

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations 
,sum(cast(vac.new_vaccinations AS int )) over (partition by dea.location order by dea.location ,dea.date)
AS RollingPeopleVaccinated
from project_protfolio..[Covid-deaths] AS dea
join Project_Protfolio..covidvaccinations AS vac
on dea.location=vac.location
AND dea.date=vac.date
where dea.continent is not null
order by 2,3


--Temp table for calculation purpose in previous query--

DROP Table if exists #PercentagePopulationVaccinated
Create Table #PercentagePopulationVaccinated
( continent  nvarchar(255),
  location nvarchar(255),
  date datetime,
  population numeric,
  new_vaccination numeric,
  RollingPeopleVaccinated numeric)

Insert into #PercentagePopulationVaccinated
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations 
,sum(cast(vac.new_vaccinations AS int )) over (partition by dea.location order by dea.location ,dea.date)
AS RollingPeopleVaccinated
from project_protfolio..[Covid-deaths] AS dea
join Project_Protfolio..covidvaccinations AS vac
on dea.location=vac.location
AND dea.date=vac.date
where dea.continent is not null
--order by 2,3

Select * ,(RollingPeopleVaccinated/Population)*100 AS RollingPeopleVaccinated_PerPopulation
from #PercentagePopulationVaccinated





