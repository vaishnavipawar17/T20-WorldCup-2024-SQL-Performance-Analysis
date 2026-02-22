
CREATE DATABASE t20_worldcup;
USE t20_worldcup;
SELECT COUNT(*) FROM matches;
SELECT * FROM matches LIMIT 5;

SHOW TABLES;

SELECT COUNT(*) FROM matches;
SELECT COUNT(*) FROM players;
SELECT COUNT(*) FROM batting_stats;
SELECT COUNT(*) FROM bowling_stats;
SELECT COUNT(*) FROM best_batting;

SELECT * FROM matches
WHERE Winner IS NULL;

SELECT DISTINCT Winner FROM matches;


-- 1. Which team won the most matches in T20 World Cup 2024?
SELECT Winner, COUNT(*) AS Total_Wins
FROM matches
WHERE Winner NOT IN ('tied','noresult')
GROUP BY Winner
ORDER BY Total_Wins DESC;


-- 2. Who are the top 5 highest run scorers?
SELECT Player, Team, Runs
FROM batting_stats
ORDER BY Runs DESC
LIMIT 5;


-- 3. Which ground hosted the highest number of matches?
SELECT Ground, COUNT(*) AS Total_Matches
FROM matches
GROUP BY Ground
ORDER BY Total_Matches DESC;


-- 4.What is the team performance summary showing matches played, matches won,
-- and win percentage for each team in T20 World Cup 2024? 
SELECT 
    Team,
    COUNT(*) AS Matches_Played,
    SUM(CASE WHEN Team = Winner THEN 1 ELSE 0 END) AS Matches_Won,
    ROUND(
        SUM(CASE WHEN Team = Winner THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 1
    ) AS Win_Percentage
FROM
(
    SELECT Team1 AS Team, Winner FROM matches
    UNION ALL
    SELECT Team2 AS Team, Winner FROM matches
) AS combined
GROUP BY Team
ORDER BY Matches_Won DESC;


-- 5. Which player has the highest batting average?
SELECT Player, Team, Ave
FROM batting_stats
ORDER BY Ave DESC
LIMIT 5;


-- 6. Which player hit the most sixes?
SELECT Player, Team, `sixes`
FROM batting_stats
ORDER BY `sixes` DESC
LIMIT 5;

-- 7. Who are the top 5 wicket takers?
SELECT Player, Team, Wkts
FROM bowling_stats
ORDER BY Wkts DESC
LIMIT 5;

-- 8. Which bowler has the best economy rate (minimum 5 matches)?
SELECT Player, Team, Econ
FROM bowling_stats
WHERE Mat >= 5
ORDER BY Econ ASC
LIMIT 5;

-- 9. Which are the top 5 matches with the largest victory margin by 
-- runs in T20 World Cup 2024?
SELECT *
FROM matches
WHERE Margin LIKE '%runs'
ORDER BY CAST(REPLACE(Margin,'runs','') AS UNSIGNED) DESC
LIMIT 5;

-- 10. Identify all-rounders who scored 150+ runs and took 5+ wickets.
SELECT b.Player, b.Runs, bw.Wkts
FROM batting_stats b
JOIN bowling_stats bw
ON b.Player = bw.Player
WHERE b.Runs >= 150 AND bw.Wkts >= 5;

-- 11. Show total count along with details of matches that ended in a tie or no result
SELECT 
    Team1,
    Team2,
    Winner,
    (SELECT COUNT(*) 
     FROM matches 
     WHERE Winner IN ('tied','noresult')) AS Tied_or_NoResult
FROM matches
WHERE Winner IN ('tied','noresult');

-- 12. Identify all-rounders who scored 150+ runs and took 5+ wickets.
SELECT b.Player, b.Runs, bw.Wkts
FROM batting_stats b
JOIN bowling_stats bw
ON b.Player = bw.Player
WHERE b.Runs >= 150 AND bw.Wkts >= 5;

-- 13. Which player scored the highest individual match score?
SELECT Player, Team, Runs, Opposition
FROM best_batting
ORDER BY Runs DESC
LIMIT 5;


-- 14. Which team lost the most matches in the tournament?
SELECT 
    Team,
    COUNT(*) AS Total_Losses
FROM
(
    SELECT Team1 AS Team, Winner FROM matches
    UNION ALL
    SELECT Team2 AS Team, Winner FROM matches
) AS combined
WHERE Team != Winner 
AND Winner NOT IN ('tied','noresult')
GROUP BY Team
ORDER BY Total_Losses DESC;


-- 15. Among top 10 run scorers, who has the highest strike rate?
SELECT Player, Team, Runs, SR 
FROM batting_stats
ORDER BY Runs DESC
LIMIT 10;





