
# Introduction
There's been a Murder in SQL City! The SQL Murder Mystery is designed to be both a self-directed lesson to learn SQL concepts and commands and a fun game for experienced SQL users to solve an intriguing crime.

A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it. You vaguely remember that the crime was a ​murder​ that occurred sometime on ​Jan.15, 2018​ and that it took place in ​SQL City​. Start by retrieving the corresponding crime scene report from the police department’s database.

 # First Steps
 
 The first step in solving the mystery is to start by analyzing the crime scene. The initial information we have is that it is a murder that took place in SQL city on 15/1/2018. To do this we perform the following query to obtain more details about the nature of the murder and suspect information
 
 ~~~~sql
SELECT * 
FROM crime_scene_report 
WHERE date = 20180115 AND city= 'SQL City' AND type = 'murder'
~~~~
Date  | type | description | City
| :-------:   | :----:  | :-------:   | :----:    |
| 20180115	 | murder |	Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave". | SQL City |

*We will then obtain the full names and personal details of the witnesses at the scene of the crime.*
### Witness number 1
 ~~~~sql
SELECT * 
FROM person 
WHERE address_street_name = 'Northwestern Dr' 
ORDER BY address_number desc
limit 1
~~~~
id  | name | license_id | address_number | address_street_name | ssn | 
| :-------:   | :----:  | :-------:   | :----:    | :----:    | :----:    |
14887  | Morty Schapiro | 118009 | 4919 | 	Northwestern Dr |	111564949 | 
 With the ID we can obtain the information related to your driving license and car.
 ~~~~sql
SELECT * 
FROM drivers_license 
WHERE id = 118009
~~~~
id  | age | height | eye_color | hair_color | gender | plate_number | car_make | car_model
| :-------:   | :----:  | :-------:   | :----:    | :----:    | :----:    | :----:    | :----:    | :----:    |
118009  | 64 | 84 | blue | white | male | 00NU00 | Mercedes-Benz | E-Class | 

### Witness number 2
~~~~sql
SELECT * FROM person 
WHERE address_street_name = 'Franklin Ave' 
and name like '%annabel%'   
~~~~
id  | name | license_id | address_number | address_street_name | ssn | 
| :-------:   | :----:  | :-------:   | :----:    | :----:    | :----:    |
16371  | Annabel Miller	 | 490173 | 103 | 	Franklin Ave |	318771143 | 
With the ID we can obtain the information related to your driving license and car.
 ~~~~sql
SELECT * 
FROM drivers_license 
WHERE id = 490173
~~~~
id  | age | height | eye_color | hair_color | gender | plate_number | car_make | car_model
| :-------:   | :----:  | :-------:   | :----:    | :----:    | :----:    | :----:    | :----:    | :----:    |
490173  | 35 | 65 | green | brown | female | 23AM98 | Toyota | Yaris | 

 # 2. Research continues
 Let's try to find out more information about the main suspects, their alibis and where they were on 1/15/2018.
 ### Get Fit Now Gym
 We will start by finding out your Get Fit Now gym information.
 ~~~~sql
SELECT * 
FROM get_fit_now_member 
WHERE person_id = 16371 or person_id = 14887
~~~~
 id  | person_id | name | membership_start_date | membership_status | 
| :-------:   | :----:  | :-------:   | :----:    | :----:    
 90081  | 16371 | 	Annabel Miller | 20160208 | gold |
 Going into more detail about Annabel Miller's activity at the gym.
  ~~~~sql
SELECT * 
FROM get_fit_now_check_in 
WHERE membership_id = 90081
~~~~
  membership_id  | check_in_date | check_in_time | check_out_time | 
| :-------:   | :----:  | :-------:   | :----:    |
 90081  | 20180109 | 1600 | 1700 | 
 *Annabel Miller did not go to the gym on the day of the murder*
 *Morty Schapiro is not a client of Get Fit Now gym*
 ### Facebook event
  ~~~~sql
SELECT * 
FROM facebook_event_checkin 
WHERE person_id = 16371 or person_id = 14887
~~~~
  person_id  | event_id | event_name | date | 
| :-------:   | :----:  | :-------:   | :----:    |
 14887  | 4719 | 	The Funky Grooves Tour	 | 20180115 | 
 16371  | 4719 | 	The Funky Grooves Tour	 | 20180115 | 
 *Both witnesses were at the same facebook event THE SAME DAY THE KILLING HAPPENED*
 # 3. Interview Time!
   ~~~~sql
SELECT * 
FROM interview 
WHERE person_id = 16371 or person_id = 14887
~~~~
| person_id  | transcript | 
| :-------:   | :----:  |
| 14887   | 	I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W". | 
| 16371 | I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th. |
# 4. Time to search for the suspect
   ~~~~sql
select 
id, person_id, name, membership_status, membership_id, check_in_date
from get_fit_now_member m
join get_fit_now_check_in c on c.membership_id=m.id
where membership_status= "gold" and check_in_date = 20180109 and id like '48Z%'
~~~~
 | id  | person_id | name  | membership_status |  membership_id  | check_in_date |
| :-------:   | :----:  | :-------:   | :----:  | :-------:   | :----:  |
 | 48Z7A  | 28819 | Joe Germuska  | gold |  48Z7A  | 20180109 |
 | 48Z55  | 67318 | Jeremy Bowers  | gold |  48Z55  | 20180109 |
 *We have 2 main suspects, to decide which one is the culprit we must find out the owner of the car whose license plate includes "H42W".*
 ~~~~sql
SELECT * 
FROM drivers_license 
WHERE plate_number LIKE '%H42W%'
and gender = 'male'
~~~~
id  | age | height | eye_color | hair_color | gender | plate_number | car_make | car_model
| :-------:   | :----:  | :-------:   | :----:    | :----:    | :----:    | :----:    | :----:    | :----:    |
423327  | 30 | 70 | brown | brown | male | 0H42W2 | Chevrolet | Spark LS | 
664760  | 21 | 71 | black | black | male | 4H42WR | Nissan | Altima | 
 *let's get the names of these driver's licenses*
  ~~~~sql
 select *
from person 
where license_id = 423327 or license_id = 664760
~~~~
id  | name | license_id | address_number | address_street_name | ssn | 
| :-------:   | :----:  | :-------:   | :----:    | :----:    | :----:    |
51739  | 	Tushar Chandra | 664760 | 312 | 	Phi St |	137882671 | 
67318  | Jeremy Bowers | 423327 | 530 | 	Washington Pl, Apt 3A |	871539279 | 

# 5. Killer exposed
Jeremy Bowers is the person who is signed up for the Get Fit Now gym and owns a car with a license plate containing "H42W". 
HE'S OUR KILLER.

