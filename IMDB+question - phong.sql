USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select count(*) from director_mapping;
select count(*) from genre;
select count(*) from movie;
select count(*) from names;
select count(*) from ratings;
select count(*) from role_mapping;

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
select sum(case when id is null then 1 else 0 end) id
,sum(case when title is null then 1 else 0 end) title
,sum(case when year is null then 1 else 0 end) year
,sum(case when date_published is null then 1 else 0 end) date_published
,sum(case when duration is null then 1 else 0 end) duration
,sum(case when country is null then 1 else 0 end) country
,sum(case when worlwide_gross_income is null then 1 else 0 end) worlwide_gross_income
,sum(case when languages is null then 1 else 0 end) languages
,sum(case when production_company is null then 1 else 0 end) production_company
from movie;

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
-- total number of movies released each year
/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+



Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select 
	year
    , count(id) number_of_movies
 from movie
 group by year;

select 
	month(date_published) as month_num
    , count(id) number_of_movies
 from movie
 group by month_num
 order by month_num;

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
select 
	Sum(Case when country like '%India%' then 1 else 0 end) as 'India',
    Sum(Case when country like '%USA%' then 1 else 0 end) as 'USA'
from 
	movie
where 
	year = '2019';
/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
select distinct genre from genre;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

select 
	genre.genre,
    count(movie_id) as count
from 
	movie 
		left join genre on movie.id = genre.movie_id
where
	year = '2019'
group by genre.genre
order by count desc;

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
select 
	genre.genre,
    count(movie_id) as count
from 
	movie 
		inner join genre on movie.id = genre.movie_id
group by genre.genre
order by count desc;


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
select 
	count(*) as count
from
	(
    select
		movie_id,
		count(movie_id) as count
	from genre
		group by movie_id
	having count = 1
    ) sub_tbl;



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select 
	genre.genre
    ,avg(duration) avg_duration
from 
	movie 
		left join genre on movie.id = genre.movie_id
group by genre.genre;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


select
	genre,
	count(movie_id) as movie_count,
	rank() over(order by count(movie_id) desc) as genre_rank
from
	genre
group by 
	genre;

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
select
	min(avg_rating) as min_avg_rating,
    max(avg_rating) as max_avg_rating,
    min(total_votes) as min_total_votes,
	max(total_votes) as max_total_votes,
    min(median_rating) as min_median_rating,
    max(median_rating) as max_median_rating
from
	ratings;
   

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
select
	movie.title,
    ratings.avg_rating,
    row_number() over( order by ratings.avg_rating desc) as movie_rank
from
	movie inner join ratings on movie.id = ratings.movie_id
limit 10;
    

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
select
	median_rating,
	count(movie_id) as movie_count
from
	ratings
group by
	median_rating
order by movie_count desc;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
select
	production_company,
    count(ratings.movie_id) movie_count,
    dense_rank() over(order by count(ratings.movie_id) desc) prod_company_rank
from
	movie inner join ratings on movie.id = ratings.movie_id
where
	avg_rating > 8
    and production_company is not null
group by production_company
limit 1;


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select
	genre,
    count(genre.movie_id) movie_count
from
	genre 
    left join  movie on movie.id = genre.movie_id
    inner join ratings on movie.id = ratings.movie_id
where
	movie.year = '2017'
    and month(movie.date_published) = 3
    and movie.country like '%USA%'
    and ratings.total_votes > 1000
group by genre;
	
-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

select
	movie.title,
    ratings.avg_rating,
    genre.genre
from
	genre 
    inner join  movie on movie.id = genre.movie_id
    inner join ratings on movie.id = ratings.movie_id
where
	ratings.avg_rating > 8
    and movie.title like "The%";
    

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select
	count(ratings.movie_id) as movie_count
from
    movie
    inner join ratings on movie.id = ratings.movie_id
where
	movie.date_published between '2018/04/01' and '2019/04/01'
    and median_rating = 8;
    
-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
select
	sum(case when movie.country like '%Germany%'  then total_votes else 0 end) as "German",
    sum(case when movie.country like '%Italy%'  then total_votes else 0 end) as "Italy"
from
	movie
		inner join ratings on movie.id = ratings.movie_id;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
select 
	sum(case when name is null then 1 else 0 end)  name_nulls,
    sum(case when height is null then 1 else 0 end)  height_nulls,
    sum(case when date_of_birth is null then 1 else 0 end)  date_of_birth_nulls,
    sum(case when known_for_movies is null then 1 else 0 end)  known_for_movies_nulls
