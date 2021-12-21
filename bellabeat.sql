CREATE DATABASE fitbase;
USE fitbase;

DROP TABLE IF EXISTS daily_activity;
CREATE TABLE daily_activity (
ID VARCHAR(20),
activity_date date,
total_steps FLOAT(20),
tracker_distance FLOAT(20),
logged_activities_distance integer(5),
very_active_dictance float(20),
moderately_active_distance float(30),
light_active_distance float(30),
sedentary_active_distance float(30),
very_active_minutes integer(11),
fairly_active_minutes integer(11),
lightly_active_minutes integer(11),
sedentary_minutes integer(11),
calories integer(11)
);

LOAD DATA LOCAL INFILE 'C:/Users/Agnes Chintia Dewi/Downloads/fitbase/dailyActivity_merged.csv'
INTO TABLE daily_activity
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n' ;


DROP TABLE IF EXISTS daily_steps;

CREATE TABLE daily_steps (
ID varchar(20),
activity_day date,
step_total integer (11)
);

LOAD DATA LOCAL INFILE 'C:/Users/Agnes Chintia Dewi/Downloads/fitbase/dailySteps_merged.csv'
INTO TABLE daily_steps
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n';



DROP TABLE IF EXISTS hourly_steps;
CREATE TABLE hourly_steps (
ID varchar(20),
activity_hour time,
step_total int(20)
);

LOAD DATA LOCAL INFILE 'C:/Users/Agnes Chintia Dewi/Downloads/fitbase/hourlySteps_merged.csv'
INTO TABLE hourly_steps
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n' ;


DROP TABLE IF EXISTS sleep_day;
CREATE TABLE sleep_day (
ID varchar(20),
sleepday date,
total_sleep integer(11),
total_minute_sleep integer(11),
total_time_in_bed integer(11)
);

LOAD DATA LOCAL INFILE 'C:/Users/Agnes Chintia Dewi/Downloads/fitbase/sleepDay_merged.csv'
INTO TABLE sleep_day
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n' ;

DROP TABLE IF EXISTS weight_log_info;
CREATE TABLE weight_log_info (
ID varchar(20),
date_weight date,
weight_kg float(30),
weight_pounds float(30),
fat integer(11),
bmi float(20),
is_manual_report enum('TRUE','FALSE'),
log_id varchar(20)
);

LOAD DATA LOCAL INFILE 'C:/Users/Agnes Chintia Dewi/Downloads/fitbase/weightLogInfo_merged.csv'
INTO TABLE weight_log_info
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n' ;

#check how many data contained
SELECT 
    *
FROM
    daily_activity;

#how many users contained in the dataset
SELECT DISTINCT
    ID
FROM
    daily_activity;

# check if the length if ID is less than or equal 10
SELECT 
    ID
FROM
    daily_activity
WHERE
    LENGTH(ID) > 10 AND LENGTH(ID) < 10;

# check the start date and end date of daily activity
SELECT 
    MIN(activity_date) AS start_date,
    MAX(activity_date) AS end_date
FROM
    daily_activity;

#what days do people being active the most?
SELECT 
    CASE
        WHEN DAYOFWEEK(activity_date) = 1 THEN 'Sunday'
        WHEN DAYOFWEEK(activity_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(activity_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(activity_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(activity_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(activity_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(activity_date) = 7 THEN 'Saturday'
    END AS day_of_week,
    ROUND((SELECT SUM(very_active_dictance) AS very_active_distance)+
    (SELECT SUM(moderately_active_distance) AS moderately_active_distance),0) AS total_active
FROM
    daily_activity
GROUP BY day_of_week
ORDER BY total_active desc;

#what days with the most steps?
SELECT 
    CASE
        WHEN DAYOFWEEK(activity_day) = 1 THEN 'Sunday'
        WHEN DAYOFWEEK(activity_day) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(activity_day) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(activity_day) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(activity_day) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(activity_day) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(activity_day) = 7 THEN 'Saturday'
    END AS day_of_week,
    ROUND(avg(step_total),0) AS avg_total_steps
FROM
    daily_steps
GROUP BY day_of_week
ORDER BY avg_total_steps DESC;

# what hour with the most steps
SELECT 
	activity_hour, 
    ROUND(AVG(step_total),0) AS step_total
from hourly_steps
group by activity_hour;

# what day do people have sedentary time the most?
SELECT 
    CASE
        WHEN DAYOFWEEK(activity_date) = 1 THEN 'Sunday'
        WHEN DAYOFWEEK(activity_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(activity_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(activity_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(activity_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(activity_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(activity_date) = 7 THEN 'Saturday'
    END AS day_of_week,
ROUND(AVG(sedentary_minutes),0) AS sedentary_minutes
FROM
    daily_activity
GROUP BY day_of_week
ORDER BY sedentary_minutes DESC;



 # what days people burn calories the most
 SELECT
	CASE
        WHEN DAYOFWEEK(activity_date) = 1 THEN 'Sunday'
        WHEN DAYOFWEEK(activity_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(activity_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(activity_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(activity_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(activity_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(activity_date) = 7 THEN 'Saturday'
    END AS day_of_week,
    ROUND(AVG(calories),0) AS calories
FROM daily_activity
GROUP BY day_of_week
ORDER BY calories;

# how many users participated to track their sleeps
SELECT DISTINCT
    ID
FROM
    sleep_day;

# the start date and end date of sleep day table

SELECT 
    MIN(sleepday) AS start_date, MAX(sleepday) AS end_date
FROM
    sleep_day;

#average hours sleep per day
SELECT 
	ROUND(AVG(total_minute_sleep/60),0) AS avg_hour_sleep,
    CASE
        WHEN DAYOFWEEK(sleepday) = 1 THEN 'Sunday'
        WHEN DAYOFWEEK(sleepday) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(sleepday) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(sleepday) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(sleepday) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(sleepday) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(sleepday) = 7 THEN 'Saturday'
    END AS day_of_week
FROM sleep_day
GROUP BY day_of_week;


#  how many users participate to give their weight information
SELECT DISTINCT
    ID
FROM
    weight_log_info;
    
# body mass index measurement
SELECT
	ID,
    weight_kg,
    CASE
		WHEN bmi < 18.5 THEN "underweight"
        WHEN bmi BETWEEN 18.5 AND 25 THEN "ideal"
        WHEN bmi BETWEEN 25 AND 29.9 THEN "overweight"
        WHEN bmi >= 30 THEN "obesity"
	END AS body_mass_index, is_manual_report
FROM weight_log_info
GROUP BY ID;

# body fat percentage
SELECT 
	ID,
    weight_kg,
    fat,
    ROUND((fat/weight_kg*100),0) AS body_fat_percentage
FROM weight_log_info
GROUP BY ID;