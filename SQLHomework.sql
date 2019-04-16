USE sakila;

-- 1A
select first_name, last_name
from actor;

-- 1B`.
Select UPPER(concat(first_name, " ", last_name)) AS 'Actor Name'
from actor;

-- 2A 
select actor_id, first_name, last_name
from actor
where first_name = "Joe";

-- 2B

select first_name, last_name
from actor
where last_name LIKE "%GEN%";

-- 2C
select first_name, last_name
from actor
where last_name LIKE "%LI%"
order by last_name, first_name;

-- 2D
select country_id, country
from country
where country in ('Afghanistan','Bangladesh','China');

-- 3A

ALTER TABLE actor
ADD COLUMN description BLOB(50);

-- 3B

ALTER TABLE actor
DROP COLUMN description;

-- 4A
select last_name, count(last_name) as 'actor count'
from actor
group by last_name;

-- 4B
select last_name, count(last_name) as 'actor count'
from actor
group by last_name
having count(last_name) >= 2;

-- 4C
update actor
set first_name = "HARPO"
WHERE first_name = "GROUCHO" and last_name = "WILLIAMS";

-- 4D
update actor
set first_name = "GROUCHO"
where first_name = "HARPO";

-- 5A
show create table address;
create table if not exists `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

-- 6A
select first_name, last_name, address
FROM staff
JOIN address
using(address_id);

-- 6B
select staff_id, first_name, last_name, sum(amount) as "Total Amount Rung Up"
from staff
join payment
using (staff_id)
where payment_date LIKE '2005-08%'
group by staff_id;

-- 6C
select title, count(actor_id) as 'actor number'
from film
inner join film_actor
using(film_id)
group by title;

-- 6D
select count(film_id) as 'copies of film'
from inventory
where film_id in
(
select film_id from film
where title = 'Hunchback Impossible'
);

-- 6E
select first_name, last_name, sum(amount) as 'Total Paid'
from customer
join payment
using (customer_id)
group by customer_id
order by last_name;

-- 7A
select title
from film
where title like 'K%' or title like 'Q%' and language_id in
(
select language_id
from language
where name = 'English'
);

-- 7B
select first_name, last_name
from actor
where actor_id in
(
select actor_id 
from film_actor
where film_id in
(
select film_id
from film
where title = 'Alone Trip'
)
);

-- 7C
select first_name, last_name
from customer
join address
using(address_id)
where city_id in
(
select city_id
from city
where country_id in
(
select country_id
from country
where country = 'Canada'
)
)
;

-- 7D
select title
from film
where film_id in
(
select film_id
from film_category
where category_id in
(
select category_id
from category
where name = 'Family'
)
);

-- 7E
select title, count(film_id) as 'numer of rentals'
from film
join inventory
using(film_id)
join rental
using(inventory_id)
group by title
order by count(film_id) desc;

-- 7fF
select store_id, sum(amount) as 'total business'
from payment
join rental
using (rental_id)
join inventory
using (inventory_id)
group by store_id;

-- 7G
select store_id, city, country
from store
join address
using (address_id)
join city
using (city_id)
join country
using (country_id);


-- 7H
select name, sum(amount) as 'gross revenue'
from payment
join rental
using (rental_id)
join inventory
using (inventory_id)
join film_category
using (film_id)
join category
using (category_id)
group by name
order by sum(amount) desc limit 5;

-- 8A
create view top_five_genres as
select name, sum(amount) as 'gross revenue'
from payment
join rental
using (rental_id)
join inventory
using (inventory_id)
join film_category
using (film_id)
join category
using (category_id)
group by name
order by sum(amount) desc limit 5;

-- 8B
select * from top_five_genres;

-- 8C
drop view top_five_genres;