from
	names;

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- create a CTE top 3 genre hace the most number of movie with an average rating > 8
with top_genre as 
(
	select	
		genre
	from 
		genre inner join ratings on genre.movie_id = ratings.movie_id
	where avg_rating > 8
	group by genre
    order by count(genre.movie_id) desc
    limit 3
)
-- create result table
select
	names.name director_name,
    count(distinct genre.movie_id) movie_count
from
	ratings 
	inner join genre on ratings.movie_id = genre.movie_id
    inner join director_mapping on ratings.movie_id = director_mapping.movie_id
    inner join names on director_mapping.name_id = names.id
    inner join top_genre on genre.genre = top_genre.genre
where
	avg_rating > 8
group by names.name
order by movie_count desc
limit 3;

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select 
	names.name actor_name, 
	count(role_mapping.movie_id) movie_count
from 
	ratings
	inner join role_mapping on ratings.movie_id = role_mapping.movie_id
	inner join names on role_mapping.name_id = names.id
where 
	ratings.median_rating >=8
    and role_mapping.category like "actor"
group by names.name
order by count(role_mapping.movie_id) desc
limit 2;


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
select 
	movie.production_company, 
	sum(ratings.total_votes) vote_count,
	row_number() over ( order by sum(ratings.total_votes) desc) as prod_comp_rank
from 
	movie inner join ratings on movie.id = ratings.movie_id
group by movie.production_company
limit 3;



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
select 
	names.name as actor_name, 
    sum(ratings.total_votes) as total_votes, 
    count(ratings.movie_id) as movie_count, 
    round(sum(ratings.avg_rating * ratings.total_votes) / sum(ratings.total_votes), 2) as actor_avg_rating,
    row_number() over (order by round(sum(ratings.avg_rating * ratings.total_votes) / sum(ratings.total_votes), 2) desc,sum(ratings.total_votes) desc ) as actor_rank
from 
	movie
        inner join role_mapping on movie.id = role_mapping.movie_id
        inner join ratings on movie.id = ratings.movie_id
		inner join names on role_mapping.name_id = names.id
where 
	movie.country like "%india%" 
    and role_mapping.category="actor"
group by names.name
having movie_count >= 5;


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
select
	names.name as actress_name,
    sum(ratings.total_votes) as total_votes,
    count(movie.id) as  movie_count,
    round(sum(ratings.avg_rating * ratings.total_votes) / sum(ratings.total_votes), 2) as actress_avg_rating,
    row_number() over (order by round(sum(ratings.avg_rating * ratings.total_votes) / sum(ratings.total_votes), 2) desc,sum(ratings.total_votes) desc ) as actor_rank
from 
	movie
        inner join role_mapping on movie.id = role_mapping.movie_id
        inner join ratings on movie.id = ratings.movie_id
		inner join names on role_mapping.name_id = names.id
where
	movie.country like '%india%'
    and movie.languages like '%hindi%'
    and role_mapping.category = "actress"
group by names.name
having movie_count >= 3
limit 5;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
select
	movie.title as 'movie',
    ratings.avg_rating,
    case when  ratings.avg_rating > 8 then 'superhit movies'
		when  ratings.avg_rating between 7 and 8 then 'hit movies'
		when  ratings.avg_rating between 5 and 7 then 'one-time-watch movies'
        when ratings.avg_rating < 5 then  'flop movies'
        end as 'category'
from
	movie
		inner join ratings on movie.id = ratings.movie_id
        inner join genre on movie.id = genre.movie_id
where
	genre.genre like 'thriller';




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
select
	genre.genre,
    avg(movie.duration) 'avg_duration',
	round(sum(avg(movie.duration)) over genre_wise,2) 'running_total_duration',
	round(avg(avg(movie.duration)) over genre_wise,2)  'moving_avg_duration'
from
	movie
		inner join ratings on movie.id = ratings.movie_id
        inner join genre on movie.id = genre.movie_id
group by genre.genre
window  genre_wise as (order by genre.genre);



-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

with top_3_gen as
(select
	genre.genre
from 
	movie
		inner join genre on movie.id = genre.movie_id
	group by genre.genre
	order by count(movie.id) desc
	limit 3),
top_5_movie  as
(select
	genre.genre 'genre' ,
    movie.year 'year',
    movie.title as 'movie_name',
	cast(right(movie.worlwide_gross_income, length(movie.worlwide_gross_income) - 2) as decimal) 'worldwide_gross_incom' ,
    rank() over (partition by genre.genre, movie.year order by cast(right(movie.worlwide_gross_income, length(movie.worlwide_gross_income) - 2) as decimal) desc) 'movie_rank'
from
	movie
		inner join ratings on movie.id = ratings.movie_id
        inner join genre on movie.id = genre.movie_id
where genre.genre in (select genre from top_3_gen))
select * from top_5_movie where movie_rank <= 5;

