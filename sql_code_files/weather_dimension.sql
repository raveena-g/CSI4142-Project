-- Creating table for weather data
CREATE TABLE weather_data (
	weather_id SERIAL PRIMARY KEY,
	state_code VARCHAR(2) NOT NULL,
	county_fips VARCHAR(3) NOT NULL,
	year SMALLINT NOT NULL,
	average_precipitation NUMERIC(7,2),
	maximum_temperature NUMERIC(7,2),
	minimum_temperature NUMERIC(7,2),
	average_temperature NUMERIC(7,2)
);

-- Load the CSV file into the table
COPY weather_data( 
	state_code,
	county_fips,
	year,
	average_precipitation,
	maximum_temperature,
	minimum_temperature,
	average_temperature
)
FROM '/tmp/weather_dimension.csv'
DELIMITER ','
CSV HEADER;
