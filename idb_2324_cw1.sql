-- Q1 returns (name,born_in,father,mother)
SELECT name,born_in,father,mother
FROM person
WHERE born_in IN (SELECT born_in
                 FROM person AS _
                 WHERE person.father=name)
AND born_in IN (SELECT born_in
               FROM person as _
               WHERE person.mother=name)
ORDER BY name
;

-- Q2 returns (name)
SELECT name
FROM person
EXCEPT
(SELECT m.name FROM monarch AS m
UNION
SELECT p.name FROM prime_minister AS p)
ORDER BY name
;

-- Q3 returns (name)
/*SELECT name
FROM monarch
WHERE 0 < (SELECT COUNT(m.coronation)
           FROM monarch AS m
           WHERE m.coronation < (SELECT dod
                                 FROM person
                                 WHERE person.name=monarch.name)
           AND m.coronation > (SELECT coronation
                               FROM monarch AS m2
                               WHERE name=monarch.name))
ORDER BY name*/
SELECT name
FROM monarch
WHERE coronation IS NULL
AND house IS NOT NULL
AND 0 < (SELECT COUNT(accession)
         FROM monarch AS m
         WHERE m.accession > monarch.accession)
;

-- Q4 returns (house,name,accession)

;

-- Q5 returns (name,role,start_date)

;

-- Q6 returns (first_name,popularity)

;

-- Q7 returns (party,seventeenth,eighteenth,nineteenth,twentieth,twentyfirst)

; 

-- Q8 returns (mother,child,born)

;

-- Q9 returns (monarch,prime_minister)

;
       
-- Q10 returns (name,entry,period,days)

;

