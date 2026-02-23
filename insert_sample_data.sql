INSERT INTO dim_addresses (unit, street_name, suburb, state, zip_code)
VALUES
('1A', 'Main St', 'Central', 'NSW', '2000'),
('12', 'High St', 'Northside', 'VIC', '3000'),
('5B', 'Lake Rd', 'Lakeside', 'QLD', '4000');

INSERT INTO dim_dates (date_key, year, month, day_of_month, day_of_week)
VALUES
(20250708, 2025, 7, 8, 3),
(20250709, 2025, 7, 9, 4),
(20250710, 2025, 7, 10, 5);

INSERT INTO dim_practitioners (practitioner_id, practitioner_name, ahpra_registration_num, ahpra_valid_from, ahpra_valid_to)
VALUES
('pr_001', 'Dr. Alice Smith', 'AHP12345', '2020-01-01', '2030-12-31'),
('pr_002', 'Dr. Bob Jones', 'AHP67890', '2021-01-01', '2031-12-31'),
('pr_003', 'Dr. Carol Lee', 'AHP54321', '2019-01-01', '2029-12-31');

INSERT INTO dim_patients (patient_id, patient_name, gender, birth_date, phone_number, address_key)
VALUES
('pt_001', 'John Doe', 'M', '1980-05-15', '555-1234', 1),
('pt_002', 'Jane Smith', 'F', '1990-08-22', '555-5678', 2),
('pt_003', 'Sam Wilson', 'M', '1975-11-02', '555-9012', 3);

INSERT INTO dim_clinics (clinic_id, clinic_name, clinic_status, address_key)
VALUES
('cl_001', 'City Clinic', 'Active', 1),
('cl_002', 'Northside Health', 'Active', 2),
('cl_003', 'Lakeside Medical', 'Active', 3);

INSERT INTO fct_consults
(consult_id, event_type, duration_minutes, modality, consult_time, consult_date_key, practitioner_key, patient_key, clinic_key)
VALUES
('con_001', 'consult_completed', 50, 'in_person', '14:00:00', 20250708, 1, 1, 1),
('con_002', 'consult_completed', 30, 'telehealth', '09:30:00', 20250709, 2, 2, 2),
('con_003', 'consult_completed', 45, 'in_person', '11:15:00', 20250710, 3, 3, 3);

INSERT INTO fct_documents
(document_id, document_status, signed, template_type, document_generated_at, generated_practitioner_key, document_date_key, consult_key, template_type_key)
VALUES
('doc_001', 'draft', FALSE, '14:10:00', 1, 20250708, 1, 1),
('doc_002', 'finalized', TRUE, 'referral_letter', '15:00:00', 1, 20250708, 1),
('doc_003', 'finalized', TRUE, '12:30:00', 'progress_note', 3, 20250710, 3),
('doc_004', 'finalized', TRUE, '10:15:00', 'mbs_referral', 2, 20250710, 2),
('doc_005', 'finalized', TRUE, '10:30:00', 'mbs_claim_form', 2, 20250710, 2);