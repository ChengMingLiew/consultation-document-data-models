-- checks if there are invalid dates or not
SELECT *
FROM dim_dates
WHERE STR_TO_DATE(
        CONCAT(year,'-',LPAD(month,2,'0'),'-',LPAD(day_of_month,2,'0')),
        '%Y-%m-%d'
      ) > CURDATE();

-- checks for duplicate addresses
SELECT unit, street_name, suburb, state, zip_code, COUNT(*) AS count_duplicates
FROM dim_addresses
GROUP BY unit, street_name, suburb, state, zip_code
HAVING COUNT(*) > 1;

-- checks for same date but different keys
SELECT year, month, day_of_month, COUNT(DISTINCT date_key) AS key_count,
       GROUP_CONCAT(date_key) AS duplicate_keys
FROM dim_dates
GROUP BY year, month, day_of_month
HAVING COUNT(DISTINCT date_key) > 1;

-- checking for clinics that have the same address
SELECT address_key, COUNT(*) AS clinic_count, GROUP_CONCAT(clinic_id) AS clinics
FROM dim_clinics
GROUP BY address_key
HAVING COUNT(*) > 1;

