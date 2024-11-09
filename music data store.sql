Select name , milliseconds
from track
where milliseconds >( 
Select avg (milliseconds) as av_length
from track )
order by milliseconds
	
/* REturn all the track names that have a song length longer
that the average song length Return the name and Milliseconds for each track . Order by the song length with 
the longest songs listed first */

Select name , milliseconds
from track
where milliseconds >( 
Select avg (milliseconds) as av_length
from track )
order by milliseconds

/* let's invite the artist who have written the most rock music in our
data set Writ a query that return the Artist name and total track count of the top 10 rock bands.*/
Select artist.artist_id,artist_name,count(artist.artist_id)as a
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by a desc
limit 10;

/* Write a query to return the email , first name,last name, and Genre of all Rock music 
listeners REturn your list ordered alphabetically by email starting with A */

Select distinct email,first_name,last_name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in(
	select track_id from track
	join genre on track.genre_id = genre.genre_id
	where genre.name like 'Ro'
)
order by email;


/*Which city has the best customers ? We would like to throw a promotional music festivals 
in the city we made the most money 
Write a query thet returns oner city that has the highest sum of invoice totals Returns both the 
city name and sum of all invoice totals*/

Select 
	sum
	(total) as a ,billing_city
from
	invoice
group by
	billing_city
order by
	a desc

--What are top 3 values of total invoice
Select total from invoice
order by total desc
limit 3

--Who is the senoior most employee based on job title
Select * from employee
order by levels desc
limit 1

--Who is the senoior most employee based on job title
Select * from employee
order by levels desc
limit 2



