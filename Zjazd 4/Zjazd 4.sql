-- 6 zjazd - test

USE ABDUczelnia;

WITH TMP AS ( --Wyrażenia CTE
    SELECT
      --  TOP 12 WITH TIES -- Dla MsSQL
      Nazwisko,
      Imie,
      Pesel,
      Idgrupy,
      AVG(Ocena)                      Sr,
      ROW_NUMBER()
      OVER (
        ORDER BY AVG(Ocena) DESC ) AS nr,
      RANK()
      OVER (
        ORDER BY AVG(Ocena) DESC ) AS rk,
      DENSE_RANK()
      OVER (
        ORDER BY AVG(Ocena) DESC ) AS drk,
      NTILE(20)
      OVER (
        ORDER BY AVG(Ocena) DESC ) AS seg,
      DENSE_RANK()
      OVER ( PARTITION BY IdGrupy
        ORDER BY AVG(Ocena) DESC ) AS drkgr
    FROM Studenci S
      INNER JOIN Oceny O
        ON S.IdStudenta = O.IdStudenta
           AND DataOceny BETWEEN '20130101' AND '20131231'
    GROUP BY
      Nazwisko,
      Imie,
      Pesel,
      Idgrupy
    HAVING
      AVG(Ocena) > 3.75
  -- ORDER BY Sr DESC
  -- OFFSET 5 ROWS FETCH NEXT 10 ROWS ONLY;
)
SELECT *
FROM TMP
WHERE drk <= 20
      AND drkgr > 1


USE ABDPrzychodnia;

SELECT *
FROM Lekarze L
  RIGHT OUTER JOIN Specjalizacje S
    ON L.Idspecjalizacji = S.idspecjalizacji
       AND DataUrodzenia < '19700101'

/*
  Dla każdego lekarza podać liczbę przyjęć
  pacjentek urodzonych przed rokiem 1944
  dla wizyt z I kwartału 2013.
 */

SELECT
  L.Nazwisko,
  L.NIP,
  count(W.IdWizyty) Ile
FROM Pacjenci P
  JOIN Wizyty W
    ON P.IdPacjenta = W.IdPacjenta
       AND DataWizyty BETWEEN '20130101' AND '20130331'
       AND P.DataUrodzenia < '19240101'
       AND P.CzyKobieta = 1
  RIGHT JOIN Lekarze L
    ON W.IdLekarza = L.IdLekarza
GROUP BY
  L.Nazwisko,
  L.NIP;


/*
Dla każdego dnia maja 2014 policzyć sumę opłat za wizyty oraz liczbę wizyt.
 */

WITH Daty AS (
  SELECT
    cast('20140501' AS DATE) AS Dzien
  UNION ALL
  SELECT
    DATEADD(DAY, 1, Dzien) AS Dzien
  FROM
    Daty
  WHERE
    Dzien < '20140531'
)
SELECT
  Dzien,
  isnull(SUM(Oplata), 0.00) Suma,
  COUNT(Oplata)    Ile
FROM Wizyty W Right Join Daty D on W.DataWizyty = D.Dzien
GROUP BY Dzien
-- OPTION (MAXRECURSION  32676)













