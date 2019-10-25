
CREATE PROCEDURE DataLoadSimulation.AddCustomers
@CurrentDateTime datetime2(7),
@StartingWhen datetime,
@EndOfTime datetime2(7),
@IsSilentMode bit
WITH EXECUTE AS OWNER
AS
BEGIN

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- add a customer one in 15 days average
    DECLARE @NumberOfCustomersToAdd int = (SELECT TOP(1) Quantity
                                              FROM (VALUES (0), (0), (0), (0), (0),
                                                           (0), (0), (0), (0), (0),
                                                           (0), (0), (0), (0), (0),
                                                           (0), (0), (0), (0), (0),
                                                           (0), (0), (0), (0), (1)) AS q(Quantity)
                                              ORDER BY NEWID());
    IF @IsSilentMode = 0
    BEGIN
        PRINT N'Adding ' + CAST(@NumberOfCustomersToAdd AS nvarchar(20)) + N' customers';
    END;

    DECLARE @Counter int = 0;
    DECLARE @CityID int;
    DECLARE @CityName nvarchar(max);
    DECLARE @CityStateProvinceID int;
    DECLARE @CityStateProvinceCode nvarchar(5);
    DECLARE @AreaCode int;
    DECLARE @CustomerCategoryID int;


    DECLARE @CustomerID int;
    DECLARE @PrimaryContactFullName nvarchar(50);
    DECLARE @PrimaryContactPersonID int;
    DECLARE @PrimaryContactFirstName nvarchar(50);
    DECLARE @DeliveryMethodID int = (SELECT DeliveryMethodID FROM [Application].DeliveryMethods
                                                             WHERE DeliveryMethodName = N'Delivery Van');
    DECLARE @DeliveryAddressLine1 nvarchar(max);
    DECLARE @DeliveryAddressLine2 nvarchar(max);
    DECLARE @DeliveryPostalCode nvarchar(max);
    DECLARE @PostalAddressLine1 nvarchar(max);
    DECLARE @PostalAddressLine2 nvarchar(max);
    DECLARE @PostalPostalCode nvarchar(max);
    DECLARE @StreetSuffix nvarchar(max);
    DECLARE @CompanySuffix nvarchar(max);
    DECLARE @StorePrefix nvarchar(max);
    DECLARE @CreditLimit int;

    WHILE @Counter < @NumberOfCustomersToAdd
    BEGIN
        WITH NamesToUse
        AS
        (
            SELECT FirstName, LastName, FullName
            FROM
            (VALUES ('Mark', 'Korjus', 'Mark Korjus'),
                    ('Emil', 'Bojin', 'Emil Bojin'),
                    ('Hue', 'Ton', 'Hue Ton'),
                    ('Leonardo', 'Jozic', 'Leonardo Jozic'),
                    ('Ivana', 'Hadrabova', 'Ivana Hadrabova'),
                    ('Hakan', 'Akbulut', 'Hakan Akbulut'),
                    ('Jayanti', 'Pandit', 'Jayanti Pandit'),
                    ('Judit', 'Gyenes', 'Judit Gyenes'),
                    ('Coralie', 'Monty', 'Coralie Monty'),
                    ('Hai', 'Banh', 'Hai Banh'),
                    ('Manuel', 'Jaramillo', 'Manuel Jaramillo'),
                    ('Damodar', 'Shenoy', 'Damodar Shenoy'),
                    ('Jatindra', 'Bandopadhyay', 'Jatindra Bandopadhyay'),
                    ('Kanan', 'Malakar', 'Kanan Malakar'),
                    ('Miloslav', 'Fisar', 'Miloslav Fisar'),
                    ('Sylvie', 'Laramee', 'Sylvie Laramee'),
                    ('Rene', 'Saucier', 'Rene Saucier'),
                    ('Aruna', 'Cheema', 'Aruna Cheema'),
                    ('Jagdish', 'Shergill', 'Jagdish Shergill'),
                    ('Gopichand', 'Dutta', 'Gopichand Dutta'),
                    ('Adrian', 'Lindqvist', 'Adrian Lindqvist'),
                    ('Renata', 'Michnova', 'Renata Michnova'),
                    ('Gunnar', 'Bjorklund', 'Gunnar Bjorklund'),
                    ('Binoba', 'Dey', 'Binoba Dey'),
                    ('Stefan', 'Selezeanu', 'Stefan Selezeanu'),
                    ('Amolik', 'Chakraborty', 'Amolik Chakraborty'),
                    ('Mai', 'Ton', 'Mai Ton'),
                    ('Rajendra', 'Mulye', 'Rajendra Mulye'),
                    ('Sushila', 'Baruah', 'Sushila Baruah'),
                    ('Jibek', 'Juniskyzy', 'Jibek Juniskyzy'),
                    ('Rabindra', 'Kaul', 'Rabindra Kaul'),
                    ('Lucia', 'Hinojosa', 'Lucia Hinojosa'),
                    ('Maija', 'Lukstina', 'Maija Lukstina'),
                    ('Rajanikant', 'Pandit', 'Rajanikant Pandit'),
                    ('Nichole ', 'Deslauriers', 'Nichole  Deslauriers'),
                    ('Max', 'Shand', 'Max Shand'),
                    ('Farzana', 'Abbasi', 'Farzana Abbasi'),
                    ('Ekambar', 'Bhuiyan', 'Ekambar Bhuiyan'),
                    ('Dhanishta', 'Pullela', 'Dhanishta Pullela'),
                    ('Busarakham', 'Kitjakarn', 'Busarakham Kitjakarn'),
                    ('Manjunatha', 'Karnik', 'Manjunatha Karnik'),
                    ('Bianca', 'Lack', 'Bianca Lack'),
                    ('Viktoria', 'Hudecova', 'Viktoria Hudecova'),
                    ('Haarati', 'Pendyala', 'Haarati Pendyala'),
                    ('Bhagavateeprasaad', 'Malladi', 'Bhagavateeprasaad Malladi'),
                    ('Aykut', 'ozkan', 'Aykut ozkan'),
                    ('Essie', 'Wimmer', 'Essie Wimmer'),
                    ('Ivan', 'Ignatyev', 'Ivan Ignatyev'),
                    ('Sohail', 'Shasthri', 'Sohail Shasthri'),
                    ('Nils', 'Kaulins', 'Nils Kaulins'),
                    ('Suresh', 'Singh', 'Suresh Singh'),
                    ('Christian', 'Couet', 'Christian Couet'),
                    ('Tami', 'Braggs', 'Tami Braggs'),
                    ('Ian', 'Olofsson', 'Ian Olofsson'),
                    ('Juan', 'Roy', 'Juan Roy'),
                    ('Chandrani', 'Dey', 'Chandrani Dey'),
                    ('Esther', 'Jobrani', 'Esther Jobrani'),
                    ('Kristi', 'Kuusik', 'Kristi Kuusik'),
                    ('Abhaya', 'Paruchuri', 'Abhaya Paruchuri'),
                    ('Sung-Hwan', 'Yoo', 'Sung-Hwan Yoo'),
                    ('Amet', 'Shergill', 'Amet Shergill'),
                    ('Damla', 'Yavuz', 'Damla Yavuz'),
                    ('Naveen', 'Scindia', 'Naveen Scindia'),
                    ('Anurupa', 'Mitra', 'Anurupa Mitra'),
                    ('Raymond', 'Beauchamp', 'Raymond Beauchamp'),
                    ('Tara', 'Kotadia', 'Tara Kotadia'),
                    ('Arnost', 'Hovorka', 'Arnost Hovorka'),
                    ('Aive', 'Petrov', 'Aive Petrov'),
                    ('Tomo', 'Vidovic', 'Tomo Vidovic'),
                    ('Arundhati', 'Majumdar', 'Arundhati Majumdar'),
                    ('Marcela', 'Mencikova', 'Marcela Mencikova'),
                    ('Cosmina', 'Leonte', 'Cosmina Leonte'),
                    ('Linda', 'Ohl', 'Linda Ohl'),
                    ('Gulzar', 'Sarkar', 'Gulzar Sarkar'),
                    ('Carol', 'Antonescu', 'Carol Antonescu'),
                    ('Kyung-Soon', 'Pak', 'Kyung-Soon Pak'),
                    ('Jaroslav', 'Fisar', 'Jaroslav Fisar'),
                    ('Amrita', 'Ganguly', 'Amrita Ganguly'),
                    ('Śani', 'Shasthri', 'Śani Shasthri'),
                    ('Ivan', 'Arenas', 'Ivan Arenas'),
                    ('Miljan', 'Stojanovic', 'Miljan Stojanovic'),
                    ('Tereza', 'Cermakova', 'Tereza Cermakova'),
                    ('Harendra', 'Sonkar', 'Harendra Sonkar'),
                    ('Taj', 'Syme', 'Taj Syme'),
                    ('Rajeev', 'Sandhu', 'Rajeev Sandhu'),
                    ('Alok', 'Sridhara', 'Alok Sridhara'),
                    ('Falgun', 'Bagchi', 'Falgun Bagchi'),
                    ('Kashi', 'Singh', 'Kashi Singh'),
                    ('Bong-Soo', 'Ha', 'Bong-Soo Ha'),
                    ('Damodara', 'Trivedi', 'Damodara Trivedi'),
                    ('Nguyen', 'Banh', 'Nguyen Banh'),
                    ('Lan', 'Bach', 'Lan Bach'),
                    ('Surya', 'Kulkarni', 'Surya Kulkarni'),
                    ('Afsar-ud-Din', 'Zare', 'Afsar-ud-Din Zare'),
                    ('Dita', 'Kreslina', 'Dita Kreslina'),
                    ('TunC', 'Polat', 'TunC Polat'),
                    ('Aleksandra', 'Semjonov', 'Aleksandra Semjonov'),
                    ('Bianh', 'Banh', 'Bianh Banh'),
                    ('Promita', 'Chattopadhyay', 'Promita Chattopadhyay'),
                    ('Alessandro', 'Sagese', 'Alessandro Sagese'),
                    ('Dinh', 'Mai', 'Dinh Mai'),
                    ('Cam', 'Dinh', 'Cam Dinh'),
                    ('Shyam', 'Sarma', 'Shyam Sarma'),
                    ('Ramesh', 'Das', 'Ramesh Das'),
                    ('Inna', 'Kask', 'Inna Kask'),
                    ('Luis', 'Saucedo', 'Luis Saucedo'),
                    ('Ilgonis', 'Prieditis', 'Ilgonis Prieditis'),
                    ('Min-ji', 'Nan', 'Min-ji Nan'),
                    ('Risto', 'Lepmets', 'Risto Lepmets'),
                    ('Vjekoslava', 'Brkic', 'Vjekoslava Brkic'),
                    ('Spidols', 'Podnieks', 'Spidols Podnieks'),
                    ('Orions', 'Podnieks', 'Orions Podnieks'),
                    ('Kristine', 'Zvaigzne', 'Kristine Zvaigzne'),
                    ('Kalyani', 'Benjaree', 'Kalyani Benjaree'),
                    ('Gadhar', 'Das', 'Gadhar Das'),
                    ('Sashi', 'Dev', 'Sashi Dev'),
                    ('Bhadram', 'Kamasamudram', 'Bhadram Kamasamudram'),
                    ('Som', 'Mukherjee', 'Som Mukherjee'),
                    ('Kyle', 'Redd', 'Kyle Redd'),
                    ('Śani', 'Sarkar', 'Śani Sarkar'),
                    ('Narendra', 'Tickoo', 'Narendra Tickoo'),
                    ('Ganesh', 'Majumdar', 'Ganesh Majumdar'),
                    ('Anusuya', 'Dutta', 'Anusuya Dutta'),
                    ('Katarina', 'Filipovic', 'Katarina Filipovic'),
                    ('Dhanya', 'Mokkapati', 'Dhanya Mokkapati'),
                    ('Mehmet', 'Arslan', 'Mehmet Arslan'),
                    ('Gita', 'Bhutia', 'Gita Bhutia'),
                    ('Tapas', 'Sikdar', 'Tapas Sikdar'),
                    ('Lucija', 'Cosic', 'Lucija Cosic'),
                    ('Vitalijs', 'Baltins', 'Vitalijs Baltins'),
                    ('Kanchana', 'Dutta', 'Kanchana Dutta'),
                    ('Elvira', 'Konovalova', 'Elvira Konovalova'),
                    ('Preecha', 'Suppamongkon', 'Preecha Suppamongkon'),
                    ('Min-ji', 'Shim', 'Min-ji Shim'),
                    ('Noora', 'Piili', 'Noora Piili'),
                    ('Arshagouhi', 'Deilami', 'Arshagouhi Deilami'),
                    ('Risto', 'Lill', 'Risto Lill'),
                    ('Emma', 'Van Zant', 'Emma Van Zant'),
                    ('Hardi', 'Laurits', 'Hardi Laurits'),
                    ('Zoltan', 'Gero', 'Zoltan Gero'),
                    ('Soner', 'Guler', 'Soner Guler'),
                    ('Abhra', 'Ganguly', 'Abhra Ganguly'),
                    ('Fabrice', 'Cloutier', 'Fabrice Cloutier'),
                    ('Yonca', 'Basturk', 'Yonca Basturk'),
                    ('Nandita', 'Bhuiyan', 'Nandita Bhuiyan'),
                    ('Omar', 'Lind', 'Omar Lind'),
                    ('Mai', 'Thai', 'Mai Thai'),
                    ('David', 'Novacek ', 'David Novacek '),
                    ('Adriana', 'Pena', 'Adriana Pena'),
                    ('Rato', 'Novakovic', 'Rato Novakovic'),
                    ('Neelam', 'Ahmadi', 'Neelam Ahmadi'),
                    ('Phoung', 'Du', 'Phoung Du'),
                    ('Luca', 'Barese', 'Luca Barese'),
                    ('Aasaajyoeti', 'Bhogireddy', 'Aasaajyoeti Bhogireddy'),
                    ('Catherine', 'Potts', 'Catherine Potts'),
                    ('Aishwarya', 'Tottempudi', 'Aishwarya Tottempudi'),
                    ('Aarti', 'Kommineni', 'Aarti Kommineni'),
                    ('Lilli', 'Peetre', 'Lilli Peetre'),
                    ('Lassi', 'Santala', 'Lassi Santala'),
                    ('Umut', 'Acar', 'Umut Acar'),
                    ('Kevin', 'Rummo', 'Kevin Rummo'),
                    ('Nargis', 'Shakiba', 'Nargis Shakiba'),
                    ('Irma', 'Berzina', 'Irma Berzina'),
                    ('Irma', 'Auzina', 'Irma Auzina'),
                    ('Manindra', 'Sidhu', 'Manindra Sidhu'),
                    ('Aita', 'Kasesalu', 'Aita Kasesalu'),
                    ('Narayan', 'Ogra', 'Narayan Ogra'),
                    ('Amrita', 'Shetty', 'Amrita Shetty'),
                    ('Logan', 'Dixon', 'Logan Dixon'),
                    ('Celik', 'TunC', 'Celik TunC'),
                    ('David', 'Jaramillo', 'David Jaramillo'),
                    ('Gagan', 'Sengupta', 'Gagan Sengupta'),
                    ('Kalpana', 'Sen', 'Kalpana Sen'),
                    ('Charline', 'Monjeau', 'Charline Monjeau'),
                    ('Essie', 'Braggs', 'Essie Braggs'),
                    ('Teresa', 'Fields', 'Teresa Fields'),
                    ('Ron', 'Williams', 'Ron Williams'),
                    ('Daniela', 'Lo Duca', 'Daniela Lo Duca'),
                    ('Ashutosh', 'Bandopadhyay', 'Ashutosh Bandopadhyay'),
                    ('Cristina', 'Angelo', 'Cristina Angelo'),
                    ('Indranil', 'Prabhupāda', 'Indranil Prabhupāda'),
                    ('Julia', 'Eder', 'Julia Eder'),
                    ('Baebeesaroejini', 'Veturi', 'Baebeesaroejini Veturi'),
                    ('Giovanna', 'Loggia', 'Giovanna Loggia'),
                    ('Nicola', 'Dellucci', 'Nicola Dellucci'),
                    ('Pavel', 'Bures', 'Pavel Bures'),
                    ('Bhaamini', 'Palagummi', 'Bhaamini Palagummi'),
                    ('Cyrus', 'Zardindoost', 'Cyrus Zardindoost'),
                    ('Jautrite', 'Avotina', 'Jautrite Avotina'),
                    ('Matija', 'Rusl', 'Matija Rusl'),
                    ('Daniella', 'Cavalcante', 'Daniella Cavalcante'),
                    ('Vedrana', 'Kovacevic', 'Vedrana Kovacevic'),
                    ('Isa', 'Hulsegge', 'Isa Hulsegge'),
                    ('Ivana', 'Popov', 'Ivana Popov'),
                    ('Tuulikki', 'Linna', 'Tuulikki Linna'),
                    ('Allan', 'Olofsson', 'Allan Olofsson'),
                    ('Cosmin', 'Vulpes', 'Cosmin Vulpes'),
                    ('Dipti', 'Shah', 'Dipti Shah'),
                    ('Teresa', 'Borgen', 'Teresa Borgen'),
                    ('Veronika', 'Necesana', 'Veronika Necesana'),
                    ('Alfonso', 'Barese', 'Alfonso Barese'),
                    ('Erik', 'Malk', 'Erik Malk'),
                    ('Deepa', 'Nandamuri', 'Deepa Nandamuri'),
                    ('Arka', 'Chatterjee', 'Arka Chatterjee'),
                    ('Veronika', 'Svancarova', 'Veronika Svancarova'),
                    ('Felipe', 'Robles', 'Felipe Robles'),
                    ('Tami', 'Shuler', 'Tami Shuler'),
                    ('Flynn', 'Moresby', 'Flynn Moresby'),
                    ('Harsha', 'Raju', 'Harsha Raju'),
                    ('Aishwarya', 'Dantuluri', 'Aishwarya Dantuluri'),
                    ('Truman', 'Schmidt', 'Truman Schmidt'),
                    ('Divyendu', 'Sen', 'Divyendu Sen'),
                    ('Nhung', 'Ton', 'Nhung Ton'),
                    ('Cuneyt', 'Arslan', 'Cuneyt Arslan'),
                    ('Drishti', 'Bose', 'Drishti Bose'),
                    ('Farzana', 'Habibi', 'Farzana Habibi'),
                    ('Angelica', 'Nilsson', 'Angelica Nilsson'),
                    ('Arjun', 'Bhowmick', 'Arjun Bhowmick'),
                    ('Salamans', 'Karklins', 'Salamans Karklins'),
                    ('Hyun-Shik', 'Lee', 'Hyun-Shik Lee'),
                    ('Anand', 'Mudaliyar', 'Anand Mudaliyar'),
                    ('Carlos', 'Aguayo', 'Carlos Aguayo'),
                    ('Sharmila', 'Bhutia', 'Sharmila Bhutia'),
                    ('Hanita', 'Nookala', 'Hanita Nookala'),
                    ('Ondrej', 'Polak', 'Ondrej Polak'),
                    ('Serdar', 'ozden', 'Serdar ozden'),
                    ('Serdar', 'ozCelik', 'Serdar ozCelik'),
                    ('Javiera', 'Laureano', 'Javiera Laureano'),
                    ('Rafael', 'Azevedo', 'Rafael Azevedo'),
                    ('Raj', 'Verma', 'Raj Verma'),
                    ('Philippe', 'Bellefeuille', 'Philippe Bellefeuille'),
                    ('Arda', 'Gunes', 'Arda Gunes'),
                    ('Marcello', 'Longo', 'Marcello Longo'),
                    ('Marcela', 'Antunes', 'Marcela Antunes'),
                    ('Matteo', 'Cattaneo', 'Matteo Cattaneo'),
                    ('Prasad', 'Raju', 'Prasad Raju'),
                    ('Peep', 'Lill', 'Peep Lill'),
                    ('Chompoo', 'Atitarn', 'Chompoo Atitarn'),
                    ('Emma', 'Salpa', 'Emma Salpa'),
                    ('Le', 'Chu', 'Le Chu'),
                    ('Kailash', 'Mittal', 'Kailash Mittal'),
                    ('Pinja', 'Pekkanen', 'Pinja Pekkanen'),
                    ('Karita', 'Jantunen', 'Karita Jantunen'),
                    ('Antonio Carlos', 'Rocha', 'Antonio Carlos Rocha'),
                    ('Kim-ly', 'Vanh', 'Kim-ly Vanh'),
                    ('Cuc', 'Du', 'Cuc Du'),
                    ('Chaowalit', 'Rojumanong', 'Chaowalit Rojumanong'),
                    ('Maria', 'Nechita', 'Maria Nechita'),
                    ('Shirley', 'Doane', 'Shirley Doane'),
                    ('Roberto', 'Sal', 'Roberto Sal'),
                    ('Damyanti', 'Bhamidipati', 'Damyanti Bhamidipati'),
                    ('Aleksandrs', 'Purins', 'Aleksandrs Purins'),
                    ('Alen', 'Kustrin', 'Alen Kustrin'),
                    ('Urve', 'Kasesalu', 'Urve Kasesalu'),
                    ('David', 'Serbanescu', 'David Serbanescu'),
                    ('Nadir', 'Seddigh', 'Nadir Seddigh'),
                    ('Dhirendro', 'Ghatak', 'Dhirendro Ghatak'),
                    ('Monika', 'Kozakova', 'Monika Kozakova'),
                    ('Riccardo', 'Esposito', 'Riccardo Esposito'),
                    ('Aleksandra', 'Abola', 'Aleksandra Abola'),
                    ('Agrita', 'Abele', 'Agrita Abele'),
                    ('Sabrina', 'Baresi', 'Sabrina Baresi'),
                    ('Mudar', 'Mihajlovik', 'Mudar Mihajlovik'),
                    ('Liga', 'Dumina', 'Liga Dumina'),
                    ('Buu', 'Tran', 'Buu Tran'),
                    ('Annette ', 'Hetu', 'Annette  Hetu'),
                    ('Sami', 'Lundin', 'Sami Lundin'),
                    ('Sylvie', 'Methot', 'Sylvie Methot'),
                    ('Petr', 'Spousta', 'Petr Spousta'),
                    ('Lorenzo', 'Howland', 'Lorenzo Howland'),
                    ('Fatima', 'Pulido', 'Fatima Pulido'),
                    ('Rui', 'Carvalho', 'Rui Carvalho')) AS Names(FirstName, LastName, FullName)
        ),
        UnusedNames
        AS
        (
            SELECT *
            FROM NamesToUse AS ntu
            WHERE NOT EXISTS (SELECT 1 FROM [Application].People AS p WHERE p.FullName = ntu.FullName)
        )
        SELECT TOP(1) @PrimaryContactFullName = un.FullName,
                      @PrimaryContactFirstName = un.FirstName
        FROM UnusedNames AS un
        ORDER BY NEWID();

        SET @CustomerID = NEXT VALUE FOR Sequences.CustomerID;
        SET @CustomerCategoryID = (SELECT TOP(1) CustomerCategoryID
                                   FROM Sales.CustomerCategories
                                   WHERE CustomerCategoryName IN (N'Novelty Shop', N'Supermarket', N'Computer Store', N'Gift Store', N'Corporate')
                                   ORDER BY NEWID());
        SET @CityID = (SELECT TOP(1) CityID FROM [Application].Cities AS c
                                            ORDER BY NEWID());
        SET @CityName = (SELECT CityName FROM [Application].Cities WHERE CityID = @CityID);
        SET @CityStateProvinceID = (SELECT StateProvinceID FROM [Application].Cities WHERE CityID = @CityID);
        SET @CityStateProvinceCode = (SELECT StateProvinceCode
                                      FROM [Application].StateProvinces
                                      WHERE StateProvinceID = @CityStateProvinceID);
        SET @AreaCode = DataLoadSimulation.GetAreaCode(@CityStateProvinceCode);
        SET @StreetSuffix = (SELECT TOP(1) StreetType
                             FROM (VALUES(N'Street'), (N'Lane'), (N'Avenue'), (N'Boulevard'), (N'Crescent'), (N'Road')) AS st(StreetType)
                             ORDER BY NEWID());
        SET @CompanySuffix = (SELECT TOP(1) CompanySuffix
                              FROM (VALUES(N'Inc'), (N'Corp'), (N'LLC')) AS cs(CompanySuffix)
                              ORDER BY NEWID());
        SET @StorePrefix = (SELECT TOP(1) StorePrefix
                            FROM (VALUES(N'Shop'), (N'Suite'), (N'Unit')) AS sp(StorePrefix)
                            ORDER BY NEWID());
        SET @CreditLimit = CEILING(RAND() * 30) * 100 + 1000;

        SET @DeliveryAddressLine1 = @StorePrefix + N' ' + CAST(CEILING(RAND() * 30) + 1 AS nvarchar(20));
        SET @DeliveryAddressLine2 = CAST(CEILING(RAND() * 2000) + 1 AS nvarchar(20)) + N' '
                                  + (SELECT TOP(1) PreferredName FROM [Application].People ORDER BY NEWID())
                                  + N' ' + @StreetSuffix;
        SET @DeliveryPostalCode = CAST(CEILING(RAND() * 800) + 90000 AS nvarchar(20));
        SET @PostalAddressLine1 = N'PO Box ' + CAST(CEILING(RAND() * 10000) + 10 AS nvarchar(20));
        SET @PostalAddressLine2 = (SELECT TOP(1) PreferredName FROM [Application].People ORDER BY NEWID()) + N'ville';
        SET @PostalPostalCode = @DeliveryPostalCode;

        SET @PrimaryContactPersonID = NEXT VALUE FOR Sequences.PersonID;

        BEGIN TRAN;

        INSERT [Application].People
            (PersonID, FullName, PreferredName, IsPermittedToLogon, LogonName,
             IsExternalLogonProvider, HashedPassword, IsSystemUser, IsEmployee,
             IsSalesperson, UserPreferences, PhoneNumber, FaxNumber,
             EmailAddress, LastEditedBy, ValidFrom, ValidTo)
        VALUES
            (@PrimaryContactPersonID, @PrimaryContactFullName, @PrimaryContactFirstName, 0, N'NO LOGON',
             0, NULL, 0, 0,
             0, NULL, N'(' + CAST(@AreaCode AS nvarchar(20)) + N') 555-0100', N'(' + CAST(@AreaCode AS nvarchar(20)) + N') 555-0101',
             LOWER(REPLACE(@PrimaryContactFirstName, N'''', N'')) + N'@example.com', 1, @CurrentDateTime, @EndOfTime);

        INSERT Sales.Customers
            (CustomerID, CustomerName, BillToCustomerID, CustomerCategoryID,
             BuyingGroupID, PrimaryContactPersonID, AlternateContactPersonID, DeliveryMethodID,
             DeliveryCityID, PostalCityID, CreditLimit, AccountOpenedDate, StandardDiscountPercentage,
             IsStatementSent, IsOnCreditHold, PaymentDays, PhoneNumber, FaxNumber,
             DeliveryRun, RunPosition, WebsiteURL, DeliveryAddressLine1, DeliveryAddressLine2,
             DeliveryPostalCode, DeliveryLocation, PostalAddressLine1, PostalAddressLine2,
             PostalPostalCode, LastEditedBy, ValidFrom, ValidTo)
         VALUES
            (@CustomerID, @PrimaryContactFullName, @CustomerID, @CustomerCategoryID,
             NULL, @PrimaryContactPersonID, NULL, @DeliveryMethodID,
             @CityID, @CityID, @CreditLimit, @StartingWhen, 0,
             0, 0, 7, N'(' + CAST(@AreaCode AS nvarchar(20)) + N') 555-0100', N'(' + CAST(@AreaCode AS nvarchar(20)) + N') 555-0101',
             NULL, NULL, N'http://www.microsoft.com/', @DeliveryAddressLine1, @DeliveryAddressLine2,
             @DeliveryPostalCode, (SELECT TOP(1) Location FROM [Application].Cities WHERE CityID = @CityID),
             @PostalAddressLine1, @PostalAddressLine2,
             @PostalPostalCode, 1, @CurrentDateTime, @EndOfTime);

        COMMIT;

        SET @Counter += 1;
    END;
END;