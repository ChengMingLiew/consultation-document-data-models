# Reporting-Ready Data Models for Consultations and Documentations

## ERD / Schema Design

<img width="833" height="737" alt="image" src="https://github.com/user-attachments/assets/6e8f9540-9875-46ff-b719-1b65f748a1e4" />

## Key Assumptions
- Dimension tables are populated with the necessary data, raw consult and raw document data are cleansed, parsed and inserted into the fact tables.
- One patient and one practitioner per consult, and each consult belongs to exactly one clinic.
- Patient, practitioner, document, consult, clinic ID are unique.
- Documents can be generated while the consultation is ongoing.
- All documents are generated the same day the consultation is performed.

## Denormalization
- This model uses a star schema to organize consult and document data. Fact tables (`fct_documents` and `fct_consults`) store foreign keys to dimension tables, but also contain redundant attributes to support faster reporting. Attributes such as `template_type`, `event_type`, `document_status` can technically be further normalised into other dimensions, but keeping them in the fact table reduces the number of joins required, hence increasing query speed.
- We also created derived attributes for the purpose of reporting and analysis in reporting tables (`consult_report` and `document_report`):
  - `consult_completed_at`, a timestamp when the consult was completed.
  - `has_documents`, a boolean indicating if a consult have documents linked to it or not.
  - `document_count`, the total number of documents linked to a specific consult.
  - `is_finalized`, a boolean indicating if a specific document is finalized or not.
  -  `minutes_from_consult_to_document`, the time between the consult ending and the documents linked to it being generated.

These transformations simplify reporting queries and simplifies proccesses for upstream analysis without repeatedly performing joins and aggregations.

## Partitioning Large Tables
Considering that this data model is primarily used for reporting and analytics purposes, we should strive to partition the data based on the most common access patterns. Reports such as monthly trend analysis, seasonal and periodic analysis, forecasting analysis are some time-based analysis that are commonly produced. Hence, in analytical and reporting systems, time-based filtering is one of the most frequent access patterns. Therefore, it is most effective to partition the tables by date. Fact tables `fct_consults` and `fct_documents` will be partitioned according to `consult_date_key` and `document_date_key` respectively. 

To partition by date, we would most likely perform range partitioning, where our table will be partitioned by months. By doing that, a query filtering for a specific month would look into the partition that belongs to that month rather than the whole table, making lookup speed faster. Furthermore, by doing monthly partitions, we are striking a balance between yearly partitions where it might be too large, or daily partitions which is too small.

## Audits and Billing
### Audits
First, to support auditing, one of the few ways we can to is to introduce audit logs to our database. We can implement shadow tables, where they contain the same fields as the tables they audit, plus audit specific fields. Some example of audit fields would be:
- `user`, records the user that made the changes.
- `date_time_changed`, records the date and time of when the changes are made.
- `action`, records the specific action (INSERT, DELETE, MODIFY) that is performed.

These fields would be able to track which specific user performed what operation at what date and time. Hence, we have an audit log that tracks database history albeit taking up more memory.

### Billing
For this, we can implement a fact table for billing, `fct_billing`. This fact table serves the purpose of calculating the price breakdown, payment period, payment type and others for our own record keeping and for client-facing purposes. Some fields that would be used are:
- `invoice_id`, `payment_status`, `payment_period`, this keeps track of which payment, the payment status and the billable period of the client.
- `billable_amount`, `quantity`, `cost_per_unit`, `discount` this records the payment breakdown for the our and client's purposes.

These are some fields which would allow us to keep track of invoices and it's details that are billed to our clients.
