DROP TABLE fct_documents;
DROP TABLE fct_consults;

CREATE TABLE fct_consults (
    consult_key INT AUTO_INCREMENT PRIMARY KEY,
    consult_id VARCHAR(50) NOT NULL,
    event_type VARCHAR(100),
    duration_minutes INT,
    modality VARCHAR(50),
    consult_time TIME,
    consult_date_key INT,
    practitioner_key INT,
    patient_key INT,
    clinic_key INT,
    UNIQUE (consult_id),
    FOREIGN KEY (consult_date_key) REFERENCES dim_dates(date_key),
    FOREIGN KEY (practitioner_key) REFERENCES dim_practitioners(practitioner_key),
    FOREIGN KEY (patient_key) REFERENCES dim_patients(patient_key),
    FOREIGN KEY (clinic_key) REFERENCES dim_clinics(clinic_key)
);

CREATE TABLE fct_documents (
    document_key INT AUTO_INCREMENT PRIMARY KEY,
    document_id VARCHAR(50) NOT NULL,
    document_status VARCHAR(50),
    signed BOOLEAN,
    document_generated_at TIME,
    template_type VARCHAR(50),
    generated_practitioner_key INT,
    document_date_key INT,
    consult_key INT,
    UNIQUE (document_id),
    FOREIGN KEY (generated_practitioner_key) 
        REFERENCES dim_practitioners(practitioner_key),
    FOREIGN KEY (document_date_key) 
        REFERENCES dim_dates(date_key),
    FOREIGN KEY (consult_key) 
        REFERENCES fct_consults(consult_key)
);
