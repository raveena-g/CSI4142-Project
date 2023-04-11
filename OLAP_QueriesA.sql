  /*Roll up*/
  /*Finding the Years of Potential Life Lost (YPLL) at the year level*/
  SELECT c.CTYYEAR, SUM(w.YPLL)
  FROM 
  wellness_fact as w
  LEFT JOIN
  county_demographics as c
  ON 
  w.county_key = c.county_id
  GROUP BY ROLLUP (c.CTYYEAR)

  /*Drill down*/
  /*Finding the YPLL at the year and state level*/
  SELECT c.CTYYEAR, c.STFIPS, SUM(w.YPLL)
  FROM 
  wellness_fact as w
  LEFT JOIN
  county_demographics as c
  ON 
  w.county_key = c.county_id
  GROUP BY ROLLUP (c.CTYYEAR, c.STFIPS)

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
  SELECT c.CTYYEAR, SUM(w.YPLL)
  FROM 
  wellness_fact as w
  LEFT JOIN
  county_demographics as c
  ON 
  w.county_key = c.county_id
  WHERE (c.CTYYEAR = 2018) OR (c.CTYYEAR = 2017)
  GROUP BY ROLLUP (c.CTYYEAR)

  /*Determining the average uninsured rate compared to the total female population per year*/
  SELECT c.CTYYEAR, AVG(w.uninsured), c.TOT_FEMALE
  FROM 
  wellness_fact as w
  LEFT JOIN
  county_demographics as c
  ON 
  w.county_key = c.county_id
  GROUP BY ROLLUP (c.CTYYEAR, c.TOT_FEMALE, c.FIPS)

  /*Determining the average fair or poor health days reported and mean PM2.5 compared to the county population per county per year*/
  SELECT c.CTYYEAR, c.FIPS, AVG(w.FAIR_POOR_HEALTH) as average_fair_poor_health, c.TOT_POP, AVG(a.mean_PM2_5_Quarterly_Means_of_Daily_Means_mcg_m3_LC) as average_PM25
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
  GROUP BY ROLLUP (c.CTYYEAR, c.TOT_POP, c.FIPS)

  /*Determining the average mentally unheatlhy days and average precipitation per county per year*/
  SELECT c.CTYYEAR, c.FIPS, AVG(w.MENTALLY_UNHEALTHY) as average_mentally_unhealthy_days, c.TOT_POP, AVG(wd.average_precipitation) as average_precipitation
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
  GROUP BY ROLLUP (c.CTYYEAR, c.TOT_POP, c.FIPS)