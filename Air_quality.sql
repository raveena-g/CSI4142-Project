CREATE TABLE air_quality_data (
index INT PRIMARY KEY,
FIPS VARCHAR(5) NOT NULL,
state_code INT,
county_code INT,
year INT NOT NULL,
mean_CO_8H_AVE_ppm NUMERIC(8,6),
mean_CO_Observed_Values_ppm NUMERIC(8,6),
mean_CO_Obseved_1H_values_ppm NUMERIC(8,6),
mean_NO_Observed_Values_ppb NUMERIC(8,6),
mean_NO2_Daily_Max_1H_AVE_ppb NUMERIC(8,6),
mean_NO2_Observed_Values_ppb NUMERIC(8,6),
mean_NO2_Observed_values_ppb NUMERIC(8,6),
mean_O3_Daily_max_1H_ppm NUMERIC(8,6),
mean_O3_Daily_max_8H_AVE_1H_ppm NUMERIC(8,6),
mean_O3_Daily_max_8H_AVE_ppm NUMERIC(8,6),
mean_PM10_Daily_Mean_mcg_m3_25C NUMERIC(8,6),
mean_PM10_Observed_Values_mcg_m3_25C NUMERIC(8,6),
mean_PM2_5_Daily_Mean_mcg_m3_LC NUMERIC(8,6),
mean_PM2_5_Observed_Values_mcg_m3_LC NUMERIC(8,6),
mean_PM2_5_Quarterly_Means_of_Daily_Means_mcg_m3_LC NUMERIC(8,6),
mean_SO2_3H_AVE_1H_ppb NUMERIC(8,6),
mean_SO2_Daily_Average_ppb NUMERIC(8,6),
mean_SO2_Daily_Max_1H_AVE_ppb NUMERIC(8,6),
mean_SO2_Observed_Values_ppb NUMERIC(8,6),
exceptional_data_count_CO_8H_AVE_ppm NUMERIC(8,6),
exceptional_data_count_CO_Observed_Values_ppm NUMERIC(8,6),
exceptional_data_count_CO_Obseved_1H_values_ppm NUMERIC(8,6),
exceptional_data_count_NO_Observed_Values_ppb NUMERIC(8,6),
exceptional_data_count_NO2_Daily_Max_1H_AVE_ppb NUMERIC(8,6),
exceptional_data_count_NO2_Observed_Values_ppb NUMERIC(8,6),
exceptional_data_count_NO2_Observed_values_ppb NUMERIC(8,6),
exceptional_data_count_O3_Daily_max_1H_ppm NUMERIC(8,6),
exceptional_data_count_O3_Daily_max_8H_AVE_1H_ppm NUMERIC(8,6),
exceptional_data_count_O3_Daily_max_8H_AVE_ppm NUMERIC(8,6),
exceptional_data_count_PM10_Daily_Mean_mcg_m3_25C NUMERIC(8,6),
exceptional_data_count_PM10_Observed_Values_mcg_m3_25C NUMERIC(8,6),
exceptional_data_count_PM2_5_Daily_Mean_mcg_m3_LC NUMERIC(8,6),
exceptional_data_count_PM2_5_Observed_Values_mcg_m3_LC NUMERIC(8,6),
exceptional_data_count_PM2_5_Quarterly_Means_of_Daily_Means_mcg_m3_LC NUMERIC(8,6),
exceptional_data_count_SO2_3H_AVE_1H_ppb NUMERIC(8,6),
exceptional_data_count_SO2_Daily_Average_ppb NUMERIC(8,6),
exceptional_data_count_SO2_Daily_Max_1H_AVE_ppb NUMERIC(8,6),
exceptional_data_count_SO2_Observed_Values_ppb NUMERIC(8,6),
max_value_CO_8H_AVE_ppm NUMERIC(8,6),
max_value_CO_Observed_Values_ppm NUMERIC(8,6),
max_value_CO_Obseved_1H_values_ppm NUMERIC(8,6),
max_value_NO_Observed_Values_ppb NUMERIC(8,6),
max_value_NO2_Daily_Max_1H_AVE_ppb NUMERIC(8,6),
max_value_NO2_Observed_Values_ppb NUMERIC(8,6),
max_value_NO2_Observed_values_ppb NUMERIC(8,6),
max_value_O3_Daily_max_1H_ppm NUMERIC(8,6),
max_value_O3_Daily_max_8H_AVE_1H_ppm NUMERIC(8,6),
max_value_O3_Daily_max_8H_AVE_ppm NUMERIC(8,6),
max_value_PM10_Daily_Mean_mcg_m3_25C NUMERIC(8,6),
max_value_PM10_Observed_Values_mcg_m3_25C NUMERIC(8,6),
max_value_PM2_5_Daily_Mean_mcg_m3_LC NUMERIC(8,6),
max_value_PM2_5_Observed_Values_mcg_m3_LC NUMERIC(8,6),
max_value_PM2_5_Quarterly_Means_of_Daily_Means_mcg_m3_LC NUMERIC(8,6),
max_value_SO2_3H_AVE_1H_ppb NUMERIC(8,6),
max_value_SO2_Daily_Average_ppb NUMERIC(8,6),
max_value_SO2_Daily_Max_1H_AVE_ppb NUMERIC(8,6),
max_value_SO2_Observed_Values_ppb NUMERIC(8,6)
);

COPY air_quality_data 
FROM '/Users/EvaGostiuk/Documents/University/CSI4142/air_quality.csv'
DELIMITER ','
CSV HEADER;