
--aggregated all data of 12 months, which were in different database tables

WITH AggregateData AS (
	SELECT * FROM tripdata_202201
	WHERE LEN(ride_id) = 16
	UNION
	SELECT * FROM tripdata_202202
	WHERE LEN(ride_id) = 16
	UNION 
	SELECT * FROM tripdata_202203
	WHERE LEN(ride_id) = 16
	UNION
	SELECT * FROM tripdata_202204
	WHERE LEN(ride_id) = 16
	UNION 
	SELECT * FROM tripdata_202205
	WHERE LEN(ride_id) = 16
	UNION 
	SELECT * FROM tripdata_202206
	WHERE LEN(ride_id) = 16
	UNION 
	SELECT * FROM tripdata_202207
	WHERE LEN(ride_id) = 16
	UNION 
	SELECT * FROM tripdata_202208
	WHERE LEN(ride_id) = 16
	UNION 
	SELECT * FROM tripdata_202209
	WHERE LEN(ride_id) = 16
	UNION 
	SELECT * FROM tripdata_202210
	WHERE LEN(ride_id) = 16
	UNION 
	SELECT * FROM tripdata_202211
	WHERE LEN(ride_id) = 16
	UNION 
	SELECT * FROM tripdata_202212
	WHERE LEN(ride_id) = 16
),


--While filtering out null values, a new field,trip_length, which computes how long a trip last, is added. 
CleanedData AS (
SELECT *, DATEDIFF(MINUTE, started_at, ended_at) AS trip_length
FROM AggregateData
WHERE start_station_id IS NOT NULL 
	AND end_station_id IS NOT NULL
	AND	start_lat IS NOT NULL
	AND	start_lng IS NOT NULL
	AND	end_lat IS NOT NULL
	AND	end_lng IS NOT NULL),

-- To gain better insight, I added two new fields: month_name, which represented the month a ride was started as name instead of number, and day_name, which the day of the week a ride was started.
UpdatedData AS (
SELECT *, 
  CASE 
	WHEN month_started = 1 THEN 'January'
	WHEN month_started = 2 THEN 'Febuary'
	WHEN month_started = 3 THEN 'March'
	WHEN month_started = 4 THEN 'April'
	WHEN month_started = 5 THEN 'May'
	WHEN month_started = 6 THEN 'June'
	WHEN month_started = 7 THEN 'July'
	WHEN month_started = 8 THEN 'August'
	WHEN month_started = 9 THEN 'September'
	WHEN month_started = 10 THEN 'October'
	WHEN month_started = 11 THEN 'November'
	Else 'December'
	END AS month_name,

  CASE 
	WHEN day_of_week = 1 THEN 'Sunday'
	WHEN day_of_week = 2 THEN 'Monday'
	WHEN day_of_week = 3 THEN 'Tuesday'
	WHEN day_of_week = 4 THEN 'Wednesday'
	WHEN day_of_week = 5 THEN 'Thursday'
	WHEN day_of_week = 6 THEN 'Friday'
	ELSE 'Saturday'
  END AS day_name
FROM CleanedData)






--Now exporting the clean data; rides less than 0 have to be treated as errors. 

SELECT * FROM UpdatedData
WHERE trip_length  >= 1;




