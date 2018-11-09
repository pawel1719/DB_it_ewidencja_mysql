-- ----------------------------------------------------------
-- VIEW workes list
-- ----------------------------------------------------------
CREATE VIEW v_listaPracownikow AS
SELECT 	 CONCAT(p.Surname, ' ',p.Name) 'Nazwisko Imię'
        ,IFNULL(d.Department, '') 'Nazwa departamentu'
        ,IFNULL(c.NameCity, '') 'Miasto'
        ,IFNULL(p.NumberPhone, '') 'Nr telefonu'
        ,IFNULL(p.DateEmployment, '') 'Data zatrudnienia'
        ,CASE WHEN p.Work = 1 THEN 'Tak' ELSE 'Nie' END 'Czy pracuje'
        ,IFNULL(p.DateRelease, '') 'Data zwolnienia'
FROM person p LEFT JOIN department d ON p.idDepartment=d.idDepartment
			  LEFT JOIN city c ON p.idCity=c.idCity
WHERE p.Work = 1
ORDER BY p.Surname ASC;
-- ----------------------------------------------------------
-- VIEW computer list
-- ----------------------------------------------------------
CREATE VIEW v_listaKomputerow AS
SELECT 	CONCAT(p.Surname,' ', p.name) 'Nazwisko Imie' 
		,IFNULL(c.Producer, '') 'Producent'
		,IFNULL(c.Model, '') 'Model'
		,c.ComputerName 'Nazwa'
		,c.SerialNumber 'Numer seryjny'
		,c.OperatingSystem 'System'
		,s.Status 'Status' 
		,CASE WHEN c.Encrypted = '1' THEN 'Tak' ELSE 'Nie' END 'Czy zaszyfrowany'
		,IFNULL(c.IdentifierBitLocker, '') 'Identfikator BitLocker'
		,IFNULL(c.RecoveryKeyNitLocker, '') 'Klucz BitLocker'
		,IFNULL(c.PasswordEncrypted, '') 'Hasło'
		,IFNULL(c.DateEncrypted, '') 'Data szyfrowania'
		,c.MacEthernet 'Mac Ethernet'
		,IFNULL(c.MacWiFi, '') 'Mac Wi-Fi'
        ,IFNULL(CONCAT(o.Office, ' ',o.Version), '') 'Office'
        ,IFNULL(o.KeyOffline, '') 'Klucz offline'
        ,IFNULL(o.DateAdd, '') 'Data dodania'
        ,IFNULL(m.AdresEmail, '') 'Mail office'
FROM computers c LEFT JOIN person p ON c.idPerson=p.idPerson
				 LEFT JOIN statusComputer s ON c.idStatusComputer=s.idStatusComputer
                 LEFT JOIN office o ON c.idOffice=o.idOffice
                 LEFT JOIN mailbox m ON o.idEmailAdd=m.idMailbox
ORDER BY s.idStatusComputer, p.surname ASC;
-- ----------------------------------------------------------
-- VIEW office list
-- ----------------------------------------------------------
CREATE VIEW v_listaOffice AS
SELECT  person.Surname 'Nazwisko'
		,person.Name 'Imie'
		,CONCAT( computers.Producer, ' ',computers.Model) 'Komputer'
        ,computers.ComputerName 'Nazwa'
        ,computers.SerialNumber 'Nr seryjny'
        ,office.KeyOffline 'Klucz offilne'
        ,office.DateAdd 'Data dodania'
        ,mailbox.AdresEmail 'Adres dodania'
FROM computers  JOIN person ON computers.idPerson=person.idPerson
				JOIN office ON computers.idOffice=office.idOffice
                JOIN mailbox ON office.idEmailAdd=mailbox.idMailbox
ORDER BY person.Surname, office.DateAdd ASC;
-- ----------------------------------------------------------
-- VIEW list of unused computers
-- ----------------------------------------------------------
CREATE VIEW v_listaWolnychPC AS
SELECT IFNULL(c.Producer, '') 'Producent'
		,IFNULL(c.Model, '') 'Model'
        ,c.ComputerName 'Nazwa'
        ,c.SerialNumber 'Numer Seryjny'
        ,s.Status 'Status PC'
        ,c.OperatingSystem 'System operacyjny'
        ,CASE WHEN c.Encrypted = 1 THEN 'Tak' ELSE 'Nie'END 'Czy zaszyfrowany'
        ,IFNULL(c.IdentifierBitLocker, '') 'Identyfikator BitLocker'
        ,IFNULL(c.RecoveryKeyNitLocker, '') 'Klucz BitLocker'
        ,IFNULL(c.PasswordEncrypted, '') 'Hasło'
        ,IFNULL(c.MacEthernet, '') 'Mac Ethernet'
        ,IFNULL(c.MacWiFi, '') 'Mac Wi-Fi'
        ,CONCAT(o.Office, ' ', o.Version) 'Office'
        ,o.KeyOffline 'Klucz offilne'
        ,o.DateAdd 'Data dodania'
        ,m.AdresEmail 'Mail office'
FROM computers c LEFT JOIN statusComputer s ON c.idStatusComputer=s.idStatusComputer
				 LEFT JOIN office o ON c.idOffice=o.idOffice
                 LEFT JOIN mailbox m ON o.idEmailAdd=m.idMailbox
WHERE c.idStatusComputer = 2
ORDER BY c.ComputerName ASC;
-- ----------------------------------------------------------
-- VIEW mailbox users
-- ----------------------------------------------------------
CREATE VIEW v_listaMaili AS
SELECT CONCAT(p.Surname, ' ',p.Name) 'Nazwisko Imie'
		,m.AdresEmail 'E-mail'
        ,m.Password 'Hasło'
        ,CASE WHEN m.PersonalType = 1 THEN 'Tak' ELSE 'Nie' END 'Osobista'
        ,CASE WHEN m.AliasType = 1 THEN 'Tak' ELSE 'Nie' END 'Alias'
        ,CASE WHEN m.GroupeType = 1 THEN 'Tak' ELSE 'Nie' END 'Grupowa'
        ,CASE WHEN m.Active = 1 THEN 'Tak' ELSE 'Nie' END 'Czy aktywna'
        ,IFNULL(m.DateCreation, '') 'Data utworzenia'
        ,IFNULL(m.DateBlocked, '') 'Data zablokowania'
        ,IFNULL(m.DateDeleted, '') 'Data usunięcia'
FROM person p INNER JOIN email e ON p.idPerson=e.idPersonal
			  INNER JOIN mailbox m ON m.idMailbox=e.idMailBox
ORDER BY m.Active DESC, p.Surname ASC;
-- ----------------------------------------------------------
-- VIEW shares users
-- ----------------------------------------------------------
CREATE VIEW v_udziałyOsob AS
SELECT CONCAT(p.Surname, ' ',p.Name) 'Nazwisko Imie'
		,name.Name 'Nazwa'
        ,name.AddressShares 'Adres'
        ,CASE WHEN n.AllPermission = 1 THEN 'Tak' ELSE 'Nie' END 'Pełne uprawnienia'
        ,CASE WHEN n.Read = 1 THEN 'Tak' ELSE 'Nie' END 'Zapis'
        ,CASE WHEN n.Read = 1 THEN 'Tak' ELSE 'Nie' END 'Odczyt'
FROM person p INNER JOIN networkShares n ON n.idPerson=p.idPerson
			  INNER JOIN nameShares name ON n.idName=name.idNameShares
ORDER BY p.Surname, p.Name ASC;