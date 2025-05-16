# Board Games Arena Management System 

### Project Description 

The system is a database and software solution designed to streamline operations for my dream business which is a board games arena that rents out board games to customers, sells food & drinks for on-site consumption, and manages staff schedules and customer transactions. I thought of creating this project when i saw a Youtube video which shows the creation of a database for a pizza delivery store. 

### Database Structure (PostgreSQL)
  
| **Table**               | **Purpose**                                                               |
|-------------------------|---------------------------------------------------------------------------|
| `customers`             | Stores customer details                              |
| `staff`             | Manages staff data                               |
| `game_items`       | Tracks game inventory                          |
| `food_drinks`           | Lists menu items                                               |
| `orders`          | Records sales                                                |
| `rentals`         | Records board game rentals                                    | 
| `shift` & `work_rotation` | Manage employee schedules                                         |

### Database Creation

- A csv file is created for each of the tables (customers, staff, game_items and food_drinks) using AI chatbots (DeepSeek, Gemini and ChatGPT)
- A csv file is created for the orders table using AI chatbots and the customers table and the food_drinks table 
- A csv file is created for the rentals table using AI chatbots and the customers table and the game_items table
- By referring to the Youtube video, a csv file is created for each of the shift table and the work_rotation table.

   - This is the chat message used in creating the rentals table

     ** the uploaded file is a table for rental of board game sets in a game arena. The start_time,  end_time, and rental_duration are empty. Please fill these empty columns. Rental is 
     available from 08:00 to 24:00. The rental_duration is the difference between the end_time and the start_time, and ranges from 1 hour to 5 hours distributed randomly.  The rental 
     duration should only be 50% integer (whole number), and the other 50% is float (with decimal) **

- Using pgAdmin 4 which is a database administration and development platform specifically designed for PostgreSQL, a database is created by defining the table name and column names of each table, and uploading each of the created csv files into the corresponding created table.

### SQL Queries  
  


  

