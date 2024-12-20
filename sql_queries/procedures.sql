DELIMITER $$

CREATE PROCEDURE SetTempTableAutoIncrement()
BEGIN
    SET @last_id = (SELECT MAX(record_id) FROM DrugAbuseRecords);
    SET @next_id = COALESCE(@last_id + 1, 1);
    SET @query = CONCAT('ALTER TABLE TempTable AUTO_INCREMENT = ', @next_id);

    -- Execute the dynamic query
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;
