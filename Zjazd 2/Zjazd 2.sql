/*
  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  ┃                                                                          ┃
  ┃                           [2018] Krystian Duma                           ┃░░
  ┃                           All Rights Reserved.                           ┃░░
  ┃                                                                          ┃░░
  ┃  NOTICE: All information contained herein is, and remains the property   ┃░░
  ┃   of Krystian Duma. The intellectual and technical concepts contained    ┃░░
  ┃  herein are proprietary to Krystian Duma and may be covered by U.S. and  ┃░░
  ┃  Foreign Patents, patents in process, and are protected by trade secret  ┃░░
  ┃  or copyright law. Dissemination of this information or reproduction of  ┃░░
  ┃  this material is strictly forbidden unless prior written permission is  ┃░░
  ┃                       obtained from Krystian Duma.                       ┃░░
  ┃                                                                          ┃░░
  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛░░
    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
*/

USE [@@@Z405];
GO

-- 3 zadania, do następnego zjazdu rozwiązania na maila.
-- W temacie maila: "ZZ405"
-- W trwści: Nazwisko imie numer grupy
-- Rozwiązania w pliku TXT!!! Nie SQL!

-- Czy pesel dla urodzonych powyżej 2000

SELECT *
FROM KD.Osoby

ALTER TABLE KD.Osoby
    ADD CONSTRAINT PeselOk CHECK
(
    Pesel LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' AND
    DataUrodzenia = '19' + substring(Pesel, 1, 6) AND
    CASE
    WHEN CzyKobieta = 1 AND substring(Pesel, 10, 1) % 2 = 0
        THEN 1
    WHEN CzyKobieta = 0 AND substring(Pesel, 10, 1) % 2 = 1
        THEN 1
    ELSE 0
    END = 1
)

INSERT INTO KD.Osoby (Nazwisko, Imie, DataUrodzenia, CzyKobieta, Pesel, IDMiasta) VALUES
    ('Kot', 'Jan', '1987-09-22', 0, '87092254579', 1),
    ('Lis', 'Ula', '1977-12-12', 1, '77121256787', 2),
    ('Sum', 'Ela', '1986-02-22', 1, '86022265687', 3)

ALTER TABLE KD.Osoby
    ADD Plec AS IIF(CzyKobieta = 1, 'Kobieta', 'Mężczyzna')

ALTER TABLE KD.Osoby
    ADD Wiek AS date diff( YEAR, DataUrodzenia, getdate());