WITH top_3_genres
AS
  (
             SELECT     g.genre
             FROM       movie m
             INNER JOIN genre g
             ON         m.id = g.movie_id
             GROUP BY   g.genre
             ORDER BY   COUNT(m.id) DESC
             LIMIT      3),
  top_5_movies
AS
  (
             SELECT     g.genre AS 'genre' ,
                        m.year  AS 'year',
                        m.title AS 'movie_name',
                        CAST(RIGHT(m.worlwide_gross_income, LENGTH(m.worlwide_gross_income) - 2) AS DECIMAL) 'worldwide_gross_income' ,
                        DENSE_RANK() OVER (PARTITION BY g.genre, m.year ORDER BY CAST(RIGHT(m.worlwide_gross_income, LENGTH(m.worlwide_gross_income) - 2) AS DECIMAL) DESC) 'movie_rank'
             FROM       movie m
             INNER JOIN ratings r
             ON         m.id = r.movie_id
             INNER JOIN genre g
             ON         m.id = g.movie_id
             WHERE      g.genre IN
                        (
                               SELECT genre
                               FROM   top_3_genres))
  SELECT *
  FROM   top_5_movies
  WHERE  movie_rank <= 5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
select
	movie.production_company,
    count(movie_id) as movie_count,
    row_number() over (order by count(movie_id) desc) 'prod_comp_rank'
from
	movie
		inner join ratings on movie.id = ratings.movie_id
where 
	ratings.median_rating >= 8 
    and movie.languages like '%,%'
    and movie.production_company is not null
group by movie.production_company
order by movie_count desc
limit 2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
select 
	names.name ' actress_name',
    sum(ratings.total_votes) 'total_votes',
    count(movie.id) 'movie_count',
    round(sum(ratings.avg_rating * ratings.total_votes) / sum(ratings.total_votes), 2) 'actress_avg_rating' ,
    row_number() over (order by round(sum(ratings.avg_rating * ratings.total_votes) / sum(ratings.total_votes), 2) desc,sum(ratings.total_votes) desc ) as actress_rank
    
from 
	movie
        inner join role_mapping on movie.id = role_mapping.movie_id
        inner join ratings on movie.id = ratings.movie_id
		inner join names on role_mapping.name_id = names.id
		inner join genre on movie.id = genre.movie_id
where 
	role_mapping.category = 'actress'
    and ratings.avg_rating > 8
    and genre.genre = 'drama'
group by names.name
limit 3;


WITH actress_summary
     AS (SELECT n.name                                                     AS
                actress_name,
                SUM(total_votes)                                           AS
                   total_votes,
                COUNT(r.movie_id)                                          AS
                   movie_count,
                ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS
                   actress_avg_rating,
                DENSE_RANK()
                  OVER (
                    ORDER BY ROUND(SUM(r.avg_rating * r.total_votes) /
                  SUM(r.total_votes), 2)
                  DESC, SUM(r.total_votes) DESC )                          AS
                   actress_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
                INNER JOIN role_mapping AS rm
                        ON m.id = rm.movie_id
                INNER JOIN names n
                        ON rm.name_id = n.id
                INNER JOIN genre g
                        ON g.movie_id = m.id
         WHERE  category LIKE '%actress%'
                AND avg_rating > 8
                AND genre LIKE '%Drama%'
         GROUP  BY n.name)
SELECT *
FROM   actress_summary
WHERE  actress_rank <= 3;

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.	   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.			   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
with main_tbl as
(
select
	movie.id,
	director_mapping.name_id,
	names.name,
    datediff(movie.date_published, lead(movie.date_published,1) over (partition by names.name order by movie.date_published desc)) 'diff',
    ratings.avg_rating,
	ratings.total_votes,
    movie.duration
from 
	movie
        inner join director_mapping on movie.id = director_mapping.movie_id
        inner join names on director_mapping.name_id = names.id
        inner join ratings on movie.id = ratings.movie_id
)
select  
	name_id 'director_id',
    name 'director_name',
    count(id) 'number_of_movies' ,
    round(avg(diff),0) 'avg_inter_movie_days',
    round(avg(avg_rating),2) 'avg_rating',
    sum(total_votes) 'total_votes',
    min(avg_rating) 'min_rating',
    max(avg_rating) 'max_rating',
    sum(duration) 'total_duration'
from main_tbl
group by name
order by count(id) desc
limit 9;

    







