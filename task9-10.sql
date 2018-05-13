/* После delete, update, insert, выполняемых с movie, обновляется movie_cnt в соответствующей cinematic_universe */

CREATE OR REPLACE FUNCTION movie_cnt_upd()
  RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE cinematic_universe
      SET movie_cnt = movie_cnt + 1
        WHERE cinematic_universe_id = NEW.cinematic_universe_id;
    RETURN NEW;
  ELSEIF TG_OP = 'DELETE' THEN
    UPDATE cinematic_universe
      SET movie_cnt = movie_cnt - 1
        WHERE cinematic_universe_id = OLD.cinematic_universe_id;
    RETURN OLD;
  ELSEIF TG_OP = 'UPDATE' THEN
    UPDATE cinematic_universe
      SET movie_cnt = movie_cnt - 1
        WHERE cinematic_universe_id = OLD.cinematic_universe_id;
    UPDATE cinematic_universe
      SET movie_cnt = movie_cnt + 1
        WHERE cinematic_universe_id = NEW.cinematic_universe_id;
    RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER work_mov
AFTER INSERT OR UPDATE OR DELETE  ON movie FOR EACH ROW
EXECUTE PROCEDURE movie_cnt_upd();

INSERT INTO movie(movie_id, movie_nm, premier_dt, fees_amt, rating_prt, age_num, cinematic_universe_id)
    VALUES (DEFAULT, 'cdaa', '2002-2-2', 100, 9, 9, 1);
UPDATE movie
  SET cinematic_universe_id = 2
    WHERE movie_nm = 'cdaa';
DELETE FROM movie WHERE movie_nm = 'cdaa';

/* После удаления из participant, автоматически удаляются все связанные записи в character и movie_x_participant */

CREATE OR REPLACE FUNCTION part_del()
  RETURNS TRIGGER AS $$
BEGIN
  DELETE FROM character
    WHERE participant_id = OLD.participant_id;
  DELETE FROM movie_x_participant
    WHERE participant_id = OLD.participant_id;
  RETURN  OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER good_part_del
BEFORE DELETE ON participant FOR EACH ROW
EXECUTE PROCEDURE part_del();

DROP TRIGGER good_part_del ON participant;
INSERT INTO participant(participant_id, first_nm, second_nm, birth_dt, gender_code, country_nm)
    VALUES (DEFAULT, 'ddd', 'dddd', '2010-2-2', 'м', 'РОССИЯ');
INSERT INTO character(character_id, participant_id, first_nm, second_nm, nation_nm)
    VALUES (DEFAULT, 16, 'aaa', 'aaaa', 'Человек');
INSERT INTO movie_x_participant(movie_id, participant_id, payment_amt, position_txt)
    VALUES (3, 16, 100, 'ssss');
DELETE FROM participant
  WHERE first_nm = 'ddd';

/* Хранимая процедура по id компании возвратит общую сумму всех рекламных контрактов, которые эта компания заключила */

CREATE OR REPLACE FUNCTION return_comp_amt(id INTEGER)
  RETURNS MONEY AS
$$
DECLARE
  SUM_ MONEY;
BEGIN
  SUM_ = 0;
  SELECT SUM(money_amt) INTO SUM_ FROM contract WHERE organization_id = id;
    RETURN SUM_;
end;
$$ LANGUAGE plpgsql;

DROP FUNCTION return_comp_amt;
SELECT return_comp_amt(9);