-- MySQL dump 10.13  Distrib 8.0.29, for Linux (x86_64)
--
-- Host: FreshStart.mysql.pythonanywhere-services.com    Database: FreshStart$freshstart_db
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
INSERT INTO `auth_group` VALUES (1,'School System 1'),(2,'School System 2');
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add food type',7,'add_foodtype'),(26,'Can change food type',7,'change_foodtype'),(27,'Can delete food type',7,'delete_foodtype'),(28,'Can view food type',7,'view_foodtype'),(29,'Can add lunch program',8,'add_lunchprogram'),(30,'Can change lunch program',8,'change_lunchprogram'),(31,'Can delete lunch program',8,'delete_lunchprogram'),(32,'Can view lunch program',8,'view_lunchprogram'),(33,'Can add menu date',9,'add_menudate'),(34,'Can change menu date',9,'change_menudate'),(35,'Can delete menu date',9,'delete_menudate'),(36,'Can view menu date',9,'view_menudate'),(37,'Can add plate portion',10,'add_plateportion'),(38,'Can change plate portion',10,'change_plateportion'),(39,'Can delete plate portion',10,'delete_plateportion'),(40,'Can view plate portion',10,'view_plateportion'),(41,'Can add food item',11,'add_fooditem'),(42,'Can change food item',11,'change_fooditem'),(43,'Can delete food item',11,'delete_fooditem'),(44,'Can view food item',11,'view_fooditem'),(45,'Can add menu item',12,'add_menuitem'),(46,'Can change menu item',12,'change_menuitem'),(47,'Can delete menu item',12,'delete_menuitem'),(48,'Can view menu item',12,'view_menuitem'),(49,'Can add Customer Orders',13,'add_userorder'),(50,'Can change Customer Orders',13,'change_userorder'),(51,'Can delete Customer Orders',13,'delete_userorder'),(52,'Can view Customer Orders',13,'view_userorder'),(53,'Can add cart',14,'add_cart'),(54,'Can change cart',14,'change_cart'),(55,'Can delete cart',14,'delete_cart'),(56,'Can view cart',14,'view_cart'),(57,'Can add order item',15,'add_orderitem'),(58,'Can change order item',15,'change_orderitem'),(59,'Can delete order item',15,'delete_orderitem'),(60,'Can view order item',15,'view_orderitem'),(61,'Can add user profile',16,'add_userprofile'),(62,'Can change user profile',16,'change_userprofile'),(63,'Can delete user profile',16,'delete_userprofile'),(64,'Can view user profile',16,'view_userprofile'),(65,'Can add delivery schedule',17,'add_deliveryschedule'),(66,'Can change delivery schedule',17,'change_deliveryschedule'),(67,'Can delete delivery schedule',17,'delete_deliveryschedule'),(68,'Can view delivery schedule',17,'view_deliveryschedule'),(69,'Can add user delivery schedule',18,'add_userdeliveryschedule'),(70,'Can change user delivery schedule',18,'change_userdeliveryschedule'),(71,'Can delete user delivery schedule',18,'delete_userdeliveryschedule'),(72,'Can view user delivery schedule',18,'view_userdeliveryschedule'),(73,'Can add user lunch program',19,'add_userlunchprogram'),(74,'Can change user lunch program',19,'change_userlunchprogram'),(75,'Can delete user lunch program',19,'delete_userlunchprogram'),(76,'Can view user lunch program',19,'view_userlunchprogram'),(77,'Can add customer support profile',20,'add_customersupportprofile'),(78,'Can change customer support profile',20,'change_customersupportprofile'),(79,'Can delete customer support profile',20,'delete_customersupportprofile'),(80,'Can view customer support profile',20,'view_customersupportprofile'),(81,'Can add user',21,'add_customuser'),(82,'Can change user',21,'change_customuser'),(83,'Can delete user',21,'delete_customuser'),(84,'Can view user',21,'view_customuser'),(85,'Can add school',22,'add_school'),(86,'Can change school',22,'change_school'),(87,'Can delete school',22,'delete_school'),(88,'Can view school',22,'view_school'),(89,'Can add school',23,'add_school'),(90,'Can change school',23,'change_school'),(91,'Can delete school',23,'delete_school'),(92,'Can view school',23,'view_school');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_school`
--

DROP TABLE IF EXISTS `auth_school`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_school` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `route_number` varchar(2) DEFAULT NULL,
  `delivery_type` varchar(20) DEFAULT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `auth_school_group_id_46b84db6_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_school_group_id_46b84db6_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_school`
--

LOCK TABLES `auth_school` WRITE;
/*!40000 ALTER TABLE `auth_school` DISABLE KEYS */;
INSERT INTO `auth_school` VALUES (1,'School 1.1','24','Ready to Serve',1),(2,'School 1.2','22','Heat on Site',1),(3,'School 2.1','34','Heat on Site',2);
/*!40000 ALTER TABLE `auth_school` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_school_delivery_schedule`
--

