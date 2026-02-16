-- Insert data
-- Insert all the ConferenceDivision data (8 rows)
-- Insert team data for AFC North (4 rows)

INSERT INTO ConferenceDivision (ConferenceDivisionID, Conference, Division)
    VALUES
    (1, 'AFC', 'North'),
    (2, 'AFC', 'South'),
    (3, 'AFC', 'East'),
    (4, 'AFC', 'West'),
    (5, 'NFC', 'North'),
    (6, 'NFC', 'South'),
    (7, 'NFC', 'East'),   
    (8, 'NFC', 'West');

INSERT INTO Team (TeamID, TeamName, TeamCityState, TeamColors, ConferenceDivisionID)
    VALUES
    (1, 'Pittsburgh Steelers', 'Pittsburgh,PA', 'Black,Yellow',1),
    (2, 'Baltimore Ravens', 'Baltimore, MD', 'Black,Purple', 1),
    (3, 'Cincinnati Bengals', 'Cincinnati, OH', 'Black,Orange', 1),
    (4, 'Cleveland Browns', 'Cleveland, OH', 'Brown,Orange', 1);