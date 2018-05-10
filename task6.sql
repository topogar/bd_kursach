/*CRUD-запросы к двум таблицам */

/*К таблице participant: */

SELECT *
  FROM
    participant;

SELECT *
  FROM
    participant
  WHERE
    first_nm = 'Вин';

SELECT
   first_nm
   , second_nm
   , birth_dt
FROM
   participant
WHERE
   birth_dt > '1979-3-3';

INSERT INTO participant(participant_id, first_nm, second_nm, birth_dt, gender_code, country_nm)
    VALUES (DEFAULT, 'Проверка', 'Работы', '2018-5-14', 'НЕОПРЕДЕЛЕННЫЙ', 'МФТИ');

DELETE FROM participant
    WHERE gender_code = 'Отчисленный';

UPDATE participant
SET gender_code = 'Отчисленный'
WHERE first_nm = 'Проверка';

/*К таблице contract: */

SELECT *
   FROM
    contract;

INSERT INTO contract(movie_id, organization_id, money_amt)
    VALUES (3, 7, 100);

UPDATE contract
SET money_amt = 30000
WHERE
   movie_id = 3 AND
   organization_id = 7;

DELETE FROM contract
   WHERE movie_id = 3;