DROP TABLE IF EXISTS `auth_school_delivery_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_school_delivery_schedule` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `school_id` int NOT NULL,
  `deliveryschedule_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_school_delivery_sch_school_id_deliveryschedu_d8a1ce83_uniq` (`school_id`,`deliveryschedule_id`),
  KEY `auth_school_delivery_deliveryschedule_id_a071de87_fk_food_orde` (`deliveryschedule_id`),
  CONSTRAINT `auth_school_delivery_deliveryschedule_id_a071de87_fk_food_orde` FOREIGN KEY (`deliveryschedule_id`) REFERENCES `food_order_api_deliveryschedule` (`id`),
  CONSTRAINT `auth_school_delivery_school_id_5b632dc0_fk_auth_scho` FOREIGN KEY (`school_id`) REFERENCES `auth_school` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_school_delivery_schedule`
--

LOCK TABLES `auth_school_delivery_schedule` WRITE;
/*!40000 ALTER TABLE `auth_school_delivery_schedule` DISABLE KEYS */;
INSERT INTO `auth_school_delivery_schedule` VALUES (1,1,1),(2,1,3),(3,2,3),(4,2,4),(5,3,2),(6,3,3),(7,3,4);
/*!40000 ALTER TABLE `auth_school_delivery_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_school_lunch_programs`
--

DROP TABLE IF EXISTS `auth_school_lunch_programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_school_lunch_programs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `school_id` int NOT NULL,
  `lunchprogram_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_school_lunch_progra_school_id_lunchprogram_i_3bdc523e_uniq` (`school_id`,`lunchprogram_id`),
  KEY `auth_school_lunch_pr_lunchprogram_id_85fa5f21_fk_food_orde` (`lunchprogram_id`),
  CONSTRAINT `auth_school_lunch_pr_lunchprogram_id_85fa5f21_fk_food_orde` FOREIGN KEY (`lunchprogram_id`) REFERENCES `food_order_api_lunchprogram` (`id`),
  CONSTRAINT `auth_school_lunch_programs_school_id_d4987cca_fk_auth_school_id` FOREIGN KEY (`school_id`) REFERENCES `auth_school` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_school_lunch_programs`
--

LOCK TABLES `auth_school_lunch_programs` WRITE;
/*!40000 ALTER TABLE `auth_school_lunch_programs` DISABLE KEYS */;
INSERT INTO `auth_school_lunch_programs` VALUES (1,1,2),(2,1,4),(3,1,5),(4,2,1),(6,2,3),(7,2,4),(8,2,5),(9,3,1),(10,3,2);
/*!40000 ALTER TABLE `auth_school_lunch_programs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_school_users`
--

DROP TABLE IF EXISTS `auth_school_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_school_users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `school_id` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_school_users_school_id_user_id_b26c7a68_uniq` (`school_id`,`user_id`),
  KEY `auth_school_users_user_id_7002af25_fk_auth_user_id` (`user_id`),
  CONSTRAINT `auth_school_users_school_id_e0c8d172_fk_auth_school_id` FOREIGN KEY (`school_id`) REFERENCES `auth_school` (`id`),
  CONSTRAINT `auth_school_users_user_id_7002af25_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_school_users`
--

LOCK TABLES `auth_school_users` WRITE;
/*!40000 ALTER TABLE `auth_school_users` DISABLE KEYS */;
INSERT INTO `auth_school_users` VALUES (1,1,1),(2,2,1),(4,3,2);
/*!40000 ALTER TABLE `auth_school_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$600000$MGjqt6dLkvWYwdwaMkRwvg$DAMkwrNUurrIFvS/dMPyn6T7VqbPUAJU+D7Tsb5NEcQ=','2025-03-22 06:25:35.307023',1,'admin','Phillip','Marzouk','phillipmarzouk@gmail.com',1,1,'2025-03-14 04:53:44.000000'),(2,'pbkdf2_sha256$600000$FptiydXEBqTuvwqlcKcwcE$D4oE/N33UUXDeMfgHGVjTDxLliD96rtWt7RHVBEAVN4=','2025-03-22 06:21:44.362959',0,'SkyHigh','Lunch','Lady','phillip@digitalonbrand.com',1,1,'2025-03-14 18:35:58.000000');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=253 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2025-03-14 17:39:16.402799','1','Grain',1,'[{\"added\": {}}]',10,1),(2,'2025-03-14 17:39:24.014383','2','Protein',1,'[{\"added\": {}}]',10,1),(3,'2025-03-14 17:39:27.937748','3','Vegetable',1,'[{\"added\": {}}]',10,1),(4,'2025-03-14 17:39:30.767341','4','Fruit',1,'[{\"added\": {}}]',10,1),(5,'2025-03-14 17:39:33.710215','5','Dairy',1,'[{\"added\": {}}]',10,1),(6,'2025-03-14 17:52:17.188932','1','NSLP K-8',1,'[{\"added\": {}}]',8,1),(7,'2025-03-14 17:52:22.549405','2','NSLP 9-12',1,'[{\"added\": {}}]',8,1),(8,'2025-03-14 17:52:27.176855','3','CACFP K-12',1,'[{\"added\": {}}]',8,1),(9,'2025-03-14 17:52:32.084665','4','CACFP Pre-K',1,'[{\"added\": {}}]',8,1),(10,'2025-03-14 17:52:36.649809','5','CACFP Adults',1,'[{\"added\": {}}]',8,1),(11,'2025-03-14 18:33:12.153087','1','Menu Item - All Programs',1,'[{\"added\": {}}]',12,1),(12,'2025-03-14 18:33:44.406259','2','Menu Item - NSLP K-8',1,'[{\"added\": {}}]',12,1),(13,'2025-03-14 18:34:05.494951','3','Menu Item - Adult School',1,'[{\"added\": {}}]',12,1),(14,'2025-03-14 18:35:58.603859','2','SkyHigh',1,'[{\"added\": {}}]',4,1),(15,'2025-03-14 18:36:48.506080','2','SkyHigh',2,'[{\"changed\": {\"fields\": [\"First name\", \"Last name\", \"Email address\"]}}]',4,1),(16,'2025-03-14 18:37:07.717466','2','SkyHigh',2,'[{\"changed\": {\"fields\": [\"Email address\"]}}]',4,1),(17,'2025-03-14 20:44:36.295305','2','SkyHigh',2,'[{\"added\": {\"name\": \"user profile\", \"object\": \"SkyHigh\"}}]',4,1),(18,'2025-03-14 20:45:29.500878','2','SkyHigh',2,'[]',4,1),(19,'2025-03-14 21:58:19.531073','1','admin',2,'[{\"added\": {\"name\": \"user profile\", \"object\": \"admin\"}}]',4,1),(20,'2025-03-14 22:08:52.568100','2','SkyHigh',2,'[{\"changed\": {\"name\": \"user profile\", \"object\": \"SkyHigh\", \"fields\": [\"Lunch programs\"]}}]',4,1),(21,'2025-03-14 22:09:16.558993','1','admin',2,'[{\"changed\": {\"name\": \"user profile\", \"object\": \"admin\", \"fields\": [\"Lunch programs\"]}}]',4,1),(22,'2025-03-14 22:15:55.708270','1','admin',2,'[{\"changed\": {\"name\": \"user profile\", \"object\": \"admin\", \"fields\": [\"Lunch programs\"]}}]',4,1),(23,'2025-03-14 22:16:27.508903','1','admin',2,'[{\"changed\": {\"name\": \"user profile\", \"object\": \"admin\", \"fields\": [\"Lunch programs\"]}}]',4,1),(24,'2025-03-14 22:16:42.139260','1','admin',2,'[{\"changed\": {\"name\": \"user profile\", \"object\": \"admin\", \"fields\": [\"Lunch programs\"]}}]',4,1),(25,'2025-03-15 03:16:28.721383','1','Menu Item - All Programs',2,'[{\"changed\": {\"fields\": [\"Plate portions\"]}}]',12,1),(26,'2025-03-15 04:43:46.536772','90','Asian Chicken Pasta Salad',3,'',12,1),(27,'2025-03-15 04:43:46.542686','70','Asian Chicken Pasta Salad',3,'',12,1),(28,'2025-03-15 04:43:46.547492','50','Asian Chicken Pasta Salad',3,'',12,1),(29,'2025-03-15 04:43:46.552501','30','Asian Chicken Pasta Salad',3,'',12,1),(30,'2025-03-15 04:43:46.557272','10','Asian Chicken Pasta Salad',3,'',12,1),(31,'2025-03-15 04:43:46.562455','95','Bagel & Jelly',3,'',12,1),(32,'2025-03-15 04:43:46.569353','75','Bagel & Jelly',3,'',12,1),(33,'2025-03-15 04:43:46.575045','55','Bagel & Jelly',3,'',12,1),(34,'2025-03-15 04:43:46.582075','35','Bagel & Jelly',3,'',12,1),(35,'2025-03-15 04:43:46.586875','15','Bagel & Jelly',3,'',12,1),(36,'2025-03-15 04:43:46.591590','103','Banana Muffin (S)',3,'',12,1),(37,'2025-03-15 04:43:46.596139','83','Banana Muffin (S)',3,'',12,1),(38,'2025-03-15 04:43:46.600633','63','Banana Muffin (S)',3,'',12,1),(39,'2025-03-15 04:43:46.605580','43','Banana Muffin (S)',3,'',12,1),(40,'2025-03-15 04:43:46.610510','23','Banana Muffin (S)',3,'',12,1),(41,'2025-03-15 04:43:46.615445','88','Bean & Cheese Burrito w/carrot sticks (1/2c)',3,'',12,1),(42,'2025-03-15 04:43:46.620848','68','Bean & Cheese Burrito w/carrot sticks (1/2c)',3,'',12,1),(43,'2025-03-15 04:43:46.625897','48','Bean & Cheese Burrito w/carrot sticks (1/2c)',3,'',12,1),(44,'2025-03-15 04:43:46.630854','28','Bean & Cheese Burrito w/carrot sticks (1/2c)',3,'',12,1),(45,'2025-03-15 04:43:46.635483','8','Bean & Cheese Burrito w/carrot sticks (1/2c)',3,'',12,1),(46,'2025-03-15 04:43:46.640318','101','Bean & Cheese Torta w/garden corn salad (3/4c)',3,'',12,1),(47,'2025-03-15 04:43:46.645200','81','Bean & Cheese Torta w/garden corn salad (3/4c)',3,'',12,1),(48,'2025-03-15 04:43:46.650018','61','Bean & Cheese Torta w/garden corn salad (3/4c)',3,'',12,1),(49,'2025-03-15 04:43:46.655014','41','Bean & Cheese Torta w/garden corn salad (3/4c)',3,'',12,1),(50,'2025-03-15 04:43:46.659586','21','Bean & Cheese Torta w/garden corn salad (3/4c)',3,'',12,1),(51,'2025-03-15 04:43:46.664230','98','Black Bean Burger w/sweet corn medley (3/4c)',3,'',12,1),(52,'2025-03-15 04:43:46.668909','78','Black Bean Burger w/sweet corn medley (3/4c)',3,'',12,1),(53,'2025-03-15 04:43:46.673451','58','Black Bean Burger w/sweet corn medley (3/4c)',3,'',12,1),(54,'2025-03-15 04:43:46.678198','38','Black Bean Burger w/sweet corn medley (3/4c)',3,'',12,1),(55,'2025-03-15 04:43:46.682924','18','Black Bean Burger w/sweet corn medley (3/4c)',3,'',12,1),(56,'2025-03-15 04:43:46.687676','92','Caesar Chicken Salad with a Wheat Dinner Roll',3,'',12,1),(57,'2025-03-15 04:43:46.692369','72','Caesar Chicken Salad with a Wheat Dinner Roll',3,'',12,1),(58,'2025-03-15 04:43:46.696955','52','Caesar Chicken Salad with a Wheat Dinner Roll',3,'',12,1),(59,'2025-03-15 04:43:46.701563','32','Caesar Chicken Salad with a Wheat Dinner Roll',3,'',12,1),(60,'2025-03-15 04:43:46.706215','12','Caesar Chicken Salad with a Wheat Dinner Roll',3,'',12,1),(61,'2025-03-15 04:43:46.711060','84','Chocolate Chip Muffin',3,'',12,1),(62,'2025-03-15 04:43:46.715790','64','Chocolate Chip Muffin',3,'',12,1),(63,'2025-03-15 04:43:46.720608','44','Chocolate Chip Muffin',3,'',12,1),(64,'2025-03-15 04:43:46.725275','24','Chocolate Chip Muffin',3,'',12,1),(65,'2025-03-15 04:43:46.729838','4','Chocolate Chip Muffin',3,'',12,1),(66,'2025-03-15 04:43:46.734578','85','Cinnamon Toast Crunch & WG Crackers',3,'',12,1),(67,'2025-03-15 04:43:46.739295','65','Cinnamon Toast Crunch & WG Crackers',3,'',12,1),(68,'2025-03-15 04:43:46.744179','45','Cinnamon Toast Crunch & WG Crackers',3,'',12,1),(69,'2025-03-15 04:43:46.748901','25','Cinnamon Toast Crunch & WG Crackers',3,'',12,1),(70,'2025-03-15 04:43:46.753585','5','Cinnamon Toast Crunch & WG Crackers',3,'',12,1),(71,'2025-03-15 04:43:46.758197','100','Fiesta Chicken Pasta Salad',3,'',12,1),(72,'2025-03-15 04:43:46.762948','80','Fiesta Chicken Pasta Salad',3,'',12,1),(73,'2025-03-15 04:43:46.767471','60','Fiesta Chicken Pasta Salad',3,'',12,1),(74,'2025-03-15 04:43:46.772153','40','Fiesta Chicken Pasta Salad',3,'',12,1),(75,'2025-03-15 04:43:46.776907','20','Fiesta Chicken Pasta Salad',3,'',12,1),(76,'2025-03-15 04:43:46.781601','97','Fresco Beef w/cilantro rice (3/4c) & sweet corn medley (3/4c)',3,'',12,1),(77,'2025-03-15 04:43:46.786238','77','Fresco Beef w/cilantro rice (3/4c) & sweet corn medley (3/4c)',3,'',12,1),(78,'2025-03-15 04:43:46.790885','57','Fresco Beef w/cilantro rice (3/4c) & sweet corn medley (3/4c)',3,'',12,1),(79,'2025-03-15 04:43:46.796255','37','Fresco Beef w/cilantro rice (3/4c) & sweet corn medley (3/4c)',3,'',12,1),(80,'2025-03-15 04:43:46.801162','17','Fresco Beef w/cilantro rice (3/4c) & sweet corn medley (3/4c)',3,'',12,1),(81,'2025-03-15 04:43:46.805693','91','Garlic Pesto Cheese Pasta Salad w/carrot sticks (3/4c)',3,'',12,1),(82,'2025-03-15 04:43:46.810406','71','Garlic Pesto Cheese Pasta Salad w/carrot sticks (3/4c)',3,'',12,1),(83,'2025-03-15 04:43:46.815271','51','Garlic Pesto Cheese Pasta Salad w/carrot sticks (3/4c)',3,'',12,1),(84,'2025-03-15 04:43:46.820026','31','Garlic Pesto Cheese Pasta Salad w/carrot sticks (3/4c)',3,'',12,1),(85,'2025-03-15 04:43:46.824686','11','Garlic Pesto Cheese Pasta Salad w/carrot sticks (3/4c)',3,'',12,1),(86,'2025-03-15 04:43:46.829413','86','Hamburger w/sweet potato (3/4c)',3,'',12,1),(87,'2025-03-15 04:43:46.834116','66','Hamburger w/sweet potato (3/4c)',3,'',12,1),(88,'2025-03-15 04:43:46.839029','46','Hamburger w/sweet potato (3/4c)',3,'',12,1),(89,'2025-03-15 04:43:46.843925','26','Hamburger w/sweet potato (3/4c)',3,'',12,1),(90,'2025-03-15 04:43:46.848551','6','Hamburger w/sweet potato (3/4c)',3,'',12,1),(91,'2025-03-15 04:43:46.853351','87','Lemon Garlic Chicken w/cilantro rice (3/4c) & glazed peas & carrots (3/4c)',3,'',12,1),(92,'2025-03-15 04:43:46.858172','67','Lemon Garlic Chicken w/cilantro rice (3/4c) & glazed peas & carrots (3/4c)',3,'',12,1),(93,'2025-03-15 04:43:46.862970','47','Lemon Garlic Chicken w/cilantro rice (3/4c) & glazed peas & carrots (3/4c)',3,'',12,1),(94,'2025-03-15 04:43:46.869671','27','Lemon Garlic Chicken w/cilantro rice (3/4c) & glazed peas & carrots (3/4c)',3,'',12,1),(95,'2025-03-15 04:43:46.874559','7','Lemon Garlic Chicken w/cilantro rice (3/4c) & glazed peas & carrots (3/4c)',3,'',12,1),(96,'2025-03-15 04:43:46.879374','102','Mediterranean Chicken Salad with a Wheat Dinner Roll',3,'',12,1),(97,'2025-03-15 04:43:46.884087','82','Mediterranean Chicken Salad with a Wheat Dinner Roll',3,'',12,1),(98,'2025-03-15 04:43:46.888812','62','Mediterranean Chicken Salad with a Wheat Dinner Roll',3,'',12,1),(99,'2025-03-15 04:43:46.893596','42','Mediterranean Chicken Salad with a Wheat Dinner Roll',3,'',12,1),(100,'2025-03-15 04:43:46.898243','22','Mediterranean Chicken Salad with a Wheat Dinner Roll',3,'',12,1),(101,'2025-03-15 04:43:46.903121','3','Menu Item - Adult School',3,'',12,1),(102,'2025-03-15 04:43:46.907704','1','Menu Item - All Programs',3,'',12,1),(103,'2025-03-15 04:43:46.912532','2','Menu Item - NSLP K-8',3,'',12,1),(104,'2025-03-15 04:43:46.917342','93','Oatmeal Cookie (S)',3,'',12,1),(105,'2025-03-15 04:43:46.922173','73','Oatmeal Cookie (S)',3,'',12,1),(106,'2025-03-15 04:43:46.930517','53','Oatmeal Cookie (S)',3,'',12,1),(107,'2025-03-15 04:43:46.935318','33','Oatmeal Cookie (S)',3,'',12,1),(108,'2025-03-15 04:43:46.940101','13','Oatmeal Cookie (S)',3,'',12,1),(109,'2025-03-15 04:43:46.945684','89','Roasted Pepper Chicken Hoagie Sandwich w/carrot sticks (3/4c)',3,'',12,1),(110,'2025-03-15 04:43:46.950987','69','Roasted Pepper Chicken Hoagie Sandwich w/carrot sticks (3/4c)',3,'',12,1),(111,'2025-03-15 04:43:46.955798','49','Roasted Pepper Chicken Hoagie Sandwich w/carrot sticks (3/4c)',3,'',12,1),(112,'2025-03-15 04:43:46.960437','29','Roasted Pepper Chicken Hoagie Sandwich w/carrot sticks (3/4c)',3,'',12,1),(113,'2025-03-15 04:43:46.965420','9','Roasted Pepper Chicken Hoagie Sandwich w/carrot sticks (3/4c)',3,'',12,1),(114,'2025-03-15 04:43:46.971154','94','Sausage English Muffin',3,'',12,1),(115,'2025-03-15 04:43:46.976263','74','Sausage English Muffin',3,'',12,1),(116,'2025-03-15 04:43:46.980946','54','Sausage English Muffin',3,'',12,1),(117,'2025-03-15 04:43:46.985445','34','Sausage English Muffin',3,'',12,1),(118,'2025-03-15 04:43:46.990012','14','Sausage English Muffin',3,'',12,1),(119,'2025-03-15 04:43:46.994556','96','Sloppy Joe on a HB Bun w/sweet corn medley (3/4c)',3,'',12,1),(120,'2025-03-15 04:43:46.999179','76','Sloppy Joe on a HB Bun w/sweet corn medley (3/4c)',3,'',12,1),(121,'2025-03-15 04:43:47.003878','56','Sloppy Joe on a HB Bun w/sweet corn medley (3/4c)',3,'',12,1),(122,'2025-03-15 04:43:47.008655','36','Sloppy Joe on a HB Bun w/sweet corn medley (3/4c)',3,'',12,1),(123,'2025-03-15 04:43:47.013291','16','Sloppy Joe on a HB Bun w/sweet corn medley (3/4c)',3,'',12,1),(124,'2025-03-15 04:43:47.017982','99','Turkey & Cheese Hoagie Sandwich w/garden corn salad (3/4c)',3,'',12,1),(125,'2025-03-15 04:43:47.022803','79','Turkey & Cheese Hoagie Sandwich w/garden corn salad (3/4c)',3,'',12,1),(126,'2025-03-15 04:43:47.027674','59','Turkey & Cheese Hoagie Sandwich w/garden corn salad (3/4c)',3,'',12,1),(127,'2025-03-15 04:43:47.032273','39','Turkey & Cheese Hoagie Sandwich w/garden corn salad (3/4c)',3,'',12,1),(128,'2025-03-15 04:43:47.037007','19','Turkey & Cheese Hoagie Sandwich w/garden corn salad (3/4c)',3,'',12,1),(129,'2025-03-15 05:03:12.291635','110','Asian Chicken Pasta Salad',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(130,'2025-03-15 05:06:42.715857','110','Asian Chicken Pasta Salad',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(131,'2025-03-15 05:06:56.399190','115','Bagel & Jelly',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(132,'2025-03-15 05:07:04.536119','115','Bagel & Jelly',2,'[]',12,1),(133,'2025-03-15 05:07:25.245345','123','Banana Muffin (S)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(134,'2025-03-15 05:07:47.345152','108','Bean & Cheese Burrito w/carrot sticks (1/2c)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(135,'2025-03-15 05:08:20.286425','121','Bean & Cheese Torta w/garden corn salad (3/4c)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(136,'2025-03-15 05:08:47.128774','118','Black Bean Burger w/sweet corn medley (3/4c)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(137,'2025-03-15 05:09:07.616209','112','Caesar Chicken Salad with a Wheat Dinner Roll',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(138,'2025-03-15 05:09:20.516094','104','Chocolate Chip Muffin',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(139,'2025-03-15 05:09:30.737054','105','Cinnamon Toast Crunch & WG Crackers',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(140,'2025-03-15 05:09:47.195098','120','Fiesta Chicken Pasta Salad',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(141,'2025-03-15 05:10:28.991429','117','Fresco Beef w/cilantro rice (3/4c) & sweet corn medley (3/4c)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(142,'2025-03-15 05:11:05.068323','111','Garlic Pesto Cheese Pasta Salad w/carrot sticks (3/4c)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(143,'2025-03-15 05:11:13.050697','111','Garlic Pesto Cheese Pasta Salad w/carrot sticks (3/4c)',2,'[]',12,1),(144,'2025-03-15 05:11:28.629892','106','Hamburger w/sweet potato (3/4c)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(145,'2025-03-15 05:11:46.917660','107','Lemon Garlic Chicken w/cilantro rice (3/4c) & glazed peas & carrots (3/4c)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(146,'2025-03-15 05:12:26.974971','122','Mediterranean Chicken Salad with a Wheat Dinner Roll',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(147,'2025-03-15 05:12:43.144797','113','Oatmeal Cookie (S)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(148,'2025-03-15 05:13:10.035949','109','Roasted Pepper Chicken Hoagie Sandwich w/carrot sticks (3/4c)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(149,'2025-03-15 05:13:31.734067','114','Sausage English Muffin',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(150,'2025-03-15 05:13:48.435657','116','Sloppy Joe on a HB Bun w/sweet corn medley (3/4c)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(151,'2025-03-15 05:14:08.118266','119','Turkey & Cheese Hoagie Sandwich w/garden corn salad (3/4c)',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(152,'2025-03-15 05:15:12.189372','120','Fiesta Chicken Pasta Salad',2,'[{\"changed\": {\"fields\": [\"Image\"]}}]',12,1),(153,'2025-03-15 05:43:04.506873','3','Order 3 - admin (Paid)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',13,1),(154,'2025-03-15 05:47:23.909190','1','admin',2,'[{\"changed\": {\"name\": \"user profile\", \"object\": \"admin\", \"fields\": [\"Lunch programs\"]}}]',4,1),(155,'2025-03-15 05:47:46.411245','1','admin',2,'[{\"changed\": {\"name\": \"user profile\", \"object\": \"admin\", \"fields\": [\"Lunch programs\"]}}]',4,1),(156,'2025-03-15 05:48:29.785480','1','admin',2,'[{\"changed\": {\"name\": \"user profile\", \"object\": \"admin\", \"fields\": [\"Lunch programs\"]}}]',4,1),(157,'2025-03-18 17:12:43.940536','3','TestUser',1,'[{\"added\": {}}]',4,1),(158,'2025-03-18 17:13:15.292595','3','TestUser',2,'[{\"changed\": {\"fields\": [\"First name\", \"Last name\"]}}]',4,1),(159,'2025-03-18 22:03:32.841492','124','Asian Chicken Pasta Salad (Copy)',2,'[]',12,1),(160,'2025-03-18 22:21:44.380905','124','Asian Chicken Pasta Salad (Copy)',3,'',12,1),(161,'2025-03-18 22:29:18.030259','1','Order 1 - admin (Order Received)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',13,1),(162,'2025-03-18 22:29:26.642784','1','Order 1 - admin (Order Received)',2,'[]',13,1),(163,'2025-03-18 22:47:29.784435','3','TestUser',3,'',16,1),(164,'2025-03-19 01:16:45.210169','3','TestUser',3,'',4,1),(165,'2025-03-19 03:20:49.577625','2','SkyHigh',2,'[{\"changed\": {\"name\": \"user profile\", \"object\": \"SkyHigh\", \"fields\": [\"Delivery schedule\"]}}]',4,1),(166,'2025-03-19 04:35:01.977515','1','Stephany Starr',1,'[{\"added\": {}}]',20,1),(167,'2025-03-19 04:35:36.148438','1','admin',2,'[{\"changed\": {\"fields\": [\"First name\", \"Last name\", \"Email address\"]}}]',4,1),(168,'2025-03-19 04:36:11.597753','2','admin',2,'[{\"changed\": {\"fields\": [\"Support rep\"]}}]',16,1),(169,'2025-03-19 04:37:31.322107','1','Stephany Starr',2,'[{\"changed\": {\"fields\": [\"Photo\"]}}]',20,1),(170,'2025-03-19 04:56:39.620855','1','Stephany Starr',2,'[{\"changed\": {\"fields\": [\"Photo\"]}}]',20,1),(171,'2025-03-19 05:51:59.520392','1','AnotherTestUser',1,'[{\"added\": {}}]',21,1),(172,'2025-03-19 05:52:34.377780','1','AnotherTestUser',2,'[{\"changed\": {\"fields\": [\"First name\", \"Last name\", \"Email address\"]}}]',21,1),(173,'2025-03-19 06:32:17.401383','1','admin',2,'[{\"changed\": {\"name\": \"user profile\", \"object\": \"admin\", \"fields\": [\"Support rep\", \"Lunch programs\", \"Delivery schedule\"]}}]',4,1),(174,'2025-03-19 06:32:39.899890','2','SkyHigh',2,'[{\"changed\": {\"name\": \"user profile\", \"object\": \"SkyHigh\", \"fields\": [\"Support rep\", \"Lunch programs\", \"Delivery schedule\"]}}]',4,1),(175,'2025-03-19 06:48:33.893840','125','Asian Chicken Pasta Salad (Copy)',3,'',12,1),(176,'2025-03-19 06:49:36.652293','110','Asian Chicken Pasta Salad',2,'[{\"changed\": {\"fields\": [\"Plate portions\"]}}]',12,1),(177,'2025-03-19 07:00:29.301037','1','admin',2,'[]',4,1),(178,'2025-03-19 07:12:36.740491','104','Chocolate Chip Muffin',2,'[{\"changed\": {\"fields\": [\"Plate portions\"]}}]',12,1),(179,'2025-03-19 07:21:00.407301','2','Order 2 - admin (Paid)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',13,1),(180,'2025-03-19 16:37:12.356882','110','Asian Chicken Pasta Salad',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(181,'2025-03-19 16:37:22.071090','115','Bagel & Jelly',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(182,'2025-03-19 16:37:30.235705','123','Banana Muffin (S)',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(183,'2025-03-19 16:37:41.341171','108','Bean & Cheese Burrito w/carrot sticks (1/2c)',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(184,'2025-03-19 16:37:53.862306','121','Bean & Cheese Torta w/garden corn salad (3/4c)',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(185,'2025-03-19 20:06:42.390070','1','admin',2,'[{\"changed\": {\"name\": \"user profile\", \"object\": \"admin\", \"fields\": [\"Route number\"]}}]',4,1),(186,'2025-03-19 20:06:53.092574','1','admin',2,'[{\"changed\": {\"name\": \"user profile\", \"object\": \"admin\", \"fields\": [\"Route number\"]}}]',4,1),(187,'2025-03-19 20:14:04.338930','1','admin',2,'[{\"changed\": {\"name\": \"user profile\", \"object\": \"admin\", \"fields\": [\"Delivery type\", \"Additional notes\"]}}]',4,1),(188,'2025-03-19 20:14:14.781596','1','admin',2,'[]',4,1),(189,'2025-03-19 21:45:23.006602','123','Banana Muffin (S)',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(190,'2025-03-19 22:22:14.535941','6','Order 6 - admin (Pending)',3,'',13,1),(191,'2025-03-19 22:22:14.542179','5','Order 5 - admin (Pending)',3,'',13,1),(192,'2025-03-19 22:22:14.547756','4','Order 4 - admin (Pending)',3,'',13,1),(193,'2025-03-19 22:22:14.553606','3','Order 3 - admin (Pending)',3,'',13,1),(194,'2025-03-19 22:22:14.559159','2','Order 2 - admin (Paid)',3,'',13,1),(195,'2025-03-19 22:22:14.565705','1','Order 1 - admin (Order Received)',3,'',13,1),(196,'2025-03-20 04:55:05.433145','7','Order 7 - admin (Pending)',3,'',13,1),(197,'2025-03-20 04:55:54.533044','104','Chocolate Chip Muffin',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(198,'2025-03-20 04:56:05.320359','105','Cinnamon Toast Crunch & WG Crackers',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(199,'2025-03-20 04:56:23.921312','106','Hamburger w/sweet potato (3/4c)',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(200,'2025-03-20 04:56:35.850252','107','Lemon Garlic Chicken w/cilantro rice (3/4c) & glazed peas & carrots (3/4c)',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(201,'2025-03-20 04:56:48.765533','108','Bean & Cheese Burrito w/carrot sticks (1/2c)',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(202,'2025-03-20 04:57:02.102312','109','Roasted Pepper Chicken Hoagie Sandwich w/carrot sticks (3/4c)',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(203,'2025-03-20 04:57:10.964247','110','Asian Chicken Pasta Salad',2,'[]',12,1),(204,'2025-03-20 04:57:22.360740','111','Garlic Pesto Cheese Pasta Salad w/carrot sticks (3/4c)',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(205,'2025-03-20 04:57:34.018957','113','Oatmeal Cookie (S)',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(206,'2025-03-20 04:57:43.731151','112','Caesar Chicken Salad with a Wheat Dinner Roll',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(207,'2025-03-20 04:57:56.430884','114','Sausage English Muffin',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(208,'2025-03-20 04:58:02.700399','115','Bagel & Jelly',2,'[]',12,1),(209,'2025-03-20 04:58:12.902723','116','Sloppy Joe on a HB Bun w/sweet corn medley (3/4c)',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(210,'2025-03-20 04:58:26.727518','117','Fresco Beef w/cilantro rice (3/4c) & sweet corn medley (3/4c)',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(211,'2025-03-20 04:58:35.581461','118','Black Bean Burger w/sweet corn medley (3/4c)',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(212,'2025-03-20 04:58:47.361684','119','Turkey & Cheese Hoagie Sandwich w/garden corn salad (3/4c)',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(213,'2025-03-20 04:58:57.974732','120','Fiesta Chicken Pasta Salad',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(214,'2025-03-20 04:59:07.250794','121','Bean & Cheese Torta w/garden corn salad (3/4c)',2,'[]',12,1),(215,'2025-03-20 04:59:21.127089','123','Banana Muffin (S)',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(216,'2025-03-20 04:59:29.653407','122','Mediterranean Chicken Salad with a Wheat Dinner Roll',2,'[{\"changed\": {\"fields\": [\"available_date\"]}}]',12,1),(217,'2025-03-20 18:24:45.682309','8','Order 8 - admin (Pending)',2,'[]',13,1),(218,'2025-03-20 18:24:56.789241','8','Order 8 - admin (Pending)',3,'',13,1),(219,'2025-03-20 18:26:05.117161','9','Order 9 - admin (Pending)',2,'[{\"changed\": {\"name\": \"order item\", \"object\": \"1x Chocolate Chip Muffin in Order #9 (Date: 2025-03-03, Delivery: 2025-03-02)\", \"fields\": [\"Delivery date\"]}}]',13,1),(220,'2025-03-20 18:55:51.815737','9','Order 9 - admin (Order Received)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',13,1),(221,'2025-03-20 21:02:47.558510','1','admin',2,'[{\"changed\": {\"name\": \"user profile\", \"object\": \"admin\", \"fields\": [\"Lunch programs\"]}}]',4,1),(222,'2025-03-20 21:05:56.922874','1','admin',2,'[{\"changed\": {\"name\": \"user profile\", \"object\": \"admin\", \"fields\": [\"Lunch programs\"]}}]',4,1),(223,'2025-03-20 21:07:13.696827','10','Order 10 - admin (Paid)',2,'[{\"changed\": {\"fields\": [\"Status\"]}}]',13,1),(224,'2025-03-20 21:07:42.167859','10','Order 10 - admin (Paid)',2,'[{\"changed\": {\"name\": \"order item\", \"object\": \"400x Hamburger w/sweet potato (3/4c) in Order #10 (Date: 2025-03-03, Delivery: 2025-02-26)\", \"fields\": [\"Quantity\"]}}]',13,1),(225,'2025-03-20 21:08:20.891844','10','Order 10 - admin (Paid)',2,'[{\"changed\": {\"name\": \"order item\", \"object\": \"200x Chocolate Chip Muffin in Order #10 (Date: 2025-03-03, Delivery: 2025-02-26)\", \"fields\": [\"Delivery date\"]}}, {\"changed\": {\"name\": \"order item\", \"object\": \"50x Cinnamon Toast Crunch & WG Crackers in Order #10 (Date: 2025-03-03, Delivery: 2025-02-26)\", \"fields\": [\"Delivery date\"]}}, {\"changed\": {\"name\": \"order item\", \"object\": \"400x Hamburger w/sweet potato (3/4c) in Order #10 (Date: 2025-03-03, Delivery: 2025-02-26)\", \"fields\": [\"Delivery date\"]}}]',13,1),(226,'2025-03-20 21:08:53.125664','10','Order 10 - admin (Paid)',2,'[{\"changed\": {\"name\": \"order item\", \"object\": \"200x Chocolate Chip Muffin in Order #10 (Date: 2025-03-03, Delivery: 2025-02-26)\", \"fields\": [\"Delivery date\"]}}, {\"changed\": {\"name\": \"order item\", \"object\": \"50x Cinnamon Toast Crunch & WG Crackers in Order #10 (Date: 2025-03-03, Delivery: 2025-02-26)\", \"fields\": [\"Delivery date\"]}}, {\"changed\": {\"name\": \"order item\", \"object\": \"400x Hamburger w/sweet potato (3/4c) in Order #10 (Date: 2025-03-03, Delivery: 2025-02-26)\", \"fields\": [\"Delivery date\"]}}, {\"changed\": {\"name\": \"order item\", \"object\": \"50x Roasted Pepper Chicken Hoagie Sandwich w/carrot sticks (3/4c) in Order #10 (Date: 2025-03-03, Delivery: 2025-02-26)\", \"fields\": [\"Delivery date\"]}}]',13,1),(227,'2025-03-20 21:16:13.752406','126','Bean & Cheese Burrito w/carrot sticks (1/2c)',2,'[{\"changed\": {\"fields\": [\"Plate name\", \"available_date\"]}}]',12,1),(228,'2025-03-21 01:03:47.672944','9','Order 9 - admin (Order Received)',3,'',13,1),(229,'2025-03-21 17:12:55.608223','12','Order 12 - admin (Pending)',3,'',13,1),(230,'2025-03-21 17:12:55.620469','11','Order 11 - admin (Pending)',3,'',13,1),(231,'2025-03-21 17:12:55.628372','10','Order 10 - admin (Paid)',3,'',13,1),(232,'2025-03-21 17:57:22.146804','1','School System 1',1,'[{\"added\": {}}]',3,1),(233,'2025-03-21 17:57:30.627130','2','School System 2',1,'[{\"added\": {}}]',3,1),(234,'2025-03-21 17:58:16.815814','1','School 1.1',1,'[{\"added\": {}}]',23,1),(235,'2025-03-21 17:58:30.499334','2','School 1.2',1,'[{\"added\": {}}]',23,1),(236,'2025-03-21 17:58:41.208885','3','School 1.3',1,'[{\"added\": {}}]',23,1),(237,'2025-03-21 17:58:54.026020','4','School 2.1',1,'[{\"added\": {}}]',23,1),(238,'2025-03-21 17:59:06.286986','5','School 2.2',1,'[{\"added\": {}}]',23,1),(239,'2025-03-21 17:59:20.819232','6','School 2.3',1,'[{\"added\": {}}]',23,1),(240,'2025-03-21 19:05:57.313346','1','School 1.1',1,'[{\"added\": {}}]',23,1),(241,'2025-03-21 19:06:22.733121','2','School 1.2',1,'[{\"added\": {}}]',23,1),(242,'2025-03-21 19:06:31.048118','2','School 1.2',2,'[{\"changed\": {\"fields\": [\"Lunch programs\"]}}]',23,1),(243,'2025-03-21 20:01:49.986445','3','School 2.1',1,'[{\"added\": {}}]',23,1),(244,'2025-03-21 20:02:02.048005','1','admin',2,'[{\"changed\": {\"fields\": [\"schools\"]}}]',4,1),(245,'2025-03-21 20:02:24.193417','3','School 2.1',2,'[{\"changed\": {\"fields\": [\"Users\"]}}]',23,1),(246,'2025-03-21 20:37:14.698761','2','School 1.2',2,'[{\"changed\": {\"fields\": [\"Delivery schedule\"]}}]',23,1),(247,'2025-03-21 20:58:02.155340','13','Order 13 - admin (Pending)',2,'[{\"changed\": {\"fields\": [\"School\"]}}]',13,1),(248,'2025-03-21 21:05:40.567678','110','Asian Chicken Pasta Salad',2,'[{\"changed\": {\"fields\": [\"Lunch programs\"]}}]',12,1),(249,'2025-03-21 21:05:52.650116','115','Bagel & Jelly',2,'[{\"changed\": {\"fields\": [\"Lunch programs\"]}}]',12,1),(250,'2025-03-21 21:07:09.909569','2','School 1.2',2,'[{\"changed\": {\"fields\": [\"Lunch programs\"]}}]',23,1),(251,'2025-03-22 06:21:06.954513','3','School 2.1',2,'[{\"changed\": {\"fields\": [\"Lunch programs\", \"Delivery schedule\", \"Route number\", \"Delivery type\"]}}]',23,1),(252,'2025-03-22 06:21:34.605026','2','SkyHigh',2,'[{\"changed\": {\"fields\": [\"Staff status\"]}}]',4,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(23,'auth','school'),(4,'auth','user'),(5,'contenttypes','contenttype'),(14,'food_order_api','cart'),(20,'food_order_api','customersupportprofile'),(21,'food_order_api','customuser'),(17,'food_order_api','deliveryschedule'),(11,'food_order_api','fooditem'),(7,'food_order_api','foodtype'),(8,'food_order_api','lunchprogram'),(9,'food_order_api','menudate'),(12,'food_order_api','menuitem'),(15,'food_order_api','orderitem'),(10,'food_order_api','plateportion'),(22,'food_order_api','school'),(18,'food_order_api','userdeliveryschedule'),(19,'food_order_api','userlunchprogram'),(13,'food_order_api','userorder'),(16,'food_order_api','userprofile'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2025-03-14 04:50:37.209524'),(2,'auth','0001_initial','2025-03-14 04:50:37.959156'),(3,'admin','0001_initial','2025-03-14 04:50:38.133922'),(4,'admin','0002_logentry_remove_auto_add','2025-03-14 04:50:38.151326'),(5,'admin','0003_logentry_add_action_flag_choices','2025-03-14 04:50:38.162841'),(6,'contenttypes','0002_remove_content_type_name','2025-03-14 04:50:38.269477'),(7,'auth','0002_alter_permission_name_max_length','2025-03-14 04:50:38.359577'),(8,'auth','0003_alter_user_email_max_length','2025-03-14 04:50:38.450729'),(9,'auth','0004_alter_user_username_opts','2025-03-14 04:50:38.464593'),(10,'auth','0005_alter_user_last_login_null','2025-03-14 04:50:38.527368'),(11,'auth','0006_require_contenttypes_0002','2025-03-14 04:50:38.534026'),(12,'auth','0007_alter_validators_add_error_messages','2025-03-14 04:50:38.547290'),(13,'auth','0008_alter_user_username_max_length','2025-03-14 04:50:38.625630'),(14,'auth','0009_alter_user_last_name_max_length','2025-03-14 04:50:38.701694'),(15,'auth','0010_alter_group_name_max_length','2025-03-14 04:50:38.775323'),(16,'auth','0011_update_proxy_permissions','2025-03-14 04:50:38.788214'),(17,'auth','0012_alter_user_first_name_max_length','2025-03-14 04:50:38.864874'),(23,'sessions','0001_initial','2025-03-14 04:50:40.458125'),(31,'food_order_api','0001_initial','2025-03-18 20:21:16.919077'),(35,'food_order_api','0002_customersupportprofile_userprofile_support_rep','2025-03-19 04:30:57.381854'),(36,'food_order_api','0003_customuser_delete_userprofile','2025-03-19 05:48:51.587816'),(37,'auth','0013_user_support_rep','2025-03-19 06:01:37.650113'),(38,'auth','0014_remove_user_support_rep','2025-03-19 06:30:19.830300'),(39,'food_order_api','0004_userprofile','2025-03-19 06:30:20.619078'),(40,'food_order_api','0005_customuser_route_number','2025-03-19 19:57:26.230035'),(41,'food_order_api','0006_remove_customuser_route_number_and_more','2025-03-19 20:06:14.762022'),(42,'food_order_api','0007_userprofile_additional_notes_and_more','2025-03-19 20:13:02.502360'),(43,'food_order_api','0008_orderitem_delivery_date','2025-03-20 18:07:13.363725'),(44,'food_order_api','0009_school','2025-03-21 17:40:07.207866'),(45,'auth','0015_school','2025-03-21 17:43:48.967716'),(46,'food_order_api','0010_delete_school','2025-03-21 17:43:49.009031'),(47,'auth','0016_delete_school','2025-03-21 18:43:45.702688'),(48,'food_order_api','0011_remove_userprofile_delivery_schedule_and_more','2025-03-21 18:43:46.549923'),(49,'food_order_api','0012_delete_school','2025-03-21 19:04:33.293485'),(50,'auth','0017_school','2025-03-21 19:04:34.363244'),(51,'food_order_api','0013_userorder_school','2025-03-21 20:57:34.314662');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('1z1nnqf4ja4u9s811uwhgq8n5plde22z','.eJxVjDsOgzAQRO_iOrLwD3tTpucMlpddxyQRljBUUe4ekCiScua9mbeIaVtL3BovcSJxFUpcfjtM45PnA9Ajzfcqxzqvy4TyUORJmxwq8et2un8HJbWyry1k9KbXRF0I3iJllRksBMfArk-hC3Z0njFr0i4pvScEMEqjz6CN-HwB4Uk3lQ:1tv0cV:vFPY2xJntnmtwS3PQfEnpXzaiYjGkvEBUggY_gOUzWk','2025-04-02 21:06:35.538520'),('3nt9kh3zyfr5v3e0z7kr5yi95suizewu','.eJxVjDsOwjAQBe_iGlm25V8o6TmDtetd4wBypDipEHcHSymgeM2b0bxEgn2rae-8ppnEWWhx-v0Q8oPbAHSHdltkXtq2ziiHIg_a5XUhfl4O9y9QodeR9QpsUEVpTVCciZCzQ_9dsAUNOaaAU4xWeYOWouaAkX3EQlNh58X7A-l_OGw:1tvf62:NQ3HNDv68pGVTcqU8YGo_HcSd-GGMwfAEW72BlhU4RY','2025-04-04 16:19:46.142303'),('5v24p6q8y27lqy9xnsfuk9igf6v5dg13','.eJxVjDsOgzAQBe_iOrJs5B-U6XMGa9e7jkkQljBUKHcPSBRJ8Zo3o9lFhG0tcWu8xJHEILS4_X4I6c3zCegF87PKVOd1GVGeirxok49KPN0v9y9QoJUz6xQYr7LSmiDbLkBKFt0xbzJ2ZJk89iEY5To0FDR7DOwCZuozW3dEG0-cVqbYUql1EoP-fAGadD93:1tvk7W:FqqBerfLEta_uP4PydqHu9SpHOK4kUZ8Yp822GMsC-Y','2025-04-04 21:41:38.254083'),('8v67l6cf2ker7onf1cow79tz3bj9jncd','.eJxVjDsOgzAQRO_iOrLwD3tTpucMlpddxyQRljBUUe4ekCiScua9mbeIaVtL3BovcSJxFUpcfjtM45PnA9Ajzfcqxzqvy4TyUORJmxwq8et2un8HJbWyry1k9KbXRF0I3iJllRksBMfArk-hC3Z0njFr0i4pvScEMEqjz6CN-HwB4Uk3lQ:1tub89:Dn4Li0Ku4MqKdde_Kf64rC3Alj1sQLRkadIop9oO1cU','2025-04-01 17:53:33.710600'),('hrtk6zzbq2v40fvcuan3okdsoesywlww','.eJxVjDsOgzAQBe_iOrJs5B-U6XMGa9e7jkkQljBUKHcPSBRJ8Zo3o9lFhG0tcWu8xJHEILS4_X4I6c3zCegF87PKVOd1GVGeirxok49KPN0v9y9QoJUz6xQYr7LSmiDbLkBKFt0xbzJ2ZJk89iEY5To0FDR7DOwCZuozW3dEG0-cVqbYUql1EoP-fAGadD93:1tvvUG:Msi6iaCATQVFV7lcyvsLpaq5tNayibtN4msd-2Ko_xU','2025-04-05 09:49:52.690679'),('ki7c27n410xkbw6nyxe4ela9u5live3i','.eJxVjEsOwjAMRO-SNYr6MXHCkn3PENmOoQWUSE27QtydVuoCdqN5b-ZtIq3LGNeqc5ySuZjOnH47Jnlq3kF6UL4XKyUv88R2V-xBqx1K0tf1cP8ORqrjtg7ILVLLPaAyBCfoHSaETlQVgJru7IQRJEi49Z4SN-yk9dB43nJvPl_hmzgH:1tt9uS:iaddijczgJd7dKvvOW8VMCG_wICNcF46S_q7Sr7L1bE','2025-03-28 18:37:28.612390'),('rdmftb4dgj7vv32jslt2p7obwspl4bnt','.eJxVjDsOwjAQBe_iGlm25V8o6TmDtetd4wBypDipEHcHSymgeM2b0bxEgn2rae-8ppnEWWhx-v0Q8oPbAHSHdltkXtq2ziiHIg_a5XUhfl4O9y9QodeR9QpsUEVpTVCciZCzQ_9dsAUNOaaAU4xWeYOWouaAkX3EQlNh58X7A-l_OGw:1tvsBm:olh-1PAxSq9GX0fseDgk7oMXSnd5r69WchU_dbTnxls','2025-04-05 06:18:34.310334'),('v96qxbgycfo5bna6qhaylsiy6hreiidj','.eJxVjDsOwjAQBe_iGlm25V8o6TmDtetd4wBypDipEHcHSymgeM2b0bxEgn2rae-8ppnEWWhx-v0Q8oPbAHSHdltkXtq2ziiHIg_a5XUhfl4O9y9QodeR9QpsUEVpTVCciZCzQ_9dsAUNOaaAU4xWeYOWouaAkX3EQlNh58X7A-l_OGw:1tvsIY:4cJS8geBGqFH6mvHYZm6d27EVkOqm7tCCXjl4VpedI4','2025-04-05 06:25:34.098201');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_cart`
--

DROP TABLE IF EXISTS `food_order_api_cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_cart` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `menu_item_id` bigint NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `menu_item_id` (`menu_item_id`),
  CONSTRAINT `food_order_api_cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `food_order_api_cart_ibfk_2` FOREIGN KEY (`menu_item_id`) REFERENCES `food_order_api_menuitem` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_cart`
--

LOCK TABLES `food_order_api_cart` WRITE;
/*!40000 ALTER TABLE `food_order_api_cart` DISABLE KEYS */;
/*!40000 ALTER TABLE `food_order_api_cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_customersupportprofile`
--

DROP TABLE IF EXISTS `food_order_api_customersupportprofile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_customersupportprofile` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(254) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `extension` varchar(10) DEFAULT NULL,
  `photo` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_customersupportprofile`
--

LOCK TABLES `food_order_api_customersupportprofile` WRITE;
/*!40000 ALTER TABLE `food_order_api_customersupportprofile` DISABLE KEYS */;
INSERT INTO `food_order_api_customersupportprofile` VALUES (1,'Stephany','Starr','info@digitalonbrand.com','8184152003',NULL,'support_profiles/images.jpg');
/*!40000 ALTER TABLE `food_order_api_customersupportprofile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_customuser`
--

DROP TABLE IF EXISTS `food_order_api_customuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_customuser` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `support_rep_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `food_order_api_custo_support_rep_id_4c897b78_fk_food_orde` (`support_rep_id`),
  CONSTRAINT `food_order_api_custo_support_rep_id_4c897b78_fk_food_orde` FOREIGN KEY (`support_rep_id`) REFERENCES `food_order_api_customersupportprofile` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_customuser`
--

LOCK TABLES `food_order_api_customuser` WRITE;
/*!40000 ALTER TABLE `food_order_api_customuser` DISABLE KEYS */;
INSERT INTO `food_order_api_customuser` VALUES (1,'pbkdf2_sha256$600000$7lU0KrmaSYNghj89Pwjptn$T5gZw4XSwpKM78ShLDN6vsAmuNt9FAvxqebCqJ5iZ+A=',NULL,0,'AnotherTestUser','Pablo','Pasqual','info@digitalonbrand.com',0,1,'2025-03-19 05:51:58.000000',NULL);
/*!40000 ALTER TABLE `food_order_api_customuser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_customuser_delivery_schedule`
--

DROP TABLE IF EXISTS `food_order_api_customuser_delivery_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_customuser_delivery_schedule` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customuser_id` bigint NOT NULL,
  `deliveryschedule_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `food_order_api_customuse_customuser_id_deliverysc_cf6f0bc3_uniq` (`customuser_id`,`deliveryschedule_id`),
  KEY `food_order_api_custo_deliveryschedule_id_935573b7_fk_food_orde` (`deliveryschedule_id`),
  CONSTRAINT `food_order_api_custo_customuser_id_85bd684e_fk_food_orde` FOREIGN KEY (`customuser_id`) REFERENCES `food_order_api_customuser` (`id`),
  CONSTRAINT `food_order_api_custo_deliveryschedule_id_935573b7_fk_food_orde` FOREIGN KEY (`deliveryschedule_id`) REFERENCES `food_order_api_deliveryschedule` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_customuser_delivery_schedule`
--

LOCK TABLES `food_order_api_customuser_delivery_schedule` WRITE;
/*!40000 ALTER TABLE `food_order_api_customuser_delivery_schedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `food_order_api_customuser_delivery_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_customuser_groups`
--

DROP TABLE IF EXISTS `food_order_api_customuser_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_customuser_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customuser_id` bigint NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `food_order_api_customuse_customuser_id_group_id_09744335_uniq` (`customuser_id`,`group_id`),
  KEY `food_order_api_custo_group_id_4c5c322c_fk_auth_grou` (`group_id`),
  CONSTRAINT `food_order_api_custo_customuser_id_2a2491a1_fk_food_orde` FOREIGN KEY (`customuser_id`) REFERENCES `food_order_api_customuser` (`id`),
  CONSTRAINT `food_order_api_custo_group_id_4c5c322c_fk_auth_grou` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_customuser_groups`
--

LOCK TABLES `food_order_api_customuser_groups` WRITE;
/*!40000 ALTER TABLE `food_order_api_customuser_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `food_order_api_customuser_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_customuser_lunch_programs`
--

DROP TABLE IF EXISTS `food_order_api_customuser_lunch_programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_customuser_lunch_programs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customuser_id` bigint NOT NULL,
  `lunchprogram_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `food_order_api_customuse_customuser_id_lunchprogr_f1d53aa0_uniq` (`customuser_id`,`lunchprogram_id`),
  KEY `food_order_api_custo_lunchprogram_id_5fec5ca1_fk_food_orde` (`lunchprogram_id`),
  CONSTRAINT `food_order_api_custo_customuser_id_1795a04d_fk_food_orde` FOREIGN KEY (`customuser_id`) REFERENCES `food_order_api_customuser` (`id`),
  CONSTRAINT `food_order_api_custo_lunchprogram_id_5fec5ca1_fk_food_orde` FOREIGN KEY (`lunchprogram_id`) REFERENCES `food_order_api_lunchprogram` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_customuser_lunch_programs`
--

LOCK TABLES `food_order_api_customuser_lunch_programs` WRITE;
/*!40000 ALTER TABLE `food_order_api_customuser_lunch_programs` DISABLE KEYS */;
/*!40000 ALTER TABLE `food_order_api_customuser_lunch_programs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_customuser_user_permissions`
--

DROP TABLE IF EXISTS `food_order_api_customuser_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_customuser_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customuser_id` bigint NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `food_order_api_customuse_customuser_id_permission_eddae436_uniq` (`customuser_id`,`permission_id`),
  KEY `food_order_api_custo_permission_id_9b0eea33_fk_auth_perm` (`permission_id`),
  CONSTRAINT `food_order_api_custo_customuser_id_47ca7eb6_fk_food_orde` FOREIGN KEY (`customuser_id`) REFERENCES `food_order_api_customuser` (`id`),
  CONSTRAINT `food_order_api_custo_permission_id_9b0eea33_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_customuser_user_permissions`
--

LOCK TABLES `food_order_api_customuser_user_permissions` WRITE;
/*!40000 ALTER TABLE `food_order_api_customuser_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `food_order_api_customuser_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_deliveryschedule`
--

DROP TABLE IF EXISTS `food_order_api_deliveryschedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_deliveryschedule` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_deliveryschedule`
--

LOCK TABLES `food_order_api_deliveryschedule` WRITE;
/*!40000 ALTER TABLE `food_order_api_deliveryschedule` DISABLE KEYS */;
INSERT INTO `food_order_api_deliveryschedule` VALUES (5,'Friday'),(1,'Monday'),(4,'Thursday'),(2,'Tuesday'),(3,'Wednesday');
/*!40000 ALTER TABLE `food_order_api_deliveryschedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_foodtype`
--

DROP TABLE IF EXISTS `food_order_api_foodtype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_foodtype` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_foodtype`
--

LOCK TABLES `food_order_api_foodtype` WRITE;
/*!40000 ALTER TABLE `food_order_api_foodtype` DISABLE KEYS */;
/*!40000 ALTER TABLE `food_order_api_foodtype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_lunchprogram`
--

DROP TABLE IF EXISTS `food_order_api_lunchprogram`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_lunchprogram` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_lunchprogram`
--

LOCK TABLES `food_order_api_lunchprogram` WRITE;
/*!40000 ALTER TABLE `food_order_api_lunchprogram` DISABLE KEYS */;
INSERT INTO `food_order_api_lunchprogram` VALUES (5,'CACFP Adults'),(3,'CACFP K-12'),(4,'CACFP Pre-K'),(2,'NSLP 9-12'),(1,'NSLP K-8');
/*!40000 ALTER TABLE `food_order_api_lunchprogram` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_menudate`
--

DROP TABLE IF EXISTS `food_order_api_menudate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_menudate` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_menudate`
--

LOCK TABLES `food_order_api_menudate` WRITE;
/*!40000 ALTER TABLE `food_order_api_menudate` DISABLE KEYS */;
/*!40000 ALTER TABLE `food_order_api_menudate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_menuitem`
--

DROP TABLE IF EXISTS `food_order_api_menuitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_menuitem` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `plate_name` varchar(255) NOT NULL,
  `meal_type` varchar(50) NOT NULL,
  `is_new` tinyint(1) NOT NULL,
  `available_date` date DEFAULT NULL,
  `image` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_menuitem`
--

LOCK TABLES `food_order_api_menuitem` WRITE;
/*!40000 ALTER TABLE `food_order_api_menuitem` DISABLE KEYS */;
INSERT INTO `food_order_api_menuitem` VALUES (104,'Chocolate Chip Muffin','Breakfast',0,'2025-03-03','menu_images/bakery-style-chocolate-chip-muffins-1-of-1-500x375.webp'),(105,'Cinnamon Toast Crunch & WG Crackers','Breakfast',1,'2025-03-03','menu_images/image_fx__21.jpg'),(106,'Hamburger w/sweet potato (3/4c)','Hot Meal',0,'2025-03-03','menu_images/image_fx__22.jpg'),(107,'Lemon Garlic Chicken w/cilantro rice (3/4c) & glazed peas & carrots (3/4c)','Hot Meal',0,'2025-03-03','menu_images/image_fx__5.jpg'),(108,'Bean & Cheese Burrito w/carrot sticks (1/2c)','Hot Vegetarian',0,'2025-03-03','menu_images/image_fx__6.jpg'),(109,'Roasted Pepper Chicken Hoagie Sandwich w/carrot sticks (3/4c)','Cold Meal',0,'2025-03-03','menu_images/image_fx__7.jpg'),(110,'Asian Chicken Pasta Salad','Cold Pastas',0,'2025-03-03','menu_images/image_fx__8.jpg'),(111,'Garlic Pesto Cheese Pasta Salad w/carrot sticks (3/4c)','Cold Vegetarian',0,'2025-03-03','menu_images/image_fx__9.jpg'),(112,'Caesar Chicken Salad with a Wheat Dinner Roll','Daily Salad',0,'2025-03-03','menu_images/image_fx__10.jpg'),(113,'Oatmeal Cookie (S)','Snack',0,'2025-03-03','menu_images/oatmeal_cookie.jpg'),(114,'Sausage English Muffin','Breakfast',0,'2025-03-04','menu_images/image_fx__11.jpg'),(115,'Bagel & Jelly','Breakfast',0,'2025-03-04','menu_images/image_fx__12.jpg'),(116,'Sloppy Joe on a HB Bun w/sweet corn medley (3/4c)','Hot Meal',0,'2025-03-04','menu_images/image_fx__13.jpg'),(117,'Fresco Beef w/cilantro rice (3/4c) & sweet corn medley (3/4c)','Hot Meal',0,'2025-03-04','menu_images/image_fx__14.jpg'),(118,'Black Bean Burger w/sweet corn medley (3/4c)','Hot Vegetarian',0,'2025-03-04','menu_images/image_fx__15.jpg'),(119,'Turkey & Cheese Hoagie Sandwich w/garden corn salad (3/4c)','Cold Meal',0,'2025-03-04','menu_images/image_fx__16.jpg'),(120,'Fiesta Chicken Pasta Salad','Cold Pastas',0,'2025-03-04','menu_images/image_fx__17.jpg'),(121,'Bean & Cheese Torta w/garden corn salad (3/4c)','Cold Vegetarian',0,'2025-03-04','menu_images/image_fx__18.jpg'),(122,'Mediterranean Chicken Salad with a Wheat Dinner Roll','Daily Salad',0,'2025-03-04','menu_images/image_fx__19_TDl5XwY.jpg'),(123,'Banana Muffin (S)','Snack',0,'2025-03-04','menu_images/image_fx__20.jpg'),(126,'Bean & Cheese Burrito w/carrot sticks (1/2c)','Hot Vegetarian',1,'2025-03-20','menu_images/image_fx__6.jpg');
/*!40000 ALTER TABLE `food_order_api_menuitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_menuitem_lunch_programs`
--

DROP TABLE IF EXISTS `food_order_api_menuitem_lunch_programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_menuitem_lunch_programs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `menuitem_id` bigint NOT NULL,
  `lunchprogram_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `food_order_api_menuitem__menuitem_id_lunchprogram_ccf7a802_uniq` (`menuitem_id`,`lunchprogram_id`),
  KEY `food_order_api_menui_lunchprogram_id_0cce1cc7_fk_food_orde` (`lunchprogram_id`),
  CONSTRAINT `food_order_api_menui_lunchprogram_id_0cce1cc7_fk_food_orde` FOREIGN KEY (`lunchprogram_id`) REFERENCES `food_order_api_lunchprogram` (`id`),
  CONSTRAINT `food_order_api_menui_menuitem_id_aa7ea628_fk_food_orde` FOREIGN KEY (`menuitem_id`) REFERENCES `food_order_api_menuitem` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_menuitem_lunch_programs`
--

LOCK TABLES `food_order_api_menuitem_lunch_programs` WRITE;
/*!40000 ALTER TABLE `food_order_api_menuitem_lunch_programs` DISABLE KEYS */;
INSERT INTO `food_order_api_menuitem_lunch_programs` VALUES (8,104,1),(9,104,2),(10,104,3),(11,104,4),(12,104,5),(13,105,1),(14,105,2),(15,105,3),(16,105,4),(17,105,5),(18,106,1),(19,107,1),(20,108,1),(21,109,1),(22,110,1),(27,111,1),(28,112,1),(29,112,2),(30,112,3),(31,112,4),(32,112,5),(33,113,1),(34,113,2),(35,113,3),(36,113,4),(37,113,5),(38,114,1),(39,114,2),(40,114,3),(41,114,4),(42,114,5),(44,115,2),(48,116,1),(49,117,1),(50,118,1),(51,119,1),(52,120,1),(53,120,2),(54,120,3),(55,120,4),(56,120,5),(57,121,1),(58,122,1),(59,122,2),(60,122,3),(61,122,4),(62,122,5),(63,123,1),(64,123,2),(65,123,3),(66,123,4),(67,123,5);
/*!40000 ALTER TABLE `food_order_api_menuitem_lunch_programs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_menuitem_plate_portions`
--

DROP TABLE IF EXISTS `food_order_api_menuitem_plate_portions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_menuitem_plate_portions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `menuitem_id` bigint NOT NULL,
  `plateportion_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `menuitem_id` (`menuitem_id`),
  KEY `plateportion_id` (`plateportion_id`),
  CONSTRAINT `food_order_api_menuitem_plate_portions_ibfk_1` FOREIGN KEY (`menuitem_id`) REFERENCES `food_order_api_menuitem` (`id`) ON DELETE CASCADE,
  CONSTRAINT `food_order_api_menuitem_plate_portions_ibfk_2` FOREIGN KEY (`plateportion_id`) REFERENCES `food_order_api_plateportion` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_menuitem_plate_portions`
--

LOCK TABLES `food_order_api_menuitem_plate_portions` WRITE;
/*!40000 ALTER TABLE `food_order_api_menuitem_plate_portions` DISABLE KEYS */;
INSERT INTO `food_order_api_menuitem_plate_portions` VALUES (1,110,1),(2,110,2),(3,110,3),(4,104,1);
/*!40000 ALTER TABLE `food_order_api_menuitem_plate_portions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_orderitem`
--

DROP TABLE IF EXISTS `food_order_api_orderitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_orderitem` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `menu_item_id` bigint NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `menu_item_date` date DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `menu_item_id` (`menu_item_id`),
  CONSTRAINT `food_order_api_orderitem_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `food_order_api_userorder` (`id`) ON DELETE CASCADE,
  CONSTRAINT `food_order_api_orderitem_ibfk_2` FOREIGN KEY (`menu_item_id`) REFERENCES `food_order_api_menuitem` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_orderitem`
--

LOCK TABLES `food_order_api_orderitem` WRITE;
/*!40000 ALTER TABLE `food_order_api_orderitem` DISABLE KEYS */;
INSERT INTO `food_order_api_orderitem` VALUES (81,13,104,1,'2025-03-03','2025-02-26'),(82,15,107,1,'2025-03-03','2025-02-27'),(83,15,105,1,'2025-03-03','2025-02-27'),(84,16,106,1,'2025-03-03','2025-02-27'),(85,17,104,1,'2025-03-03','2025-02-27'),(86,17,107,1,'2025-03-03','2025-02-27'),(87,17,113,3,'2025-03-03','2025-02-27'),(88,18,104,100,'2025-03-03','2025-02-27'),(89,18,106,200,'2025-03-03','2025-02-27'),(90,18,107,360,'2025-03-03','2025-02-27'),(91,18,110,360,'2025-03-03','2025-02-27'),(92,19,106,300,'2025-03-03','2025-02-27'),(93,19,108,280,'2025-03-03','2025-02-27'),(94,19,113,280,'2025-03-03','2025-02-27');
/*!40000 ALTER TABLE `food_order_api_orderitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_plateportion`
--

DROP TABLE IF EXISTS `food_order_api_plateportion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_plateportion` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_plateportion`
--

LOCK TABLES `food_order_api_plateportion` WRITE;
/*!40000 ALTER TABLE `food_order_api_plateportion` DISABLE KEYS */;
INSERT INTO `food_order_api_plateportion` VALUES (5,'Dairy'),(4,'Fruit'),(1,'Grain'),(2,'Protein'),(3,'Vegetable');
/*!40000 ALTER TABLE `food_order_api_plateportion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_userdeliveryschedule`
--

DROP TABLE IF EXISTS `food_order_api_userdeliveryschedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_userdeliveryschedule` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `delivery_schedule_id` bigint NOT NULL,
  `user_profile_id` bigint NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_userdeliveryschedule`
--

LOCK TABLES `food_order_api_userdeliveryschedule` WRITE;
/*!40000 ALTER TABLE `food_order_api_userdeliveryschedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `food_order_api_userdeliveryschedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_userlunchprogram`
--

DROP TABLE IF EXISTS `food_order_api_userlunchprogram`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_userlunchprogram` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `lunch_program_id` bigint NOT NULL,
  `user_profile_id` bigint NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_userlunchprogram`
--

LOCK TABLES `food_order_api_userlunchprogram` WRITE;
/*!40000 ALTER TABLE `food_order_api_userlunchprogram` DISABLE KEYS */;
/*!40000 ALTER TABLE `food_order_api_userlunchprogram` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_userorder`
--

DROP TABLE IF EXISTS `food_order_api_userorder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_userorder` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `status` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `quantity` int NOT NULL DEFAULT '1',
  `school_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `food_order_api_userorder_school_id_4fb23c10_fk_auth_school_id` (`school_id`),
  CONSTRAINT `food_order_api_userorder_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `food_order_api_userorder_school_id_4fb23c10_fk_auth_school_id` FOREIGN KEY (`school_id`) REFERENCES `auth_school` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_userorder`
--

LOCK TABLES `food_order_api_userorder` WRITE;
/*!40000 ALTER TABLE `food_order_api_userorder` DISABLE KEYS */;
INSERT INTO `food_order_api_userorder` VALUES (13,1,'Pending','2025-03-21 17:13:31',1,1),(14,1,'Pending','2025-03-21 20:59:06',1,1),(15,1,'Pending','2025-03-21 21:02:33',1,1),(16,1,'Pending','2025-03-21 21:02:57',1,2),(17,1,'Pending','2025-03-21 21:30:13',1,2),(18,1,'Pending','2025-03-21 21:34:58',1,2),(19,1,'Pending','2025-03-21 21:39:16',1,2);
/*!40000 ALTER TABLE `food_order_api_userorder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_userorder_menu_items`
--

DROP TABLE IF EXISTS `food_order_api_userorder_menu_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_userorder_menu_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `userorder_id` bigint NOT NULL,
  `menuitem_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userorder_id` (`userorder_id`),
  KEY `menuitem_id` (`menuitem_id`),
  CONSTRAINT `food_order_api_userorder_menu_items_ibfk_1` FOREIGN KEY (`userorder_id`) REFERENCES `food_order_api_userorder` (`id`) ON DELETE CASCADE,
  CONSTRAINT `food_order_api_userorder_menu_items_ibfk_2` FOREIGN KEY (`menuitem_id`) REFERENCES `food_order_api_menuitem` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_userorder_menu_items`
--

LOCK TABLES `food_order_api_userorder_menu_items` WRITE;
/*!40000 ALTER TABLE `food_order_api_userorder_menu_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `food_order_api_userorder_menu_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_userprofile`
--

DROP TABLE IF EXISTS `food_order_api_userprofile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_userprofile` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `support_rep_id` bigint DEFAULT NULL,
  `user_id` int NOT NULL,
  `additional_notes` longtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `food_order_api_userp_support_rep_id_019ae942_fk_food_orde` (`support_rep_id`),
  CONSTRAINT `food_order_api_userp_support_rep_id_019ae942_fk_food_orde` FOREIGN KEY (`support_rep_id`) REFERENCES `food_order_api_customersupportprofile` (`id`),
  CONSTRAINT `food_order_api_userprofile_user_id_0a311e2f_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_userprofile`
--

LOCK TABLES `food_order_api_userprofile` WRITE;
/*!40000 ALTER TABLE `food_order_api_userprofile` DISABLE KEYS */;
INSERT INTO `food_order_api_userprofile` VALUES (1,1,1,'Customer is the best one we have - never change! Stay Gold Pony boy!'),(2,1,2,'');
/*!40000 ALTER TABLE `food_order_api_userprofile` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-25  3:30:26
