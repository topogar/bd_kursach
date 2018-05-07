CREATE TABLE REWARD(
  reward_id SERIAL PRIMARY KEY,
  community_nm VARCHAR(40) NOT NULL,
  reward_nm VARCHAR(20) NOT NULL
);

CREATE TABLE CINEMATIC_UNIVERSE(
  cinematic_universe_id SERIAL PRIMARY KEY,
  cinematic_universe_nm VARCHAR(60) NOT NULL,
  movie_cnt INTEGER CHECK(movie_cnt >= 0)
);

CREATE TABLE MOVIE(
  movie_id SERIAL PRIMARY KEY,
  movie_nm VARCHAR(60) NOT NULL,
  premier_dt DATE NOT NULL,
  fees_amt MONEY,
  rating_prt NUMERIC CHECK(rating_prt >= 0 AND 100 >= rating_prt),
  age_num INTEGER CHECK(age_num >= 0 AND 21 >= age_num),
  cinematic_universe_id INTEGER NOT NULL,
  FOREIGN KEY(cinematic_universe_id)
    REFERENCES CINEMATIC_UNIVERSE(cinematic_universe_id)
);

CREATE TABLE REWARD_X_MOVIE(
  reward_id INTEGER NOT NULL,
  movie_id INTEGER NOT NULL,
  rewarding_dt DATE,
  presenter_first_nm VARCHAR(20),
  presenter_second_nm VARCHAR(40),
  FOREIGN KEY(reward_id)
    REFERENCES REWARD(reward_id),
  FOREIGN KEY(movie_id)
    REFERENCES MOVIE(movie_id)
);

CREATE TABLE PARTICIPANT(
  participant_id SERIAL PRIMARY KEY,
  first_nm VARCHAR(20) NOT NULL,
  second_nm VARCHAR(40) NOT NULL,
  birth_dt DATE,
  gender_code VARCHAR(20),
  country_nm VARCHAR(30)
);

CREATE TABLE CHARACTER(
  character_id SERIAL PRIMARY KEY,
  participant_id INTEGER NOT NULL,
  first_nm VARCHAR(40) NOT NULL,
  second_nm VARCHAR(40),
  nation_nm VARCHAR(40),
  FOREIGN KEY(participant_id)
    REFERENCES PARTICIPANT(participant_id)
);

CREATE TABLE CHARACTER_X_MOVIE(
  character_id INTEGER NOT NULL,
  movie_id INTEGER NOT NULL,
  position_txt VARCHAR(40),
  gender_code VARCHAR(20),
  die_flg BOOLEAN,
  FOREIGN KEY(character_id)
    REFERENCES CHARACTER(character_id),
  FOREIGN KEY(movie_id)
    REFERENCES MOVIE(movie_id)
);

CREATE TABLE MOVIE_X_PARTICIPANT(
  movie_id INTEGER NOT NULL,
  participant_id INTEGER NOT NULL,
  payment_amt MONEY,
  position_txt VARCHAR(60)
);

CREATE TABLE ORGANIZATION(
  organization_id SERIAL PRIMARY KEY,
  organization_code VARCHAR(20) NOT NULL,
  organization_nm VARCHAR(100) NOT NULL,
  foundation_dt DATE,
  country_nm VARCHAR(40),
  city_nm VARCHAR(40),
  website_url VARCHAR(60)
);

CREATE TABLE CINEM_UNIVERSE_X_ORGANIZATION(
  cinematic_universe_id INTEGER NOT NULL,
  organization_id INTEGER NOT NULL,
  beginning_dt DATE,
  FOREIGN KEY(cinematic_universe_id)
    REFERENCES CINEMATIC_UNIVERSE(cinematic_universe_id),
  FOREIGN KEY(organization_id)
    REFERENCES ORGANIZATION(organization_id)
);

CREATE TABLE CONTRACT(
  movie_id INTEGER NOT NULL,
  organization_id INTEGER NOT NULL,
  money_amt MONEY,
  FOREIGN KEY(movie_id)
    REFERENCES MOVIE(movie_id),
  FOREIGN KEY(organization_id)
    REFERENCES ORGANIZATION(organization_id)
);