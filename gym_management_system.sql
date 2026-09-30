CREATE DATABASE gym_management_system;
USE gym_management_system;
 
-- ------------------------------------------------------------
-- 1. STAFF  (trainers, receptionists, managers)
-- ------------------------------------------------------------
CREATE TABLE Staff (
    staff_id      INT AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(50) NOT NULL,
    last_name     VARCHAR(50) NOT NULL,
    role          VARCHAR(30) NOT NULL,          -- Trainer, Manager, Receptionist, Nutritionist
    phone         VARCHAR(15) UNIQUE,
    email         VARCHAR(100) UNIQUE,
    salary        DECIMAL(10,2) NOT NULL,
    hire_date     DATE NOT NULL
);
 
-- ------------------------------------------------------------
-- 2. MEMBERS
-- ------------------------------------------------------------
CREATE TABLE Members (
    member_id     INT AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(50) NOT NULL,
    last_name     VARCHAR(50) NOT NULL,
    gender        ENUM('Male','Female','Other') NOT NULL,
    dob           DATE NOT NULL,
    phone         VARCHAR(15) UNIQUE,
    email         VARCHAR(100) UNIQUE,
    address       VARCHAR(150),
    join_date     DATE NOT NULL
);
 
-- ------------------------------------------------------------
-- 3. MEMBERSHIP_PLANS
-- ------------------------------------------------------------
CREATE TABLE Membership_Plans (
    plan_id         INT AUTO_INCREMENT PRIMARY KEY,
    plan_name       VARCHAR(50) NOT NULL,          -- Basic, Standard, Premium, Student, Annual
    duration_months INT NOT NULL,
    price           DECIMAL(10,2) NOT NULL,
    description     VARCHAR(200)
);
 
-- ------------------------------------------------------------
-- 4. MEMBERSHIPS  (which member subscribed to which plan, when)
-- ------------------------------------------------------------
CREATE TABLE Memberships (
    membership_id  INT AUTO_INCREMENT PRIMARY KEY,
    member_id      INT NOT NULL,
    plan_id        INT NOT NULL,
    start_date     DATE NOT NULL,
    end_date       DATE NOT NULL,
    status         ENUM('Active','Expired','Cancelled') NOT NULL DEFAULT 'Active',
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (plan_id) REFERENCES Membership_Plans(plan_id) ON DELETE RESTRICT
);
 
-- ------------------------------------------------------------
-- 5. PAYMENTS
-- ------------------------------------------------------------
CREATE TABLE Payments (
    payment_id     INT AUTO_INCREMENT PRIMARY KEY,
    membership_id  INT NOT NULL,
    amount         DECIMAL(10,2) NOT NULL,
    payment_date   DATE NOT NULL,
    payment_method ENUM('Cash','Card','UPI','NetBanking') NOT NULL,
    FOREIGN KEY (membership_id) REFERENCES Memberships(membership_id) ON DELETE CASCADE
);
 
-- ------------------------------------------------------------
-- 6. ATTENDANCE
-- ------------------------------------------------------------
CREATE TABLE Attendance (
    attendance_id   INT AUTO_INCREMENT PRIMARY KEY,
    member_id       INT NOT NULL,
    attendance_date DATE NOT NULL,
    check_in        TIME NOT NULL,
    check_out       TIME,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE
);
 
-- ------------------------------------------------------------
-- 7. EQUIPMENT
-- ------------------------------------------------------------
CREATE TABLE Equipment (
    equipment_id    INT AUTO_INCREMENT PRIMARY KEY,
    equipment_name  VARCHAR(80) NOT NULL,
    category        VARCHAR(40) NOT NULL,   -- Cardio, Strength, Free Weights, Machines
    purchase_date   DATE NOT NULL,
    cost            DECIMAL(10,2) NOT NULL,
    status          ENUM('Working','Under Maintenance','Retired') NOT NULL DEFAULT 'Working'
);
 
-- ------------------------------------------------------------
-- 8. GYM_CLASSES  (group classes like Zumba, Yoga, CrossFit)
-- ------------------------------------------------------------
CREATE TABLE Gym_Classes (
    class_id       INT AUTO_INCREMENT PRIMARY KEY,
    class_name     VARCHAR(60) NOT NULL,
    trainer_id     INT NOT NULL,
    day_of_week    VARCHAR(10) NOT NULL,
    start_time     TIME NOT NULL,
    duration_mins  INT NOT NULL,
    capacity       INT NOT NULL,
    FOREIGN KEY (trainer_id) REFERENCES Staff(staff_id) ON DELETE CASCADE
);
 
