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