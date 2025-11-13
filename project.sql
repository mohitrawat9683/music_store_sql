-- number of album and track made by artist
CREATE VIEW album_count AS
    SELECT 
        a.name, COUNT(a1.title) AS no_of_album
    FROM
        artist a
            JOIN
        album a1 ON a.artist_id = a1.artist_id
    GROUP BY a.name
    ORDER BY no_of_album DESC;
    
select * from album_count;


-- which employee manage whome
CREATE VIEW management_details AS
    SELECT 
        CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
        CONCAT(r.first_name, ' ', r.last_name) AS reports_to
    FROM
        employee e
            LEFT JOIN
        employee r ON e.reports_to = r.employee_id;
        
select * from management_details;


-- how much total revenue evey album generated
SELECT 
    a.album_id,
    a.title,
    COUNT(t.track_id) AS sold_track,
    SUM(i.unit_price * i.quantity) AS total_revenue
FROM
    album a
        JOIN
    track t ON a.album_id = t.album_id
        JOIN
    invoice_line i ON t.track_id = i.track_id
GROUP BY a.album_id , a.title
ORDER BY total_revenue DESC;


-- how much total revenue every gener generated
SELECT 
    g.genre_id,
    g.name,
    SUM(i.unit_price * i.quantity) AS total_revenue
FROM
    genre g
        JOIN
    track t ON g.genre_id = t.genre_id
        JOIN
    invoice_line i ON t.track_id = i.track_id
GROUP BY g.genre_id , g.name
ORDER BY total_revenue desc;


-- which country has the highest number of buyers
CREATE VIEW customer_per_country AS
    SELECT 
        billing_country, COUNT(customer_id) AS total_customer
    FROM
        invoice
    GROUP BY billing_country
    ORDER BY total_customer DESC
    LIMIT 10;
    
    select * from customer_per_country;


-- growth of customer per year
SELECT 
    YEAR(invoice_date) AS year,
    COUNT(customer_id) AS customer_count
FROM
    invoice
GROUP BY year
ORDER BY customer_count;


-- number of track not sold in every album
SELECT 
    a.album_id, COUNT(t.track_id) AS not_sold
FROM
    album a
        JOIN
    track t ON a.album_id = t.album_id
        LEFT JOIN
    invoice_line i ON t.track_id = i.track_id
WHERE
    i.track_id IS NULL
GROUP BY a.album_id
ORDER BY not_sold DESC;


-- Find how much amount spent by each customer on artists? Write a query to return 
-- customer name, artist name and total spent 
SELECT 
    a2.name AS artist_name,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(i2.unit_price*i2.quantity) as total_spend
FROM
    customer c
JOIN
    invoice i ON c.customer_id = i.customer_id
JOIN
    invoice_line i2 ON i.invoice_id = i2.invoice_id
JOIN
    track t ON i2.track_id = t.track_id
JOIN
    album a ON t.album_id = a.album_id
JOIN
    artist a2 ON a.artist_id = a2.artist_id
GROUP BY artist_name , customer_name
ORDER BY total_spend DESC;


-- Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the 
-- longest songs listed first

SELECT 
    track_id, name, milliseconds
FROM
    track
WHERE
    milliseconds > (SELECT 
            AVG(milliseconds)
        FROM
            track)
ORDER BY milliseconds desc;


-- which mediatype is popular among peoples
SELECT 
    m.name AS media_type, COUNT(i.track_id) AS count_of_track
FROM
    media_type m
        JOIN
    track t ON m.media_type_id = t.media_type_id
        JOIN
    invoice_line i ON t.track_id = i.track_id
        JOIN
    invoice i1 ON i.invoice_id = i1.invoice_id
GROUP BY media_type
ORDER BY count_of_track desc;


-- ranking country based on total revenue
select 
country,
sum(il.unit_price*il.quantity) as total_revenue ,
rank() over(order by sum(il.unit_price*il.quantity) desc) as revenue_ranked
 from customer c 
 join 
 invoice i on c.customer_id=i.customer_id 
 join 
 invoice_line il on i.invoice_id=il.invoice_id 
 group by 
 country;
 
 SELECT 
    a.album_id,
    SUM(il.unit_price * il.quantity) AS total_sales,
    RANK() OVER(ORDER BY SUM(il.unit_price * il.quantity) DESC) AS album_rank
FROM 
    album a
JOIN 
    track t ON a.album_id = t.album_id
JOIN 
    invoice_line il ON t.track_id = il.track_id
GROUP BY 
    a.album_id
