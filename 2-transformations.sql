DROP TABLE document_report;
DROP TABLE consult_report;

CREATE TABLE consult_report AS
SELECT     
	c.consult_key,
    c.consult_id,
    c.event_type,
    c.duration_minutes,
    c.modality,
    DATE_ADD(consult_time, INTERVAL c.duration_minutes MINUTE) AS consult_completed_at,
	CASE
		WHEN COUNT(d.document_key) > 0 THEN TRUE ELSE FALSE END AS has_documents,
    COUNT(d.document_key) AS document_count,
    c.consult_date_key,
    c.practitioner_key,
    c.patient_key,
    c.clinic_key
	FROM fct_consults c 
	LEFT JOIN fct_documents d
		ON c.consult_key = d.consult_key
	GROUP BY c.consult_key;

CREATE TABLE document_report AS
SELECT
    fd.document_key,
    fd.document_id,
    fd.document_status,
    fd.signed,
    fd.template_type,
    fd.document_generated_at,
    CASE 
		WHEN fd.document_status = "finalized" THEN TRUE ELSE FALSE END AS is_finalized,
	TIMESTAMPDIFF(MINUTE, fc.consult_time, fd.document_generated_at) AS minutes_from_consult_to_document,
	fd.generated_practitioner_key,
    fd.document_date_key,
    fd.consult_key
	FROM fct_documents fd
	LEFT JOIN fct_consults fc 
		ON fd.consult_key = fc.consult_key
	LEFT JOIN dim_dates dd
		ON fd.document_date_key = dd.date_key
	LEFT JOIN dim_dates dc 
		ON fc.consult_date_key = dc.date_key;