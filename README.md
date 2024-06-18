# Pizza_Data_SQL_Project-2

Pizza_Data_SQL_Project-2 is a SQL-based database designed to manage and analyze various aspects of a pizza restaurant's operations, including orders, pizzas, and revenue. This repository contains SQL scripts for creating and populating the database, as well as for performing complex queries to extract meaningful insights about sales, customer preferences, and performance metrics.

Database Structure
The database consists of the following tables:

orders

Stores order details including order ID, order date, and order time.
  Columns:
    order_id: INT, Primary Key
    order_date: DATE
    order_time: TIME
    order_details

Stores details of each order, including the pizza ID and quantity.
  Columns:
    order_details_id: INT, Primary Key
    order_id: INT, Foreign Key
    pizza_id: TEXT
    quantity: INT
    pizza_types

Contains information about different types of pizzas.
  Columns:
    pizza_type_id: TEXT, Primary Key
    name: TEXT
    category: TEXT
    ingredients: TEXT
    pizzas

Contains detailed information about pizzas including their size and price.
  Columns:
    pizza_id: TEXT, Primary Key
    pizza_type_id: TEXT, Foreign Key
    size: TEXT
    price: DOUBLE
