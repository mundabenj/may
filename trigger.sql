
-- add trigger to update user_points after inserting into user_skills
DROP TRIGGER IF EXISTS `trg_after_user_skill_insert`;
DELIMITER $$
CREATE TRIGGER `trg_after_user_skill_insert` AFTER INSERT ON `user_skills` FOR EACH ROW BEGIN
    DECLARE total_points DOUBLE;
    SELECT SUM(s.points) INTO total_points
    FROM user_skills us
    JOIN skills s ON us.skillId = s.skillId
    WHERE us.userId = NEW.userId;
    UPDATE user_points SET points = total_points WHERE userId = NEW.userId;
END
$$
DELIMITER ;

--
-- Triggers `users`
--
DROP TRIGGER IF EXISTS `trg_after_user_insert`;
DELIMITER $$
CREATE TRIGGER `trg_after_user_insert` AFTER INSERT ON `users` FOR EACH ROW BEGIN
    INSERT INTO user_points (userId, points) VALUES (NEW.userId, 0.00);
END
$$
DELIMITER ;



--
-- Triggers `users`
--
DROP TRIGGER IF EXISTS `trg_after_user_insert`;
DELIMITER $$
CREATE TRIGGER `trg_after_user_insert` AFTER INSERT ON `users` FOR EACH ROW BEGIN
    INSERT INTO user_points (userId, points) VALUES (NEW.userId, 0.00);
END
$$
DELIMITER ;



--
-- Triggers `user_skills`
--
DROP TRIGGER IF EXISTS `trg_after_user_skill_insert`;
DELIMITER $$
CREATE TRIGGER `trg_after_user_skill_insert` AFTER INSERT ON `user_skills` FOR EACH ROW BEGIN
    DECLARE total_points DOUBLE;
    SELECT SUM(s.points) INTO total_points
    FROM user_skills us
    JOIN skills s ON us.skillId = s.skillId
    WHERE us.userId = NEW.userId;
    UPDATE user_points SET points = total_points WHERE userId = NEW.userId;
END
$$
DELIMITER ;