-- ------------------------------------------------------------
-- 9. CLASS_BOOKINGS  (members enrolling into group classes)
-- ------------------------------------------------------------
CREATE TABLE Class_Bookings (
    booking_id     INT AUTO_INCREMENT PRIMARY KEY,
    class_id       INT NOT NULL,
    member_id      INT NOT NULL,
    booking_date   DATE NOT NULL,
    status         ENUM('Booked','Attended','Cancelled','No-Show') NOT NULL DEFAULT 'Booked',
    FOREIGN KEY (class_id) REFERENCES Gym_Classes(class_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE
);
 
-- ------------------------------------------------------------
-- 10. TRAINER_ASSIGNMENTS  (personal trainer <-> member mapping)
-- ------------------------------------------------------------
CREATE TABLE Trainer_Assignments (
    assignment_id  INT AUTO_INCREMENT PRIMARY KEY,
    trainer_id     INT NOT NULL,
    member_id      INT NOT NULL,
    assigned_date  DATE NOT NULL,
    goal           VARCHAR(60),   -- Weight Loss, Muscle Gain, General Fitness, Rehab
    FOREIGN KEY (trainer_id) REFERENCES Staff(staff_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE
);

SELECT* from staff
SELECT * from members
SELECT * from membership_plans
SELECT * from memberships
SELECT * from payments
SELECT * from attendance
SELECT * from equipment
SELECT * FROM gym_classes
SELECT * from class_bookings
SELECT *from trainer_assignments
-- 1.Display all members
SELECT * 
FROM Members;
-- 2. Display only member names and phone numbers
SELECT first_name, last_name, phone
FROM Members;
-- 3. Find female members
SELECT *
FROM Members
WHERE gender = 'Female';
-- 4. Find members who joined after a particular date
SELECT *
FROM Members
WHERE join_date > '2025-01-01';
-- 5. Find members from a particular city/address
SELECT *
FROM Members
WHERE address LIKE '%Chennai%';
-- 6. Display membership plans costing more than ₹3000
SELECT *
FROM Membership_Plans
WHERE price > 3000;
-- 7. Display plans from highest to lowest price
SELECT *
FROM Membership_Plans
ORDER BY price DESC;
-- 8. Display the first 5 members
SELECT *
FROM Members
LIMIT 5;
-- 9. Find trainers
SELECT *
FROM Staff
WHERE role = 'Trainer';
-- 10. Display working equipment
SELECT *
FROM Equipment
WHERE status = 'Working';

                 --   INTERMEDIATE       
-- 11. Count total members
SELECT COUNT(*) AS total_members
FROM Members;
-- 12. Count members by gender
SELECT 
    gender,
    COUNT(*) AS total_members
FROM Members
GROUP BY gender;
-- 13. Find total gym revenue
SELECT 
    SUM(amount) AS total_revenue
FROM Payments;
-- 14. Find average membership plan price
SELECT 
    AVG(price) AS average_price
FROM Membership_Plans;
-- 15. Find the most expensive membership plan
SELECT *
FROM Membership_Plans
ORDER BY price DESC
LIMIT 1;
-- 16. Find total revenue by payment method
SELECT
    payment_method,
    SUM(amount) AS total_revenue
FROM Payments
GROUP BY payment_method
ORDER BY total_revenue DESC;
-- 17. Find number of members in each membership plan
SELECT
    mp.plan_name,
    COUNT(ms.member_id) AS total_members
FROM Membership_Plans mp
JOIN Memberships ms
    ON mp.plan_id = ms.plan_id
GROUP BY mp.plan_id, mp.plan_name;
-- 18. Display member + membership plan
SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    mp.plan_name,
    mp.price,
    ms.start_date,
    ms.end_date,
    ms.status
FROM Members m
JOIN Memberships ms
    ON m.member_id = ms.member_id
JOIN Membership_Plans mp
    ON ms.plan_id = mp.plan_id;
-- 19. Display members with active memberships
SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    mp.plan_name,
    ms.start_date,
    ms.end_date
FROM Members m
JOIN Memberships ms
    ON m.member_id = ms.member_id
JOIN Membership_Plans mp
    ON ms.plan_id = mp.plan_id
WHERE ms.status = 'Active';
-- 20. Display members who attended the gym
SELECT DISTINCT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name
FROM Members m
JOIN Attendance a
    ON m.member_id = a.member_id;
    
-- 🔴 LEVEL 3 — ADVANCED (21–30)

-- 21. Find the highest-paid staff member
SELECT
    staff_id,
    CONCAT(first_name, ' ', last_name) AS staff_name,
    role,
    salary
FROM Staff
WHERE salary = (
    SELECT MAX(salary)
    FROM Staff
);

-- 22. Find staff earning more than average salary
SELECT
    staff_id,
    CONCAT(first_name, ' ', last_name) AS staff_name,
    role,
    salary
FROM Staff
WHERE salary > (
    SELECT AVG(salary)
    FROM Staff
);
-- Concept:

-- AVG() + Subquery

-- 23. Find trainers and number of members assigned to them
SELECT
    s.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS trainer_name,
    COUNT(ta.member_id) AS total_members
FROM Staff s
JOIN Trainer_Assignments ta
    ON s.staff_id = ta.trainer_id
WHERE s.role = 'Trainer'
GROUP BY s.staff_id, s.first_name, s.last_name;
-- 24. Find the trainer with the highest number of assigned members
SELECT
    s.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS trainer_name,
    COUNT(ta.member_id) AS total_members
FROM Staff s
JOIN Trainer_Assignments ta
    ON s.staff_id = ta.trainer_id
WHERE s.role = 'Trainer'
GROUP BY s.staff_id, s.first_name, s.last_name
ORDER BY total_members DESC
LIMIT 1;
-- 25. Find members who have never attended the gym
SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name
FROM Members m
LEFT JOIN Attendance a
    ON m.member_id = a.member_id
WHERE a.attendance_id IS NULL;
-- Concept:

-- LEFT JOIN + IS NULL

-- 26. Find members who paid more than the average payment
SELECT
    p.payment_id,
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    p.amount,
    p.payment_date
FROM Payments p
JOIN Memberships ms
    ON p.membership_id = ms.membership_id
JOIN Members m
    ON ms.member_id = m.member_id
WHERE p.amount > (
    SELECT AVG(amount)
    FROM Payments
);
-- 27. Find total revenue generated by each membership plan
SELECT
    mp.plan_name,
    SUM(p.amount) AS total_revenue
FROM Membership_Plans mp
JOIN Memberships ms
    ON mp.plan_id = ms.plan_id
JOIN Payments p
    ON ms.membership_id = p.membership_id
GROUP BY mp.plan_id, mp.plan_name
ORDER BY total_revenue DESC;

-- 28. Find the most popular gym class
SELECT
    gc.class_id,
    gc.class_name,
    COUNT(cb.booking_id) AS total_bookings
FROM Gym_Classes gc
JOIN Class_Bookings cb
    ON gc.class_id = cb.class_id
WHERE cb.status <> 'Cancelled'
GROUP BY gc.class_id, gc.class_name
ORDER BY total_bookings DESC
LIMIT 1;
-- 29. Find members with their trainer and fitness goal
SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    CONCAT(s.first_name, ' ', s.last_name) AS trainer_name,
    ta.goal,
    ta.assigned_date
FROM Trainer_Assignments ta
JOIN Members m
    ON ta.member_id = m.member_id
JOIN Staff s
    ON ta.trainer_id = s.staff_id
WHERE s.role = 'Trainer';
-- 30. 🏆 Complete Member Dashboard Query

-- This combines Members + Memberships + Plans + Payments + Trainers.

SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.phone,
    m.email,
    mp.plan_name,
    ms.start_date,
    ms.end_date,
    ms.status AS membership_status,
    COALESCE(SUM(p.amount), 0) AS total_paid,
    CONCAT(s.first_name, ' ', s.last_name) AS trainer_name,
    ta.goal
FROM Members m

LEFT JOIN Memberships ms
    ON m.member_id = ms.member_id

LEFT JOIN Membership_Plans mp
    ON ms.plan_id = mp.plan_id

LEFT JOIN Payments p
    ON ms.membership_id = p.membership_id

LEFT JOIN Trainer_Assignments ta
    ON m.member_id = ta.member_id

LEFT JOIN Staff s
    ON ta.trainer_id = s.staff_id

GROUP BY
    m.member_id,
    m.first_name,
    m.last_name,
    m.phone,
    m.email,
    mp.plan_name,
    ms.start_date,
    ms.end_date,
    ms.status,
    s.first_name,
    s.last_name,
    ta.goal;