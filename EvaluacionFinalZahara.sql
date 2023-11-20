## EVALUACIÓN FINAL


 # 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
 
	SELECT title
			FROM film;

 
 # 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
 
	 SELECT title
			FROM film
			WHERE rating = "PG-13";

 
 # 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
	SELECT title, `description`  -- comillas para que no salga azul, no sea que haga otra cosa en vez de leer la columna
			FROM film
			WHERE `description` LIKE "%amazing%";

 
 # 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
	SELECT title
			FROM film
			WHERE length > 120;

 
 # 5. Recupera los nombres de todos los actores.
	SELECT CONCAT(first_name, " ", last_name) AS `nombres_actores`
			FROM actor;


 # 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
	SELECT first_name, last_name
			FROM actor
			WHERE last_name LIKE "%Gibson%";

 
 # 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
	SELECT CONCAT(first_name, " ", last_name) AS `nombres_actores`
			FROM actor
			WHERE actor_id BETWEEN 10 AND 20;

 
 # 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
	SELECT title
			FROM film
			WHERE rating NOT IN ("PG-13") AND rating NOT IN ("R")
            ORDER BY title ASC; 

 
 # 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
 
	SELECT rating, COUNT(*) AS `recuento_pelis`
			FROM film
			GROUP BY rating;

 
 # 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
	SELECT customer.customer_id, CONCAT (customer.first_name," ", customer.last_name) AS `nombre_cliente`, COUNT(rental.rental_id) AS `cantidad_alquileres`
			FROM customer
			LEFT JOIN rental ON customer.customer_id = rental.customer_id
			GROUP BY customer.customer_id, CONCAT(customer.first_name, " ", customer.last_name) -- no se agrupa por alias
			ORDER BY cantidad_alquileres;
 
 # 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
 
	SELECT category.`name` AS `categoria`, COUNT(rental.rental_id) AS `cantidad_alquileres`
			FROM category
	JOIN film_category ON category.category_id = film_category.category_id
	JOIN film ON film_category.film_id = film.film_id
	JOIN inventory  ON film.film_id = inventory.film_id
	JOIN rental ON inventory.inventory_id = rental.inventory_id
	GROUP BY categoria
	ORDER BY cantidad_alquileres DESC; 
    -- seguro que se puede hacer una *subquery* en vez de tantísimos joins

	SELECT category.`name` AS `categoria`, COUNT(rental.rental_id) AS `cantidad_alquileres`
			FROM category
	JOIN film_category ON category.category_id = film_category.category_id
	JOIN rental ON rental.inventory_id IN (
			SELECT inventory_id
				FROM inventory
			WHERE inventory.film_id = film_category.film_id)
	GROUP BY categoria
	ORDER BY cantidad_alquileres DESC; -- OLE OLE

 
 # 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
 -- promedio es la media 
	SELECT rating , AVG (length) AS `duracion_promedio`
			FROM film
			GROUP BY rating;


 # 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
	SELECT CONCAT(actor.first_name, " ", actor.last_name) AS `nombres_actores`
		FROM actor
	JOIN film_actor ON actor.actor_id = film_actor.actor_id
	JOIN film ON film_actor.film_id = film.film_id
	WHERE film.title = "Indian Love";

 
 # 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
	SELECT title
		FROM film
		WHERE `description` LIKE "%dog%" OR `description` LIKE "%cat%";

 
 # 15. Hay algún actor que no aparece en ninguna película en la tabla film_actor.
	SELECT actor_id, first_name, last_name -- concat no, a ver si no lo encuentra
		FROM actor
		WHERE actor_id NOT IN (SELECT DISTINCT actor_id FROM film_actor); -- da solo nulls porque no hay ninguno


 # 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
	SELECT title
		FROM film
		WHERE release_year BETWEEN 2005 AND 2010;
 
 # 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
	SELECT title  
		FROM film
	JOIN film_category ON film.film_id = film_category.film_id
	JOIN category ON film_category.category_id = category.category_id
	WHERE category.name = "Family"; -- ¿subconsultas correlacionadas?
    
   
 # 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
	SELECT CONCAT(actor.first_name, " ", actor.last_name) AS `nombres_actores`
		FROM actor
	INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
	GROUP BY actor.actor_id
	HAVING COUNT(film_actor.film_id) > 10
    ORDER BY nombres_actores; -- esta última linea no haría falta

 
 
 # 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
	SELECT title
		FROM film
	WHERE rating = "R" AND length > 120; -- 
    
 
 # 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
 -- 12 parecido
	SELECT category.`name` AS `nombre_categoria`, AVG(film.length) AS `duracion_promedio` -- name sale en azul
		FROM category
	JOIN film_category ON category.category_id = film_category.category_id
	JOIN film ON film_category.film_id = film.film_id
	GROUP BY nombre_categoria
	HAVING duracion_promedio > 120;

 
 # 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
		-- parecido al 1 de CTEs del repaso, no olvidar llamar a la función
	 WITH ActorFilmCount AS (
		SELECT actor.actor_id,
			CONCAT(actor.first_name, ' ', actor.last_name) AS `nombre_actor`,
			COUNT(film_actor.film_id) AS `cantidad_peliculas`
		FROM actor
		JOIN film_actor ON actor.actor_id = film_actor.actor_id
		GROUP BY actor.actor_id, nombre_actor
	)	
	SELECT * -- llamando a la función
		FROM ActorFilmCount  
		WHERE cantidad_peliculas >= 5
		ORDER BY cantidad_peliculas DESC;

 
 # 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.

	SELECT title
		FROM film
	WHERE film.film_id IN (  -- pongo de dónde es el id porque me estoy liando con film_id de inventory
		SELECT  inventory.film_id  --  no era necesario el distinct 
		FROM rental
		JOIN inventory ON rental.inventory_id = inventory.inventory_id
		WHERE rental.return_date - rental.rental_date > 5 
	 );

 -- no era necesario lo de abajo, pero lo dejo para saber de dónde salió la idea de restar las fechas
