# Deliverable 1: Database system using Oracle
Use the above scenario to answer the following questions:

1.1 Create the tables identified in the ERD from the given scenario.                                

1.2 Create a UNIQUE sequence which increment by one (1) for the tables created in Question 1.1. Therefore, no sequence should have the same value, and it is strongly advised NOT to create a sequence for USES entity because it is an intersection entity.                                                      

1.3 Store at least two (2) records into each table created in Question 1.1 using INSERT statement and relevant sample data. Use the sequence created for each table in Question 1.2 to automatically insert values in the primary key column. It is important to note that sequence is not expected to be implemented for USES entity because it is an intersection entity without a specific primary key column as evidenced in the ERD. Therefore, a composite key comprising of the two foreign keys from the parent tables should rather be implemented in USES table.                                                                                  

1.4 Retrieve and display the number of municipalities that do not have any facility with an activity of ‘Music’ using a suitable query. Remember to use multiple JOIN statements, aggregate functions, suitable wild cards character and sub-query where necessary.                              

1.5 Write a query to retrieve and display a list of provinces that have municipalities with an average population of 4,000,000 (4 million) or more. You may consider the use of sub-query and relevant conditional operators in obtaining the output if necessary.                                        

1.6 The management intends to know the utilisation capacity of each facility in order to plan for future events and expansion. Write a stored procedure named “Province_Capacity_Utilization_procedure” that calculates and displays the cultural facility capacity utilisation per province. The procedure should:
  
  Calculates the total number of facilities in each province.                                             
  Sum up the total capacity of all facilities within each province.                                     
  Count the total number of activities hosted by those facilities.                                       
  Computes a capacity utilisation percentage using the formula below:
  Display a province-based report that includes the province name, number of facilities, total capacity, total activities hosted and the computed utilisation percentage in each province.                
  Sort the output by utilisation percentage in descending order. 

# Deliverable 2: Implementation of Database System with MongoDB   
Use the above scenario to answer the following questions:

2.1  Create a database called OLMS using query.                                                                                              

2.2 Create the collections identified / derived from the ERD in the given scenario.                                  

2.3 Store at least two (2) records into each collection in Question 2.2.                                           

2.4 Write a query to retrieve and display the name of a facility such as “Arts” and all the related rooms associated with the facility. The result of the query may be displayed is follow:

2.5 Write a query to retrieve and display a list of municipalities with an average population of 3,500,000 (3.5 million) or more.        The result below demonstrates the result of the query.          

2.6 Retrieve and display the date on which a facility is used, the details of the facility including facility identity, name, capacity and address. A sample output of the query result is displayed as follow:

2.7 Write a query to retrieve and display a list of activities including activity reference codes, activity name along with the date on which each activity takes place as well as detailed information regarding the facility such as the facility identity, facility name, capacity and address of each facility. In addition, the municipalities and province in which the facility are situated should be displayed with other requested information.  This task requires obtaining information from multiple collections, with a sample output of the query as shown below:

