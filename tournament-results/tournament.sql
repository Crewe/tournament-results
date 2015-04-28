-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

\c vagrant

DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;

\c tournament

-- Drop all the tables if they exist (ORDER MATTERS!)
DROP VIEW player_standings;
DROP TABLE IF EXISTS player_stats;
DROP TABLE IF EXISTS matches;
DROP TABLE IF EXISTS players;


-- CREATE TABLE events (
--	event_id SERIAL PRIMARY KEY,
--	event_name TEXT NOT NULL,
--);

-- Create all the tables (ORDER MATTERS!)
CREATE TABLE players (
	player_id SERIAL PRIMARY KEY,
--	event_id INTEGER NOT NULL,
	player_name TEXT NOT NULL--,
--	FOREIGN KEY (event_id) REFERENCES events(event_id)
);

CREATE TABLE matches (
	match_id SERIAL PRIMARY KEY,
	player_id_A INTEGER NOT NULL,
	player_id_B INTEGER NOT NULL,
	winner_id INTEGER DEFAULT 0,
	FOREIGN KEY (player_id_A) REFERENCES players(player_id),
	FOREIGN KEY (player_id_B) REFERENCES players(player_id)
);

CREATE TABLE player_stats (
	player_id SERIAL PRIMARY KEY NOT NULL,
--	event_id INTEGER NOT NULL,
	wins INTEGER DEFAULT 0 NOT NULL,
	losses INTEGER DEFAULT 0 NOT NULL,
	-- ties INTEGER DEFAULT 0 NOT NULL,
	-- OMW NUMERIC(5,2) DEFAULT 0.0 
	FOREIGN KEY (player_id) REFERENCES players(player_id) ON DELETE CASCADE
	-- FOREIGN KEY (event_id) REFERENCES events(event_id) ON DELETE CASCADE
);

-- Some handy views
CREATE VIEW player_standings AS
SELECT --row_number() OVER () AS ranking
	p.player_id
	, p.player_name
	, s.wins
	, (s.wins + s.losses) AS matches
--	, CASE WHEN s.wins + s.losses = 0 THEN 0
--	  ELSE (s.wins / (s.wins + s.losses)) * 100.00
--	  END
FROM players p
JOIN player_stats s ON p.player_id = s.player_id
GROUP BY s.wins, s.losses, p.player_id, p.player_name
ORDER BY SUM(s.wins) DESC, SUM(s.losses) ASC;