# https://es.stackoverflow.com/questions/255292/d%C3%ADas-de-diferencia-entre-dos-fecha-sql-server-2012#:~:text=Puedes%20utilizar%20la%20funci%C3%B3n%20DateDiff,%2C%20horas%2C%20minutos%2C%20etc.
		 SELECT title
			FROM film
		 WHERE film.film_id IN (
			SELECT DISTINCT inventory.film_id
			FROM rental
			JOIN inventory ON rental.inventory_id = inventory.inventory_id
			WHERE DATEDIFF(return_date, rental_date) > 5
		);

 
 # 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
 
	SELECT CONCAT(first_name, " ", last_name) AS `nombres_actores_nunca_horror`
			FROM actor
	WHERE actor.actor_id NOT IN (
			SELECT film_actor.actor_id  -- por nombre y apellido no deja
				FROM film_actor
			JOIN film_category ON film_actor.film_id = film_category.film_id
			JOIN category ON film_category.category_id = category.category_id
			WHERE category.name = "Horror"
	);
 
 # 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.
 
 SELECT title
		FROM film
 WHERE film.film_id IN (   -- where coge film_id de film, no de film_category
		SELECT film_id
			FROM film_category
		JOIN category ON film_category.category_id = category.category_id
		WHERE category.`name` = "Comedy" -- name sale azul
		)
AND length > 180;

 
 # 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.
    
    SELECT 	CONCAT(primer_actor.first_name, " ", primer_actor.last_name) AS primer_actor,
			CONCAT(segundo_actor.first_name, " ", segundo_actor.last_name) AS segundo_actor,
			COUNT(DISTINCT film_primer_actor.film_id) AS pelis_juntos
					FROM film_actor AS `film_primer_actor`
	JOIN film_actor AS `film_segundo_actor` ON film_primer_actor.film_id = film_segundo_actor.film_id -- AND film_primer_actor.actor_id < film_segundo_actor.actor_id
	JOIN actor AS `primer_actor` ON film_primer_actor.actor_id = primer_actor.actor_id
	JOIN actor AS `segundo_actor` ON film_segundo_actor.actor_id = segundo_actor.actor_id
	GROUP BY primer_actor, segundo_actor
	HAVING pelis_juntos > 0;

    
