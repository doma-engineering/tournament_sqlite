.headers on

WITH AggregatedScores AS (
    -- Calculate total score, wins, and losses for each entrant
    SELECT 
        me,
        SUM(my_result) AS total_score,
        SUM(CASE WHEN my_result = 3 THEN 1 ELSE 0 END) AS wins,
        SUM(CASE WHEN my_result = 0 THEN 1 ELSE 0 END) AS losses,
        SUM(CASE WHEN my_result = 1 THEN 1 ELSE 0 END) AS draws
    FROM match_results
    WHERE tournament = '795ce2e7-c6d7-4fe1-a58e-6680981bf7f4'
    AND round < 5
    GROUP BY me
)
-- Pair entrants based on their scores, ensuring they haven't played against each other already
SELECT 
    a.me AS me_a, 
    b.me AS me_b,
    a.total_score AS score_a,
    b.total_score AS score_b,
    a.wins AS wins_a,
    b.wins AS wins_b,
    a.losses AS losses_a,
    b.losses AS losses_b,
    a.draws AS draws_a,
    b.draws AS draws_b
FROM
    (SELECT me, total_score, wins, losses, draws, ROW_NUMBER() OVER (ORDER BY total_score DESC, me) AS rn FROM AggregatedScores) a
JOIN 
    (SELECT me, total_score, wins, losses, draws, ROW_NUMBER() OVER (ORDER BY total_score DESC, me) AS rn FROM AggregatedScores) b
ON a.rn = b.rn - 1 AND a.rn % 2 = 1 -- pair adjacent rows: 1 with 2, 3 with 4, etc.
AND NOT EXISTS (
    -- Check if the two entrants have already played against each other
    SELECT 1
    FROM match_results
    WHERE tournament = '795ce2e7-c6d7-4fe1-a58e-6680981bf7f4'
    AND ((me = a.me AND opponent = b.me) OR (me = b.me AND opponent = a.me))
)
ORDER BY a.total_score DESC, a.me, b.me;

