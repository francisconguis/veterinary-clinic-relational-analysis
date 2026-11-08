# Veterinary Clinic Relational Database Analysis

A comprehensive MySQL relational database analysis and reporting project tracking veterinary clinic operations, patient demographics, owner records, clinical visits, and procedural billing.

This project demonstrates practical multi-table joins (`INNER JOIN`), conditional filtering (`WHERE`, `LIKE`, `IN`), group-level aggregations (`GROUP BY`, `HAVING`, `SUM`, `COUNT`), temporal functions (`TIMESTAMPDIFF`, `YEAR`, `CURDATE`), and financial formatting (`FORMAT`).

---

## Repository Structure

```text
veterinary-clinic-relational-analysis/
├── doctorvisit.csv
├── owner.csv
├── pet.csv
├── procedure.csv
├── 01_veterinary_clinical_queries_and_analytics.sql
├── LICENSE
└── README.md
```

Entity Relationship & Schema Details
The database models a normalized relational schema connecting patients, pet owners, clinical visits, and medical procedures:
[ owner ] (1) <─────── (M) [ pet ] (1) <─────── (M) [ doctorvisit ] (M) ───────> (1) [ procedure ]
