.headers on

WITH AggregatedScores AS (
    SELECT
        me,
        SUM(my_result) AS total_score,
        SUM(my_gw) AS game_wins,
        COUNT(*) AS total_matches
    FROM match_results
    WHERE tournament = '795ce2e7-c6d7-4fe1-a58e-6680981bf7f4'
    AND round < 5
    GROUP BY me
),
OpponentMatchWins AS (
    SELECT
        m1.me,
        SUM(CASE WHEN m2.my_result = 3 THEN 1 ELSE 0 END) AS omw,
        COUNT(*) AS total_opponent_matches
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
        SUM(m2.my_gw) AS ogw,
        SUM(m2.my_gw + m2.opp_gw) AS total_opponent_games
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
    ROUND(1.0 * a.game_wins / (a.game_wins + a.total_matches * 3 - a.total_score), 2) AS gw_percent_a,
    ROUND(1.0 * b.game_wins / (b.game_wins + b.total_matches * 3 - b.total_score), 2) AS gw_percent_b,
    ROUND(1.0 * a.omw / a.total_opponent_matches, 2) AS omw_percent_a,
    ROUND(1.0 * b.omw / b.total_opponent_matches, 2) AS omw_percent_b,
    ROUND(1.0 * a.ogw / a.total_opponent_games, 2) AS ogw_percent_a,
    ROUND(1.0 * b.ogw / b.total_opponent_games, 2) AS ogw_percent_b
FROM
    (SELECT
        me,
        total_score,
        game_wins,
        omw,
        ogw,
        total_matches,
        total_opponent_matches,
        total_opponent_games,
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
        total_matches,
        total_opponent_matches,
        total_opponent_games,
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

