-- Percentage of consult with at least one document
SELECT 
	ROUND(
		100 * (1 - SUM(CASE WHEN has_documents = 0 THEN 1 ELSE 0 END)
        / COUNT(*)),
	2) as percent_with_documents
FROM consult_report;

-- Most common document template per practitioner
SELECT
    practitioner_name,
    template_type,
    template_count
FROM (
    SELECT
        p.practitioner_name,
        d.template_type,
        COUNT(*) AS template_count,
        ROW_NUMBER() OVER (
            PARTITION BY p.practitioner_name
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM document_report d
    INNER JOIN dim_practitioners p
        ON d.generated_practitioner_key = p.practitioner_key
    GROUP BY p.practitioner_name, d.template_type
) sub
WHERE rn = 1
ORDER BY practitioner_name;

-- Average time from consult end to document generation
SELECT 
	AVG(TIMESTAMPDIFF(MINUTE, c.consult_completed_at, d.document_generated_at)) AS avg_time_consult_end_to_document
FROM consult_report c 
LEFT JOIN document_report d 
	ON c.consult_key = d.consult_key
    WHERE document_generated_at > consult_completed_at;

-- Finalized vs draft documents by clinic
SELECT
    cl.clinic_name,
    d.document_status,
    COUNT(*) AS document_count
FROM document_report d
LEFT JOIN consult_report c
    ON d.consult_key = c.consult_key
INNER JOIN dim_clinics cl
    ON c.clinic_key = cl.clinic_key
	WHERE d.document_status IN ('draft', 'finalized')
GROUP BY
    cl.clinic_name,
    d.document_status
ORDER BY
    cl.clinic_name,
    d.document_status;

-- Practitioners that consistently generate MBS-related documents
SELECT 
    p.practitioner_name,
    COUNT(*) AS total_documents,
    SUM(CASE WHEN LOWER(d.template_type) LIKE '%mbs%' THEN 1 ELSE 0 END) AS mbs_documents,
    ROUND(100.0 * SUM(CASE WHEN LOWER(d.template_type) LIKE '%mbs%' THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_mbs
FROM document_report d
INNER JOIN dim_practitioners p
    ON d.generated_practitioner_key = p.practitioner_key
GROUP BY p.practitioner_name
ORDER BY pct_mbs DESC;