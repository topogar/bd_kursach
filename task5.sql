SELECT DISTINCT
  first_nm
  , (CASE
      WHEN second_nm IS NULL THEN 'Нет фамилии, и не предполагается'
      ELSE second_nm
  END)
FROM character
  WHERE
    nation_nm = 'Человек';


SELECT COUNT(organization_id)
  FROM organization
    WHERE
      organization_code = 'киностудия'
    AND
      foundation_dt > '1950-1-1';


SELECT DISTINCT
   MAX(cinematic_universe_nm)    AS Cinematic_universe
   , MIN(premier_dt)             AS FirstMovie
   , MAX(premier_dt)             AS LastMovie
FROM
   movie AS mv
INNER JOIN
   cinematic_universe            AS cu
ON
   mv.cinematic_universe_id = cu.cinematic_universe_id
GROUP BY
   cinematic_universe_nm


SELECT
   movie_nm
   , COUNT(movie_nm)             AS Count_reward
FROM
   movie
INNER JOIN
   reward_x_movie
ON
   movie.movie_id = reward_x_movie.movie_id
GROUP BY movie.movie_nm
   ORDER BY COUNT(movie.movie_nm) DESC
      LIMIT 3;


SELECT DISTINCT
   prct.first_nm          AS first_nm
   , prct.second_nm       AS second_nm
FROM
   participant                   AS prct
INNER JOIN
   movie_x_participant           AS m_prct
ON
   prct.participant_id = m_prct.participant_id
WHERE movie_id IN (
       SELECT
          movie_id
       FROM
          contract
       INNER JOIN
          organization
       ON
          contract.organization_id = organization.organization_id
       WHERE
          organization_nm = 'Nike'
)
