USE Souvenir;
GO 

--inserting data to category table
INSERT INTO dbo.Category(CategoryName)
    SELECT DISTINCT CategoryName
    FROM dbo.TempSouvenir;

--inserting data to SouvenirOwner table
INSERT INTO dbo.SouvenirOwner(OwnerName)
    SELECT DISTINCT OwnerName
    FROM dbo.TempSouvenir;

--inserting data to SouvenirLocation table
INSERT INTO dbo.SouvenirLocation(City, Region, country, Longitude, Latitude)
    SELECT DISTINCT City, Region, country, Longitude, Latitude
    FROM dbo.TempSouvenir
    WHERE City IS NOT NULL OR Longitude IS NOT NULL; --There are couple rows with all the location fields null. We dont want that as that would mean we will have entire row with null.

--inserting data into Souvenir table
INSERT INTO dbo.Souvenir (SouvenirName, SouvenirDescription, CategoryID, SouvenirOwnerID, SouvenirLocationID, Price, SouvenirWeight, DateObtained)
    SELECT SouvenirName, SouvenirDescription, CategoryID, SouvenirOwnerID, SouvenirLocationID, Price, SouvenirWeight, DateObtained
    FROM dbo.TempSouvenir
    INNER JOIN dbo.Category ON dbo.TempSouvenir.CategoryName = dbo.Category.CategoryName
    INNER JOIN dbo.SouvenirOwner ON dbo.TempSouvenir.OwnerName = dbo.SouvenirOwner.OwnerName
    LEFT OUTER JOIN dbo.SouvenirLocation ON (dbo.SouvenirLocation.city = dbo.TempSouvenir.city OR dbo.SouvenirLocation.Longitude = dbo.TempSouvenir.Longitude); /*There are couple rows with all the location fields null.
    But we still want the value of the rest of the fields.*/ 

--dropping TempSouvenir Table
drop table dbo.TempSouvenir;

--updating CategoryName for video games from 'Toy' to 'Video Game'
INSERT INTO dbo.Category(CategoryName)  -- adding a new category
    VALUES('Video Game')

UPDATE dbo.Souvenir SET
    CategoryID = (SELECT CategoryID FROM dbo.Category WHERE CategoryName = 'video game')
WHERE SouvenirName LIKE '%Video Game%' OR SouvenirDescription LIKE '%Video Game%'; /*For this particular data only SouvenirDescription has 'Video Game' in it. 
But I thought it would be better to add SouvenirName as there might be a case where SouvenirName contains 'Video Game' and SouvenirDescription is empty. */

--updating CategoryName for Jewelry boxes as 'Miscellaneous'
UPDATE dbo.Souvenir SET
    CategoryID = (SELECT CategoryID FROM dbo.Category WHERE CategoryName = 'Miscellaneous')
WHERE SouvenirName LIKE '%Jewelry Box%' OR SouvenirDescription LIKE '%Jewelry Box%'; /*For this particular data only SouvenirName has 'Jewelry Box' in it. 
But I thought it would be better to add SouvenirDescription as there might be a case where Souvenirdescription contains 'Jewelry Box' instead of SouvenirName. */

-- updating CategoryName of Shamisen, Egyptian Drum, and Zuffolo as Musical Instruments.
INSERT INTO dbo.Category(CategoryName) --adding new category
    VALUES('Musical Instruments')

UPDATE dbo.Souvenir SET
    CategoryID = (SELECT CategoryID FROM dbo.Category WHERE CategoryName = 'Musical Instruments')
WHERE SouvenirName IN ('Shamisen', 'Egyptian Drum', 'Zuffolo');

--deleting the heaviest souvenir
DECLARE @MaxSouvenirWeight decimal(8,2)         --decalring sql variable to store aggregate value
select @MaxSouvenirWeight=MAX(SouvenirWeight)
FROM dbo.Souvenir

Delete FROM dbo.Souvenir 
WHERE SouvenirWeight = @MaxSouvenirWeight;

--deleting all souvenirs that are dirt and sand
DELETE FROM dbo.Souvenir
WHERE SouvenirName LIKE '%dirt%' OR SouvenirName LIKE '%sand%' OR SouvenirDescription LIKE '%dirt%' OR SouvenirDescription LIKE '%sand%';