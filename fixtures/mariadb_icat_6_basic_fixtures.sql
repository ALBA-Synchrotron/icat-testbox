DROP TABLE IF EXISTS `AFFILIATION`;
CREATE TABLE `AFFILIATION`
(
    `ID`                     bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`              varchar(255) NOT NULL,
    `CREATE_TIME`            datetime     NOT NULL,
    `FULLREFERENCE`          varchar(1023) DEFAULT NULL,
    `MOD_ID`                 varchar(255) NOT NULL,
    `MOD_TIME`               datetime     NOT NULL,
    `NAME`                   varchar(255) NOT NULL,
    `PID`                    varchar(255)  DEFAULT NULL,
    `DATAPUBLICATIONUSER_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_AFFILIATION_0` (`DATAPUBLICATIONUSER_ID`,`NAME`),
    CONSTRAINT `FK_AFFILIATION_DATAPUBLICATIONUSER_ID` FOREIGN KEY (`DATAPUBLICATIONUSER_ID`) REFERENCES `DATAPUBLICATIONUSER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `APPLICATION`;
CREATE TABLE `APPLICATION`
(
    `ID`          bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`   varchar(255) NOT NULL,
    `CREATE_TIME` datetime     NOT NULL,
    `MOD_ID`      varchar(255) NOT NULL,
    `MOD_TIME`    datetime     NOT NULL,
    `NAME`        varchar(255) NOT NULL,
    `VERSION`     varchar(255) NOT NULL,
    `FACILITY_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_APPLICATION_0` (`FACILITY_ID`,`NAME`,`VERSION`),
    CONSTRAINT `FK_APPLICATION_FACILITY_ID` FOREIGN KEY (`FACILITY_ID`) REFERENCES `FACILITY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `DATACOLLECTION`;
CREATE TABLE `DATACOLLECTION`
(
    `ID`          bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`   varchar(255) NOT NULL,
    `CREATE_TIME` datetime     NOT NULL,
    `DOI`         varchar(255) DEFAULT NULL,
    `MOD_ID`      varchar(255) NOT NULL,
    `MOD_TIME`    datetime     NOT NULL,
    PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8;
DROP TABLE IF EXISTS `DATACOLLECTIONDATAFILE`;

CREATE TABLE `DATACOLLECTIONDATAFILE`
(
    `ID`                bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`         varchar(255) NOT NULL,
    `CREATE_TIME`       datetime     NOT NULL,
    `MOD_ID`            varchar(255) NOT NULL,
    `MOD_TIME`          datetime     NOT NULL,
    `DATACOLLECTION_ID` bigint(20) NOT NULL,
    `DATAFILE_ID`       bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_DATACOLLECTIONDATAFILE_0` (`DATACOLLECTION_ID`,`DATAFILE_ID`),
    KEY                 `FK_DATACOLLECTIONDATAFILE_DATAFILE_ID` (`DATAFILE_ID`),
    CONSTRAINT `FK_DATACOLLECTIONDATAFILE_DATACOLLECTION_ID` FOREIGN KEY (`DATACOLLECTION_ID`) REFERENCES `DATACOLLECTION` (`ID`),
    CONSTRAINT `FK_DATACOLLECTIONDATAFILE_DATAFILE_ID` FOREIGN KEY (`DATAFILE_ID`) REFERENCES `DATAFILE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `DATACOLLECTIONDATASET`;
CREATE TABLE `DATACOLLECTIONDATASET`
(
    `ID`                bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`         varchar(255) NOT NULL,
    `CREATE_TIME`       datetime     NOT NULL,
    `MOD_ID`            varchar(255) NOT NULL,
    `MOD_TIME`          datetime     NOT NULL,
    `DATACOLLECTION_ID` bigint(20) NOT NULL,
    `DATASET_ID`        bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_DATACOLLECTIONDATASET_0` (`DATACOLLECTION_ID`,`DATASET_ID`),
    KEY                 `FK_DATACOLLECTIONDATASET_DATASET_ID` (`DATASET_ID`),
    CONSTRAINT `FK_DATACOLLECTIONDATASET_DATACOLLECTION_ID` FOREIGN KEY (`DATACOLLECTION_ID`) REFERENCES `DATACOLLECTION` (`ID`),
    CONSTRAINT `FK_DATACOLLECTIONDATASET_DATASET_ID` FOREIGN KEY (`DATASET_ID`) REFERENCES `DATASET` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=142 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `DATACOLLECTIONINVESTIGATION`;
CREATE TABLE `DATACOLLECTIONINVESTIGATION`
(
    `ID`                bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`         varchar(255) NOT NULL,
    `CREATE_TIME`       datetime     NOT NULL,
    `MOD_ID`            varchar(255) NOT NULL,
    `MOD_TIME`          datetime     NOT NULL,
    `DATACOLLECTION_ID` bigint(20) NOT NULL,
    `INVESTIGATION_ID`  bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_DATACOLLECTIONINVESTIGATION_0` (`DATACOLLECTION_ID`,`INVESTIGATION_ID`),
    KEY                 `FK_DATACOLLECTIONINVESTIGATION_INVESTIGATION_ID` (`INVESTIGATION_ID`),
    CONSTRAINT `FK_DATACOLLECTIONINVESTIGATION_DATACOLLECTION_ID` FOREIGN KEY (`DATACOLLECTION_ID`) REFERENCES `DATACOLLECTION` (`ID`),
    CONSTRAINT `FK_DATACOLLECTIONINVESTIGATION_INVESTIGATION_ID` FOREIGN KEY (`INVESTIGATION_ID`) REFERENCES `INVESTIGATION` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `DATACOLLECTIONPARAMETER`;

CREATE TABLE `DATACOLLECTIONPARAMETER`
(
    `ID`                bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`         varchar(255) NOT NULL,
    `CREATE_TIME`       datetime     NOT NULL,
    `DATETIME_VALUE`    datetime      DEFAULT NULL,
    `ERROR` double DEFAULT NULL,
    `MOD_ID`            varchar(255) NOT NULL,
    `MOD_TIME`          datetime     NOT NULL,
    `NUMERIC_VALUE` double DEFAULT NULL,
    `RANGEBOTTOM` double DEFAULT NULL,
    `RANGETOP` double DEFAULT NULL,
    `STRING_VALUE`      varchar(4000) DEFAULT NULL,
    `DATACOLLECTION_ID` bigint(20) NOT NULL,
    `PARAMETER_TYPE_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_DATACOLLECTIONPARAMETER_0` (`DATACOLLECTION_ID`,`PARAMETER_TYPE_ID`),
    KEY                 `FK_DATACOLLECTIONPARAMETER_PARAMETER_TYPE_ID` (`PARAMETER_TYPE_ID`),
    CONSTRAINT `FK_DATACOLLECTIONPARAMETER_DATACOLLECTION_ID` FOREIGN KEY (`DATACOLLECTION_ID`) REFERENCES `DATACOLLECTION` (`ID`),
    CONSTRAINT `FK_DATACOLLECTIONPARAMETER_PARAMETER_TYPE_ID` FOREIGN KEY (`PARAMETER_TYPE_ID`) REFERENCES `PARAMETERTYPE` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=379 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `DATAFILE`;

CREATE TABLE `DATAFILE`
(
    `ID`                 bigint(20) NOT NULL AUTO_INCREMENT,
    `CHECKSUM`           varchar(255) DEFAULT NULL,
    `CREATE_ID`          varchar(255) NOT NULL,
    `CREATE_TIME`        datetime     NOT NULL,
    `DATAFILECREATETIME` datetime     DEFAULT NULL,
    `DATAFILEMODTIME`    datetime     DEFAULT NULL,
    `DESCRIPTION`        varchar(255) DEFAULT NULL,
    `DOI`                varchar(255) DEFAULT NULL,
    `FILESIZE`           bigint(20) DEFAULT NULL,
    `LOCATION`           varchar(255) DEFAULT NULL,
    `MOD_ID`             varchar(255) NOT NULL,
    `MOD_TIME`           datetime     NOT NULL,
    `NAME`               varchar(255) NOT NULL,
    `DATAFILEFORMAT_ID`  bigint(20) DEFAULT NULL,
    `DATASET_ID`         bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_DATAFILE_0` (`DATASET_ID`,`NAME`),
    KEY                  `INDEX_DATAFILE_location` (`LOCATION`),
    KEY                  `FK_DATAFILE_DATAFILEFORMAT_ID` (`DATAFILEFORMAT_ID`),
    CONSTRAINT `FK_DATAFILE_DATAFILEFORMAT_ID` FOREIGN KEY (`DATAFILEFORMAT_ID`) REFERENCES `DATAFILEFORMAT` (`ID`),
    CONSTRAINT `FK_DATAFILE_DATASET_ID` FOREIGN KEY (`DATASET_ID`) REFERENCES `DATASET` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5158004 DEFAULT CHARSET=utf8;

DELIMITER;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER RECALCULATE_ON_DF_INSERT AFTER INSERT ON DATAFILE
FOR EACH ROW
BEGIN
    SET @DELTA = IFNULL(NEW.FILESIZE, 0);
    CALL UPDATE_DS_FILESIZE(NEW.DATASET_ID, @DELTA);
    CALL UPDATE_DS_FILECOUNT(NEW.DATASET_ID, 1);
    SELECT i.ID INTO @INVESTIGATION_ID FROM INVESTIGATION i JOIN DATASET AS ds ON ds.INVESTIGATION_ID = i.ID WHERE ds.ID = NEW.DATASET_ID;
    CALL UPDATE_INV_FILESIZE(@INVESTIGATION_ID, @DELTA);
    CALL UPDATE_INV_FILECOUNT(@INVESTIGATION_ID, 1);
END */;;
DELIMITER;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER RECALCULATE_ON_DF_UPDATE AFTER UPDATE ON DATAFILE
FOR EACH ROW
BEGIN
    IF NEW.DATASET_ID != OLD.DATASET_ID THEN
        SET @DELTA = - IFNULL(OLD.FILESIZE, 0);
        CALL UPDATE_DS_FILESIZE(OLD.DATASET_ID, @DELTA);
        CALL UPDATE_DS_FILECOUNT(OLD.DATASET_ID, -1);
        SELECT i.ID INTO @INVESTIGATION_ID FROM INVESTIGATION i JOIN DATASET AS ds ON ds.INVESTIGATION_ID = i.ID WHERE ds.ID = OLD.DATASET_ID;
        CALL UPDATE_INV_FILESIZE(@INVESTIGATION_ID, @DELTA);
        CALL UPDATE_INV_FILECOUNT(@INVESTIGATION_ID, -1);

        SET @DELTA = IFNULL(NEW.FILESIZE, 0);
        CALL UPDATE_DS_FILESIZE(NEW.DATASET_ID, @DELTA);
        CALL UPDATE_DS_FILECOUNT(NEW.DATASET_ID, 1);
        SELECT i.ID INTO @INVESTIGATION_ID FROM INVESTIGATION i JOIN DATASET AS ds ON ds.INVESTIGATION_ID = i.ID WHERE ds.ID = NEW.DATASET_ID;
        CALL UPDATE_INV_FILESIZE(@INVESTIGATION_ID, @DELTA);
        CALL UPDATE_INV_FILECOUNT(@INVESTIGATION_ID, 1);

    ELSEIF IFNULL(NEW.FILESIZE, 0) != IFNULL(OLD.FILESIZE, 0) THEN
        SET @DELTA = IFNULL(NEW.FILESIZE, 0) - IFNULL(OLD.FILESIZE, 0);
        CALL UPDATE_DS_FILESIZE(NEW.DATASET_ID, @DELTA);
        SELECT i.ID INTO @INVESTIGATION_ID FROM INVESTIGATION i JOIN DATASET AS ds ON ds.INVESTIGATION_ID = i.ID WHERE ds.ID = NEW.DATASET_ID;
        CALL UPDATE_INV_FILESIZE(@INVESTIGATION_ID, @DELTA);
    END IF;
END */;;
DELIMITER;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER RECALCULATE_ON_DF_DELETE AFTER DELETE ON DATAFILE
FOR EACH ROW
BEGIN
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET @INVESTIGATION_ID = NULL;

    SET @DELTA = - IFNULL(OLD.FILESIZE, 0);
    CALL UPDATE_DS_FILESIZE(OLD.DATASET_ID, @DELTA);
    CALL UPDATE_DS_FILECOUNT(OLD.DATASET_ID, -1);
    SELECT i.ID INTO @INVESTIGATION_ID FROM INVESTIGATION i JOIN DATASET AS ds ON ds.INVESTIGATION_ID = i.ID WHERE ds.ID = OLD.DATASET_ID;
    CALL UPDATE_INV_FILESIZE(@INVESTIGATION_ID, @DELTA);
    CALL UPDATE_INV_FILECOUNT(@INVESTIGATION_ID, -1);
END */;;
DELIMITER;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `DATAFILEFORMAT`
--

DROP TABLE IF EXISTS `DATAFILEFORMAT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DATAFILEFORMAT`
(
    `ID`          bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`   varchar(255) NOT NULL,
    `CREATE_TIME` datetime     NOT NULL,
    `DESCRIPTION` varchar(255) DEFAULT NULL,
    `MOD_ID`      varchar(255) NOT NULL,
    `MOD_TIME`    datetime     NOT NULL,
    `NAME`        varchar(255) NOT NULL,
    `TYPE`        varchar(255) DEFAULT NULL,
    `VERSION`     varchar(255) NOT NULL,
    `FACILITY_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_DATAFILEFORMAT_0` (`FACILITY_ID`,`NAME`,`VERSION`),
    CONSTRAINT `FK_DATAFILEFORMAT_FACILITY_ID` FOREIGN KEY (`FACILITY_ID`) REFERENCES `FACILITY` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DATAFILEPARAMETER`
--

DROP TABLE IF EXISTS `DATAFILEPARAMETER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DATAFILEPARAMETER`
(
    `ID`                bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`         varchar(255) NOT NULL,
    `CREATE_TIME`       datetime     NOT NULL,
    `DATETIME_VALUE`    datetime      DEFAULT NULL,
    `ERROR` double DEFAULT NULL,
    `MOD_ID`            varchar(255) NOT NULL,
    `MOD_TIME`          datetime     NOT NULL,
    `NUMERIC_VALUE` double DEFAULT NULL,
    `RANGEBOTTOM` double DEFAULT NULL,
    `RANGETOP` double DEFAULT NULL,
    `STRING_VALUE`      varchar(4000) DEFAULT NULL,
    `DATAFILE_ID`       bigint(20) NOT NULL,
    `PARAMETER_TYPE_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_DATAFILEPARAMETER_0` (`DATAFILE_ID`,`PARAMETER_TYPE_ID`),
    KEY                 `FK_DATAFILEPARAMETER_PARAMETER_TYPE_ID` (`PARAMETER_TYPE_ID`),
    CONSTRAINT `FK_DATAFILEPARAMETER_DATAFILE_ID` FOREIGN KEY (`DATAFILE_ID`) REFERENCES `DATAFILE` (`ID`),
    CONSTRAINT `FK_DATAFILEPARAMETER_PARAMETER_TYPE_ID` FOREIGN KEY (`PARAMETER_TYPE_ID`) REFERENCES `PARAMETERTYPE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DATAPUBLICATION`
--

DROP TABLE IF EXISTS `DATAPUBLICATION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DATAPUBLICATION`
(
    `ID`                     bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`              varchar(255) NOT NULL,
    `CREATE_TIME`            datetime     NOT NULL,
    `DESCRIPTION`            varchar(4000) DEFAULT NULL,
    `MOD_ID`                 varchar(255) NOT NULL,
    `MOD_TIME`               datetime     NOT NULL,
    `PID`                    varchar(255) NOT NULL,
    `PUBLICATIONDATE`        datetime      DEFAULT NULL,
    `SUBJECT`                varchar(1023) DEFAULT NULL,
    `TITLE`                  varchar(255) NOT NULL,
    `DATACOLLECTION_ID`      bigint(20) NOT NULL,
    `FACILITY_ID`            bigint(20) NOT NULL,
    `DATAPUBLICATIONTYPE_ID` bigint(20) DEFAULT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_DATAPUBLICATION_0` (`FACILITY_ID`,`PID`),
    KEY                      `FK_DATAPUBLICATION_DATACOLLECTION_ID` (`DATACOLLECTION_ID`),
    KEY                      `FK_DATAPUBLICATION_DATAPUBLICATIONTYPE_ID` (`DATAPUBLICATIONTYPE_ID`),
    CONSTRAINT `FK_DATAPUBLICATION_DATACOLLECTION_ID` FOREIGN KEY (`DATACOLLECTION_ID`) REFERENCES `DATACOLLECTION` (`ID`),
    CONSTRAINT `FK_DATAPUBLICATION_DATAPUBLICATIONTYPE_ID` FOREIGN KEY (`DATAPUBLICATIONTYPE_ID`) REFERENCES `DATAPUBLICATIONTYPE` (`ID`),
    CONSTRAINT `FK_DATAPUBLICATION_FACILITY_ID` FOREIGN KEY (`FACILITY_ID`) REFERENCES `FACILITY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DATAPUBLICATIONDATE`
--

DROP TABLE IF EXISTS `DATAPUBLICATIONDATE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DATAPUBLICATIONDATE`
(
    `ID`                 bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`          varchar(255) NOT NULL,
    `CREATE_TIME`        datetime     NOT NULL,
    `DATE_`              varchar(255) NOT NULL,
    `DATETYPE`           varchar(255) NOT NULL,
    `MOD_ID`             varchar(255) NOT NULL,
    `MOD_TIME`           datetime     NOT NULL,
    `DATAPUBLICATION_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_DATAPUBLICATIONDATE_0` (`DATAPUBLICATION_ID`,`DATETYPE`),
    CONSTRAINT `FK_DATAPUBLICATIONDATE_DATAPUBLICATION_ID` FOREIGN KEY (`DATAPUBLICATION_ID`) REFERENCES `DATAPUBLICATION` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DATAPUBLICATIONFUNDING`
--

DROP TABLE IF EXISTS `DATAPUBLICATIONFUNDING`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DATAPUBLICATIONFUNDING`
(
    `ID`                 bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`          varchar(255) NOT NULL,
    `CREATE_TIME`        datetime     NOT NULL,
    `MOD_ID`             varchar(255) NOT NULL,
    `MOD_TIME`           datetime     NOT NULL,
    `DATAPUBLICATION_ID` bigint(20) NOT NULL,
    `FUNDING_ID`         bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_DATAPUBLICATIONFUNDING_0` (`DATAPUBLICATION_ID`,`FUNDING_ID`),
    KEY                  `FK_DATAPUBLICATIONFUNDING_FUNDING_ID` (`FUNDING_ID`),
    CONSTRAINT `FK_DATAPUBLICATIONFUNDING_DATAPUBLICATION_ID` FOREIGN KEY (`DATAPUBLICATION_ID`) REFERENCES `DATAPUBLICATION` (`ID`),
    CONSTRAINT `FK_DATAPUBLICATIONFUNDING_FUNDING_ID` FOREIGN KEY (`FUNDING_ID`) REFERENCES `FUNDINGREFERENCE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DATAPUBLICATIONTYPE`
--

DROP TABLE IF EXISTS `DATAPUBLICATIONTYPE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DATAPUBLICATIONTYPE`
(
    `ID`          bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`   varchar(255) NOT NULL,
    `CREATE_TIME` datetime     NOT NULL,
    `DESCRIPTION` varchar(255) DEFAULT NULL,
    `MOD_ID`      varchar(255) NOT NULL,
    `MOD_TIME`    datetime     NOT NULL,
    `NAME`        varchar(255) NOT NULL,
    `FACILITY_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_DATAPUBLICATIONTYPE_0` (`FACILITY_ID`,`NAME`),
    CONSTRAINT `FK_DATAPUBLICATIONTYPE_FACILITY_ID` FOREIGN KEY (`FACILITY_ID`) REFERENCES `FACILITY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DATAPUBLICATIONUSER`
--

DROP TABLE IF EXISTS `DATAPUBLICATIONUSER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DATAPUBLICATIONUSER`
(
    `ID`                 bigint(20) NOT NULL AUTO_INCREMENT,
    `CONTRIBUTORTYPE`    varchar(255) NOT NULL,
    `CREATE_ID`          varchar(255) NOT NULL,
    `CREATE_TIME`        datetime     NOT NULL,
    `EMAIL`              varchar(255) DEFAULT NULL,
    `FAMILYNAME`         varchar(255) DEFAULT NULL,
    `FULLNAME`           varchar(255) DEFAULT NULL,
    `GIVENNAME`          varchar(255) DEFAULT NULL,
    `MOD_ID`             varchar(255) NOT NULL,
    `MOD_TIME`           datetime     NOT NULL,
    `ORDERKEY`           varchar(255) DEFAULT NULL,
    `DATAPUBLICATION_ID` bigint(20) NOT NULL,
    `USER_ID`            bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_DATAPUBLICATIONUSER_0` (`DATAPUBLICATION_ID`,`USER_ID`,`CONTRIBUTORTYPE`),
    KEY                  `FK_DATAPUBLICATIONUSER_USER_ID` (`USER_ID`),
    CONSTRAINT `FK_DATAPUBLICATIONUSER_DATAPUBLICATION_ID` FOREIGN KEY (`DATAPUBLICATION_ID`) REFERENCES `DATAPUBLICATION` (`ID`),
    CONSTRAINT `FK_DATAPUBLICATIONUSER_USER_ID` FOREIGN KEY (`USER_ID`) REFERENCES `USER_` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DATASET`
--

DROP TABLE IF EXISTS `DATASET`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DATASET`
(
    `ID`               bigint(20) NOT NULL AUTO_INCREMENT,
    `COMPLETE`         tinyint(1) NOT NULL DEFAULT 0,
    `CREATE_ID`        varchar(255) NOT NULL,
    `CREATE_TIME`      datetime     NOT NULL,
    `DESCRIPTION`      varchar(255) DEFAULT NULL,
    `DOI`              varchar(255) DEFAULT NULL,
    `END_DATE`         datetime     DEFAULT NULL,
    `LOCATION`         varchar(255) DEFAULT NULL,
    `MOD_ID`           varchar(255) NOT NULL,
    `MOD_TIME`         datetime     NOT NULL,
    `NAME`             varchar(255) NOT NULL,
    `STARTDATE`        datetime     DEFAULT NULL,
    `INVESTIGATION_ID` bigint(20) NOT NULL,
    `SAMPLE_ID`        bigint(20) DEFAULT NULL,
    `TYPE_ID`          bigint(20) NOT NULL,
    `FILECOUNT`        bigint(20) DEFAULT NULL,
    `FILESIZE`         bigint(20) DEFAULT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_DATASET_0` (`INVESTIGATION_ID`,`NAME`),
    KEY                `FK_DATASET_SAMPLE_ID` (`SAMPLE_ID`),
    KEY                `FK_DATASET_TYPE_ID` (`TYPE_ID`),
    CONSTRAINT `FK_DATASET_INVESTIGATION_ID` FOREIGN KEY (`INVESTIGATION_ID`) REFERENCES `INVESTIGATION` (`ID`),
    CONSTRAINT `FK_DATASET_SAMPLE_ID` FOREIGN KEY (`SAMPLE_ID`) REFERENCES `SAMPLE` (`ID`),
    CONSTRAINT `FK_DATASET_TYPE_ID` FOREIGN KEY (`TYPE_ID`) REFERENCES `DATASETTYPE` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=25229 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER RECALCULATE_ON_DS_UPDATE AFTER UPDATE ON DATASET
FOR EACH ROW
BEGIN
    IF NEW.INVESTIGATION_ID != OLD.INVESTIGATION_ID THEN
        SET @SIZE_DELTA = - IFNULL(OLD.FILESIZE, 0);
        SET @COUNT_DELTA = - IFNULL(OLD.FILECOUNT, 0);
        CALL UPDATE_INV_FILESIZE(OLD.INVESTIGATION_ID, @SIZE_DELTA);
        CALL UPDATE_INV_FILECOUNT(OLD.INVESTIGATION_ID, @COUNT_DELTA);

        SET @SIZE_DELTA = IFNULL(NEW.FILESIZE, 0);
        SET @COUNT_DELTA = IFNULL(NEW.FILECOUNT, 0);
        CALL UPDATE_INV_FILESIZE(NEW.INVESTIGATION_ID, @SIZE_DELTA);
        CALL UPDATE_INV_FILECOUNT(NEW.INVESTIGATION_ID, @COUNT_DELTA);
    END IF;
END */;;
DELIMITER;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER RECALCULATE_ON_DS_DELETE AFTER DELETE ON DATASET
FOR EACH ROW
BEGIN
    SET @SIZE_DELTA = - IFNULL(OLD.FILESIZE, 0);
    SET @COUNT_DELTA = - IFNULL(OLD.FILECOUNT, 0);
    CALL UPDATE_INV_FILESIZE(OLD.INVESTIGATION_ID, @SIZE_DELTA);
    CALL UPDATE_INV_FILECOUNT(OLD.INVESTIGATION_ID, @COUNT_DELTA);
END */;;
DELIMITER;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `DATASETINSTRUMENT`
--

DROP TABLE IF EXISTS `DATASETINSTRUMENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DATASETINSTRUMENT`
(
    `ID`            bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`     varchar(255) NOT NULL,
    `CREATE_TIME`   datetime     NOT NULL,
    `MOD_ID`        varchar(255) NOT NULL,
    `MOD_TIME`      datetime     NOT NULL,
    `DATASET_ID`    bigint(20) NOT NULL,
    `INSTRUMENT_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_DATASETINSTRUMENT_0` (`DATASET_ID`,`INSTRUMENT_ID`),
    KEY             `FK_DATASETINSTRUMENT_INSTRUMENT_ID` (`INSTRUMENT_ID`),
    CONSTRAINT `FK_DATASETINSTRUMENT_DATASET_ID` FOREIGN KEY (`DATASET_ID`) REFERENCES `DATASET` (`ID`),
    CONSTRAINT `FK_DATASETINSTRUMENT_INSTRUMENT_ID` FOREIGN KEY (`INSTRUMENT_ID`) REFERENCES `INSTRUMENT` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DATASETPARAMETER`
--

DROP TABLE IF EXISTS `DATASETPARAMETER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DATASETPARAMETER`
(
    `ID`                bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`         varchar(255) NOT NULL,
    `CREATE_TIME`       datetime     NOT NULL,
    `DATETIME_VALUE`    datetime      DEFAULT NULL,
    `ERROR` double DEFAULT NULL,
    `MOD_ID`            varchar(255) NOT NULL,
    `MOD_TIME`          datetime     NOT NULL,
    `NUMERIC_VALUE` double DEFAULT NULL,
    `RANGEBOTTOM` double DEFAULT NULL,
    `RANGETOP` double DEFAULT NULL,
    `STRING_VALUE`      varchar(4000) DEFAULT NULL,
    `DATASET_ID`        bigint(20) NOT NULL,
    `PARAMETER_TYPE_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_DATASETPARAMETER_0` (`DATASET_ID`,`PARAMETER_TYPE_ID`),
    KEY                 `FK_DATASETPARAMETER_PARAMETER_TYPE_ID` (`PARAMETER_TYPE_ID`),
    CONSTRAINT `FK_DATASETPARAMETER_DATASET_ID` FOREIGN KEY (`DATASET_ID`) REFERENCES `DATASET` (`ID`),
    CONSTRAINT `FK_DATASETPARAMETER_PARAMETER_TYPE_ID` FOREIGN KEY (`PARAMETER_TYPE_ID`) REFERENCES `PARAMETERTYPE` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=365482 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DATASETTECHNIQUE`
--

DROP TABLE IF EXISTS `DATASETTECHNIQUE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DATASETTECHNIQUE`
(
    `ID`           bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`    varchar(255) NOT NULL,
    `CREATE_TIME`  datetime     NOT NULL,
    `MOD_ID`       varchar(255) NOT NULL,
    `MOD_TIME`     datetime     NOT NULL,
    `DATASET_ID`   bigint(20) NOT NULL,
    `TECHNIQUE_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_DATASETTECHNIQUE_0` (`DATASET_ID`,`TECHNIQUE_ID`),
    KEY            `FK_DATASETTECHNIQUE_TECHNIQUE_ID` (`TECHNIQUE_ID`),
    CONSTRAINT `FK_DATASETTECHNIQUE_DATASET_ID` FOREIGN KEY (`DATASET_ID`) REFERENCES `DATASET` (`ID`),
    CONSTRAINT `FK_DATASETTECHNIQUE_TECHNIQUE_ID` FOREIGN KEY (`TECHNIQUE_ID`) REFERENCES `TECHNIQUE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DATASETTYPE`
--

DROP TABLE IF EXISTS `DATASETTYPE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DATASETTYPE`
(
    `ID`          bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`   varchar(255) NOT NULL,
    `CREATE_TIME` datetime     NOT NULL,
    `DESCRIPTION` varchar(255) DEFAULT NULL,
    `MOD_ID`      varchar(255) NOT NULL,
    `MOD_TIME`    datetime     NOT NULL,
    `NAME`        varchar(255) NOT NULL,
    `FACILITY_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_DATASETTYPE_0` (`FACILITY_ID`,`NAME`),
    CONSTRAINT `FK_DATASETTYPE_FACILITY_ID` FOREIGN KEY (`FACILITY_ID`) REFERENCES `FACILITY` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `FACILITY`
--

DROP TABLE IF EXISTS `FACILITY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FACILITY`
(
    `ID`               bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`        varchar(255) NOT NULL,
    `CREATE_TIME`      datetime     NOT NULL,
    `DAYSUNTILRELEASE` int(11) DEFAULT NULL,
    `DESCRIPTION`      varchar(1023) DEFAULT NULL,
    `FULLNAME`         varchar(255)  DEFAULT NULL,
    `MOD_ID`           varchar(255) NOT NULL,
    `MOD_TIME`         datetime     NOT NULL,
    `NAME`             varchar(255) NOT NULL,
    `URL`              varchar(255)  DEFAULT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_FACILITY_0` (`NAME`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `FACILITYCYCLE`
--

DROP TABLE IF EXISTS `FACILITYCYCLE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FACILITYCYCLE`
(
    `ID`          bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`   varchar(255) NOT NULL,
    `CREATE_TIME` datetime     NOT NULL,
    `DESCRIPTION` varchar(255) DEFAULT NULL,
    `ENDDATE`     datetime     DEFAULT NULL,
    `MOD_ID`      varchar(255) NOT NULL,
    `MOD_TIME`    datetime     NOT NULL,
    `NAME`        varchar(255) NOT NULL,
    `STARTDATE`   datetime     DEFAULT NULL,
    `FACILITY_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_FACILITYCYCLE_0` (`FACILITY_ID`,`NAME`),
    CONSTRAINT `FK_FACILITYCYCLE_FACILITY_ID` FOREIGN KEY (`FACILITY_ID`) REFERENCES `FACILITY` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `FUNDINGREFERENCE`
--

DROP TABLE IF EXISTS `FUNDINGREFERENCE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FUNDINGREFERENCE`
(
    `ID`               bigint(20) NOT NULL AUTO_INCREMENT,
    `AWARDNUMBER`      varchar(255) NOT NULL,
    `AWARDTITLE`       varchar(255) DEFAULT NULL,
    `CREATE_ID`        varchar(255) NOT NULL,
    `CREATE_TIME`      datetime     NOT NULL,
    `FUNDERIDENTIFIER` varchar(255) DEFAULT NULL,
    `FUNDERNAME`       varchar(255) NOT NULL,
    `MOD_ID`           varchar(255) NOT NULL,
    `MOD_TIME`         datetime     NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_FUNDINGREFERENCE_0` (`FUNDERNAME`,`AWARDNUMBER`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `GROUPING`
--

DROP TABLE IF EXISTS `GROUPING`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GROUPING`
(
    `ID`          bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`   varchar(255) NOT NULL,
    `CREATE_TIME` datetime     NOT NULL,
    `MOD_ID`      varchar(255) NOT NULL,
    `MOD_TIME`    datetime     NOT NULL,
    `NAME`        varchar(255) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_GROUPING_0` (`NAME`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `INSTRUMENT`
--

DROP TABLE IF EXISTS `INSTRUMENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `INSTRUMENT`
(
    `ID`          bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`   varchar(255) NOT NULL,
    `CREATE_TIME` datetime     NOT NULL,
    `DESCRIPTION` varchar(4000) DEFAULT NULL,
    `FULLNAME`    varchar(255)  DEFAULT NULL,
    `MOD_ID`      varchar(255) NOT NULL,
    `MOD_TIME`    datetime     NOT NULL,
    `NAME`        varchar(255) NOT NULL,
    `TYPE`        varchar(255)  DEFAULT NULL,
    `URL`         varchar(255)  DEFAULT NULL,
    `FACILITY_ID` bigint(20) NOT NULL,
    `PID`         varchar(255)  DEFAULT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_INSTRUMENT_0` (`FACILITY_ID`,`NAME`),
    CONSTRAINT `FK_INSTRUMENT_FACILITY_ID` FOREIGN KEY (`FACILITY_ID`) REFERENCES `FACILITY` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `INSTRUMENTSCIENTIST`
--

DROP TABLE IF EXISTS `INSTRUMENTSCIENTIST`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `INSTRUMENTSCIENTIST`
(
    `ID`            bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`     varchar(255) NOT NULL,
    `CREATE_TIME`   datetime     NOT NULL,
    `MOD_ID`        varchar(255) NOT NULL,
    `MOD_TIME`      datetime     NOT NULL,
    `INSTRUMENT_ID` bigint(20) NOT NULL,
    `USER_ID`       bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_INSTRUMENTSCIENTIST_0` (`USER_ID`,`INSTRUMENT_ID`),
    KEY             `FK_INSTRUMENTSCIENTIST_INSTRUMENT_ID` (`INSTRUMENT_ID`),
    CONSTRAINT `FK_INSTRUMENTSCIENTIST_INSTRUMENT_ID` FOREIGN KEY (`INSTRUMENT_ID`) REFERENCES `INSTRUMENT` (`ID`),
    CONSTRAINT `FK_INSTRUMENTSCIENTIST_USER_ID` FOREIGN KEY (`USER_ID`) REFERENCES `USER_` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `INVESTIGATION`
--

DROP TABLE IF EXISTS `INVESTIGATION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `INVESTIGATION`
(
    `ID`          bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`   varchar(255) NOT NULL,
    `CREATE_TIME` datetime     NOT NULL,
    `DOI`         varchar(255)  DEFAULT NULL,
    `ENDDATE`     datetime      DEFAULT NULL,
    `MOD_ID`      varchar(255) NOT NULL,
    `MOD_TIME`    datetime     NOT NULL,
    `NAME`        varchar(255) NOT NULL,
    `RELEASEDATE` datetime      DEFAULT NULL,
    `STARTDATE`   datetime      DEFAULT NULL,
    `SUMMARY`     varchar(4000) DEFAULT NULL,
    `TITLE`       varchar(255) NOT NULL,
    `VISIT_ID`    varchar(255) NOT NULL,
    `FACILITY_ID` bigint(20) NOT NULL,
    `TYPE_ID`     bigint(20) NOT NULL,
    `FILECOUNT`   bigint(20) DEFAULT NULL,
    `FILESIZE`    bigint(20) DEFAULT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_INVESTIGATION_0` (`FACILITY_ID`,`NAME`,`VISIT_ID`),
    KEY           `FK_INVESTIGATION_TYPE_ID` (`TYPE_ID`),
    CONSTRAINT `FK_INVESTIGATION_FACILITY_ID` FOREIGN KEY (`FACILITY_ID`) REFERENCES `FACILITY` (`ID`),
    CONSTRAINT `FK_INVESTIGATION_TYPE_ID` FOREIGN KEY (`TYPE_ID`) REFERENCES `INVESTIGATIONTYPE` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3658 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `INVESTIGATIONFACILITYCYCLE`
--

DROP TABLE IF EXISTS `INVESTIGATIONFACILITYCYCLE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `INVESTIGATIONFACILITYCYCLE`
(
    `ID`               bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`        varchar(255) NOT NULL,
    `CREATE_TIME`      datetime     NOT NULL,
    `MOD_ID`           varchar(255) NOT NULL,
    `MOD_TIME`         datetime     NOT NULL,
    `FACILITYCYCLE_ID` bigint(20) NOT NULL,
    `INVESTIGATION_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_INVESTIGATIONFACILITYCYCLE_0` (`FACILITYCYCLE_ID`,`INVESTIGATION_ID`),
    KEY                `FK_INVESTIGATIONFACILITYCYCLE_INVESTIGATION_ID` (`INVESTIGATION_ID`),
    CONSTRAINT `FK_INVESTIGATIONFACILITYCYCLE_FACILITYCYCLE_ID` FOREIGN KEY (`FACILITYCYCLE_ID`) REFERENCES `FACILITYCYCLE` (`ID`),
    CONSTRAINT `FK_INVESTIGATIONFACILITYCYCLE_INVESTIGATION_ID` FOREIGN KEY (`INVESTIGATION_ID`) REFERENCES `INVESTIGATION` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `INVESTIGATIONFUNDING`
--

DROP TABLE IF EXISTS `INVESTIGATIONFUNDING`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `INVESTIGATIONFUNDING`
(
    `ID`               bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`        varchar(255) NOT NULL,
    `CREATE_TIME`      datetime     NOT NULL,
    `MOD_ID`           varchar(255) NOT NULL,
    `MOD_TIME`         datetime     NOT NULL,
    `FUNDING_ID`       bigint(20) NOT NULL,
    `INVESTIGATION_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_INVESTIGATIONFUNDING_0` (`INVESTIGATION_ID`,`FUNDING_ID`),
    KEY                `FK_INVESTIGATIONFUNDING_FUNDING_ID` (`FUNDING_ID`),
    CONSTRAINT `FK_INVESTIGATIONFUNDING_FUNDING_ID` FOREIGN KEY (`FUNDING_ID`) REFERENCES `FUNDINGREFERENCE` (`ID`),
    CONSTRAINT `FK_INVESTIGATIONFUNDING_INVESTIGATION_ID` FOREIGN KEY (`INVESTIGATION_ID`) REFERENCES `INVESTIGATION` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `INVESTIGATIONGROUP`
--

DROP TABLE IF EXISTS `INVESTIGATIONGROUP`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `INVESTIGATIONGROUP`
(
    `ID`               bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`        varchar(255) NOT NULL,
    `CREATE_TIME`      datetime     NOT NULL,
    `MOD_ID`           varchar(255) NOT NULL,
    `MOD_TIME`         datetime     NOT NULL,
    `ROLE`             varchar(255) NOT NULL,
    `GROUP_ID`         bigint(20) NOT NULL,
    `INVESTIGATION_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_INVESTIGATIONGROUP_0` (`GROUP_ID`,`INVESTIGATION_ID`,`ROLE`),
    KEY                `FK_INVESTIGATIONGROUP_INVESTIGATION_ID` (`INVESTIGATION_ID`),
    CONSTRAINT `FK_INVESTIGATIONGROUP_GROUP_ID` FOREIGN KEY (`GROUP_ID`) REFERENCES `GROUPING` (`ID`),
    CONSTRAINT `FK_INVESTIGATIONGROUP_INVESTIGATION_ID` FOREIGN KEY (`INVESTIGATION_ID`) REFERENCES `INVESTIGATION` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `INVESTIGATIONINSTRUMENT`
--

DROP TABLE IF EXISTS `INVESTIGATIONINSTRUMENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `INVESTIGATIONINSTRUMENT`
(
    `ID`               bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`        varchar(255) NOT NULL,
    `CREATE_TIME`      datetime     NOT NULL,
    `MOD_ID`           varchar(255) NOT NULL,
    `MOD_TIME`         datetime     NOT NULL,
    `INSTRUMENT_ID`    bigint(20) NOT NULL,
    `INVESTIGATION_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_INVESTIGATIONINSTRUMENT_0` (`INVESTIGATION_ID`,`INSTRUMENT_ID`),
    KEY                `FK_INVESTIGATIONINSTRUMENT_INSTRUMENT_ID` (`INSTRUMENT_ID`),
    CONSTRAINT `FK_INVESTIGATIONINSTRUMENT_INSTRUMENT_ID` FOREIGN KEY (`INSTRUMENT_ID`) REFERENCES `INSTRUMENT` (`ID`),
    CONSTRAINT `FK_INVESTIGATIONINSTRUMENT_INVESTIGATION_ID` FOREIGN KEY (`INVESTIGATION_ID`) REFERENCES `INVESTIGATION` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6335 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `INVESTIGATIONPARAMETER`
--

DROP TABLE IF EXISTS `INVESTIGATIONPARAMETER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `INVESTIGATIONPARAMETER`
(
    `ID`                bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`         varchar(255) NOT NULL,
    `CREATE_TIME`       datetime     NOT NULL,
    `DATETIME_VALUE`    datetime      DEFAULT NULL,
    `ERROR` double DEFAULT NULL,
    `MOD_ID`            varchar(255) NOT NULL,
    `MOD_TIME`          datetime     NOT NULL,
    `NUMERIC_VALUE` double DEFAULT NULL,
    `RANGEBOTTOM` double DEFAULT NULL,
    `RANGETOP` double DEFAULT NULL,
    `STRING_VALUE`      varchar(4000) DEFAULT NULL,
    `INVESTIGATION_ID`  bigint(20) NOT NULL,
    `PARAMETER_TYPE_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_INVESTIGATIONPARAMETER_0` (`INVESTIGATION_ID`,`PARAMETER_TYPE_ID`),
    KEY                 `FK_INVESTIGATIONPARAMETER_PARAMETER_TYPE_ID` (`PARAMETER_TYPE_ID`),
    CONSTRAINT `FK_INVESTIGATIONPARAMETER_INVESTIGATION_ID` FOREIGN KEY (`INVESTIGATION_ID`) REFERENCES `INVESTIGATION` (`ID`),
    CONSTRAINT `FK_INVESTIGATIONPARAMETER_PARAMETER_TYPE_ID` FOREIGN KEY (`PARAMETER_TYPE_ID`) REFERENCES `PARAMETERTYPE` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5564 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `INVESTIGATIONTYPE`
--

DROP TABLE IF EXISTS `INVESTIGATIONTYPE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `INVESTIGATIONTYPE`
(
    `ID`          bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`   varchar(255) NOT NULL,
    `CREATE_TIME` datetime     NOT NULL,
    `DESCRIPTION` varchar(255) DEFAULT NULL,
    `MOD_ID`      varchar(255) NOT NULL,
    `MOD_TIME`    datetime     NOT NULL,
    `NAME`        varchar(255) NOT NULL,
    `FACILITY_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_INVESTIGATIONTYPE_0` (`NAME`,`FACILITY_ID`),
    KEY           `FK_INVESTIGATIONTYPE_FACILITY_ID` (`FACILITY_ID`),
    CONSTRAINT `FK_INVESTIGATIONTYPE_FACILITY_ID` FOREIGN KEY (`FACILITY_ID`) REFERENCES `FACILITY` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `INVESTIGATIONUSER`
--

DROP TABLE IF EXISTS `INVESTIGATIONUSER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `INVESTIGATIONUSER`
(
    `ID`               bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`        varchar(255) NOT NULL,
    `CREATE_TIME`      datetime     NOT NULL,
    `MOD_ID`           varchar(255) NOT NULL,
    `MOD_TIME`         datetime     NOT NULL,
    `ROLE`             varchar(255) NOT NULL,
    `INVESTIGATION_ID` bigint(20) NOT NULL,
    `USER_ID`          bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_INVESTIGATIONUSER_0` (`USER_ID`,`INVESTIGATION_ID`,`ROLE`),
    KEY                `FK_INVESTIGATIONUSER_INVESTIGATION_ID` (`INVESTIGATION_ID`),
    CONSTRAINT `FK_INVESTIGATIONUSER_INVESTIGATION_ID` FOREIGN KEY (`INVESTIGATION_ID`) REFERENCES `INVESTIGATION` (`ID`),
    CONSTRAINT `FK_INVESTIGATIONUSER_USER_ID` FOREIGN KEY (`USER_ID`) REFERENCES `USER_` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=13003 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `JOB`
--

DROP TABLE IF EXISTS `JOB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `JOB`
(
    `ID`                      bigint(20) NOT NULL AUTO_INCREMENT,
    `ARGUMENTS`               varchar(255) DEFAULT NULL,
    `CREATE_ID`               varchar(255) NOT NULL,
    `CREATE_TIME`             datetime     NOT NULL,
    `MOD_ID`                  varchar(255) NOT NULL,
    `MOD_TIME`                datetime     NOT NULL,
    `APPLICATION_ID`          bigint(20) NOT NULL,
    `INPUTDATACOLLECTION_ID`  bigint(20) DEFAULT NULL,
    `OUTPUTDATACOLLECTION_ID` bigint(20) DEFAULT NULL,
    PRIMARY KEY (`ID`),
    KEY                       `FK_JOB_OUTPUTDATACOLLECTION_ID` (`OUTPUTDATACOLLECTION_ID`),
    KEY                       `FK_JOB_INPUTDATACOLLECTION_ID` (`INPUTDATACOLLECTION_ID`),
    KEY                       `FK_JOB_APPLICATION_ID` (`APPLICATION_ID`),
    CONSTRAINT `FK_JOB_APPLICATION_ID` FOREIGN KEY (`APPLICATION_ID`) REFERENCES `APPLICATION` (`ID`),
    CONSTRAINT `FK_JOB_INPUTDATACOLLECTION_ID` FOREIGN KEY (`INPUTDATACOLLECTION_ID`) REFERENCES `DATACOLLECTION` (`ID`),
    CONSTRAINT `FK_JOB_OUTPUTDATACOLLECTION_ID` FOREIGN KEY (`OUTPUTDATACOLLECTION_ID`) REFERENCES `DATACOLLECTION` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `KEYWORD`
--

DROP TABLE IF EXISTS `KEYWORD`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `KEYWORD`
(
    `ID`               bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`        varchar(255) NOT NULL,
    `CREATE_TIME`      datetime     NOT NULL,
    `MOD_ID`           varchar(255) NOT NULL,
    `MOD_TIME`         datetime     NOT NULL,
    `NAME`             varchar(255) NOT NULL,
    `INVESTIGATION_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_KEYWORD_0` (`NAME`,`INVESTIGATION_ID`),
    KEY                `FK_KEYWORD_INVESTIGATION_ID` (`INVESTIGATION_ID`),
    CONSTRAINT `FK_KEYWORD_INVESTIGATION_ID` FOREIGN KEY (`INVESTIGATION_ID`) REFERENCES `INVESTIGATION` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PARAMETERTYPE`
--

DROP TABLE IF EXISTS `PARAMETERTYPE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PARAMETERTYPE`
(
    `ID`                         bigint(20) NOT NULL AUTO_INCREMENT,
    `APPLICABLETODATACOLLECTION` tinyint(1) DEFAULT 0,
    `APPLICABLETODATAFILE`       tinyint(1) DEFAULT 0,
    `APPLICABLETODATASET`        tinyint(1) DEFAULT 0,
    `APPLICABLETOINVESTIGATION`  tinyint(1) DEFAULT 0,
    `APPLICABLETOSAMPLE`         tinyint(1) DEFAULT 0,
    `CREATE_ID`                  varchar(255) NOT NULL,
    `CREATE_TIME`                datetime     NOT NULL,
    `DESCRIPTION`                varchar(255) DEFAULT NULL,
    `ENFORCED`                   tinyint(1) DEFAULT 0,
    `MAXIMUMNUMERICVALUE` double DEFAULT NULL,
    `MINIMUMNUMERICVALUE` double DEFAULT NULL,
    `MOD_ID`                     varchar(255) NOT NULL,
    `MOD_TIME`                   datetime     NOT NULL,
    `NAME`                       varchar(255) NOT NULL,
    `UNITS`                      varchar(255) NOT NULL,
    `UNITSFULLNAME`              varchar(255) DEFAULT NULL,
    `VALUETYPE`                  int(11) NOT NULL,
    `VERIFIED`                   tinyint(1) DEFAULT 0,
    `FACILITY_ID`                bigint(20) NOT NULL,
    `PID`                        varchar(255) DEFAULT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_PARAMETERTYPE_0` (`FACILITY_ID`,`NAME`,`UNITS`),
    CONSTRAINT `FK_PARAMETERTYPE_FACILITY_ID` FOREIGN KEY (`FACILITY_ID`) REFERENCES `FACILITY` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1403 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PERMISSIBLESTRINGVALUE`
--

DROP TABLE IF EXISTS `PERMISSIBLESTRINGVALUE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PERMISSIBLESTRINGVALUE`
(
    `ID`               bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`        varchar(255) NOT NULL,
    `CREATE_TIME`      datetime     NOT NULL,
    `MOD_ID`           varchar(255) NOT NULL,
    `MOD_TIME`         datetime     NOT NULL,
    `VALUE`            varchar(255) NOT NULL,
    `PARAMETERTYPE_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_PERMISSIBLESTRINGVALUE_0` (`VALUE`,`PARAMETERTYPE_ID`),
    KEY                `FK_PERMISSIBLESTRINGVALUE_PARAMETERTYPE_ID` (`PARAMETERTYPE_ID`),
    CONSTRAINT `FK_PERMISSIBLESTRINGVALUE_PARAMETERTYPE_ID` FOREIGN KEY (`PARAMETERTYPE_ID`) REFERENCES `PARAMETERTYPE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PUBLICATION`
--

DROP TABLE IF EXISTS `PUBLICATION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PUBLICATION`
(
    `ID`               bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`        varchar(255) NOT NULL,
    `CREATE_TIME`      datetime     NOT NULL,
    `DOI`              varchar(255) DEFAULT NULL,
    `FULLREFERENCE`    varchar(511) NOT NULL,
    `MOD_ID`           varchar(255) NOT NULL,
    `MOD_TIME`         datetime     NOT NULL,
    `REPOSITORY`       varchar(255) DEFAULT NULL,
    `REPOSITORYID`     varchar(255) DEFAULT NULL,
    `URL`              varchar(255) DEFAULT NULL,
    `INVESTIGATION_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    KEY                `FK_PUBLICATION_INVESTIGATION_ID` (`INVESTIGATION_ID`),
    CONSTRAINT `FK_PUBLICATION_INVESTIGATION_ID` FOREIGN KEY (`INVESTIGATION_ID`) REFERENCES `INVESTIGATION` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PUBLICSTEP`
--

DROP TABLE IF EXISTS `PUBLICSTEP`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PUBLICSTEP`
(
    `ID`          bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`   varchar(255) NOT NULL,
    `CREATE_TIME` datetime     NOT NULL,
    `FIELD`       varchar(32)  NOT NULL,
    `MOD_ID`      varchar(255) NOT NULL,
    `MOD_TIME`    datetime     NOT NULL,
    `ORIGIN`      varchar(32)  NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_PUBLICSTEP_0` (`ORIGIN`,`FIELD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RELATEDDATAFILE`
--

DROP TABLE IF EXISTS `RELATEDDATAFILE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RELATEDDATAFILE`
(
    `ID`                 bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`          varchar(255) NOT NULL,
    `CREATE_TIME`        datetime     NOT NULL,
    `MOD_ID`             varchar(255) NOT NULL,
    `MOD_TIME`           datetime     NOT NULL,
    `RELATION`           varchar(255) NOT NULL,
    `DEST_DATAFILE_ID`   bigint(20) NOT NULL,
    `SOURCE_DATAFILE_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_RELATEDDATAFILE_0` (`SOURCE_DATAFILE_ID`,`DEST_DATAFILE_ID`),
    KEY                  `FK_RELATEDDATAFILE_DEST_DATAFILE_ID` (`DEST_DATAFILE_ID`),
    CONSTRAINT `FK_RELATEDDATAFILE_DEST_DATAFILE_ID` FOREIGN KEY (`DEST_DATAFILE_ID`) REFERENCES `DATAFILE` (`ID`),
    CONSTRAINT `FK_RELATEDDATAFILE_SOURCE_DATAFILE_ID` FOREIGN KEY (`SOURCE_DATAFILE_ID`) REFERENCES `DATAFILE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RELATEDITEM`
--

DROP TABLE IF EXISTS `RELATEDITEM`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RELATEDITEM`
(
    `ID`                 bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`          varchar(255) NOT NULL,
    `CREATE_TIME`        datetime     NOT NULL,
    `FULLREFERENCE`      varchar(1023) DEFAULT NULL,
    `IDENTIFIER`         varchar(255) NOT NULL,
    `MOD_ID`             varchar(255) NOT NULL,
    `MOD_TIME`           datetime     NOT NULL,
    `RELATEDITEMTYPE`    varchar(255)  DEFAULT NULL,
    `RELATIONTYPE`       varchar(255) NOT NULL,
    `TITLE`              varchar(255)  DEFAULT NULL,
    `DATAPUBLICATION_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_RELATEDITEM_0` (`DATAPUBLICATION_ID`,`IDENTIFIER`),
    CONSTRAINT `FK_RELATEDITEM_DATAPUBLICATION_ID` FOREIGN KEY (`DATAPUBLICATION_ID`) REFERENCES `DATAPUBLICATION` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RULE_`
--

DROP TABLE IF EXISTS `RULE_`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RULE_`
(
    `ID`          bigint(20) NOT NULL AUTO_INCREMENT,
    `ATTRIBUTE`   varchar(255)  DEFAULT NULL,
    `BEAN`        varchar(255)  DEFAULT NULL,
    `C`           tinyint(1) DEFAULT 0,
    `CREATE_ID`   varchar(255)  NOT NULL,
    `CREATE_TIME` datetime      NOT NULL,
    `CRUDFLAGS`   varchar(4)    NOT NULL,
    `CRUDJPQL`    varchar(1024) DEFAULT NULL,
    `D`           tinyint(1) DEFAULT 0,
    `INCLUDEJPQL` varchar(1024) DEFAULT NULL,
    `MOD_ID`      varchar(255)  NOT NULL,
    `MOD_TIME`    datetime      NOT NULL,
    `R`           tinyint(1) DEFAULT 0,
    `RESTRICTED`  tinyint(1) DEFAULT 0,
    `SEARCHJPQL`  varchar(1024) DEFAULT NULL,
    `U`           tinyint(1) DEFAULT 0,
    `WHAT`        varchar(1024) NOT NULL,
    `GROUPING_ID` bigint(20) DEFAULT NULL,
    PRIMARY KEY (`ID`),
    KEY           `FK_RULE__GROUPING_ID` (`GROUPING_ID`),
    CONSTRAINT `FK_RULE__GROUPING_ID` FOREIGN KEY (`GROUPING_ID`) REFERENCES `GROUPING` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1135 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SAMPLE`
--

DROP TABLE IF EXISTS `SAMPLE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SAMPLE`
(
    `ID`               bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`        varchar(255) NOT NULL,
    `CREATE_TIME`      datetime     NOT NULL,
    `MOD_ID`           varchar(255) NOT NULL,
    `MOD_TIME`         datetime     NOT NULL,
    `NAME`             varchar(255) NOT NULL,
    `INVESTIGATION_ID` bigint(20) NOT NULL,
    `SAMPLETYPE_ID`    bigint(20) DEFAULT NULL,
    `PID`              varchar(255) DEFAULT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_SAMPLE_0` (`INVESTIGATION_ID`,`NAME`),
    KEY                `FK_SAMPLE_SAMPLETYPE_ID` (`SAMPLETYPE_ID`),
    CONSTRAINT `FK_SAMPLE_INVESTIGATION_ID` FOREIGN KEY (`INVESTIGATION_ID`) REFERENCES `INVESTIGATION` (`ID`),
    CONSTRAINT `FK_SAMPLE_SAMPLETYPE_ID` FOREIGN KEY (`SAMPLETYPE_ID`) REFERENCES `SAMPLETYPE` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=13264 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SAMPLEPARAMETER`
--

DROP TABLE IF EXISTS `SAMPLEPARAMETER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SAMPLEPARAMETER`
(
    `ID`                bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`         varchar(255) NOT NULL,
    `CREATE_TIME`       datetime     NOT NULL,
    `DATETIME_VALUE`    datetime      DEFAULT NULL,
    `ERROR` double DEFAULT NULL,
    `MOD_ID`            varchar(255) NOT NULL,
    `MOD_TIME`          datetime     NOT NULL,
    `NUMERIC_VALUE` double DEFAULT NULL,
    `RANGEBOTTOM` double DEFAULT NULL,
    `RANGETOP` double DEFAULT NULL,
    `STRING_VALUE`      varchar(4000) DEFAULT NULL,
    `SAMPLE_ID`         bigint(20) NOT NULL,
    `PARAMETER_TYPE_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_SAMPLEPARAMETER_0` (`SAMPLE_ID`,`PARAMETER_TYPE_ID`),
    KEY                 `FK_SAMPLEPARAMETER_PARAMETER_TYPE_ID` (`PARAMETER_TYPE_ID`),
    CONSTRAINT `FK_SAMPLEPARAMETER_PARAMETER_TYPE_ID` FOREIGN KEY (`PARAMETER_TYPE_ID`) REFERENCES `PARAMETERTYPE` (`ID`),
    CONSTRAINT `FK_SAMPLEPARAMETER_SAMPLE_ID` FOREIGN KEY (`SAMPLE_ID`) REFERENCES `SAMPLE` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=54577 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SAMPLETYPE`
--

DROP TABLE IF EXISTS `SAMPLETYPE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SAMPLETYPE`
(
    `ID`                bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`         varchar(255) NOT NULL,
    `CREATE_TIME`       datetime     NOT NULL,
    `MOD_ID`            varchar(255) NOT NULL,
    `MOD_TIME`          datetime     NOT NULL,
    `MOLECULARFORMULA`  varchar(255) NOT NULL,
    `NAME`              varchar(255) NOT NULL,
    `SAFETYINFORMATION` varchar(4000) DEFAULT NULL,
    `FACILITY_ID`       bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_SAMPLETYPE_0` (`FACILITY_ID`,`NAME`,`MOLECULARFORMULA`),
    CONSTRAINT `FK_SAMPLETYPE_FACILITY_ID` FOREIGN KEY (`FACILITY_ID`) REFERENCES `FACILITY` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SEQ_GEN_SEQUENCE`
--

DROP TABLE IF EXISTS `SEQ_GEN_SEQUENCE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SEQ_GEN_SEQUENCE`
(
    `next_not_cached_value` bigint(21) NOT NULL,
    `minimum_value`         bigint(21) NOT NULL,
    `maximum_value`         bigint(21) NOT NULL,
    `start_value`           bigint(21) NOT NULL COMMENT 'start value when sequences is created or value if RESTART is used',
    `increment`             bigint(21) NOT NULL COMMENT 'increment value',
    `cache_size`            bigint(21) unsigned NOT NULL,
    `cycle_option`          tinyint(1) unsigned NOT NULL COMMENT '0 if no cycles are allowed, 1 if the sequence should begin a new cycle when maximum_value is passed',
    `cycle_count`           bigint(21) NOT NULL COMMENT 'How many cycles have been done'
) ENGINE=InnoDB SEQUENCE=1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SESSION_`
--

DROP TABLE IF EXISTS `SESSION_`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SESSION_`
(
    `ID`             varchar(255) NOT NULL,
    `EXPIREDATETIME` datetime     DEFAULT NULL,
    `USERNAME`       varchar(255) DEFAULT NULL,
    PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SHIFT`
--

DROP TABLE IF EXISTS `SHIFT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SHIFT`
(
    `ID`               bigint(20) NOT NULL AUTO_INCREMENT,
    `COMMENT`          varchar(255) DEFAULT NULL,
    `CREATE_ID`        varchar(255) NOT NULL,
    `CREATE_TIME`      datetime     NOT NULL,
    `ENDDATE`          datetime     NOT NULL,
    `MOD_ID`           varchar(255) NOT NULL,
    `MOD_TIME`         datetime     NOT NULL,
    `STARTDATE`        datetime     NOT NULL,
    `INVESTIGATION_ID` bigint(20) NOT NULL,
    `INSTRUMENT_ID`    bigint(20) DEFAULT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_SHIFT_0` (`INVESTIGATION_ID`,`STARTDATE`,`ENDDATE`),
    KEY                `FK_SHIFT_INSTRUMENT_ID` (`INSTRUMENT_ID`),
    CONSTRAINT `FK_SHIFT_INSTRUMENT_ID` FOREIGN KEY (`INSTRUMENT_ID`) REFERENCES `INSTRUMENT` (`ID`),
    CONSTRAINT `FK_SHIFT_INVESTIGATION_ID` FOREIGN KEY (`INVESTIGATION_ID`) REFERENCES `INVESTIGATION` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `STUDY`
--

DROP TABLE IF EXISTS `STUDY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `STUDY`
(
    `ID`          bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`   varchar(255) NOT NULL,
    `CREATE_TIME` datetime     NOT NULL,
    `DESCRIPTION` varchar(4000) DEFAULT NULL,
    `MOD_ID`      varchar(255) NOT NULL,
    `MOD_TIME`    datetime     NOT NULL,
    `NAME`        varchar(255) NOT NULL,
    `STARTDATE`   datetime      DEFAULT NULL,
    `STATUS`      int(11) DEFAULT NULL,
    `USER_ID`     bigint(20) DEFAULT NULL,
    `ENDDATE`     datetime      DEFAULT NULL,
    `PID`         varchar(255)  DEFAULT NULL,
    PRIMARY KEY (`ID`),
    KEY           `FK_STUDY_USER_ID` (`USER_ID`),
    CONSTRAINT `FK_STUDY_USER_ID` FOREIGN KEY (`USER_ID`) REFERENCES `USER_` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `STUDYINVESTIGATION`
--

DROP TABLE IF EXISTS `STUDYINVESTIGATION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `STUDYINVESTIGATION`
(
    `ID`               bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`        varchar(255) NOT NULL,
    `CREATE_TIME`      datetime     NOT NULL,
    `MOD_ID`           varchar(255) NOT NULL,
    `MOD_TIME`         datetime     NOT NULL,
    `INVESTIGATION_ID` bigint(20) NOT NULL,
    `STUDY_ID`         bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_STUDYINVESTIGATION_0` (`STUDY_ID`,`INVESTIGATION_ID`),
    KEY                `FK_STUDYINVESTIGATION_INVESTIGATION_ID` (`INVESTIGATION_ID`),
    CONSTRAINT `FK_STUDYINVESTIGATION_INVESTIGATION_ID` FOREIGN KEY (`INVESTIGATION_ID`) REFERENCES `INVESTIGATION` (`ID`),
    CONSTRAINT `FK_STUDYINVESTIGATION_STUDY_ID` FOREIGN KEY (`STUDY_ID`) REFERENCES `STUDY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TECHNIQUE`
--

DROP TABLE IF EXISTS `TECHNIQUE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TECHNIQUE`
(
    `ID`          bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`   varchar(255) NOT NULL,
    `CREATE_TIME` datetime     NOT NULL,
    `DESCRIPTION` varchar(255) DEFAULT NULL,
    `MOD_ID`      varchar(255) NOT NULL,
    `MOD_TIME`    datetime     NOT NULL,
    `NAME`        varchar(255) NOT NULL,
    `PID`         varchar(255) DEFAULT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_TECHNIQUE_0` (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `USERGROUP`
--

DROP TABLE IF EXISTS `USERGROUP`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USERGROUP`
(
    `ID`          bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`   varchar(255) NOT NULL,
    `CREATE_TIME` datetime     NOT NULL,
    `MOD_ID`      varchar(255) NOT NULL,
    `MOD_TIME`    datetime     NOT NULL,
    `GROUP_ID`    bigint(20) NOT NULL,
    `USER_ID`     bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_USERGROUP_0` (`USER_ID`,`GROUP_ID`),
    KEY           `FK_USERGROUP_GROUP_ID` (`GROUP_ID`),
    CONSTRAINT `FK_USERGROUP_GROUP_ID` FOREIGN KEY (`GROUP_ID`) REFERENCES `GROUPING` (`ID`),
    CONSTRAINT `FK_USERGROUP_USER_ID` FOREIGN KEY (`USER_ID`) REFERENCES `USER_` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3361 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `USER_`
--

DROP TABLE IF EXISTS `USER_`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_`
(
    `ID`          bigint(20) NOT NULL AUTO_INCREMENT,
    `CREATE_ID`   varchar(255) CHARACTER SET utf8 NOT NULL,
    `CREATE_TIME` datetime                        NOT NULL,
    `EMAIL`       varchar(255) CHARACTER SET utf8 DEFAULT NULL,
    `FULLNAME`    varchar(255) CHARACTER SET utf8 DEFAULT NULL,
    `MOD_ID`      varchar(255) CHARACTER SET utf8 NOT NULL,
    `MOD_TIME`    datetime                        NOT NULL,
    `NAME`        varchar(255) CHARACTER SET utf8 NOT NULL,
    `ORCIDID`     varchar(255) CHARACTER SET utf8 DEFAULT NULL,
    `AFFILIATION` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
    `FAMILYNAME`  varchar(255) CHARACTER SET utf8 DEFAULT NULL,
    `GIVENNAME`   varchar(255) CHARACTER SET utf8 DEFAULT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNQ_USER__0` (`NAME`)
) ENGINE=InnoDB AUTO_INCREMENT=11402 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'icat'
--
/*!50003 DROP PROCEDURE IF EXISTS `UPDATE_DS_FILECOUNT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER;;
CREATE
DEFINER=`root`@`localhost` PROCEDURE `UPDATE_DS_FILECOUNT`(DATASET_ID INTEGER, DELTA BIGINT)
BEGIN
UPDATE DATASET
SET FILECOUNT = IFNULL(FILECOUNT, 0) + DELTA
WHERE ID = DATASET_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UPDATE_DS_FILESIZE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`root`@`localhost` PROCEDURE `UPDATE_DS_FILESIZE`(DATASET_ID INTEGER, DELTA BIGINT)
BEGIN
UPDATE DATASET
SET FILESIZE = IFNULL(FILESIZE, 0) + DELTA
WHERE ID = DATASET_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UPDATE_INV_FILECOUNT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`root`@`localhost` PROCEDURE `UPDATE_INV_FILECOUNT`(INVESTIGATION_ID INTEGER, DELTA BIGINT)
BEGIN
UPDATE INVESTIGATION
SET FILECOUNT = IFNULL(FILECOUNT, 0) + DELTA
WHERE ID = INVESTIGATION_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UPDATE_INV_FILESIZE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`root`@`localhost` PROCEDURE `UPDATE_INV_FILESIZE`(INVESTIGATION_ID INTEGER, DELTA BIGINT)
BEGIN
UPDATE INVESTIGATION
SET FILESIZE = IFNULL(FILESIZE, 0) + DELTA
WHERE ID = INVESTIGATION_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;







