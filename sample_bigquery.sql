/* Sample Problems using Google Bigquery on the dataset of world_bank_intl_education */

-- How many countries are there in this dataset?

SELECT count(distinct(country_name)) FROM `bigquery-public-data.world_bank_intl_education.international_education`

-- result 242

-- show GDP related data of India

SELECT * FROM `bigquery-public-data.world_bank_intl_education.international_education`
WHERE INDICATOR_NAME LIKE "%GDP%" AND
COUNTRY_NAME = "India"


-- average GDP per capita FROM 1996 TO 2016

SELECT AVG(VALUE) FROM `bigquery-public-data.world_bank_intl_education.international_education`
WHERE INDICATOR_CODE = "NY.GDP.PCAP.CD" AND
COUNTRY_NAME = "India" AND
YEAR BETWEEN 1996 AND 2016
GROUP BY COUNTRY_NAME

-- RESULT: 921.5962534451222

