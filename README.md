# Reporting-Ready Data Models for Consulations and Documentations

## ERD / Schema Design

<img width="1325" height="748" alt="image" src="https://github.com/user-attachments/assets/010289fb-1d81-474f-805d-7cb55ed157eb" />

## Key Assumptions
- Dimension Tables are populated and, data is cleaned ,parsed and ready to be inserted into fact tables.
- One patient and one practitioner per consult, and each consult belongs to exactly one clinic.

## Denormalization
- This model uses a star schema to organize consult and documentation data. Fact tables (`fct_documents` and `fct_consults`) store foreign keys to dimension tables, but also contain redundant attributes to support faster reporting. Attributes such as `template_type`, `event_type`, `document_status` can technically be further normalised into other dimensions, but keeping them in the fact table reduces the number of joins required, hence increasing query speed.
- We also created derived attributes for the purpose of reporting and analysis in reporting tables (`consult_report` and `document_report`):
- - `consult_completed_at`, a timestamp when the consult was completed.
  - `has_documents`, a boolean indicating if a document is linked with a specific consult.
  - `document_count`, the total number of documents linked to a specific consult.

##
