USE ABDUczelnia;

---- Funkcje Agregujące (banda pięciorga)
-- count
-- sum
-- avg
-- min
-- max


SELECT count(*)
FROM Wykladowcy

-- specyficzny MSSQL: TOP 12 WITH TIES

SELECT TOP 12 WITH TIES
  Nazwisko,
  Imie,
  Pesel,
  AVG(ocena) AS Sr
FROM Studenci AS S
  JOIN Oceny AS O ON S.IdStudenta = O.IdStudenta
WHERE year(DataOceny) = 2013
GROUP BY Nazwisko, Imie, Pesel
HAVING AVG(ocena) > 4.15
ORDER BY Sr DESC

-- Standard SQL

SELECT
  Nazwisko,
  Imie,
  Pesel,
  AVG(ocena) AS Sr
FROM Studenci AS S
  JOIN Oceny AS O ON S.IdStudenta = O.IdStudenta
WHERE year(DataOceny) = 2013
GROUP BY Nazwisko, Imie, Pesel
HAVING AVG(ocena) > 3.50
ORDER BY Sr DESC
  OFFSET 10 ROWS
  FETCH NEXT 20 ROWS ONLY


USE ABDPrzychodnia;

SELECT
  COUNT(*),
  COUNT(Test),
  count(DISTINCT Idspecjalizacji)
FROM Lekarze