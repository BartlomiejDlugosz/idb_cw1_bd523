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
                 ELSE SUBSTRING(name FROM 1 FOR POSITION(' ' IN name))
                 END AS first_name
      FROM person) AS names
GROUP BY first_name
HAVING count(first_name) > 1
ORDER BY popularity DESC, first_name
;

-- Q7 returns (party,seventeenth,eighteenth,nineteenth,twentieth,twentyfirst)

;

-- Q8 returns (mother,child,born)

;

-- Q9 returns (monarch,prime_minister)

;

-- Q10 returns (name,entry,period,days)

;

