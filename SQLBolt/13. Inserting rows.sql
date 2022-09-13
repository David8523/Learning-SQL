-- 1. Add the studio's new production, Toy Story 4 to the list of movies (you can use any director)

INSERT INTO movies (title, director, year, length_minutes)
VALUES ('Toy Story 4', 'Lance Lafontaine', 2984, 15)

-- 2. Toy Story 4 has been released to critical acclaim! It had a rating of 8.7, and made 340 million domestically and 270 million internationally. Add the record to the BoxOffice table.

INSERT INTO boxoffice (movie_id, rating, domestic_sales, international_sales)
VALUES (15, 8.7, 340000000, 270000000)
