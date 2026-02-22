CREATE DATABASE IF NOT EXISTS consult_dw;
USE consult_dw;

DROP TABLE dim_clinics;
DROP TABLE dim_patients;
DROP TABLE dim_addresses;
DROP TABLE dim_dates;
DROP TABLE dim_practitioners;
DROP TABLE dim_template_types;

CREATE TABLE dim_addresses (
    address_key INT AUTO_INCREMENT PRIMARY KEY,
    unit VARCHAR(20),
    street_name VARCHAR(255),
    address_line_2 VARCHAR(255),
    suburb VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(4)
);

CREATE TABLE dim_dates (
    date_key INT PRIMARY KEY,   
    year INT NOT NULL,
    month INT NOT NULL,
    day_of_month INT NOT NULL,
    day_of_week INT NOT NULL
);

CREATE TABLE dim_practitioners (
    practitioner_key INT AUTO_INCREMENT PRIMARY KEY,
    practitioner_id VARCHAR(50) NOT NULL,
    practitioner_name VARCHAR(255),
    ahpra_registration_num VARCHAR(50),
    ahpra_valid_from DATE NOT NULL,
    ahpra_valid_to DATE,
    UNIQUE (practitioner_id, ahpra_registration_num)
);

CREATE TABLE dim_template_types (
    template_key INT AUTO_INCREMENT PRIMARY KEY,
    template_type VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE dim_patients (
    patient_key INT AUTO_INCREMENT PRIMARY KEY,
    patient_id VARCHAR(50) NOT NULL,
    patient_name VARCHAR(255),
    gender VARCHAR(20),
    birth_date DATE,
    phone_number VARCHAR(20),
    address_key INT,
    UNIQUE (patient_id),
    FOREIGN KEY (address_key) REFERENCES dim_addresses(address_key)
);

CREATE TABLE dim_clinics (
    clinic_key INT AUTO_INCREMENT PRIMARY KEY,
    clinic_id VARCHAR(50) NOT NULL,
    clinic_name VARCHAR(255),
    clinic_status VARCHAR(50),
    address_key INT,
    UNIQUE (clinic_id),
    FOREIGN KEY (address_key) REFERENCES dim_addresses(address_key)
);