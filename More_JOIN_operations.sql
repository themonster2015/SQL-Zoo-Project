--1. List the films where the yr is 1962 [Show id, title]

SELECT id, title
FROM movie
WHERE yr=1962

-- 2.  Give year of 'Citizen Kane'.
SELECT yr
FROM movie
WHERE title='Citizen Kane'

-- 3. List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
SELECT id, title, yr
FROM movie
WHERE title LIKE '%Star Trek%'

-- 4. What id number does the actor 'Glenn Close' have?
SELECT id
FROM actor
WHERE name = 'Glenn Close'


-- 5. What is the id of the film 'Casablanca'
SELECT id
FROM movie
WHERE title = 'Casablanca'

-- 6. Obtain the cast list for 'Casablanca'.
SELECT name
FROM casting INNER JOIN actor on casting.actorid  = actor.id
WHERE movieid=11768

-- 7. Obtain the cast list for the film 'Alien'
SELECT name
FROM casting INNER JOIN actor on casting.actorid  = actor.id INNER JOIN movie on movie.id = casting.movieid
WHERE title = 'Alien'

--8.List the films in which 'Harrison Ford' has appeared
SELECT title
FROM movie INNER JOIN casting on movie.id = casting.movieid INNER JOIN actor on casting.actorid  = actor.id
WHERE actor.name =  'Harrison Ford'

--9. List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
SELECT title
FROM movie INNER JOIN casting on movie.id = casting.movieid INNER JOIN actor on casting.actorid  = actor.id
WHERE actor.name =  'Harrison Ford' and casting.ord <> 1

--10.List the films together with the leading star for all 1962 films.
SELECT title, actor.name
FROM movie INNER JOIN casting on movie.id = casting.movieid INNER JOIN actor on casting.actorid  = actor.id
WHERE yr=1962 and casting.ord = 1

--11. Which were the busiest years for 'John Travolta', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
SELECT yr, COUNT(title)
FROM
    movie JOIN casting ON movie.id=movieid
    JOIN actor ON actorid=actor.id
where name='John Travolta'
GROUP BY yr
HAVING COUNT(title)=(SELECT MAX(c)
FROM
    (SELECT yr, COUNT(title) AS c
    FROM
        movie JOIN casting ON movie.id=movieid
        JOIN actor ON actorid=actor.id
    where name='John Travolta'
    GROUP BY yr) AS t
)

--12.List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT title, actor.name
FROM movie INNER JOIN casting on movie.id = casting.movieid INNER JOIN actor on casting.actorid  = actor.id
WHERE ord = 1 and movie.id
IN (SELECT movieid
    FROM casting
    WHERE actorid IN (SELECT id
    FROM actor
    WHERE name = 'Julie Andrews'))

--13. Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.
SELECT actor.name
FROM actor JOIN casting ON actor.id=casting.actorid
WHERE casting.ord = 1
GROUP BY actor.name
HAVING COUNT(actor.name) >= 30

--14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT title, COUNT(actorid)
FROM movie INNER JOIN casting on movie.id = casting.movieid INNER JOIN actor on casting.actorid  = actor.id
WHERE yr=1978
GROUP BY movie.id, title
ORDER BY COUNT(actorid) DESC, title

--15. List all the people who have worked with 'Art Garfunkel'.
SELECT actor.name
FROM casting INNER JOIN actor on casting.actorid  = actor.id INNER JOIN movie on movie.id = casting.movieid
WHERE movie.id in (SELECT movieid
    from casting
    where  actorid = (SELECT id
    from actor
    where name = 'Art Garfunkel' )) AND actor.name <> 'Art Garfunkel'