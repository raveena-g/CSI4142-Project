  /*Roll up*/
  /*Finding the Years of Potential Life Lost (YPLL) at the year level*/
  SELECT c.CTYYEAR, ROUND(CAST(SUM(w.YPLL) AS NUMERIC), 2) AS sum_YPLL
  FROM
  wellness_fact w
  LEFT JOIN
  county_demographics c
  ON
  w.county_key = c.county_id
  WHERE
  c.CTYYEAR IS NOT NULL
  GROUP BY ROLLUP (c.CTYYEAR)
  HAVING c.CTYYEAR IS NOT NULL

  /*Drill down*/
  /*Finding the YPLL at the year and state level*/
  SELECT c.CTYYEAR, c.STFIPS, ROUND(CAST(SUM(w.YPLL) AS NUMERIC), 2) AS sum_YPLL
  FROM 
  wellness_fact as w
  LEFT JOIN
  county_demographics as c
  ON 
  w.county_key = c.county_id
  WHERE
  c.CTYYEAR IS NOT NULL 
  AND
  c.STFIPS IS NOT NULL
  GROUP BY ROLLUP (c.CTYYEAR, c.STFIPS)
  HAVING c.CTYYEAR IS NOT NULL 
  AND 
  c.STFIPS IS NOT NULL 

  /*Slice*/
  /*Selecting all measures where the year is 2018*/
  SELECT *
  FROM 
  wellness_fact as w
  LEFT JOIN
  county_demographics as c
  ON
  w.county_key = c.county_id
  WHERE (c.CTYYEAR = 2018)

  /*Dice*/
  /*Selecting YPLL, county, year, and average precipitation where the year is 2018 and average_precipitation is greater than 3.5*/
  SELECT w.YPLL, c.FIPS, c.CTYYEAR, wd.average_precipitation
  FROM 
  wellness_fact as w
  LEFT JOIN
  county_demographics as c
  ON
  w.county_key = c.county_id
  LEFT JOIN
  weather_data as wd
  ON
  w.weather_key = wd.weather_id
  WHERE (c.CTYYEAR = 2018 AND wd.average_precipitation > 3.5)

  /*Combining OLAP operations*/
  /*Comparing the YPLL in 2018 and 2017*/
  SELECT c.CTYYEAR, ROUND(CAST(SUM(w.YPLL) AS NUMERIC), 2) AS sum_YPLL
  FROM 
  wellness_fact as w
  LEFT JOIN
  county_demographics as c
  ON 
  w.county_key = c.county_id
  WHERE (c.CTYYEAR = 2018) OR (c.CTYYEAR = 2017)
  GROUP BY ROLLUP (c.CTYYEAR)

  /*Determining the average uninsured rate compared to the total female population per year*/
  SELECT c.CTYYEAR, ROUND(CAST(AVG(w.uninsured) AS NUMERIC), 2) as avg_uninsured, c.TOT_FEMALE
  FROM 
  wellness_fact as w
  LEFT JOIN
  county_demographics as c
  ON 
  w.county_key = c.county_id
  WHERE
  c.CTYYEAR IS NOT NULL 
  AND
  c.TOT_FEMALE IS NOT NULL
  AND
  c.FIPS IS NOT NULL
  GROUP BY ROLLUP (c.CTYYEAR, c.TOT_FEMALE, c.FIPS)
  HAVING c.CTYYEAR IS NOT NULL
  AND
  c.TOT_FEMALE IS NOT NULL
  AND
  c.FIPS IS NOT NULL

  /*Determining the average fair or poor health days reported and mean PM2.5 compared to the county population per county per year*/
  SELECT c.CTYYEAR, c.FIPS, ROUND(CAST(AVG(w.FAIR_POOR_HEALTH) AS NUMERIC), 2) as avg_fair_poor_health, c.TOT_POP, ROUND(CAST(AVG(a.mean_PM2_5_Quarterly_Means_of_Daily_Means_mcg_m3_LC) AS NUMERIC), 2) as avg_PM25
  FROM 
  wellness_fact as w
  LEFT JOIN
  county_demographics as c
  ON 
  w.county_key = c.county_id
  LEFT JOIN
  air_quality_data as a
  ON
  w.air_key = a.air_quality_id
  WHERE
  c.CTYYEAR IS NOT NULL 
  AND
  c.TOT_POP IS NOT NULL
  AND
  c.FIPS IS NOT NULL
  GROUP BY ROLLUP (c.CTYYEAR, c.TOT_POP, c.FIPS)
  HAVING c.CTYYEAR IS NOT NULL
  AND
  c.TOT_POP IS NOT NULL
  AND
  c.FIPS IS NOT NULL

  /*Determining the average mentally unheatlhy days and average precipitation per county per year*/
  SELECT c.CTYYEAR, c.FIPS, ROUND(CAST(AVG(w.MENTALLY_UNHEALTHY) AS NUMERIC), 2) as avg_mentally_unhealthy, c.TOT_POP, ROUND(CAST(AVG(wd.average_precipitation) AS NUMERIC), 2) as avg_precipitation
  FROM 
  wellness_fact as w
  LEFT JOIN
  county_demographics as c
  ON 
  w.county_key = c.county_id
  LEFT JOIN
  weather_data as wd
  ON
  w.weather_key = wd.weather_id
  WHERE
  c.CTYYEAR IS NOT NULL 
  AND
  c.TOT_POP IS NOT NULL
  AND
  c.FIPS IS NOT NULL
  GROUP BY ROLLUP (c.CTYYEAR, c.TOT_POP, c.FIPS)
  HAVING c.CTYYEAR IS NOT NULL
  AND
  c.TOT_POP IS NOT NULL
  AND
  c.FIPS IS NOT NULL

