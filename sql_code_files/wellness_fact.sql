-- Create the wellness fact table
CREATE TABLE wellness_fact (
    fact_id SERIAL PRIMARY KEY,
    weather_key INTEGER REFERENCES weather_data(weather_id),
    county_key INTEGER REFERENCES county_demographics(county_id),
	air_key INTEGER REFERENCES air_quality_data(air_quality_id),
    YPLL FLOAT,
    FAIR_POOR_HEALTH NUMERIC(7, 2),
	MENTALLY_UNHEALTHY NUMERIC(7, 2),
	UNINSURED NUMERIC(7, 2)
);

-- Load the keys and fact measures
INSERT INTO wellness_fact (
	weather_key,
	county_key,
	air_key,
	YPLL,
	FAIR_POOR_HEALTH,
	MENTALLY_UNHEALTHY,
	UNINSURED
)
SELECT
    wd.weather_id AS weather_key,
    c.county_id AS county_key,
	aq.air_quality_id AS air_key,
    hm.YPLL,
    hm.FAIR_POOR_HEALTH,
	hm.MENTALLY_UNHEALTHY,
	hm.UNINSURED
FROM
	health_measures AS hm
INNER JOIN
    air_quality_data AS aq
	ON
	hm.STATE_FIPS = aq.state_code
	AND
	hm.COUNTY_FIPS = aq.county_code
	AND
	hm.YEAR = aq.year
INNER JOIN 
	county_demographics AS c
	ON
	aq.state_code = c.STFIPS
	AND
	aq.county_code = c.CTYFIPS
	AND
	aq.year = c.CTYYEAR
INNER JOIN
    weather_data AS wd
	ON
	c.STFIPS = wd.state_code
	AND
	c.CTYFIPS = wd.county_fips
	AND
	c.CTYYEAR = wd.year;

-- Drop the temporary table used to help load the fact table
DROP TABLE health_measures;
