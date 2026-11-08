-- Veterinary Clinic Relational Database Analysis

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