/*
--- Iceberg queries ---
This finds the top 10 counties with the highest average percentage of smokers over years, 
where the daily mean PM2.5 air quality measure is above 5 micrograms per cubic meter, 
and the average temperature is above 70 degrees Fahrenheit. The results are displayed 
with state name, county name, and the rounded average smokers percentage.
*/
SELECT
  cd.STNAME,
  cd.CTYNAME,
  ROUND(AVG(f.SMOKERS), 2) AS average_smokers
FROM
  wellness_fact f
JOIN
  air_quality_data aqd ON f.air_key = aqd.air_quality_id
JOIN
  weather_data wd ON f.weather_key = wd.weather_id
JOIN
  county_demographics cd ON f.county_key = cd.county_id
WHERE
  aqd.mean_PM2_5_Daily_Mean_mcg_m3_LC > 5
  AND wd.average_temperature > 70
  AND f.SMOKERS IS NOT NULL
GROUP BY
  cd.STNAME,
  cd.CTYNAME,
  cd.FIPS
ORDER BY average_smokers DESC
LIMIT 10; 

/*
--- Windowing queries ---
This retrieves state name, county name, year, average temperature, 
average PM2.5 air quality measure, years of potential life lost (YPLL) for each record, 
the average YPLL for each state and county, and the YPLL rank within each state and county. 
The data is sourced from the wellness_fact, county_demographics, weather_data, and air_quality_data tables.
*/
SELECT
  cd.STNAME,
  cd.CTYNAME,
  wd.year,
  wd.average_temperature,
  aqd.mean_PM2_5_Daily_Mean_mcg_m3_LC AS average_pm2_5,
  f.YPLL,
  ROUND(CAST(AVG(f.YPLL) OVER (PARTITION BY cd.STNAME, cd.CTYNAME, cd.FIPS) AS NUMERIC), 2) AS average_YPLL,
  RANK() OVER (PARTITION BY cd.STNAME, cd.CTYNAME, cd.FIPS ORDER BY f.YPLL DESC) AS YPLL_rank
FROM
  wellness_fact f
JOIN
  county_demographics cd ON f.county_key = cd.county_id
JOIN
  weather_data wd ON f.weather_key = wd.weather_id
JOIN
  air_quality_data aqd ON f.air_key = aqd.air_quality_id;

/*
--- Using the Window clause ---
This gets state name, county name, year, percentage of uninsured, the average uninsured percentage for each state and county, 
and a combined rank based on the highest average precipitation and daily maximum 8-hour average ozone concentration. 
The data is sourced from the wellness_fact, county_demographics, weather_data, and air_quality_data tables.
*/
SELECT
  cd.STNAME,
  cd.CTYNAME,
  wd.year,
  f.UNINSURED,
  ROUND(AVG(f.UNINSURED) OVER county_window, 2) AS average_uninsured,
  RANK() OVER (ORDER BY wd.average_precipitation DESC, aqd.mean_O3_Daily_max_8H_AVE_ppm DESC) AS combined_rank
FROM
  wellness_fact f
JOIN
  county_demographics cd ON f.county_key = cd.county_id
JOIN
  weather_data wd ON f.weather_key = wd.weather_id
JOIN
  air_quality_data aqd ON f.air_key = aqd.air_quality_id
WINDOW
  county_window AS (PARTITION BY cd.STNAME, cd.CTYNAME, cd.FIPS);
