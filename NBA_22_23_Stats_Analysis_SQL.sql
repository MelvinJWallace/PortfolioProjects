/* This is a project on NBA statistics from the 2022 and 2023 season. The dataset was retrieved from the Kaggle website and consist of data pertaining 
to player points, averages, salary and minutes. In this SQL project I will be performing  exploratory data analysis to gather insights and answer a list
of questions regarding the dataset. */

--select * from [nba22/23_stats]  

-- Who are the top 5 players on each team?
select t.Player_Name, concat('$', t.Salary) "Player Salary", t.Position, t.Age, t.Team, t.GP, t.GS,
    t.MP, t.FG1, t._3P1, t._2P1, t.FT1, t.ORB, t.DRB, t.AST, t.STL, t.BLK, t.TOV, t.PF, t.PTS, t.Total_Minutes
from (select Player_Name, Salary, Position, Age, Team, GP, GS, MP, FG1, _3P1, _2P1, FT1, ORB, DRB,
            AST, STL, BLK, TOV, PF, PTS, Total_Minutes, 
	        row_number() over(partition by Team order by Salary desc) "Max Salary per Player by Team"
    from [nba22/23_stats]) t
where "Max Salary per Player by Team" <= 5
and t.Team not like '%/%';

-- What is the highest salary per team?
select Team, max(Salary) "Max Salary per Team"
from [nba22/23_stats]
where Team not like '%/%'
group by Team
order by "Max Salary per Team" desc;

-- What team/teams has the highest salary per total team points average per game?
select Team, sum(Salary) "Team Total Salary", sum(PTS) "Total Team Points Avg"
from [nba22/23_stats]
where Team not like '%/%'
group by Team
order by "Team Total Salary" desc, "Total Team Points Avg" desc;

-- What player has the highest salary per team?
select h.Player_Name, h.Team, concat('$', max(h."Salary")) "Max Salary"
from (select Player_Name,
            Team, 
			Salary, 
			row_number() over(partition by Team order by Salary desc) "Max Salary by Player per Team"
    from [nba22/23_stats]) h
where h.[Max Salary by Player per Team] = 1
and h.Team not like '%/%'
group by h.Player_Name, h.Team, h.Salary
order by h.Salary desc;

-- What player has the higest salary in the league?
select top 1 Player_Name, max(Salary) "Highest Salary"
from [nba22/23_stats]
where Team not like '%/%'
group by Player_Name
order by "Highest Salary" desc;


-- What player has the lowest salary per team?
select l.Player_Name, l.Team, concat('$', min(l.Salary)) "Lowest Salary per Team" 
from (select Player_Name,
            Team,
			Salary,
	        row_number() over(partition by Team order by Salary) "Lowest Salary per Team"
    from [nba22/23_stats]) l
where l.Team not like '%/%'
and "Lowest Salary per Team" <= 1
group by l.Player_Name, l.Team, l.Salary
order by l.Salary;

-- What player has the lowest salary in the league?
select top 1 with ties Player_Name, min(Salary) "Lowest Salary"
from [nba22/23_stats]
where Team not like '%/%'
group by Player_Name
order by "Lowest Salary";

-- What is the lowest salary per team?
select Team, min(Salary) "Lowest Salary Team"
from [nba22/23_stats]
where Team not like '%/%'
group by Team
order by [Lowest Salary Team];

-- What is the average salary per team?
select Team, avg(Salary) "Avg Salary per Team"
from [nba22/23_stats]
where Team not like '%/%'
group by Team
order by "Avg Salary per Team" desc;

-- What is the sum of every teams salary?
select Team, sum(Salary) "Sum of Team Salary"
from [nba22/23_stats]
where Team not like '%/%'
group by Team
order by "Sum of Team Salary" desc;

-- Who is the oldest player with the higest salary per team?
select o.Player_Name, o.Team, concat('$', o.Salary) "Salary", o.Age
from (select Player_Name, 
            Team, 
			Salary,
		    Age, 
		    row_number() over(partition by Team order by Age desc, Salary desc) "Highest Salary of Oldest Player per Team"
    from [nba22/23_stats]) o
where o.[Highest Salary of Oldest Player per Team] = 1
and o.Team not like '%/%';

