zadanie 4 a) CREATE TABLE `labolatorium-filmoteka`.`agenci` (
  `licencja` VARCHAR(30) NOT NULL,
  `nazwa` VARCHAR(90) NULL,
  `wiek` INT NULL,
  `typ` ENUM('osoba indywidualna', 'agencja', 'inny') NULL,
  PRIMARY KEY (`licencja`));

  DELIMITER $$
CREATE TRIGGER before_agenci_update 
    BEFORE UPDATE ON agenci
    FOR EACH ROW 
BEGIN
    if ( agenci.wiek<21) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Agent za mlody';
    END IF;
		
END$$
DELIMITER ;
b)
CREATE TABLE `labolatorium-filmoteka`.`kontrakty` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `agent` VARCHAR(30) NULL,
  `aktor` INT NULL,
  `poczatek` DATE NULL,
  `koniec` DATE NULL,
  `gaza` INT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (agent) REFERENCES agenci(licencja),
  FOREIGN KEY (aktor) REFERENCES aktorzy(id_aktorzy)
  
  );
   DELIMITER $$
CREATE TRIGGER before_kontrakty_update 
    BEFORE UPDATE ON kontrakty
    FOR EACH ROW 
BEGIN
    if ( gaza<0) or (DATEDIFF(koniec, poczatek )<1) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'blad danych';
    END IF;
		
END$$
DELIMITER ;
zadanie 5:
DELIMITER $$
CREATE PROCEDURE dodajagentow (IN ilosc INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < ilosc DO
        INSERT INTO agenci (licencja, nazwa, wiek, typ) VALUES (
            to_base64(FLOOR((RAND()*90 +1000*RAND()))),
            CONCAT_WS(' ',
                ELT(FLOOR(RAND()*9 + 1), 'Adam', 'Andrzej', 'Jurek', 'Madam', 'Arnold', 'Maria', 'Zeus', 'Jan', 'Janusz' ),
                ELT(FLOOR(RAND()*10 + 1), 'Malysz', 'Duda', 'Owsiak', 'Alysz', 'Szwarceneger', 'Sklodowska', 'Walesa', 'Gromowladny', 'Miodek', 'Kowalski'),
                ELT(FLOOR(RAND()*4 + 1), 'SA', 'ZOO', 'INC.' , 'sp.j.')
            ),
			/* na nastepnych listach juz mi sie nie chce losowac imion wiec losuje liczbe, wrzucam do base64 i udaje ze to Klingońskie imiona */ 
            (FLOOR(21 + 40*RAND())),
            ELT(FLOOR(RAND()*3 + 1), 'osoba indywidualna', 'agencja', 'inny')
        );
        SET i = i + 1;
    END WHILE;
END $$
DELIMITER ; 

CALL dodajagentow(1000);
DELIMITER $$
CREATE PROCEDURE przydzielkontrakty ()
BEGIN
    DECLARE n INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    SELECT COUNT(*) FROM aktorzy INTO n;
    WHILE i < n DO
        INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES (
            (SELECT licencja FROM agenci ORDER BY RAND() LIMIT 1),
            (SELECT id_aktorzy FROM aktorzy LIMIT i,1),
            DATE_ADD(CURDATE(),INTERVAL FLOOR(RAND()*-365) DAY),
            DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY),
            FLOOR(RAND()*500 + 1)
        );
        SET i = i + 1;
    END WHILE;
END $$
DELIMITER ;
CALL przydzielkontrakty();
zadanaie 6:
/* fajne rozwiazanie, takie nie za sensowne*/ 
ALTER TABLE kontrakty CHANGE gaza gaza INT COMMENT 'zloty miesiecznie';
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 1, '20150108', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 2, '20150102', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 3, '20150103', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 4, '20150104', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 5, '20150105', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 6, '20150106', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 7, '20150102', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 8, '20150109', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 9, '20150102', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 10, '20150501', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 11, '20130101', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 12, '20110101', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 13, '20100101', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 14, '20100201', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 15, '20150501', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 16, '20150601', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 17, '20150201', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 18, '20150501', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 19, '20151101', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 20, '20150102', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 21, '20150112', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 22, '20150119', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 23, '20150101', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 24, '20150108', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 25, '20150101', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 26, '20150101', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 27, '20150101', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 28, '20150101', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 29, '20150101', '20160101', 3333);
INSERT INTO kontrakty (agent, aktor, poczatek, koniec, gaza) VALUES ((SELECT licencja from agenci order by rand() LIMIT 1), 30, '20150101', '20160101', 3333);
zadanie 7:
DELIMITER //
CREATE FUNCTION znajdz (a VARCHAR(30), b VARCHAR(30)) RETURNS VARCHAR(200) DETERMINISTIC
BEGIN
    DECLARE wyn VARCHAR(200) DEFAULT '';
    SELECT CONCAT_WS(', ', imie, nazwisko, nazwa, DATEDIFF(koniec, CURDATE())) AS info FROM aktorzy JOIN kontrakty ON Aktorzy.id_aktorzy = Kontrakty.aktor JOIN agenci ON agenci.licencja = kontrakty.agent WHERE aktorzy.imie = a AND aktorzy.nazwisko = b INTO wyn;
    IF wyn = '' THEN SET wyn = 'Brak takiego aktora';
    END IF;
    RETURN wyn;
