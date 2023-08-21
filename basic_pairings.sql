WITH AggregatedScores AS (
    -- Calculate total score for each entrant
    SELECT 
        me,
        SUM(my_result) AS total_score
    FROM match_results
    WHERE tournament = '795ce2e7-c6d7-4fe1-a58e-6680981bf7f4'
    AND round < 5
    GROUP BY me
)
-- Pair entrants based on their scores, ensuring they haven't played against each other already
SELECT 
    a.me AS me_a, 
    b.me AS me_b
FROM 
    (SELECT me, total_score, ROW_NUMBER() OVER (ORDER BY total_score DESC, me) AS rn FROM AggregatedScores) a
JOIN 
    (SELECT me, total_score, ROW_NUMBER() OVER (ORDER BY total_score DESC, me) AS rn FROM AggregatedScores) b
ON a.rn = b.rn - 1 AND a.rn % 2 = 1 -- pair adjacent rows: 1 with 2, 3 with 4, etc.
AND NOT EXISTS (
    -- Check if the two entrants have already played against each other
    SELECT 1
    FROM match_results
    WHERE tournament = '795ce2e7-c6d7-4fe1-a58e-6680981bf7f4'
    AND ((me = a.me AND opponent = b.me) OR (me = b.me AND opponent = a.me))
)
ORDER BY a.total_score DESC, a.me, b.me;