-- Who is the youngest player with the higest salary per team?
select y.Player_Name, y.Team, concat('$', y.Salary) "Salary", y.Age
from (select Player_Name,
    Team,
	Salary,
	Age,
    dense_rank() over(partition by Team order by Age, Salary desc) "Highest Salary of Youngest Player per Team"
    from [nba22/23_stats]) y
where y.Team not like '%/%'
and y."Highest Salary of Youngest Player per Team" = 1;

-- What player has the highest salary for the most minutes played?
select m.Player_Name, m.Team, concat('$', m.Salary) "Salary", m.Total_Minutes
from (select Player_Name,
            Team, 
		    Salary,
	        Total_Minutes, 
	        row_number() over(order by Total_Minutes desc, Salary desc) "Most Minutes Played"
    from [nba22/23_stats]
	where Team not like '%/%') m
where m.Team not like '%/%'
and m."Most Minutes Played" = 1;

-- What player has the highest salary for the least amount of minutes played?
select m.Player_Name, m.Team, concat('$', m.Salary) "Salary", m.Total_Minutes
from (select Player_Name,
            Team, 
		    Salary,
	        Total_Minutes, 
	        row_number() over(order by Salary desc, Total_Minutes) "Most Minutes Played"
    from [nba22/23_stats]
	where Team not like '%/%') m
where m.Team not like '%/%'
and m."Most Minutes Played" = 1;

-- What player has the lowest salary for the most minutes played?
select l.Player_Name, l.Team, concat('$', l.Salary) "Salary", l.Total_Minutes
from (select Player_Name,
            Team, 
	        Salary,
	        Total_Minutes,
	        row_number() over(order by Total_Minutes desc, Salary) "Lowest Salary by Least Minutes"
    from [nba22/23_stats]
	where Team not like '%/%') l
where l.Team not like '%/%'
and l.[Lowest Salary by Least Minutes] = 1;

-- What player has the lowest salary for the least amount of minutes played?
with cte as (select Player_Name,
                Team, Salary, 
				Total_Minutes,
				row_number() over(order by Salary, Total_Minutes) "Lowest Salary by Least Minutes"
            from [nba22/23_stats]
            where Team not like '%/%')
select cte.Player_Name, cte.Team, concat('$', cte.Salary) "Salary", cte.Total_Minutes
from cte
where cte.Team not like '%/%'
and cte.[Lowest Salary by Least Minutes] = 1;

-- What player has the highest field goal percentage in the league?
with cte as (select Player_Name,
                Team,
	            Salary,
	            FG1,  
	            GS,
	            GP,
	            PTS,
				Position,
	            row_number() over(order by FG1 desc) "Highest FG Percentage"
            from [nba22/23_stats]
            where GP >= 25) 
select cte.Player_Name, 
    cte.Team, 
	concat('$', cte.Salary) "Salary",
	concat(round(cte.FG1, 2), '%') "FG Percentage",
	cte.GS,
	cte.GP, 
	round(cte.PTS, 2) "PTS", 
	Position
from cte
where cte.[Highest FG Percentage] = 1;

-- What is the highest field goal percentage per team?
select h.Player_Name,
    h.Team,
	concat('$', h.Salary) "Salary",
	concat(round(FG1, 2), '%') "FG Percentage",
	h.GS,
	h.GP,
	h.PTS,
	h.Position
from (select Player_Name,
            Team, 
	        Salary,
	        FG1,
	        GS,
	        GP,
	        PTS,
	        Position,
	        row_number() over(partition by Team order by FG1 desc) "Highest FG Pecentage by Team"
    from [nba22/23_stats]
    where GP > 25
    and Team not like '%/%') h
where h.[Highest FG Pecentage by Team] = 1;

-- What is the lowest field goal percentage per team?
with low_fg_pct as (select Player_Name, 
                        Team,
	                    Salary,
	                    FG1, 
	                    GS, 
	                    GP,
	                    PTS,
	                    Position,
	                    row_number() over(partition by Team order by FG1) "Lowest FG Percentage by Team"
                from [nba22/23_stats]
				where Team not like '%/%'
				and GP > 25)
select low_fg_pct.Player_Name,
    low_fg_pct.Team,
	concat('$', low_fg_pct.Salary) "Salary", 
	concat(round(low_fg_pct.FG1, 2), '%') "FG Percentage",
	low_fg_pct.GS,
	low_fg_pct.GP,
	low_fg_pct.PTS,
	low_fg_pct.Position
