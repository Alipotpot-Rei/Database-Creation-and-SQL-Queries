# Board Games Arena Management System 

### Project Description 

The system is a database and software solution designed to streamline operations for my dream business which is a board games arena that rents out board games to customers, sells food & drinks for on-site consumption, and manages staff schedules and customer transactions. I thought of creating this project when I saw a Youtube video which shows the creation of a database for a pizza delivery store. 

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
- Database normalization is considered in creating the database. Database normalization is a systematic process of organizing data in a relational database to reduce data redundancy and improve data integrity. It involves breaking down large tables into smaller, more manageable ones and establishing relationships between them according to a set of rules called "normal forms." The goal of normalization is to ensure that data is stored logically, efficiently, and without inconsistencies or errors. This is achieved by:

  - Eliminating Redundancy: Preventing the same data from being stored in multiple places. Redundant data wastes storage space and can lead to inconsistencies if updates are not applied everywhere.

  - Improving Data Integrity: Ensuring the accuracy and consistency of data. When data is stored in only one place, any changes only need to be made once, reducing the chance of errors.

  - Minimizing Data Anomalies: Preventing issues that can arise during data modification (insertion, update, or deletion).
     - Insertion Anomaly: Inability to add new data without also adding data that belongs to a different entity.
     - Update Anomaly: Having to update the same data in multiple places, increasing the risk of inconsistencies if some instances are missed.
     - Deletion Anomaly: Losing important data when deleting a record, because that data was implicitly tied to other, unrelated information in the same row.
  - Simplifying Queries: A well-normalized database typically has a clearer structure, making it easier to write efficient queries and retrieve the desired information.
  - Enhancing Flexibility and Scalability: A normalized database is more adaptable to changing business needs and can be extended to accommodate new types of data without extensive restructuring.
 
### SQL Queries  

The csv file of each table in the database is uploaded into the AI chatbot, and I asked the AI chatbot to create questions or instructions which can be answered with SQL queries. I also added some questions which I deemed necessary, and which are not included in the questions provided by the AI chatbot. The questions range from easy, intermediate and hard in difficulty. Since I have become fond of AI, I also asked AI to help me in creating the SQL queries.    

- Here is the SQL query used in answering my question, " what is the total combined revenue from both food/beverage sales and board game rentals?" Food_revenue and rental_revenue are each used as a Common Table Expression (CTE) in a sub-query for calculating the corresponding revenue. The food_revenue is calculated by multiplying item prices by quantities sold. The rental revenue is calculated by multiplying hourly rates by rental durations. For precise decimal calculations, ::numeric casting is used.
 
![psql1](https://github.com/user-attachments/assets/3c09e6b8-d9cb-4508-a825-f974dd0ea31d)

- Here is the SQL query used in answering my question, " what is the total cost (food/beverage sales + board game rentals) for customer 'C0000456'?" JOIN links orders with food_drinks to get item prices. JOIN connects rentals with game_items to access hourly rates. COALESCE(..., 0) handles NULL values (if no orders/rentals exist). The first/last names of the customer are concatenated for readability.

![psql3](https://github.com/user-attachments/assets/21fbf4fa-c5dc-4f04-b096-ab0482f4dd4c)
