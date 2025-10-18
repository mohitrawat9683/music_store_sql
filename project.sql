-- which artist created the most albums
SELECT 
    a.name, COUNT(a1.title) AS number_of_album
FROM
    album a1
        JOIN
    artist a ON a1.artist_id = a.artist_id
GROUP BY a.name
ORDER BY number_of_album DESC
LIMIT 5;


-- which employee reports to which
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    CONCAT(r.first_name, ' ', r.last_name) AS report_to
FROM
    employee e
        LEFT JOIN
    employee r ON e.reports_to = r.employee_id;
    
    
-- how much total revenue every album generate
SELECT 
    a.album_id,
    a.title,
    COUNT(t.track_id) AS track_count,
    SUM(total) AS total
FROM
    album a
        JOIN
    track t ON a.album_id = t.album_id
        JOIN
    invoice_line i ON t.track_id = i.track_id
        JOIN
    invoice i1 ON i.invoice_id = i1.invoice_id
GROUP BY a.album_id , a.title
ORDER BY total DESC;


-- how much total revenue every genre genrated 
SELECT 
    g.genre_id, g.name, SUM(i.quantity*i.unit_price) AS total
FROM
    genre g
        JOIN
    track t ON g.genre_id = t.genre_id
        JOIN
    invoice_line i ON t.track_id = i.track_id
        JOIN
    invoice i1 ON i.invoice_id = i1.invoice_id
GROUP BY g.genre_id , g.name
ORDER BY total DESC;


-- which country has the highest number of buyers
SELECT 
    c.country, COUNT(c.customer_id) AS total_customers
FROM
    customer c
        JOIN
    invoice i ON c.customer_id = i.customer_id
GROUP BY c.country
ORDER BY total_customers DESC;


-- growth of customer per year
SELECT 
    YEAR(invoice_date) AS year,
    COUNT(invoice_id) AS customer_growth
FROM
    invoice
GROUP BY year
ORDER BY year DESC;


-- how may track are not sold in every album
SELECT 
    a.album_id, COUNT(t.track_id) AS not_saled 
FROM
    album a
        JOIN
    track t ON a.album_id = t.album_id
        LEFT JOIN
    invoice_line i ON t.track_id = i.track_id
WHERE
    i.track_id IS NULL
GROUP BY a.album_id
ORDER BY not_saled DESC;


-- Find how much amount spent by each customer on artists? Write a query to return 
-- customer name, artist name and total spent 
SELECT 
    a2.name AS artist_name,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(i.total) as totalspend
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
ORDER BY artist_name DESC;


-- Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the 
-- longest songs listed first
SELECT 
    name, milliseconds
FROM
    track
WHERE
    milliseconds > (SELECT 
            AVG(milliseconds) AS avg_song_length
        FROM
            track)
ORDER BY milliseconds DESC;