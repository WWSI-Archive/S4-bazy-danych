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

CREATE SCHEMA KD;

CREATE TABLE KD.Maista
(
    IdMiasta INT PRIMARY KEY IDENTITY (1, 1),
    Nazwa    NVARCHAR(100) NOT NULL,
);

/*
	char(n), varchar(n), varchar(max)[, text]
	n <= 8000
	max -> 2gb

	n* (nchar(...)) - Unicode wtedy n <= 4000
*/

CREATE TABLE KD.Osoby
(
    IdOsoby       INT PRIMARY KEY IDENTITY (1, 1),
    Nazwisko      NVARCHAR(100) NOT NULL,
    Imie          NVARCHAR(100) NOT NULL,
    DataUrodzenia DATE          NOT NULL,
    CzyKobieta    BIT           NOT NULL,
    Pesel         CHAR(11)      NOT NULL,
    IdMiasta      INT           NOT NULL,
);

/*
	daterime, datetime2(precyzja 0-7), date, time, datetimeoffset
	bit
*/


ALTER TABLE KD.Miasta
    ADD CONSTRAINT C1 UNIQUE (Nazwa);

INSERT INTO KD.Miasta (Nazwa)
VALUES ('Warszawa'), ('Opole'), ('Sopot');

SELECT *
FROM KD.Miasta;

ALTER TABLE KD.Osoby
    ADD CONSTRAINT C2 UNIQUE (Pesel);

ALTER TABLE KD.Osoby
    ADD CONSTRAINT C3 FOREIGN KEY (IdMIasta)
REFERENCES KD.Miasta (IdMiasta);

