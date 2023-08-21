-- Create the table schema
CREATE TABLE match_results (
    tournament TEXT,
    me TEXT,
    opponent TEXT,
    round INTEGER,
    my_gw INTEGER,
    opp_gw INTEGER,
    games_drawn INTEGER,
    my_result INTEGER,
    opp_result INTEGER
);

-- Round 1
INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerA', 'PlayerB', 1, 2, 1, 2, 3, 0);
INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerB', 'PlayerA', 1, 1, 2, 2, 0, 3);

INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerC', 'PlayerD', 1, 2, 1, 2, 3, 0);
INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerD', 'PlayerC', 1, 1, 2, 2, 0, 3);

INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerE', 'PlayerF', 1, 1, 2, 2, 0, 3);
INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerF', 'PlayerE', 1, 2, 1, 2, 3, 0);

INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerG', 'PlayerH', 1, 1, 2, 2, 0, 3);
INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerH', 'PlayerG', 1, 2, 1, 2, 3, 0);

-- Round 2 (Mixing up results for diversity)
INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerA', 'PlayerC', 2, 2, 1, 2, 3, 0);
INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerC', 'PlayerA', 2, 1, 2, 2, 0, 3);

INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerB', 'PlayerD', 2, 1, 2, 2, 0, 3);
INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerD', 'PlayerB', 2, 2, 1, 2, 3, 0);

-- Let's assume PlayerE and PlayerF draw
INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerE', 'PlayerF', 2, 1, 1, 3, 1, 1);
INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerF', 'PlayerE', 2, 1, 1, 3, 1, 1);

-- Let's make PlayerG win again
INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerG', 'PlayerH', 2, 2, 1, 2, 3, 0);
INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerH', 'PlayerG', 2, 1, 2, 2, 0, 3);

-- Round 3 (To make it even more mixed up)
-- Let's assume PlayerA and PlayerG draw
INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerA', 'PlayerG', 3, 1, 1, 3, 1, 1);
INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerG', 'PlayerA', 3, 1, 1, 3, 1, 1);

-- Let's make PlayerE win
INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerE', 'PlayerB', 3, 2, 1, 2, 3, 0);
INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerB', 'PlayerE', 3, 1, 2, 2, 0, 3);

-- Let's make PlayerF win
INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerF', 'PlayerD', 3, 2, 1, 2, 3, 0);
INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerD', 'PlayerF', 3, 1, 2, 2, 0, 3);

-- Let's make PlayerC win
INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerC', 'PlayerH', 3, 2, 1, 2, 3, 0);
INSERT INTO match_results VALUES ('795ce2e7-c6d7-4fe1-a58e-6680981bf7f4', 'PlayerH', 'PlayerC', 3, 1, 2, 2, 0, 3);

