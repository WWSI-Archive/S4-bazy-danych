-- Zadanie 1 -  Zadanie wagi lekkiej.
--
-- W bazie danych ABDPrzychodnia przygotować zestawienie zawierające następujące dane: nazwisko, imię i numer Pesel,
-- datę urodzenia  pacjenta oraz  liczbę wizyt w lekarza rodzinnego w I półroczu 2013. W wyniku uwzględniamy tylko tych
-- pacjentów, którzy byli w podanym okresie na więcej niż 3 wizytach. Wynik uporządkować według liczby wizyt, a w obrębie
-- tej samej ilości wizyt uporządkować alfabetycznie według nazwiska.

USE ABDPrzychodnia

SELECT
  P.Nazwisko,
  P.Imie,
  P.Pesel,
  P.DataUrodzenia,
  count(Idwizyty) as Liczba
FROM Pacjenci as P
  join Wizyty as W ON P.IdPacjenta = W.IdPacjenta
  join Lekarze as L ON L.IdLekarza = W.IdLekarza
  join Specjalizacje as S ON L.Idspecjalizacji = S.idspecjalizacji
WHERE DataWizyty between '20130101' and '20130630' and S.idspecjalizacji = 1
group by P.Nazwisko, P.Imie, P.Pesel, P.DataUrodzenia
having count(Idwizyty) > 3
ORDER by Liczba, P.Nazwisko

-- Zadanie 2 – Zadanie wagi lekkiej
--
-- W bazie danych ABDUczelnia napisać zapytanie, które zwraca następujące dane; nazwisko, imię, Pesel oraz średnią ocen
-- z roku 2013 dla studentów urodzonych po roku 1966. Uwzględniamy tylko tych studentów, którzy w roku 2013 otrzymali
-- więcej niż 20 ocen.
-- Wynik uporządkować malejąco według średniej ocen.

USE ABDUczelnia

SELECT
  S.Nazwisko,
  S.Imie,
  S.Pesel,
  avg(ocena) as Srednia
FROM Studenci as S
  join Oceny as O ON S.IdStudenta = O.IdStudenta
WHERE DataOceny BETWEEN '20130101' and '20131231' and DataUrodzenia > '19661231'
Group by S.Nazwisko, S.Imie, S.Pesel
having count(*) > 20
ORDER by Srednia DESC


-- Zadanie 3  – Zadanie wagi cięższej
-- 
-- W bazie ABDUczelnia przygotować zapytanie zwracające następujące dane; nazwisko, imię studentów oraz średnią ocen 
-- wystawionych w roku 2013 przez wykładowców którzy  w rankingu według średniej wystawianych ocen są na miejscach 
-- od 3 do 7.

USE ABDUczelnia

WITH W as
(
    SELECT
      W.IdWykladowcy,
      avg(ocena)                 Srednia,
      ROW_NUMBER()
      over (
        ORDER by avg(ocena) ) as Nr
    FROM Wykladowcy as W
      join Oceny as O ON W.IdWykladowcy = O.IdWykladowcy
    group by W.IdWykladowcy
    ORDER by Srednia
      offset 2 rows
      fetch next 5 rows only
)

SELECT
  S.Nazwisko,
  avg(ocena) Srednia
FROM Studenci as S
  join oceny as O ON S.IdStudenta = O.IdStudenta
  right join W as N ON O.IdWykladowcy = N.IdWykladowcy
                          and DataOceny BETWEEN '20130101' and '20131231'
group by S.Nazwisko

  
  
-- Zadanie 4 – Zadanie wagi cięższej
-- 
-- W bazie ABDPrzychodnia napisać zapytanie, które zwróci dane pacjentek urodzonych po roku 1965; nazwisko, imię i pesel,
-- które w roku 2013 miały przynajmniej trzy wizyty u lekarza rodzinnego i przynajmniej 3 wizyty u innych specjalistów.

USE ABDPrzychodnia

WITH Rodzinny as
(
    SELECT
      p.Imie,
      p.Nazwisko,
      p.Pesel,
      count(*) liczba
    From Pacjenci as P
      join Wizyty as W ON P.IdPacjenta = W.IdPacjenta
      join Lekarze as L ON W.IdLekarza = L.IdLekarza
      join Specjalizacje as S ON S.idspecjalizacji = L.Idspecjalizacji
    Where p.DataUrodzenia > '19651231' and DataWizyty between '20130101' and '20131231' and
          NazwaSpecjalizacji = 'Lekarz rodzinny' and p.CzyKobieta = 1
    group by p.Imie, p.Nazwisko, p.Pesel
    having count(*) >= 3
)

SELECT
  p.Imie,
  p.Nazwisko,
  p.Pesel,
  count(*) liczba
From Pacjenci as P
  join Wizyty as W ON P.IdPacjenta = W.IdPacjenta
  join Lekarze as L ON W.IdLekarza = L.IdLekarza
  join Specjalizacje as S ON S.idspecjalizacji = L.Idspecjalizacji
  join Rodzinny ON p.Pesel = Rodzinny.Pesel
              and NazwaSpecjalizacji != 'Lekarz rodzinny'
group by p.Imie, p.Nazwisko, p.Pesel
having count(*) >= 3