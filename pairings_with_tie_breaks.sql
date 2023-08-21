.headers on

WITH AggregatedScores AS (
    SELECT 
        me,
        SUM(my_result) AS total_score,
        SUM(my_gw) AS game_wins
    FROM match_results
    WHERE tournament = '795ce2e7-c6d7-4fe1-a58e-6680981bf7f4'
    AND round < 5
    GROUP BY me
),
OpponentMatchWins AS (
    SELECT 
        m1.me,
        SUM(CASE WHEN m2.my_result = 3 THEN 1 ELSE 0 END) AS omw
    FROM match_results m1
    JOIN match_results m2 ON m1.opponent = m2.me
    WHERE m1.tournament = '795ce2e7-c6d7-4fe1-a58e-6680981bf7f4'
    AND m2.tournament = '795ce2e7-c6d7-4fe1-a58e-6680981bf7f4'
    AND m1.round < 5
    GROUP BY m1.me
),
OpponentGameWins AS (
    SELECT 
        m1.me,
        SUM(m2.my_gw) AS ogw
    FROM match_results m1
    JOIN match_results m2 ON m1.opponent = m2.me
    WHERE m1.tournament = '795ce2e7-c6d7-4fe1-a58e-6680981bf7f4'
    AND m2.tournament = '795ce2e7-c6d7-4fe1-a58e-6680981bf7f4'
    AND m1.round < 5
    GROUP BY m1.me
)

SELECT 
    a.me AS me_a, 
    b.me AS me_b,
    a.total_score AS score_a,
    b.total_score AS score_b,
    a.game_wins AS game_wins_a,
    b.game_wins AS game_wins_b,
    a.omw AS omw_a,
    b.omw AS omw_b,
    a.ogw AS ogw_a,
    b.ogw AS ogw_b
FROM
    (SELECT 
        me,
        total_score,
        game_wins,
        omw,
        ogw,
        ROW_NUMBER() OVER (ORDER BY total_score DESC, omw DESC, game_wins DESC, ogw DESC, me) AS rn
     FROM AggregatedScores
     LEFT JOIN OpponentMatchWins USING (me)
     LEFT JOIN OpponentGameWins USING (me)
    ) a
JOIN
    (SELECT 
        me,
        total_score,
        game_wins,
        omw,
        ogw,
        ROW_NUMBER() OVER (ORDER BY total_score DESC, omw DESC, game_wins DESC, ogw DESC, me) AS rn
     FROM AggregatedScores
     LEFT JOIN OpponentMatchWins USING (me)
     LEFT JOIN OpponentGameWins USING (me)
    ) b
ON a.rn = b.rn - 1 AND a.rn % 2 = 1 -- pair adjacent rows: 1 with 2, 3 with 4, etc.
WHERE NOT EXISTS (
    -- Check if the two entrants have already played against each other
    SELECT 1
    FROM match_results
    WHERE tournament = '795ce2e7-c6d7-4fe1-a58e-6680981bf7f4'
    AND ((me = a.me AND opponent = b.me) OR (me = b.me AND opponent = a.me))
);
