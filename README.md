# Reporting-Ready Data Models for Consulations and Documentations

## ERD / Schema Design

<img width="833" height="737" alt="image" src="https://github.com/user-attachments/assets/6e8f9540-9875-46ff-b719-1b65f748a1e4" />

## Key Assumptions
- Dimension tables are populated with the necessary data, raw consult and document data are cleaned, parsed and ready to be inserted into the fact tables.
- One patient and one practitioner per consult, and each consult belongs to exactly one clinic.

## Denormalization
- This model uses a star schema to organize consult and documentation data. Fact tables (`fct_documents` and `fct_consults`) store foreign keys to dimension tables, but also contain redundant attributes to support faster reporting. Attributes such as `template_type`, `event_type`, `document_status` can technically be further normalised into other dimensions, but keeping them in the fact table reduces the number of joins required, hence increasing query speed.
- We also created derived attributes for the purpose of reporting and analysis in reporting tables (`consult_report` and `document_report`):
  - `consult_completed_at`, a timestamp when the consult was completed.
  - `has_documents`, a boolean indicating if a document is linked with a specific consult.
  - `document_count`, the total number of documents linked to a specific consult.
  - `is_finalized`, a boolean indicating if a specific document is finalized or not.
  -  `minutes_from_consult_to_document`, the time between the consult ending and the documents linked to it being generated.
These transformations simplify reporting queries and simplifies proccesses for upstream analysis without repeatedly performing joins and aggregations.

## Partitioning Large Tables
Considering that this data model is primarily used for reporting and analytics purposes, partitioing the data based on the data would be most effective. Fact tables `fct_consults` and `fct_documents` will be partitioned according to `consult_date_key` and `document_date_key` respectively.

This approach is appropriate as most queries used for reporting commonly filter the data by date. Reports based on the fiscal year, the 3rd quarter of the year, monthly reports to name a few. 

Hence, this would improve query performance significantly.

## Audits and Billing
