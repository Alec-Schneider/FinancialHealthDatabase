# Financial Health Database

## A database created to help users understand their financial postion

A semester long project for class IST659 Database Administration and Database Management, in the Applied Data Science Master's program at Syracuse University.

Aim of the project is to build a database to:
1. Create a conceptual model of the database
2. Create the logical model from the conceptual model
3. Implement the tables and relationships as a database in SQL Server
4. Create stored procedures, views, and functions for users of the database to be able to apply CRUD methods to the database
5. Connect the database through the server to a Python or R script in order to retrieve data and run any analysis.
6. Build a GUI (building a web version with Flask) to create users, create accounts, update their cash flow, accounts, and password, etc.
7. Answer all questions a user would have about their financial health such as:
 	* What is my debt to income ratio?
 	* What percent of my monthly income am I spending?
 	* How has spending changed over time?
 	* How has my debt changed over time?
 	* What is my debt to bank account balance ratio?
 	* How much interest am I paying on my debt every year?

Folder and File Description:
- data/: fake data created to be inserted into the database for testing purposes. Microsoft Excel is required to view.
- images/: screenshots and plots taken for presentation purposes
- SQLScripts/: SQL code used to create the database, insert the data, and add Views, Functions, etc., These files will require Microsoft SQL Server to be used.
- templates:/: html code for the Flask website. Requires a text editor to view and Flask to run.
- app.py: Python script used to run Flask website. Require Python and Flask library.
- database_analysis.ipynb: Jupyter notebook for analysis. Requires Python and Jupyter installed.
- analysis_script.py: Connect to SQL database via SQLalchemy, query database, and answer User questions. Require Python and SQLalchemy library. 
