-- [Problem 1]

-- Cleaning up old tables. Note that tables containing foreign keys are
-- dropped first for the sake of referential integrity constraints.


DROP TABLE IF EXISTS track;
DROP TABLE IF EXISTS artist, album, playlist;

-- Creating artist table with artist_uri, artist_name. 
-- Provide info. about artist

CREATE TABLE artist (
    artist_uri  VARCHAR(250)  PRIMARY KEY,
    artist_name  VARCHAR(250)  NOT NULL
); 

-- Creating album table with album_uri, album_name, release_date
-- (date when album is released). 
-- Provide info. about album


CREATE TABLE album (
    album_uri  VARCHAR(250)  PRIMARY KEY,
    album_name  VARCHAR(250)  NOT NULL,
    release_date  DATETIME  NOT NULL
); 

-- Creating playlist table with playlist_uri, playlist_name, added_by
-- Provide info. about artist


CREATE TABLE playlist (
    playlist_uri  VARCHAR(250)  PRIMARY KEY,
    playlist_name  VARCHAR(250)  NOT NULL,
    added_by  VARCHAR(250)
); 


-- Creating track table with track_uri, track_name, artist_uri, album_uri,
-- playlist_uri, duration_ms, preview_url, added_at. Note that 
-- artist_uri, album_uri, playlist_uri is a foregin key. 
-- Provide info. about track including how long the song is (duration_ms),
-- as well as info. about track, artist, album, etc.

CREATE TABLE track (
    track_uri  VARCHAR(250)  PRIMARY KEY,
    track_name  VARCHAR(250) NOT NULL,
    artist_uri  VARCHAR(250)  NOT NULL,
    album_uri  VARCHAR(250)  NOT NULL,
    playlist_uri  VARCHAR(250)  NOT NULL,
    duration_ms  VARCHAR(250)  NOT NULL,
    preview_url  VARCHAR(250),
    added_at  TIMESTAMP  NOT NULL,
    
    FOREIGN KEY  (artist_uri) REFERENCES artist(artist_uri)
	    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY  (album_uri) REFERENCES album(album_uri)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY  (playlist_uri) REFERENCES playlist(playlist_uri)
        ON UPDATE CASCADE ON DELETE CASCADE
); 