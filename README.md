# SQL-NoSQL Sample Project

This project demonstrates the use of SQL and NoSQL to create, manage, and query databases. We use MySQL as the SQL database and MongoDB as the NoSQL database. The SQL folder contains scripts to manage the MySQL database, while the NoSQL folder contains a JSON file to populate the MongoDB database and a text file containing MongoDB queries.

## SQL

The SQL folder contains the following files:

1. **mysqlsample.sql**: This file creates tables and relations in the MySQL database. The schema includes four tables: `customers`, `employees`, `offices`, `order details`, `orders`, `payments`, `productlines`, and `products`.

2. **stored.sql**: This file contains a stored procedure named `get_margin_contribution_by_rank` that calculates margin contributions for countries based on sales data. The procedure takes a country rank as input and outputs the country name, margin contribution, and delta global margin contribution.

3. **denormalized.sql**: This file contains a procedure to create a denormalized table (SalesTable) from the original tables. This can be useful for analytical queries and reporting purposes.

4. **salesCountry.sql**: This script creates indexes on various tables if they do not exist and then performs a query to retrieve the top-selling product in each country.

## NoSQL

The NoSQL folder contains the following files:

1. **CakeCollection.json**: This is a sample JSON file that can be imported into MongoDB to create a collection of cakes with various properties such as name, description, image URL, ingredients, and stock level.

2. **QueryMongoDB.txt**: This text file contains two MongoDB aggregation queries. The first query gets the top-selling product per country for a MongoDB collection. The second query retrieves all customers and their associated orders, order details, and product info, calculating total sales by product and country.

# Setup


## SQL

1. Import the `mysqlsample.sql` script into MySQL to create and populate the tables.

2. Run the `stored.sql`, `denormalized.sql`, and `salesCountry.sql` scripts in MySQL to execute the stored procedures and queries.

## NoSQL

1. Import the `CakeCollection.json` file into MongoDB to create a collection.

2. Run the queries in `QueryMongoDB.txt` using MongoDB shell or a MongoDB client such as Compass or Robo 3T.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](LICENSE)