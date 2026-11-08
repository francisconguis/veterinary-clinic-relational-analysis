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

---

## Entity Relationship & Schema Details

The database models a normalized relational schema connecting patients, pet owners, clinical visits, and medical procedures:

```text
[ owner ] (1) <─────── (M) [ pet ] (1) <─────── (M) [ doctorvisit ] (M) ───────> (1) [ procedure ]
```

### 1. `owner` Table
| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `Owner` | `VARCHAR(50)` | `PRIMARY KEY` | Unique alphanumeric owner code (e.g., `SLC`, `MDB`) |
| `OwnerName` | `VARCHAR(50)` | `NOT NULL` | Full name of the pet owner |
| `Address` | `VARCHAR(255)` | `NULL` | Residential address including city/municipality |
| `ContactNum` | `VARCHAR(50)` | `NULL` | Primary mobile contact number |

### 2. `pet` Table
| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `PetID` | `INT` | `PRIMARY KEY` | Unique identifier assigned to each patient |
| `PetName` | `VARCHAR(50)` | `NOT NULL` | Registered name of the pet |
| `PetType` | `VARCHAR(50)` | `NOT NULL` | Animal species (e.g., `dog`, `cat`) |
| `Breed` | `VARCHAR(50)` | `NOT NULL` | Specific breed classification |
| `Birthdate` | `DATE` | `NOT NULL` | Verified date of birth (`YYYY-MM-DD`) |
| `Age` | `INT` | `DEFAULT 0` | Current age in completed years |
| `Sex` | `VARCHAR(50)` | `NOT NULL` | Gender indicator (`M` / `F`) |
| `Owner` | `VARCHAR(50)` | `FOREIGN KEY` | References `owner.Owner` |
| `FurColor` | `VARCHAR(50)` | `NULL` | Coat color description |
| `Weight` | `INT` | `NULL` | Recorded weight in kilograms |

### 3. `procedure` Table
| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `ProcCode` | `VARCHAR(50)` | `PRIMARY KEY` | Clinical procedure code (e.g., `NEU`, `SPY`, `RAV`) |
| `ProcedureName` | `VARCHAR(50)` | `NOT NULL` | Full descriptive title of the veterinary service |
| `Fee` | `DECIMAL(10, 2)`| `NOT NULL` | Standard procedural billing cost |

### 4. `doctorvisit` Table
| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `PetID` | `INT` | `FOREIGN KEY`, `COMPOSITE PK` | References `pet.PetID` |
| `DateofVisit` | `DATE` | `COMPOSITE PK` | Date of clinical consultation |
| `ProcCode` | `VARCHAR(50)` | `FOREIGN KEY`, `COMPOSITE PK` | References `procedure.ProcCode` |
| `OtherComments` | `VARCHAR(255)` | `NULL` | Practitioner notes or observations |

---

## Tasks & Problems

1. Update age of pet using a date function which can compute the number of years gap between 2 dates.
2. Display the name of the pets and the number of visits to the vet. Include in the list only those who had visited the vet more than once.
3. Display the name of the owner and the number of pets owned.
4. Display all pet information and owner name. Display only those whose owners are from Manila. Sort by age, from the oldest to the youngest.
5. Display pet name, date of visit to the vet, and the name of procedure done during the visit. Exclude procedures related to neutering.
6. Display the total amount paid to the vet for all the procedures done to the pet. Include also the name of the pet. Display from highest to lowest amount.
7. List the names and age of the pets which have been spayed or neutered.
8. List the name of pets which already have their rabies vaccination from previous years.
9. Display the name of the pets which have been vaccinated twice for rabies.
10. Display the name of the owner and the pets he own together with the breed and age of the pet.

---

## Solutions Overview

1. **Dynamic Age Synchronization (DML)**: Dynamically calculated each patient's age in completed years using `TIMESTAMPDIFF(YEAR, Birthdate, CURDATE())` via an in-place `UPDATE` statement.
2. **Patient Visit Frequency Aggregation**: Grouped clinical consultation records by pet identifier using `COUNT()` and isolated repeat patients with `HAVING COUNT(v.PetID) > 1`.
3. **Owner Pet Volume Analysis**: Performed an inner relational join between owners and registered animals, aggregating count distribution per owner using `GROUP BY`.
4. **Targeted Regional Cohort Filtering**: Extracted full clinical profiles joined with owner metadata, filtered for accounts situated in the Manila municipality using `LIKE '%Manila%'`, and ordered chronologically by birthdate.
5. **Routine Medical History Extraction**: Joined patient, visit, and procedure relations while excluding reproductive surgical procedures using `WHERE ProcedureName NOT LIKE '%Neuter%'`.
6. **Cumulative Clinical Revenue Rollup**: Computed total procedural expenditures per animal using `SUM(pr.Fee)`, formatted amounts with commas and standard two-decimal precision using `FORMAT()`, and ranked results in descending order.
7. **Reproductive Health Audit**: Isolated distinct animals subjected to spaying or neutering using `IN ('NEU', 'SPY')` to track sterilized populations.
8. **Historical Rabies Immunization Tracking**: Filtered rabies vaccination visits (`ProcCode = 'RAV'`) strictly occurring prior to the current calendar year via `YEAR(DateofVisit) < YEAR(CURDATE())`.
9. **Multi-Dose Compliance Verification**: Identified patient profiles that have achieved two rabies vaccination records using a grouped evaluation bounded by `HAVING COUNT(v.ProcCode) = 2`.
10. **Comprehensive Ownership Roster**: Generated a sorted master catalog pairing each registered owner with their respective pets, breeds, and current ages.

---

---

## Execution Instructions

1. **Create and Select Database:**
   ```sql
   CREATE DATABASE IF NOT EXISTS veterinary_clinic;
   USE veterinary_clinic;
   ```

2. **Import Tables via CSV:**
   Import the four baseline CSV files (`owner.csv`, `pet.csv`, `procedure.csv`, `doctorvisit.csv`) using the MySQL Workbench Table Data Import Wizard or through `LOAD DATA LOCAL INFILE`.

   > **Note on Reserved Keywords:** If importing `procedure.csv` via Workbench automatically creates a table named `procedure1`, rename it using:
   > ```sql
   > RENAME TABLE procedure1 TO `procedure`;
   > ```

3. **Execute Analysis Script:**
   ```bash
   mysql -u <username> -p veterinary_clinic < 01_veterinary_clinical_queries_and_analytics.sql
   ```

---

## License

This project is licensed under the [MIT License](LICENSE).
