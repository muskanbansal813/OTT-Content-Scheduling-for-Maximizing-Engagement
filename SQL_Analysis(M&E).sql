-- Media & Entertainment Project

--Create database OTT_Platform

--use OTT_Platform

--------------------------------------------------------------------------------
--EDA
-- So the below query gives us the number of columns in the dataset.
SELECT COUNT(*) AS TotalColumns FROM information_schema.columns
WHERE table_name = 'Content_Scheduling';                       --23columns

-- Count the number of rows
SELECT COUNT(*) AS TotalRows FROM Content_Scheduling;             --1000 rows

--Understanding the structure, datatype of the Customers table
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH, 
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Content_Scheduling';

-- checking missing values
--checking missing values
DECLARE @sql NVARCHAR(MAX);

SELECT @sql = STRING_AGG(
    'SELECT ''' + COLUMN_NAME + ''' AS Column_Name, COUNT(*) AS Null_Count ' +
    'FROM Content_Scheduling WHERE [' + COLUMN_NAME + '] IS NULL', 
    ' UNION ALL '
)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Content_Scheduling';

EXEC(@sql)    

------Check if there is any consistency in Column names
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Content_Scheduling';


--Identify Duplicate Records
SELECT Content_ID,Content_Type,Genre,Release_Date,Time_of_Day,Day_of_the_Week,Duration_mins,
	Viewership,Average_Watch_Time_mins,Peak_Viewership_Time,Peak_Viewership_Day,
	Viewer_Age,Viewer_Gender,Viewer_Location,Likes,Shares,Comments,User_Ratings,
	Seasonality,Content_Popularity,Competitor_Content,Promotion_Data,
	Subscription_Data, COUNT(*) as Duplicate_Cnt
FROM Content_Scheduling
GROUP BY Content_ID,Content_Type,Genre,Release_Date,Time_of_Day,Day_of_the_Week,Duration_mins,
	Viewership,Average_Watch_Time_mins,Peak_Viewership_Time,Peak_Viewership_Day,
	Viewer_Age,Viewer_Gender,Viewer_Location,Likes,Shares,Comments,User_Ratings,
	Seasonality,Content_Popularity,Competitor_Content,Promotion_Data,
	Subscription_Data
HAVING COUNT(*) > 1                             --No duplicate records


---------------------DESCRIPTIVE ANALYSIS-----------------------------------------------
SELECT TOP 20 * FROM Content_Scheduling

SELECT  Content_Type FROM Content_Scheduling
--What are the top 10 most viewed content pieces overall??

SELECT TOP 10
    Content_ID,
    Content_Type,
    Genre,
    Viewership
FROM Content_Scheduling
ORDER BY Viewership DESC;

--What are the most-watched genres in each region??
SELECT 
    Viewer_Location AS Region,
    Genre,
    SUM(Viewership) AS Total_Viewership
FROM Content_Scheduling
GROUP BY Viewer_Location, Genre
ORDER BY Viewer_Location, Total_Viewership DESC;

--Most watched genre from every region
SELECT Region, Genre, Total_Viewership
FROM (
    SELECT 
        Viewer_Location AS Region,
        Genre,
        SUM(Viewership) AS Total_Viewership,
        ROW_NUMBER() OVER (PARTITION BY Viewer_Location ORDER BY SUM(Viewership) DESC) AS rn
    FROM Content_Scheduling
    GROUP BY Viewer_Location, Genre
) AS RankedGenres
WHERE rn = 1;


SELECT COUNT(DISTINCT Genre) FROM Content_Scheduling

--Which genre has the highest average watch time??
SELECT TOP 1
    Genre,
    AVG(Average_Watch_Time_mins) AS Avg_Watch_Time
FROM Content_Scheduling
GROUP BY Genre
ORDER BY Avg_Watch_Time DESC;

--What time of day has the highest viewer engagement??

SELECT 
    Time_of_Day,
    SUM(Viewership) AS Total_Engagement
FROM Content_Scheduling
GROUP BY Time_of_Day
ORDER BY Total_Engagement DESC;
---
SELECT 
    Time_of_Day,
    SUM(Viewership + Likes + Shares + Comments) AS Total_Engagement
FROM Content_Scheduling
GROUP BY Time_of_Day
ORDER BY Total_Engagement DESC;

--Which days of the week drive the most views??
SELECT 
    Day_of_the_Week,
    SUM(Viewership) AS Total_Viewership
FROM Content_Scheduling
GROUP BY Day_of_the_Week
ORDER BY Total_Viewership DESC;
																																																																																			
--What is the average user rating for different content types (Movies vs Series)??
SELECT 
    Content_Type,
    AVG(User_Ratings) AS Avg_User_Rating
FROM Content_Scheduling
WHERE Content_Type IN ('Movie', 'Series')  
GROUP BY Content_Type;

--How many likes, shares, and comments are generated per content type?
SELECT 
    Content_Type,
    SUM(Likes) AS Total_Likes,
    SUM(Shares) AS Total_Shares,
    SUM(Comments) AS Total_Comments
FROM Content_Scheduling
GROUP BY Content_Type;

--Which Genres Get the Best Ratings?
SELECT 
    Genre,
    ROUND(AVG(User_Ratings), 2) AS Avg_Rating,
    COUNT(*) AS Total_Entries
FROM Content_Scheduling
GROUP BY Genre 
ORDER BY Avg_Rating DESC;

--Content Popularity vs Ratings vs Engagement
SELECT 
    Content_ID,
    Genre,
    Content_Popularity,
    ROUNd(User_Ratings,2) AS Rating,
    (Likes + Shares + Comments) AS Engagement,
    Viewership
FROM Content_Scheduling
ORDER BY Content_Popularity DESC, Engagement DESC, User_Ratings DESC;

-------------------------------------------DIAGNOSTIC ANALYSIS---------------------------------------------------------
--Why did the viewership for "Thriller" genre spike on weekends?​
--Viewership of Thriller by Day of Week
SELECT 
    Day_of_the_Week,
    SUM(Viewership) AS Thriller_Viewership
FROM Content_Scheduling
WHERE Genre = 'Thriller'
GROUP BY Day_of_the_Week
ORDER BY Day_of_the_Week DESC

--Engagement on Thriller Content by Day
SELECT 
    Day_of_the_Week,
    SUM(Likes + Shares + Comments) AS Total_Engagement
FROM Content_Scheduling
WHERE Genre = 'Thriller'
GROUP BY Day_of_the_Week
ORDER BY Total_Engagement DESC;

--Viewer Age & Gender Distribution for Thriller (on weekends)
SELECT 
    Viewer_Age,
    Viewer_Gender,
    SUM(Viewership) AS Weekend_Thriller_Views
FROM Content_Scheduling
WHERE Genre = 'Thriller'
  AND Day_of_the_Week IN ('Saturday', 'Sunday')
GROUP BY Viewer_Age, Viewer_Gender
ORDER BY Weekend_Thriller_Views DESC;

--Completion Rate Analysis by Content Type and Genre

SELECT 
    Content_ID,
    Content_Type,
    Genre,
    Duration_mins,
    Average_Watch_Time_mins,
    ROUND(CAST(Average_Watch_Time_mins AS FLOAT) / NULLIF(Duration_mins, 0), 2) AS Completion_Rate
FROM Content_Scheduling
WHERE Duration_mins IS NOT NULL AND Average_Watch_Time_mins IS NOT NULL;


---------------------------PREDICTIVE ANALYSIS----------------------------------------------
---------------------------PRESCRIPTIVE ANALYSIS-------------------------------------------








