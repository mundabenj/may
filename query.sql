queries
-- Query to select all columns from the 'users' table
SELECT distinct(u.userId), u.fullname, u.email, up.points, r.role, g.gender, GROUP_CONCAT(s.skill SEPARATOR ', ') AS skills, SUM(s.points) AS sum_skill_points
FROM users u
LEFT JOIN roles r USING(roleId)
LEFT JOIN gender g USING(genderId)
LEFT JOIN user_skills us USING(userId)
LEFT JOIN user_points up USING(userId)
LEFT JOIN skills s USING(skillId)
GROUP BY us.userId
HAVING COUNT(us.userId) > 1
ORDER BY u.fullname;

-- Query to select users with more than 50 total skill points
SELECT distinct(u.userId), u.fullname, u.email, up.points, r.role, g.gender, GROUP_CONCAT(s.skill SEPARATOR ', ') AS skills, SUM(s.points) AS sum_skill_points
FROM users u
LEFT JOIN roles r USING(roleId)
LEFT JOIN gender g USING(genderId)
LEFT JOIN user_skills us USING(userId)
LEFT JOIN user_points up USING(userId)
LEFT JOIN skills s USING(skillId)
GROUP BY us.userId
HAVING SUM(s.points) > 50
ORDER BY u.fullname;

-- Query to select users with the 'admin' role
SELECT distinct(u.userId), u.fullname, u.email, up.points, r.role, g.gender, GROUP_CONCAT(s.skill SEPARATOR ', ') AS skills, SUM(s.points) AS sum_skill_points
FROM users u
LEFT JOIN roles r USING(roleId)
LEFT JOIN gender g USING(genderId)
LEFT JOIN user_skills us USING(userId)
LEFT JOIN user_points up USING(userId)
LEFT JOIN skills s USING(skillId)
WHERE r.role = 'admin'
GROUP BY us.userId
ORDER BY u.fullname;

-- Query to select users with 'Python' skill
SELECT distinct(u.userId), u.fullname, u.email, up.points, r.role, g.gender, GROUP_CONCAT(s.skill SEPARATOR ', ') AS skills, SUM(s.points) AS sum_skill_points
FROM users u
LEFT JOIN roles r USING(roleId)
LEFT JOIN gender g USING(genderId)
LEFT JOIN user_skills us USING(userId)
LEFT JOIN user_points up USING(userId)
LEFT JOIN skills s USING(skillId)
WHERE s.skill = 'Python'
GROUP BY us.userId
ORDER BY u.fullname;

-- Query to select users ordered by their total skill points in descending order
SELECT distinct(u.userId), u.fullname, u.email, up.points, r.role, g.gender, GROUP_CONCAT(s.skill SEPARATOR ', ') AS skills, SUM(s.points) AS sum_skill_points
FROM users u
LEFT JOIN roles r USING(roleId)
LEFT JOIN gender g USING(genderId)
LEFT JOIN user_skills us USING(userId)
LEFT JOIN user_points up USING(userId)
LEFT JOIN skills s USING(skillId)
GROUP BY us.userId
ORDER BY sum_skill_points DESC;

-- Query to select users with no skills assigned
SELECT distinct(u.userId), u.fullname, u.email, up.points, r.role, g.gender, GROUP_CONCAT(s.skill SEPARATOR ', ') AS skills, SUM(s.points) AS sum_skill_points
FROM users u
LEFT JOIN roles r USING(roleId)
LEFT JOIN gender g USING(genderId)
LEFT JOIN user_skills us USING(userId)
LEFT JOIN user_points up USING(userId)
LEFT JOIN skills s USING(skillId)
GROUP BY us.userId
HAVING COUNT(s.skillId) = 0;

-- Query to select users with 'viewer' role and more than 20 total skill points
SELECT distinct(u.userId), u.fullname, u.email, up.points, r.role, g.gender, GROUP_CONCAT(s.skill SEPARATOR ', ') AS skills, SUM(s.points) AS sum_skill_points
FROM users u
LEFT JOIN roles r USING(roleId)
LEFT JOIN gender g USING(genderId)
LEFT JOIN user_skills us USING(userId)
LEFT JOIN user_points up USING(userId)
LEFT JOIN skills s USING(skillId)
WHERE r.role = 'viewer'
AND SUM(s.points) > 20
GROUP BY us.userId
ORDER BY u.fullname;

-- Create an index on the 'email' column in the 'users' table to improve query performance
CREATE INDEX idx_email ON users(email);

-- Create an index on the 'skill' column in the 'skills' table to improve query performance
CREATE INDEX idx_skill ON skills(skill);

-- Create view to simplify user skill queries
CREATE OR REPLACE VIEW user_skill_summary AS
SELECT distinct(u.userId), u.fullname, u.email, up.points, r.role, g.gender, GROUP_CONCAT(s.skill SEPARATOR ', ') AS skills, SUM(s.points) AS sum_skill_points
FROM users u
LEFT JOIN roles r USING(roleId)
LEFT JOIN gender g USING(genderId)
LEFT JOIN user_skills us USING(userId)
LEFT JOIN user_points up USING(userId)
LEFT JOIN skills s USING(skillId)
GROUP BY us.userId;

-- Query to select all users from the user_skill_summary view
SELECT * FROM user_skill_summary;

-- Query to select users from the user_skill_summary view with more than 30 total skill points
SELECT * FROM user_skill_summary
WHERE sum_skill_points > 30;

-- Query to select users from the user_skill_summary view with 'instructor' role
SELECT * FROM user_skill_summary
WHERE role = 'instructor';

-- Query to select users from the user_skill_summary view with 'JavaScript' skill
SELECT * FROM user_skill_summary
WHERE FIND_IN_SET('JavaScript', skills) > 0;

-- Query to select users from the user_skill_summary view ordered by total skill points in descending order
SELECT * FROM user_skill_summary
ORDER BY sum_skill_points DESC;