CREATE TABLE movies (
  id INTEGER PRIMARY KEY,
  name TEXT DEFAULT NULL,
  year INTEGER DEFAULT NULL,
  rank REAL DEFAULT NULL
);

CREATE TABLE actors (
  id INTEGER PRIMARY KEY,
  first_name TEXT DEFAULT NULL,
  last_name TEXT DEFAULT NULL,
  gender TEXT DEFAULT NULL
);

CREATE TABLE roles (
  actor_id INTEGER,
  movie_id INTEGER,
  role_name TEXT DEFAULT NULL
);




SELECT COUNT(*) FROM movies WHERE year = 1982;

SELECT * FROM actors WHERE last_name LIKE '%stack%';


-- // 10 most popular first names
SELECT first_name, COUNT(*)
FROM actors
GROUP BY first_name
ORDER BY COUNT(*) DESC
LIMIT 10

-- 10 last names
SELECT last_name, COUNT(*)
FROM actors
GROUP BY last_name
ORDER BY COUNT(*) DESC
LIMIT 10

-- 10 last names
SELECT first_name, last_name, COUNT(*)
FROM actors
GROUP BY lower(first_name), lower(last_name)
ORDER BY COUNT(*) DESC
LIMIT 10

-- 100 most active actors
SELECT actor_id, first_name, last_name, COUNT(*)
FROM roles
JOIN actors ON roles.actor_id = actors.id
GROUP BY actor_id
ORDER BY COUNT(*) DESC
LIMIT 100


-- movies genre
SELECT genre, COUNT(*) AS num_movies_by_genres
FROM movies
JOIN movies_genres ON movies.id = movies_genres.movie_id
GROUP BY genre
ORDER BY COUNT(*) ASC


--BRAVEHEART
SELECT * FROM movies WHERE name = "Braveheart";
-- id 46169
SELECT * 
FROM roles
JOIN actors ON roles.actor_id = actors.id
WHERE movie_id = 46169
ORDER BY last_name ASC

--leap noir


SELECT * 
FROM movies
JOIN movies_directors ON movies.id = movies_directors.movie_id
JOIN directors ON movies_directors.director_id = directors.id
WHERE movies.id IN(SELECT movie_id from movies_genres WHERE genre = "Film-Noir")
AND movies.year % 4 = 0
ORDER by name

--Kevin Bacon

--1. Find KB id
--2. filter roles for the ID for movie_id
--3. filter list of movie ids for drama movies
--4. look at the roles table again for all other actor_ids
--5. join the actor name with ID table

SELECT * FROM actors WHERE first_name = 'Kevin' AND last_name = 'Bacon'
SELECT * FROM roles where actor_id = 22591;

SELECT movie_id
FROM movies_genres
WHERE movie_id IN(SELECT movie_id FROM roles where actor_id = 22591)
AND genre = "Drama"

SELECT * 
FROM roles
JOIN actors ON roles.actor_id = actors.id
JOIN movies ON roles.movie_id = movies.id
WHERE movie_id IN(
    SELECT movie_id
    FROM movies_genres
    WHERE movie_id IN(SELECT movie_id FROM roles where actor_id = 22591)
    AND genre = "Drama")
AND actor_id != 22591
ORDER BY movies.name ASC

1. 1900 Table-
    1. Query movies table for movies before 1900
    2. Query roles table for all actor_ids in those movies
2. 
     1. Query movies table for movies after 2000
    2. Query roles table for all actor_ids in those movies

3. intersect 2 tables for actor_id match
4. Query actors table for actor_id names
SELECT * FROM actors 
WHERE id IN(
SELECT actor_id FROM roles 
WHERE movie_id IN(SELECT id From movies WHERE year < 1900)
INTERSECT
SELECT actor_id FROM roles 
WHERE movie_id IN(SELECT id From movies WHERE year > 2000)
)

-- BUSY FILMING

-- PRODUCES the right answer given that we know the movie already
SELECT *, COUNT(*)
FROM (
    SELECT DISTINCT * FROM roles
    JOIN actors ON actor_id = actors.id
    JOIN movies ON movie_id = movies.id
    WHERE movie_id = 399153
)
GROUP BY actor_id
HAVING count(role) >= 5

-- IN PROGRESS
SELECT *
FROM ( -- list of movie id's with roles > 5
    SELECT DISTINCT *, COUNT(*)
    FROM (SELECT DISTINCT * FROM roles)
    GROUP BY movie_id, actor_id
    HAVING count(DISTINCT role) >= 5
)
JOIN actors ON actor_id = actors.id
JOIN movies ON movie_id = movies.id
WHERE year > 1990

-- --test
    SELECT DISTINCT *, COUNT(*)
    FROM (SELECT DISTINCT * FROM roles)
    JOIN actors ON actor_id = actors.id
    JOIN movies ON movie_id = movies.id
    WHERE movie_id = 399153
    GROUP BY movie_id, actor_id
    HAVING count(DISTINCT role) >= 5



























-- FEMALE ACTORS
-- INCLUDING NO CAST AT ALL
SELECT count(*), year FROM movies
WHERE id NOT IN(SELECT DISTINCT movie_id FROM roles
JOIN actors ON actor_id = actors.id
WHERE gender = "M")
GROUP BY year;



-- EXCLUDING NO CAST AT ALL
SELECT year, count(*) as femaleOnly FROM movies
WHERE id -- exclude the 2 types of movies below
    NOT IN( -- all movies with males in them
        SELECT DISTINCT movie_id FROM roles
        JOIN actors ON actor_id = actors.id
        WHERE gender = "M"
    ) 
    AND id
    NOT IN( -- all movies that have no cast
        SELECT id
        FROM movies
        WHERE id NOT IN(SELECT DISTINCT movie_id from roles)
    )
GROUP BY year;

