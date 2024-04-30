/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table sessions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sessions`;

CREATE TABLE `sessions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `start` timestamp NULL DEFAULT NULL,
  `stop` timestamp NULL DEFAULT NULL,
  `siteIP` char(15) DEFAULT NULL,
  `username` char(6) DEFAULT NULL,
  `mac` char(17) DEFAULT NULL,
  `ap` char(17) DEFAULT NULL,
  `building_identifier` varchar(20) DEFAULT NULL,
  `success` tinyint(1) DEFAULT NULL,
  `task_id` varchar(100) DEFAULT '',
  `cert_name` varchar(100) DEFAULT NULL,
  `authentication_reply` varchar(100) DEFAULT NULL,
  `cert_serial` char(100) DEFAULT NULL,
  `cert_issuer` varchar(100) DEFAULT NULL,
  `cert_subject` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `siteIP` (`siteIP`,`username`),
  KEY `sessions_username` (`username`),
  KEY `sessions_start_username` (`start`,`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