END//
DELIMITER ;



select znajdz('PARKER', 'GOLDBERG' );
ZADANIE 8;
DELIMITER //
CREATE FUNCTION avrg (lic VARCHAR(90)) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE a INT;
    SELECT gaza FROM kontrakty WHERE agent = lic INTO a;
    IF ISNULL(a) THEN RETURN NULL;
    END IF;
    RETURN a;
END//
DELIMITER ;
zadanie 9;
PREPARE liczbaklientow FROM 'SELECT agent, COUNT(*) AS liczba FROM (SELECT agent, aktor FROM kontrakty K JOIN agenci A ON K.agent = A.licencja WHERE A.nazwa = ?) AS S;';
SET @uruchom = 'Jurek Sklodowska INC.'; 
EXECUTE liczbaklientow USING @uruchom;
zadanie 10;
DELIMITER //
CREATE procedure zadanie10()
BEGIN 
	
	SELECT ak,ag,suma_dni FROM 
		(SELECT aktor AS ak, agent as ag,SUM(datediff(koniec,poczatek)) AS suma_dni from kontrakty group by agent , aktor  order by suma_dni DESC) S
    WHERE ( 
		datediff(
		
		(SELECT koniec FROM kontrakty where aktor=ak and agent=ag ORDER BY koniec DESC LIMIT 1),
		(SELECT poczatek FROM kontrakty where aktor=ak and agent=ag ORDER BY poczatek ASC LIMIT 1) 
    )=suma_dni)
    ORDER BY suma_dni DESC LIMIT 1; 
    
   
end//
DELIMITER ; 
zadanie 11:
DELIMITER //
CREATE TRIGGER after_insert_zagrali AFTER INSERT ON zagrali
FOR EACH ROW
BEGIN
    UPDATE aktorzy SET liczba_filmow = (SELECT COUNT(*) FROM zagrali WHERE aktorzy.id_aktorzy = zagrali.aktor);
    
END;//
DELIMITER ;
--------------
DELIMITER //
CREATE TRIGGER after_update_zagrali AFTER UPDATE ON zagrali
FOR EACH ROW
BEGIN
    UPDATE aktorzy SET liczba_filmow = (SELECT COUNT(*) FROM zagrali WHERE aktorzy.id_aktorzy = zagrali.id_aktora);
    
END;//
DELIMITER ;
---------------
DELIMITER //
CREATE TRIGGER after_delete_aktorzy AFTER DELETE ON zagrali
FOR EACH ROW
BEGIN
    UPDATE aktorzy SET liczba_filmow = (SELECT COUNT(*) FROM zagrali WHERE aktorzy.id_aktorzy = zagrali.id_aktora);
    
END;//
DELIMITER ;
zadanie 12: 
DELIMITER $$
CREATE TRIGGER zadanie12trigger BEFORE INSERT ON kontrakty
FOR EACH ROW
BEGIN 
DECLARE czykontrakt INT default 0;
 SELECT COUNT(*) FROM kontrakty WHERE NEW.aktor = aktor AND poczatek < CURDATE() AND koniec > CURDATE() INTO czykontrakt;
    IF ( czykontrakt > 0) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'blad';
        END IF;
    INSERT INTO agenci (licencja, nazwa, wiek, typ) VALUES (
            to_base64(FLOOR((RAND()*90 +1000*RAND()))),
            CONCAT_WS(' ',
                ELT(FLOOR(RAND()*9 + 1), 'Adam', 'Andrzej', 'Jurek', 'Madam', 'Arnold', 'Maria', 'Zeus', 'Jan', 'Janusz' ),
                ELT(FLOOR(RAND()*10 + 1), 'Malysz', 'Duda', 'Owsiak', 'Alysz', 'Szwarceneger', 'Sklodowska', 'Walesa', 'Gromowladny', 'Miodek', 'Kowalski')
            ),
            (FLOOR(RAND()*25 + 40*RAND())),
            ELT(FLOOR(RAND()*3 + 1), 'osoba indywidualna', 'agencja', 'inny'));
END;$$
zadanie 13:
DELIMITER //
CREATE TRIGGER after_delete_filmy AFTER DELETE ON filmy
FOR EACH ROW
BEGIN
    DELETE FROM zagrali WHERE zagrali.if_filmu = old.id_filmy;
END;//
DELIMITER ;
zadanie 14:
CREATE VIEW zadanie14 AS SELECT imie, nazwisko, nazwa, DATEDIFF(koniec, CURDATE()) AS czas_do_zakonczenia FROM aktorzy A JOIN kontrakty K ON (A.id_aktorzy = K.aktor) JOIN agenci AG ON AG.licencja = K.agent;
zadanie 15:
CREATE USER 'user15'@'localhost' ON `labolatorium-filmoteka`;

CREATE VIEW aktorzyinfo AS SELECT imie, nazwisko FROM aktorzy;
CREATE VIEW agenciinfo AS SELECT nazwa, wiek, typ FROM agenci;
CREATE VIEW filmyinfo AS SELECT tytul, gatunek, kategoria, czas FROM filmy;

GRANT SELECT  ON `Labolatorium-Filmoteka`.aktorzyinfo TO 'user15'@'localhost';






  
