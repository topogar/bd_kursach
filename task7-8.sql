/*К character и participant*/

/* Персонаж и исполнитель роли */
CREATE OR REPLACE VIEW character_participant AS (
    SELECT DISTINCT
      chrt.first_nm name_chrt
      , (CASE
           WHEN
             chrt.second_nm IS NULL THEN 'Нет фамилии, и не предполагается'
           ELSE
             chrt.second_nm
        END) AS second_name_chrt
      , prt.first_nm name_actor
      , prt.second_nm second_name_actor
    FROM
      character chrt
    INNER JOIN
      participant prt
    ON
      chrt.participant_id = prt.participant_id
);

DROP VIEW character_participant;

SELECT *
   FROM character_participant;

/*К cinematic_universe */

/* Первый фильм киновселенной */
CREATE OR REPLACE VIEW year_cin_un AS (
    SELECT DISTINCT
      cinematic_universe_nm
      , MIN(Extract(YEAR from(premier_dt))) AS year_beginning
    FROM
      cinematic_universe AS cu
    INNER JOIN
      movie              AS mv
    ON
      cu.cinematic_universe_id = mv.cinematic_universe_id
    GROUP BY cu.cinematic_universe_id
);

DROP VIEW year_cin_un;

SELECT *
   FROM year_cin_un;

/* К movie (вью выше тоже относится) : */

/* Сборы фильмов */
CREATE OR REPLACE VIEW fees_movies AS (
     SELECT
       movie_nm
       , fees_amt
     FROM
       movie
     WHERE
       age_num >= 6
);

DROP VIEW fees_movies;

SELECT *
   FROM fees_movies;

/* К organization */

/*Вебсайты компаний */
CREATE OR REPLACE VIEW comp_website AS (
     SELECT
       organization_nm
       , website_url
     FROM
       organization
     WHERE
       organization_code = 'компания'
);

DROP VIEW comp_website;

SELECT *
   FROM comp_website;

/* К participant */

/* Мужчины, которые были режиссерами */
CREATE OR REPLACE VIEW men_directors AS (
     SELECT DISTINCT
       first_nm
       , second_nm
     FROM
       participant         AS p
     INNER JOIN
       movie_x_participant AS mp
     ON
       p.participant_id = mp.participant_id
     WHERE
       p.gender_code = 'м' AND
       mp.position_txt = 'director'
);

DROP VIEW men_directors;

SELECT *
   FROM men_directors;

/* К reward: */

/* Возможные награды ОСКАР */
CREATE OR REPLACE VIEW Oskar_rew AS (
     SELECT DISTINCT
       reward_nm
     FROM
       reward
     WHERE
       community_nm = 'Оскар'
);

DROP VIEW Oskar_rew;

SELECT *
   FROM Oskar_rew;

/* На 2 балла: */

/* Показывает фильмы с наградами */
CREATE OR REPLACE VIEW rew_movie AS (
     SELECT
       movie_nm
       , community_nm
       , reward_nm
     FROM
       movie
     INNER JOIN
       reward_x_movie
     ON
       movie.movie_id = reward_x_movie.movie_id
     INNER JOIN
       reward
     ON
       reward_x_movie.reward_id = reward.reward_id
);

DROP VIEW rew_movie;

SELECT *
   FROM rew_movie;
/* Работает со сборами фильмов */
CREATE OR REPLACE VIEW cin_un_mon AS (
  SELECT
                  cu.cinematic_universe_nm,
                  AVG(fees_amt :: numeric) AS avg_fees,
                  SUM(fees_amt)            AS sum_fees,
                  movie_cnt
                FROM
                  movie
                  INNER JOIN
                  cinematic_universe AS cu
                    ON
                      movie.cinematic_universe_id = cu.cinematic_universe_id
                GROUP BY
                  cu.cinematic_universe_id);


DROP VIEW cin_un_mon;

SELECT *
   FROM cin_un_mon;