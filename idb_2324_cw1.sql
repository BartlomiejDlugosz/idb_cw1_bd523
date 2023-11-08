-- Q1 returns (name,born_in,father,mother)
SELECT p.name, p.born_in, p.father, p.mother
FROM person p
         LEFT JOIN person AS father
                   ON (p.father = father.name)
         LEFT JOIN person AS mother
                   ON (p.mother = mother.name)
WHERE p.born_in = father.born_in
  AND p.born_in = mother.born_in
ORDER BY name
;

-- Q2 returns (name)
SELECT name
FROM person
EXCEPT
(SELECT m.name
 FROM monarch AS m
 UNION
 SELECT p.name
 FROM prime_minister AS p)
ORDER BY name
;

-- Q3 returns (name)
SELECT name
FROM monarch
         LEFT JOIN person
                   USING (name)
WHERE 0 < (SELECT COUNT(m.accession)
           FROM monarch AS m
           WHERE m.accession < person.dod
             AND m.accession > monarch.accession)
ORDER BY name
;

-- Q4 returns (house,name,accession)
SELECT house, name, accession
FROM monarch AS m
WHERE 0 = (SELECT COUNT(house)
           FROM monarch
           WHERE m.house = house
             AND m.accession > accession)
  AND house IS NOT NULL
;

-- Q5 returns (name,role,start_date)
SELECT name, 'Prime Minister' AS role, entry AS start_date
FROM prime_minister
UNION ALL
SELECT name,
       CASE
           WHEN house IS NOT NULL THEN 'Monarch'
           ELSE 'Lord Protector'
           END   AS role,
       accession AS start_date
FROM monarch
ORDER BY start_date, name
;

-- Q6 returns (first_name,popularity)
SELECT first_name,
       count(first_name) AS popularity
FROM (SELECT CASE
                 WHEN POSITION(' ' IN name) = 0 THEN name
                 ELSE SUBSTRING(name FROM 1 FOR POSITION(' ' IN name) - 1)
                 END AS first_name
      FROM person) AS names
GROUP BY first_name
HAVING count(first_name) > 1
ORDER BY popularity DESC, first_name
;

-- Q7 returns (party,seventeenth,eighteenth,nineteenth,twentieth,twentyfirst)
SELECT party,
       COUNT(party) FILTER (WHERE entry >= '1700-01-01' AND entry < '1800-01-01') AS eighteenth,
       COUNT(party) FILTER (WHERE entry >= '1800-01-01' AND entry < '1900-01-01') AS nineteenth,
       COUNT(party) FILTER (WHERE entry >= '1900-01-01' AND entry < '2000-01-01') AS twentieth,
       COUNT(party) FILTER (WHERE entry >= '2000-01-01' AND entry < '2100-01-01') AS twentyfirst
FROM prime_minister
GROUP BY party
ORDER BY party
;

-- Q8 returns (mother,child,born)
SELECT woman.name AS mother,
       child.name AS child,
       born
FROM person AS woman
         LEFT JOIN person AS child ON (woman.name = child.mother)
         LEFT JOIN (SELECT name, ROW_NUMBER() OVER (PARTITION BY mother ORDER BY dob) AS born
                    FROM person) AS children ON (child.name = children.name)
WHERE woman.gender = 'F'
ORDER BY mother, born, child
;

-- Q9 returns (monarch,prime_minister)
SELECT monarch.name AS monarch,
       p.name AS prime_minister
FROM monarch
         JOIN person AS m USING (name)
         JOIN prime_minister AS p ON (p.entry > monarch.accession
    AND p.entry < COALESCE((SELECT MIN(next_monarch.accession)
                            FROM monarch AS next_monarch
                            WHERE next_monarch.accession > monarch.accession), CURRENT_DATE) OR (
        p.entry < monarch.accession
        AND
        monarch.accession < (SELECT MIN(next_pm.entry)
                             FROM prime_minister AS next_pm
                             WHERE next_pm.entry > p.entry)
    ))
ORDER BY prime_minister, monarch
;

-- Q10 returns (name,entry,period,days)

;

