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