from low_fg_pct
where low_fg_pct.[Lowest FG Percentage by Team] = 1;

-- What player has the lowest field goal percentage in the league?
select l.Player_Name,
    l.Team,
	concat('$', l.Salary) "Salary",
	concat(round(l.FG1, 2), '%') "FG Percentage",
	l.GS,
	l.GP,
	l.PTS,
	l.Position
from (select Player_Name,
            Team, 
	        Salary,
	        FG1,
	        GS,
	        GP,
	        PTS,
	        Position,
	        row_number() over(order by FG1) "Lowest FG Percentage"
    from [nba22/23_stats]
    where GP > 25) l
where l.[Lowest FG Percentage] = 1;

-- What players have the highest 3 point percentage per team?
with high_3pt_pct as (select Player_Name, 
                            Team, 
	                        Salary,
	                        FG1,
	                        GS,
	                        GP,
	                        PTS,
	                        _3P1,
	                        Position,
	                        row_number() over(partition by Team order by _3P1 desc) "Highest 3pt Percentage"
                    from [nba22/23_stats]
					where Team not like '%/%')
select high_3pt_pct.Player_Name,
    high_3pt_pct.Team, 
	concat('$', high_3pt_pct.Salary) "Salary",
	concat(round(high_3pt_pct.FG1, 2), '%') "FG Percentage",
	high_3pt_pct.GS,
	high_3pt_pct.GP, 
	high_3pt_pct.PTS,
	concat(round(high_3pt_pct._3P1, 2), '%') "3PT Percentage",
	high_3pt_pct.Position
from high_3pt_pct
where high_3pt_pct.[Highest 3pt Percentage] = 1;

-- What players have the lowest 3 point percentage per team?
select l.Player_Name,
    l.Team,
	concat('$', l.Salary) "Salary",
	concat(round(l.FG1, 2), '%') "FG Percentage",
	l.GS,
	l.GP,
	l.PTS,
	concat(round(l._3P1, 2), '%') "3PT Percentage",
	l.Position
from (select Player_Name,
	        Team, 
	        Salary, 
	        FG1,
	        GS, 
	        GP,
	        PTS,
	    _3P1,
		Position,
	    row_number() over(partition by Team order by _3P1) "Lowest 3pt Percentage"
    from [nba22/23_stats]
    where _3P > 1
    and Team not like '%/%') l
where l.[Lowest 3pt Percentage] = 1;

-- What players have the highest free throw percentage per team?
with high_ft_pct as (select Player_Name,
                        Team,
	                    Salary,
	                    FG1,
	                    GS,
	                    GP,
	                    PTS, 
	                    FT1,
	                    Position,
	                    row_number() over(partition by Team order by FT1 desc) "Highest FT Percentage"
                    from [nba22/23_stats]
                    where Team not like '%/%'
                    and GP > 20
                    and FT1 is not null)
select high_ft_pct.Player_Name,
    high_ft_pct.Team,
	concat('$', high_ft_pct.Salary) "Salary",
	concat(round(high_ft_pct.FG1, 2), '%') "FG Percentage",
	high_ft_pct.GS,
	high_ft_pct.GP,
	high_ft_pct.PTS, 
	concat(round(high_ft_pct.FT1, 2), '%') "FT Percentage",
	high_ft_pct.Position
from high_ft_pct
where high_ft_pct.[Highest FT Percentage] = 1
order by high_ft_pct.FT1 desc;

-- What players have the lowest free throw percentage per team?
select l.Player_Name,
    l.Team,
	concat('$', l.Salary) "Salary",
	concat(round(l.FG1, 2), '%') "FG Percentage",
	l.GS,
	l.GP,
	l.PTS,
	concat(round(l.FT1, 2), '%') "FT Percentage"
from (select Player_Name, 
            Team, 
	        Salary,
	        FG1,
	        GS,
	        GP,
	        PTS, 
	        FT1,
	        Position,
	        row_number() over(partition by Team order by FT1) "Lowest FT Percentage"
    from [nba22/23_stats]
    where Team not like '%/%'
    and GP > 20) l
where l.[Lowest FT Percentage] = 1;

/* Now that we have answered the questions, we can use a BI tool such as Power BI to visualize the findings. This is a great option becasue it allows for 
the data to be put in such a way that it can tell its own story and be easily understood. */



