-- 1. The first example shows the goal scored by a player with the last name 'Bender'. The * says to list all the columns in the table - a shorter way of saying matchid, teamid, player, gtime 
-- Modify it to show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'

SELECT matchid, player
FROM goal 
WHERE teamid = 'GER'

-- 2. From the previous query you can see that Lars Bender's scored a goal in game 1012. Now we want to know what teams were playing in that match.
-- Notice in the that the column matchid in the goal table corresponds to the id column in the game table. We can look up information about game 1012 by finding that row in the game table.
-- Show id, stadium, team1, team2 for just game 1012

SELECT id,stadium,team1,team2
FROM game
WHERE id = 1012
-- 3. The FROM clause says to merge data from the goal table with that from the game table. The ON says how to figure out which rows in game go with which rows in goal - the matchid from goal must match id from game. (If we wanted to be more clear/specific we could say ON (game.id=goal.matchid)
-- The code below shows the player (from the goal) and stadium name (from the game table) for every goal scored.
-- Modify it to show the player, teamid, stadium and mdate for every German goal.

SELECT player, teamid, stadium, mdate
FROM game 
JOIN goal ON game.id=goal.matchid
WHERE goal.teamid = 'GER'

-- 4. Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'

SELECT team1, team2, player
FROM game 
JOIN goal ON game.id=goal.matchid
WHERE goal.player LIKE 'Mario%'

-- 5. The table eteam gives details of every national team including the coach. You can JOIN goal to eteam using the phrase goal JOIN eteam on teamid=id
-- Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10

SELECT player, teamid, coach, gtime
FROM goal 
join eteam on goal.teamid=eteam.id
where goal.gtime<=10

-- 6. List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.

select mdate, teamname
from game
join eteam on eteam.id=game.team1
where eteam.coach like 'Fernando Santos'

-- 7. List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'

select player
from goal
join game on game.id=goal.matchid
where game.stadium like 'National Stadium, Warsaw'

-- 8. show the name of all players who scored a goal against Germany.

SELECT DISTINCT player 
FROM game JOIN goal ON matchid = id 
WHERE (team1 ='GER' OR team2 ='GER')
AND teamid!='GER'

-- 9. Show teamname and the total number of goals scored.

SELECT teamname,count(teamname) as goal
FROM eteam 
JOIN goal ON eteam.id=goal.teamid
group by teamname

-- 10. Show the stadium and the number of goals scored in each stadium.

select stadium, count(stadium) as goals
from game
join goal ON matchid = id 
group by stadium

-- 11. For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'

SELECT matchid,mdate,COUNT(gtime)
FROM game 
inner JOIN goal ON goal.matchid = game.id
where goal.teamid = 'GER'
group by matchid,mdate

-- 12. List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.

SELECT mdate,team1,
sum(case when goal.teamid = game.team1 then 1 else 0 end) as score1,
team2,sum(case when goal.teamid = game.team2 then 1 else 0 end) as score2
FROM game 
left JOIN goal
ON goal.matchid = game.id
group by mdate,team1,team2
