use may;

DELIMITER $$

DROP FUNCTION IF EXISTS CalculateUserTotalPoints;

CREATE FUNCTION CalculateUserTotalPoints (p_userId BIGINT(11))
RETURNS DOUBLE(8, 2)
READS SQL DATA
BEGIN
    DECLARE total_points DOUBLE(8, 2);

    -- Sum the points from the 'skills' table for all skills linked to the user via 'user_skills'
    SELECT SUM(s.points)
    INTO total_points
    FROM user_skills us  -- References the user_skills table [2]
    JOIN skills s USING(skillId) -- Joins to skills table [3]
    WHERE us.userId = p_userId;

    -- Return 0.00 if the user has no skills (SUM returns NULL in this case), otherwise return the calculated total
    RETURN COALESCE(total_points, 0.00);

END $$

DELIMITER ;

-- 1. Skill Aggregator (String Formatting)

DROP FUNCTION IF EXISTS get_user_skill_names;

DELIMITER $$
CREATE FUNCTION get_user_skill_names(input_userId BIGINT) 
RETURNS TEXT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE skill_list TEXT;
    
    SELECT GROUP_CONCAT(s.skill SEPARATOR ', ') 
    INTO skill_list
    FROM user_skills us
    JOIN skills s ON us.skillId = s.skillId
    WHERE us.userId = input_userId;
    
    RETURN IFNULL(skill_list, 'No Skills Assigned');
END$$
DELIMITER ;

-- 2. User Level Labeler (Conditional Logic)

DROP FUNCTION IF EXISTS get_user_level_label;

DELIMITER $$
CREATE FUNCTION get_user_level_label(input_userId BIGINT) 
RETURNS VARCHAR(50)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE current_points DOUBLE(8,2);
    DECLARE level_label VARCHAR(50);
    
    -- Fetch points from the user_points table
    SELECT points INTO current_points 
    FROM user_points 
    WHERE userId = input_userId 
    LIMIT 1;
    
    -- Logic to determine level
    IF current_points IS NULL THEN SET level_label = 'Unranked';
    ELSEIF current_points < 50 THEN SET level_label = 'Novice';
    ELSEIF current_points < 150 THEN SET level_label = 'Intermediate';
    ELSEIF current_points < 500 THEN SET level_label = 'Advanced';
    ELSE SET level_label = 'Expert';
    END IF;
    
    RETURN level_label;
END$$
DELIMITER ;