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
| `Owner` | `VARCHAR(50)` | `PRIMARY KEY` | Unique alphanumeric owner code (e.g., `SLC`, `MDB`)[cite: 3] |
| `OwnerName` | `VARCHAR(50)` | `NOT NULL` | Full name of the pet owner[cite: 3] |
| `Address` | `VARCHAR(255)` | `NULL` | Residential address including city/municipality[cite: 3] |
| `ContactNum` | `VARCHAR(50)` | `NULL` | Primary mobile contact number[cite: 3] |

### 2. `pet` Table
| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `PetID` | `INT` | `PRIMARY KEY` | Unique identifier assigned to each patient[cite: 4] |
| `PetName` | `VARCHAR(50)` | `NOT NULL` | Registered name of the pet[cite: 4] |
| `PetType` | `VARCHAR(50)` | `NOT NULL` | Animal species (e.g., `dog`, `cat`)[cite: 4] |
| `Breed` | `VARCHAR(50)` | `NOT NULL` | Specific breed classification[cite: 4] |
| `Birthdate` | `DATE` | `NOT NULL` | Verified date of birth (`YYYY-MM-DD`)[cite: 4] |
| `Age` | `INT` | `DEFAULT 0` | Current age in completed years[cite: 4] |
| `Sex` | `VARCHAR(50)` | `NOT NULL` | Gender indicator (`M` / `F`)[cite: 4] |
| `Owner` | `VARCHAR(50)` | `FOREIGN KEY` | References `owner.Owner`[cite: 4] |
| `FurColor` | `VARCHAR(50)` | `NULL` | Coat color description[cite: 4] |
| `Weight` | `INT` | `NULL` | Recorded weight in kilograms[cite: 4] |

### 3. `procedure` Table
| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `ProcCode` | `VARCHAR(50)` | `PRIMARY KEY` | Clinical procedure code (e.g., `NEU`, `SPY`, `RAV`) |
| `ProcedureName` | `VARCHAR(50)` | `NOT NULL` | Full descriptive title of the veterinary service |
| `Fee` | `DECIMAL(10, 2)`| `NOT NULL` | Standard procedural billing cost |

### 4. `doctorvisit` Table
| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `PetID` | `INT` | `FOREIGN KEY`, `COMPOSITE PK` | References `pet.PetID`[cite: 2] |
| `DateofVisit` | `DATE` | `COMPOSITE PK` | Date of clinical consultation[cite: 2] |
| `ProcCode` | `VARCHAR(50)` | `FOREIGN KEY`, `COMPOSITE PK` | References `procedure.ProcCode`[cite: 2] |
| `OtherComments` | `VARCHAR(255)` | `NULL` | Practitioner notes or observations[cite: 2] |

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

## Technical Implementation (`01_veterinary_clinical_queries_and_analytics.sql`)

```sql
-- =============================================================================
-- Veterinary Clinic Relational Database Analysis
-- File: 01_veterinary_clinical_queries_and_analytics.sql
-- =============================================================================

-- 1. Update Age of Pet Using a Date Function
UPDATE pet
SET Age = TIMESTAMPDIFF(YEAR, Birthdate, CURDATE());

-- 2. Pets with More Than One Vet Visit
SELECT 
    p.PetName AS `Pet Name`,
    COUNT(v.PetID) AS `Total Visits`
FROM pet p
JOIN doctorvisit v ON p.PetID = v.PetID
GROUP BY p.PetID, p.PetName
HAVING COUNT(v.PetID) > 1
ORDER BY `Total Visits` DESC, `Pet Name` ASC;

-- 3. Owner Name and Total Pets Owned
SELECT 
    o.OwnerName AS `Owner Name`,
    COUNT(p.PetID) AS `Pets Owned`
FROM owner o
JOIN pet p ON o.Owner = p.Owner
GROUP BY o.Owner, o.OwnerName
ORDER BY `Pets Owned` DESC, `Owner Name` ASC;

-- 4. Pet Information for Owners from Manila (Sorted Oldest to Youngest)
SELECT 
    p.PetID AS `Pet ID`,
    p.PetName AS `Pet Name`,
    p.PetType AS `Type`,
    p.Breed AS `Breed`,
    p.Birthdate AS `Birthdate`,
    p.Age AS `Age`,
    p.Sex AS `Sex`,
    p.FurColor AS `Fur Color`,
    p.Weight AS `Weight (kg)`,
    o.OwnerName AS `Owner Name`,
    o.Address AS `Owner Address`
FROM pet p
JOIN owner o ON p.Owner = o.Owner
WHERE o.Address LIKE '%Manila%'
ORDER BY p.Birthdate ASC;

-- 5. Pet Name, Visit Date, and Procedure (Excluding Neutering)
SELECT 
    p.PetName AS `Pet Name`,
    v.DateofVisit AS `Date of Visit`,
    pr.ProcedureName AS `Procedure Performed`
FROM doctorvisit v
JOIN pet p ON v.PetID = p.PetID
JOIN `procedure` pr ON v.ProcCode = pr.ProcCode
WHERE pr.ProcedureName NOT LIKE '%Neuter%'
ORDER BY v.DateofVisit ASC;

-- 6. Total Amount Paid to the Vet per Pet (Highest to Lowest)
SELECT 
    p.PetName AS `Pet Name`,
    CONCAT('₱', FORMAT(SUM(pr.Fee), 2)) AS `Total Amount Paid`
FROM pet p
JOIN doctorvisit v ON p.PetID = v.PetID
JOIN `procedure` pr ON v.ProcCode = pr.ProcCode
GROUP BY p.PetID, p.PetName
ORDER BY SUM(pr.Fee) DESC;

-- 7. Names and Age of Spayed or Neutered Pets
SELECT DISTINCT 
    p.PetName AS `Pet Name`,
    p.Age AS `Age`,
    p.Sex AS `Sex`,
    pr.ProcedureName AS `Procedure Done`
FROM pet p
JOIN doctorvisit v ON p.PetID = v.PetID
JOIN `procedure` pr ON v.ProcCode = pr.ProcCode
WHERE v.ProcCode IN ('NEU', 'SPY')
ORDER BY p.PetName ASC;

-- 8. Pets with Rabies Vaccination from Previous Years
SELECT DISTINCT 
    p.PetName AS `Pet Name`,
    v.DateofVisit AS `Vaccination Date`
FROM pet p
JOIN doctorvisit v ON p.PetID = v.PetID
WHERE v.ProcCode = 'RAV'
  AND YEAR(v.DateofVisit) < YEAR(CURDATE())
ORDER BY v.DateofVisit ASC;

-- 9. Pets Vaccinated Twice for Rabies
SELECT 
    p.PetName AS `Pet Name`,
    COUNT(v.ProcCode) AS `Rabies Vaccinations Count`
FROM pet p
JOIN doctorvisit v ON p.PetID = v.PetID
WHERE v.ProcCode = 'RAV'
GROUP BY p.PetID, p.PetName
HAVING COUNT(v.ProcCode) = 2;

-- 10. Owner Name, Owned Pets, Breed, and Age
SELECT 
    o.OwnerName AS `Owner Name`,
    p.PetName AS `Pet Name`,
    p.Breed AS `Breed`,
    p.Age AS `Age`
FROM owner o
JOIN pet p ON o.Owner = p.Owner
ORDER BY o.OwnerName ASC, p.PetName ASC;
```

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
