-- Q1 returns (name,born_in,father,mother)
SELECT p.name, p.born_in, p.father, p.mother
FROM person AS p
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
(SELECT name
 FROM monarch
 UNION
 SELECT name
 FROM prime_minister)
ORDER BY name
;

-- Q3 returns (name)
SELECT name
FROM monarch AS currentMonarch
         NATURAL JOIN person
WHERE dod > COALESCE((SELECT MIN(accession)
                      FROM monarch AS nextMonarch
                      WHERE accession > currentMonarch.accession), CURRENT_DATE)
ORDER BY name
;

-- Q4 returns (house,name,accession)
SELECT house, name, accession
FROM monarch AS currentMonarch
WHERE 0 = (SELECT COUNT(house)
           FROM monarch
           WHERE currentMonarch.house = house
             AND currentMonarch.accession > accession)
  AND house IS NOT NULL
;

-- Q5 returns (name,role,start_date)
SELECT name, 'Prime Minister' AS role, entry AS start_date
FROM prime_minister
UNION
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
       COUNT(first_name) AS popularity
FROM (SELECT CASE
                 WHEN POSITION(' ' IN name) = 0 THEN name
                 ELSE SUBSTRING(name FROM 1 FOR POSITION(' ' IN name) - 1)
                 END AS first_name
      FROM person) AS names
GROUP BY first_name
HAVING COUNT(first_name) > 1
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
       children.name AS child,
       CASE
           WHEN children.name IS NOT NULL
               THEN ROW_NUMBER() OVER (PARTITION BY children.mother ORDER BY children.dob)
           END    AS born
FROM person AS woman
         LEFT JOIN person AS children ON (woman.name = children.mother)
WHERE woman.gender = 'F'
ORDER BY mother, born, child
;

-- Q9 returns (monarch,prime_minister)
SELECT DISTINCT current_monarch.name AS monarch,
                pm.name              AS prime_minister
FROM monarch AS current_monarch
         JOIN prime_minister AS pm ON (pm.entry > current_monarch.accession
                                           AND pm.entry < COALESCE((SELECT MIN(next_monarch.accession)
                                                                    FROM monarch AS next_monarch
                                                                    WHERE next_monarch.accession > current_monarch.accession),
                                                                   CURRENT_DATE
                                                          ) OR (
                                                   pm.entry < current_monarch.accession
                                               AND current_monarch.accession < COALESCE((SELECT MIN(next_pm.entry)
                                                                                         FROM prime_minister AS next_pm
                                                                                         WHERE next_pm.entry > pm.entry),
                                                                                        CURRENT_DATE)
                                           ))
ORDER BY monarch, prime_minister
;

-- Q10 returns (name,entry,period,days)
SELECT name,
       entry,
       ROW_NUMBER() OVER (PARTITION BY name ORDER BY entry)            AS period,
       COALESCE((SELECT MIN(entry)
                 FROM prime_minister
                 WHERE entry > currentPm.entry), CURRENT_DATE) - entry AS days
FROM prime_minister AS currentPm
ORDER BY days
;

