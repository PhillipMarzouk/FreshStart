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
INSERT INTO `auth_group` VALUES (1,'Staff');
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
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
INSERT INTO `auth_group_permissions` VALUES (1,1,13),(2,1,14),(3,1,15),(4,1,16),(5,1,17),(6,1,18),(7,1,19),(8,1,20),(9,1,21),(10,1,22),(11,1,23),(12,1,24),(13,1,25),(14,1,26),(15,1,27),(16,1,28),(17,1,29),(18,1,30),(19,1,31),(20,1,32),(21,1,33),(22,1,34),(23,1,35),(24,1,36),(25,1,37),(26,1,38),(27,1,39),(28,1,40),(29,1,41),(30,1,42),(31,1,43),(32,1,44),(33,1,45),(34,1,46),(35,1,47),(36,1,48),(37,1,49),(38,1,50),(39,1,51),(40,1,52),(41,1,53),(42,1,54),(43,1,55),(44,1,56),(45,1,57),(46,1,58),(47,1,59),(48,1,60),(49,1,61),(50,1,62),(51,1,63),(52,1,64),(53,1,65),(54,1,66),(55,1,67),(56,1,68),(57,1,69),(58,1,70),(59,1,71),(60,1,72),(61,1,73),(62,1,74),(63,1,75),(64,1,76),(65,1,77),(66,1,78),(67,1,79),(68,1,80),(69,1,81),(70,1,82),(71,1,83),(72,1,84);
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
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add session',5,'add_session'),(18,'Can change session',5,'change_session'),(19,'Can delete session',5,'delete_session'),(20,'Can view session',5,'view_session'),(21,'Can add custom user',6,'add_customuser'),(22,'Can change custom user',6,'change_customuser'),(23,'Can delete custom user',6,'delete_customuser'),(24,'Can view custom user',6,'view_customuser'),(25,'Can add customer support profile',7,'add_customersupportprofile'),(26,'Can change customer support profile',7,'change_customersupportprofile'),(27,'Can delete customer support profile',7,'delete_customersupportprofile'),(28,'Can view customer support profile',7,'view_customersupportprofile'),(29,'Can add delivery schedule',8,'add_deliveryschedule'),(30,'Can change delivery schedule',8,'change_deliveryschedule'),(31,'Can delete delivery schedule',8,'delete_deliveryschedule'),(32,'Can view delivery schedule',8,'view_deliveryschedule'),(33,'Can add food type',9,'add_foodtype'),(34,'Can change food type',9,'change_foodtype'),(35,'Can delete food type',9,'delete_foodtype'),(36,'Can view food type',9,'view_foodtype'),(37,'Can add lunch program',10,'add_lunchprogram'),(38,'Can change lunch program',10,'change_lunchprogram'),(39,'Can delete lunch program',10,'delete_lunchprogram'),(40,'Can view lunch program',10,'view_lunchprogram'),(41,'Can add menu date',11,'add_menudate'),(42,'Can change menu date',11,'change_menudate'),(43,'Can delete menu date',11,'delete_menudate'),(44,'Can view menu date',11,'view_menudate'),(45,'Can add menu item',12,'add_menuitem'),(46,'Can change menu item',12,'change_menuitem'),(47,'Can delete menu item',12,'delete_menuitem'),(48,'Can view menu item',12,'view_menuitem'),(49,'Can add milk type image',13,'add_milktypeimage'),(50,'Can change milk type image',13,'change_milktypeimage'),(51,'Can delete milk type image',13,'delete_milktypeimage'),(52,'Can view milk type image',13,'view_milktypeimage'),(53,'Can add plate portion',14,'add_plateportion'),(54,'Can change plate portion',14,'change_plateportion'),(55,'Can delete plate portion',14,'delete_plateportion'),(56,'Can view plate portion',14,'view_plateportion'),(57,'Can add school',15,'add_school'),(58,'Can change school',15,'change_school'),(59,'Can delete school',15,'delete_school'),(60,'Can view school',15,'view_school'),(61,'Can add school group',16,'add_schoolgroup'),(62,'Can change school group',16,'change_schoolgroup'),(63,'Can delete school group',16,'delete_schoolgroup'),(64,'Can view school group',16,'view_schoolgroup'),(65,'Can add user profile',17,'add_userprofile'),(66,'Can change user profile',17,'change_userprofile'),(67,'Can delete user profile',17,'delete_userprofile'),(68,'Can view user profile',17,'view_userprofile'),(69,'Can add Customer Orders',18,'add_userorder'),(70,'Can change Customer Orders',18,'change_userorder'),(71,'Can delete Customer Orders',18,'delete_userorder'),(72,'Can view Customer Orders',18,'view_userorder'),(73,'Can add order item',19,'add_orderitem'),(74,'Can change order item',19,'change_orderitem'),(75,'Can delete order item',19,'delete_orderitem'),(76,'Can view order item',19,'view_orderitem'),(77,'Can add food item',20,'add_fooditem'),(78,'Can change food item',20,'change_fooditem'),(79,'Can delete food item',20,'delete_fooditem'),(80,'Can view food item',20,'view_fooditem'),(81,'Can add cart',21,'add_cart'),(82,'Can change cart',21,'change_cart'),(83,'Can delete cart',21,'delete_cart'),(84,'Can view cart',21,'view_cart');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
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
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_food_orde` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_food_orde` FOREIGN KEY (`user_id`) REFERENCES `food_order_api_customuser` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2025-04-13 01:52:02.027959','1','Staff',1,'[{\"added\": {}}]',3,1),(2,'2025-04-13 01:57:26.949139','1','Pablo Picasso',1,'[{\"added\": {}}]',7,1),(3,'2025-04-13 01:57:50.055587','1','admin',2,'[{\"changed\": {\"fields\": [\"First name\", \"Last name\"]}}]',22,1),(4,'2025-04-13 01:58:13.808398','2','Los Angeles School District',1,'[{\"added\": {}}]',3,1),(5,'2025-04-13 02:37:10.100017','1','William R Anton Elementary',1,'[{\"added\": {}}]',15,1),(6,'2025-04-13 02:37:34.491522','1','K-8',1,'[{\"added\": {}}]',10,1),(7,'2025-04-13 02:37:39.323092','2','9-12',1,'[{\"added\": {}}]',10,1),(8,'2025-04-13 02:37:43.987003','3','Adult',1,'[{\"added\": {}}]',10,1),(9,'2025-04-13 02:38:03.536491','1','William R Anton Elementary',2,'[{\"changed\": {\"fields\": [\"Lunch programs\"]}}]',15,1),(10,'2025-04-13 02:38:09.888025','1','Monday',1,'[{\"added\": {}}]',8,1),(11,'2025-04-13 02:38:16.143541','2','Tuesday',1,'[{\"added\": {}}]',8,1),(12,'2025-04-13 02:38:18.496528','3','Wednesday',1,'[{\"added\": {}}]',8,1),(13,'2025-04-13 02:38:20.925968','4','Thursday',1,'[{\"added\": {}}]',8,1),(14,'2025-04-13 02:38:23.485868','5','Friday',1,'[{\"added\": {}}]',8,1),(15,'2025-04-13 05:14:29.110004','1','1% Milk',1,'[{\"added\": {}}]',13,1),(16,'2025-04-13 05:14:57.689709','2','Fat-Free Chocolate Milk',1,'[{\"added\": {}}]',13,1),(17,'2025-04-13 05:15:11.702085','3','Fat-Free White Milk',1,'[{\"added\": {}}]',13,1),(18,'2025-04-13 05:15:34.986387','4','Whole White Milk',1,'[{\"added\": {}}]',13,1),(19,'2025-04-13 05:16:15.137009','5','Soy Milk',1,'[{\"added\": {}}]',13,1),(20,'2025-04-13 05:16:50.078007','1','LAUSD',1,'[{\"added\": {}}]',16,1),(21,'2025-04-13 05:18:44.852460','1','William R Anton Elementary',2,'[{\"changed\": {\"fields\": [\"Group\", \"Delivery schedule\"]}}]',15,1),(22,'2025-04-13 05:19:30.735576','1','Fruit',1,'[{\"added\": {}}]',14,1),(23,'2025-04-13 05:19:39.185291','2','Vegetable',1,'[{\"added\": {}}]',14,1),(24,'2025-04-13 05:19:53.753968','3','Protein',1,'[{\"added\": {}}]',14,1),(25,'2025-04-13 05:19:58.630233','4','Grain',1,'[{\"added\": {}}]',14,1),(26,'2025-04-13 05:20:03.327734','5','Dairy',1,'[{\"added\": {}}]',14,1),(27,'2025-04-13 05:21:38.319824','1','FIELD TRIP',1,'[{\"added\": {}}]',12,1),(28,'2025-04-13 05:22:13.758137','2','FIELD TRIP VEGITERIAN',1,'[{\"added\": {}}]',12,1),(29,'2025-04-13 06:33:54.154365','3','Order 3 - admin (Pending)',3,'',18,1),(30,'2025-04-13 06:33:54.166731','2','Order 2 - admin (Pending)',3,'',18,1),(31,'2025-04-13 06:33:54.172107','1','Order 1 - admin (Pending)',3,'',18,1),(32,'2025-04-13 06:52:53.407128','1','William R Anton Elementary',2,'[{\"changed\": {\"fields\": [\"Delivery type\"]}}]',15,1),(33,'2025-04-13 07:04:57.133167','1','FIELD TRIP',2,'[{\"changed\": {\"fields\": [\"Meal type\"]}}]',12,1),(34,'2025-04-13 07:05:18.265685','6','Order 6 - admin (Pending)',3,'',18,1),(35,'2025-04-13 07:05:18.278300','5','Order 5 - admin (Pending)',3,'',18,1),(36,'2025-04-13 07:05:18.289205','4','Order 4 - admin (Pending)',3,'',18,1),(37,'2025-04-13 07:05:59.643049','1','FIELD TRIP',2,'[{\"changed\": {\"fields\": [\"Meal type\"]}}]',12,1),(38,'2025-04-13 07:06:42.684823','9','Hot Dog',1,'[{\"added\": {}}]',12,1),(39,'2025-04-13 07:10:36.581526','1','William R Anton Elementary',2,'[{\"changed\": {\"fields\": [\"Delivery type\"]}}]',15,1),(40,'2025-04-14 04:07:03.973337','1','admin',2,'[{\"changed\": {\"name\": \"user profile\", \"object\": \"admin\", \"fields\": [\"Support rep\"]}}]',6,1),(41,'2025-04-14 04:19:17.310902','5','LAUSD_Lunch_program',1,'[{\"added\": {}}, {\"added\": {\"name\": \"user profile\", \"object\": \"LAUSD_Lunch_program\"}}]',6,1),(42,'2025-04-14 04:19:58.112919','5','LAUSD_Lunch_program',2,'[{\"changed\": {\"fields\": [\"Email address\", \"First name\", \"Last name\"]}}]',6,1),(43,'2025-04-14 04:21:13.666562','1','William R Anton Elementary',2,'[{\"changed\": {\"fields\": [\"Users\"]}}]',15,1),(44,'2025-04-14 04:29:23.446106','1','William R Anton Elementary',2,'[]',15,1),(45,'2025-04-14 05:11:47.428793','1','William R Anton Elementary',2,'[{\"changed\": {\"fields\": [\"Delivery Days\"]}}]',15,1),(46,'2025-04-14 05:28:30.107211','1','William R Anton Elementary',2,'[{\"changed\": {\"fields\": [\"delivery_schedule\"]}}]',15,1),(47,'2025-04-14 15:15:39.641078','1','William R Anton Elementary',2,'[{\"changed\": {\"fields\": [\"Pizza Days\"]}}]',15,1),(48,'2025-04-14 15:43:22.241974','11','Order 11 - admin (Pending)',3,'',18,1),(49,'2025-04-14 15:43:22.257302','10','Order 10 - admin (Pending)',3,'',18,1),(50,'2025-04-14 15:43:22.269121','9','Order 9 - admin (Pending)',3,'',18,1),(51,'2025-04-14 15:43:22.276712','8','Order 8 - admin (Pending)',3,'',18,1),(52,'2025-04-14 15:43:22.290444','7','Order 7 - admin (Pending)',3,'',18,1),(53,'2025-04-14 16:18:03.778022','1','William R Anton Elementary',2,'[{\"changed\": {\"fields\": [\"Family Style Days\"]}}]',15,1),(54,'2025-04-14 16:23:50.561640','1','William R Anton Elementary',2,'[{\"changed\": {\"fields\": [\"Family Style Days\"]}}]',15,1),(55,'2025-04-14 16:33:53.002076','1','William R Anton Elementary',2,'[{\"changed\": {\"fields\": [\"Pizza Days\"]}}]',15,1),(56,'2025-04-14 17:13:29.272500','10','Hamburger w/ Sweet Potato (3/4c)',1,'[{\"added\": {}}]',12,1),(57,'2025-04-14 20:48:00.300431','2','FIELD TRIP VEGETERIAN',2,'[{\"changed\": {\"fields\": [\"Plate name\"]}}]',12,1),(58,'2025-04-14 20:48:19.198956','2','FIELD TRIP VEGETARIAN',2,'[{\"changed\": {\"fields\": [\"Plate name\"]}}]',12,1),(59,'2025-04-14 20:51:04.812667','11','BBQ On Site',1,'[{\"added\": {}}]',12,1),(60,'2025-04-14 20:51:23.599313','11','BBQ On Site',3,'',12,1),(61,'2025-04-15 04:36:16.283388','1','NSLP K-8',2,'[{\"changed\": {\"fields\": [\"Name\"]}}]',10,1),(62,'2025-04-15 04:36:29.341321','2','NSLP 9-12',2,'[{\"changed\": {\"fields\": [\"Name\"]}}]',10,1),(63,'2025-04-15 04:36:52.555993','3','CACFP Adult',2,'[{\"changed\": {\"fields\": [\"Name\"]}}]',10,1),(64,'2025-04-15 04:37:06.822519','4','CACFP K-12',1,'[{\"added\": {}}]',10,1),(65,'2025-04-15 04:37:15.096829','5','CACFP Pre-K',1,'[{\"added\": {}}]',10,1),(66,'2025-04-15 04:51:48.767608','6','Staff_User',1,'[{\"added\": {}}, {\"added\": {\"name\": \"user profile\", \"object\": \"Staff_User\"}}]',6,1),(67,'2025-04-15 04:52:03.374652','6','Staff_User',2,'[{\"changed\": {\"fields\": [\"First name\", \"Last name\", \"Staff status\"]}}]',6,1),(68,'2025-04-15 05:32:55.065908','5','LAUSD_Lunch_program',2,'[{\"changed\": {\"fields\": [\"Groups\"]}}]',6,1),(69,'2025-04-15 05:33:09.469907','6','Staff_User',2,'[{\"changed\": {\"fields\": [\"Groups\"]}}]',6,1),(70,'2025-04-15 05:33:18.384790','5','LAUSD_Lunch_program',2,'[{\"changed\": {\"fields\": [\"Groups\"]}}]',6,1),(71,'2025-04-15 05:36:26.135193','2','Los Angeles School District',3,'',3,1),(72,'2025-04-15 05:53:52.111666','8','TestUser',1,'[{\"added\": {}}]',6,1),(73,'2025-04-15 05:54:01.036414','8','TestUser',2,'[{\"changed\": {\"fields\": [\"Staff status\"]}}]',6,1),(74,'2025-04-15 05:54:43.617944','8','TestUser',2,'[]',6,1),(75,'2025-04-15 05:59:44.978635','8','TestUser',2,'[]',6,1),(76,'2025-04-15 06:00:15.891078','8','TestUser',2,'[{\"changed\": {\"fields\": [\"Staff status\"]}}]',6,1),(77,'2025-04-15 06:00:21.655327','8','TestUser',2,'[{\"changed\": {\"fields\": [\"Staff status\"]}}]',6,1),(78,'2025-04-15 06:02:58.658107','8','TestUser',2,'[{\"changed\": {\"fields\": [\"Staff status\"]}}]',6,1),(79,'2025-04-15 06:03:05.122270','8','TestUser',2,'[{\"changed\": {\"fields\": [\"Staff status\"]}}]',6,1),(80,'2025-04-15 06:03:23.383901','6','Staff_User',3,'',6,1),(81,'2025-04-15 06:03:23.389911','8','TestUser',3,'',6,1),(82,'2025-04-15 06:11:00.485878','9','Test',1,'[{\"added\": {}}]',6,1),(83,'2025-04-15 06:11:30.554538','9','Test',2,'[{\"changed\": {\"fields\": [\"Staff status\"]}}]',6,1),(84,'2025-04-15 06:11:55.643036','9','Test',3,'',6,1),(85,'2025-04-17 17:17:52.520960','5','LAUSD_Lunch_program',2,'[{\"changed\": {\"fields\": [\"Email address\"]}}]',6,1),(86,'2025-04-17 17:28:34.260385','11','Test_user',1,'[{\"added\": {}}, {\"added\": {\"name\": \"user profile\", \"object\": \"Test_user\"}}]',6,1),(87,'2025-04-17 17:28:50.151344','11','Test_user',3,'',6,1),(88,'2025-04-17 17:29:09.527551','12','Howdy',1,'[{\"added\": {}}, {\"added\": {\"name\": \"user profile\", \"object\": \"Howdy\"}}]',6,1),(89,'2025-04-17 17:29:13.717939','12','Howdy',2,'[]',6,1),(90,'2025-04-17 17:37:33.426792','12','Howdy',3,'',6,1),(91,'2025-04-17 17:41:45.253679','13','Howdy',1,'[{\"added\": {}}, {\"added\": {\"name\": \"user profile\", \"object\": \"Howdy\"}}]',6,1),(92,'2025-04-17 17:42:03.163036','13','Howdy',3,'',6,1),(93,'2025-04-17 19:25:08.124173','15','Order 15 - admin (Nutrition Review)',2,'[{\"changed\": {\"fields\": [\"Status\", \"Notes\", \"Staff notes\"]}}, {\"changed\": {\"name\": \"order item\", \"object\": \"100x FIELD TRIP in Order #15 (Date: 2025-03-31, Delivery: 2025-03-26)\", \"fields\": [\"Quantity\"]}}]',18,1),(94,'2025-04-24 04:27:54.945349','15','Order 15 - admin (Nutrition Review)',3,'',18,1),(95,'2025-04-24 04:27:54.962194','14','Order 14 - admin (Pending)',3,'',18,1),(96,'2025-04-24 04:27:54.969332','13','Order 13 - admin (Pending)',3,'',18,1),(97,'2025-04-24 04:27:54.977893','12','Order 12 - admin (Pending)',3,'',18,1),(98,'2025-04-24 04:29:48.043195','14','Carlitos',1,'[{\"added\": {}}]',6,1),(99,'2025-04-24 04:30:40.077370','15','Armando',1,'[{\"added\": {}}]',6,1),(100,'2025-04-24 04:31:22.781979','1','Pablo Picasso',3,'',7,1),(101,'2025-04-24 04:33:15.636498','2','Elizabeth Arroyo',1,'[{\"added\": {}}]',7,1),(102,'2025-04-24 04:33:49.526721','3','Julie Arroyo',1,'[{\"added\": {}}]',7,1),(103,'2025-04-24 04:34:14.724642','4','Pablo Arroyo',1,'[{\"added\": {}}]',7,1),(104,'2025-04-24 04:35:25.474106','16','CustomerService',1,'[{\"added\": {}}]',6,1),(105,'2025-04-24 04:36:13.590306','17','Operations',1,'[{\"added\": {}}]',6,1),(106,'2025-04-24 04:36:40.753854','18','Elizabeth',1,'[{\"added\": {}}]',6,1),(107,'2025-04-24 04:37:15.585460','19','Julie',1,'[{\"added\": {}}]',6,1),(108,'2025-04-24 04:37:41.522642','20','Pablo',1,'[{\"added\": {}}]',6,1),(109,'2025-04-24 04:39:00.580788','21','Veronica',1,'[{\"added\": {}}]',6,1);
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
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(22,'auth','customuser'),(3,'auth','group'),(2,'auth','permission'),(23,'auth','school'),(4,'contenttypes','contenttype'),(21,'food_order_api','cart'),(7,'food_order_api','customersupportprofile'),(6,'food_order_api','customuser'),(8,'food_order_api','deliveryschedule'),(20,'food_order_api','fooditem'),(9,'food_order_api','foodtype'),(10,'food_order_api','lunchprogram'),(11,'food_order_api','menudate'),(12,'food_order_api','menuitem'),(13,'food_order_api','milktypeimage'),(19,'food_order_api','orderitem'),(14,'food_order_api','plateportion'),(15,'food_order_api','school'),(16,'food_order_api','schoolgroup'),(18,'food_order_api','userorder'),(17,'food_order_api','userprofile'),(5,'sessions','session');
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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2025-04-13 01:48:26.578612'),(2,'contenttypes','0002_remove_content_type_name','2025-04-13 01:48:26.655210'),(3,'auth','0001_initial','2025-04-13 01:48:26.980713'),(4,'auth','0002_alter_permission_name_max_length','2025-04-13 01:48:27.053790'),(5,'auth','0003_alter_user_email_max_length','2025-04-13 01:48:27.063956'),(6,'auth','0004_alter_user_username_opts','2025-04-13 01:48:27.073316'),(7,'auth','0005_alter_user_last_login_null','2025-04-13 01:48:27.082382'),(8,'auth','0006_require_contenttypes_0002','2025-04-13 01:48:27.088481'),(9,'auth','0007_alter_validators_add_error_messages','2025-04-13 01:48:27.100114'),(10,'auth','0008_alter_user_username_max_length','2025-04-13 01:48:27.111919'),(11,'auth','0009_alter_user_last_name_max_length','2025-04-13 01:48:27.121252'),(12,'auth','0010_alter_group_name_max_length','2025-04-13 01:48:27.193974'),(13,'auth','0011_update_proxy_permissions','2025-04-13 01:48:27.204456'),(14,'auth','0012_alter_user_first_name_max_length','2025-04-13 01:48:27.215189'),(15,'food_order_api','0001_initial','2025-04-13 01:48:30.538095'),(16,'admin','0001_initial','2025-04-13 01:48:30.732626'),(17,'admin','0002_logentry_remove_auto_add','2025-04-13 01:48:30.759568'),(18,'admin','0003_logentry_add_action_flag_choices','2025-04-13 01:48:30.864210'),(19,'sessions','0001_initial','2025-04-13 01:48:30.922392'),(20,'food_order_api','0002_alter_customuser_options_alter_menuitem_options_and_more','2025-04-14 04:44:18.814716'),(21,'food_order_api','0003_remove_customuser_delivery_schedule_and_more','2025-04-14 05:11:34.726845'),(22,'food_order_api','0004_customuser_delivery_schedule_and_more','2025-04-14 05:28:14.289743'),(23,'food_order_api','0005_school_family_style_days','2025-04-14 16:16:21.831196'),(24,'food_order_api','0006_userprofile_email','2025-04-17 17:22:07.047138'),(25,'food_order_api','0007_alter_userprofile_email','2025-04-17 17:22:27.257755'),(26,'food_order_api','0008_remove_userprofile_email','2025-04-17 17:24:07.441643');
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
INSERT INTO `django_session` VALUES ('4tfeu076fz36b1gyua22kjix82p5xugh','.eJxVjMsOwiAQRf-FtSEMlEdduvcbyDAwUjU0Ke3K-O_apAvd3nPOfYmI21rj1ssSpyzOQoM4_Y4J6VHaTvId222WNLd1mZLcFXnQLq9zLs_L4f4dVOz1WzMbKkzGUbbkgy_KDM6y8zCCCdmGAZQGJGUZLDhUKWAgthp4JC5GvD8MRDgH:1u7oNE:5YNKPlM33pIxlNmwRD38iduY2cnwbZeil0b7PB5jRvc','2025-05-08 04:39:44.258014'),('5yuhp04gps8mpy44xh99vm9bqkwh555i','.eJxVjL0OwiAURt-F2TRQCD-OJo7GyZlcuJfQ2BYDdjK-u5h00PWc7zsv5mF7Zr81qn5CdmSCHX5ZgHin9StSKehLxQ7hMQ27aMN5gWm-1ltfr7DQpSDNp_31l8rQcu8EOaKzmlOioEQKNvLkQKO0KmqOoLtzGg3AKEYjEkZno0aulDBcErL3B7IePDc:1u7vuD:1O573VDeTBSP8PiAPuQJYSVk6Q43O0gcZFF07W45QeA','2025-05-08 12:42:17.330323'),('7bjmqgggyyql7a56hmfc7sjbpde10qi0','.eJxVjMsOgjAUBf-la9MUuaWFpXu_obmPYlFCE1pWxn8XEha6PTNn3irgVlPYSlzDJGpQVl1-N0J-xeUA8sTlkTXnpa4T6UPRJy36niXOt9P9CyQsaX8DeLboQBzRaFpP7CJ1o0NnWyFiuo4W0Tu2ANh503LTAxhAK9I7A3u0xDlyjRIKp5xnNTSfL64iPz4:1u4BK7:AebPm_nDIhw2_hfxIYde9Uuxhu8ZWOanteBl0l7rlc4','2025-04-28 04:21:31.716708'),('8qbpihcay9d7z5uojwb564ffgw4wknlx','.eJxVjLEOgyAURf-FuTGgBMGxScemU2fy4D2CKYoRnZr-ezFxaNdz7j1vZmHfot0LrXZENjDBLr_MgX_RfIiQM9q8YoWwjM0pSnObYEyP9VnXM0x0z0jper7-UhFKrB3XtWi04hTISRGc9jwYUNhp6RVHUNUZhT1AK9peBPRGe4VcStHzjo5ooUR-I7TFx5wTG8TnC67vQ0I:1uARI5:G7orvjKRz4d_1Nn6N13MElF2wL3xlk8SzovJQnntwDA','2025-05-15 10:37:17.387515'),('91a8mz0vbjwhsm1pqchz07lf3x6lrys0','.eJxVjEEOwiAQRe_C2hARKODSfc9AZphBqgaS0q6Md7dNutDtf-_9t4iwLiWunec4kbiKQZx-N4T05LoDekC9N5laXeYJ5a7Ig3Y5NuLX7XD_Dgr0stXanwfvKFhlIKOlBMFoYBdMZsuoFFuPoC8pGyCNFi0oozaagkrktPh8AfCAOGc:1u4Yvw:7fntUvtebaywOD2-wWpRTLwJz0VUKUx_zy9CFpwZv_s','2025-04-29 05:34:08.015768'),('9z1g52640w4rd8h5etncp01vko5nfpvc','.eJxVjT0PgjAQhv9LZ0Naanuto4mjcXJurtxdIAI1IJPxvwsJg67P8368VcLl1aZl5il1pE7KHNXhF2ZsHjxuRkqhVCZaIT67ahdzdRmw62_TfU2POPC1EPfnvfU31eLcbg8UwYvLbAJ41N4KihbPrkGgOtqgSchIYGsIIWaNYr0TwBrAsIvq8wXbfzyt:1uAblH:L-rgEKj302j-iotBpur5-YR2TbY6X1kBGg03DT0R--s','2025-05-15 21:48:07.360643'),('il8yp8aioqb2hb2cax1bvp11i96zrsp5','.eJxVjLsOgkAQRf9la0OWh86spYmlsbLeDPMIRGDNIpXx38WEQttz7j0vF2l5dnGZNcde3NGV4Ha_sCW-6_Q1lpLElGWF9OiLTczFeaR-uObbup5o1EsSHU7b6y_V0dytHWSsWlA7BNizKXJlhqLeQCuW1isYEkoDvgkIWEOozZOyF2Euy-DeH_jZPVQ:1uAH1b:BbzkJYaxQy9_LAq_Aa4PwgfDvZ1v0NbD2r5lSTHV86Y','2025-05-14 23:39:35.518057'),('iu6quygc3cgaae033mqu831a0gh1c67c','.eJxVjEEOwiAQRe_C2hARKODSfc9AZphBqgaS0q6Md7dNutDtf-_9t4iwLiWunec4kbiKQZx-N4T05LoDekC9N5laXeYJ5a7Ig3Y5NuLX7XD_Dgr0stXanwfvKFhlIKOlBMFoYBdMZsuoFFuPoC8pGyCNFi0oozaagkrktPh8AfCAOGc:1u4YpF:OZGo-0HT4VRdyRqQt52hNx8GZjGfI5dNsdmf_3TkRl0','2025-04-29 05:27:13.571766'),('jg51eyz0b6xq5g3eaz6iga6v1kvsryoc','.eJxVjEEOgjAQRe_StWk6FaaMS_ecoWk7M4IaSCisjHdXEha6_e-9_zIxbesQtypLHNlcDJnT75ZTeci0A76n6TbbMk_rMma7K_ag1fYzy_N6uH8HQ6rDt_YOFZ0XbBx3Gf25tEoAOXSK5AlJ1GWQlktgztIAgjaBA7kAQErm_QHPvjdj:1u4ZVn:3dxvvtTeMNK0P7F-A-d-2dPd1mQDjPx35DV2_q6W6aI','2025-04-29 06:11:11.218695'),('nzvfuzjjub6v8x35htv2rb4yhzevxcr5','.eJxVjEEOwiAQRe_C2hAKAwwu3fcMZICJVA1NSrsy3t026UK3_7333yLStta4dV7iVMRVoLj8bonyk9sByoPafZZ5busyJXko8qRdjnPh1-10_w4q9brXEIgVWlDe6qJ8AGUJOFtjfA7J4aCRBwbkHLIFZo3OsAFGh5j2RHy-vS83Bg:1u4ZFP:a0dZitRrZhOuzKYz7RVSulPLb6qYKGVjJ1n7LI_3ECY','2025-04-29 05:54:15.335524'),('u7268svm6sz13yrdx7hvkpu7814dpc54','.eJxVjL0OwiAURt-F2TRQCD-OJo7GyZlcuJfQ2BYDdjK-u5h00PWc7zsv5mF7Zr81qn5CdmSCHX5ZgHin9StSKehLxQ7hMQ27aMN5gWm-1ltfr7DQpSDNp_31l8rQcu8EOaKzmlOioEQKNvLkQKO0KmqOoLtzGg3AKEYjEkZno0aulDBcErL3B7IePDc:1uARHu:tlcZrOzx8AUXamS_ZgkoFBQkEkNPt5OC2yUef7nKW_c','2025-05-15 10:37:06.959943'),('vrpzkufprl0wehq68ds5wv1d8jk9rqbq','.eJxVjEEOwiAQRe_C2hARKODSfc9AZphBqgaS0q6Md7dNutDtf-_9t4iwLiWunec4kbiKQZx-N4T05LoDekC9N5laXeYJ5a7Ig3Y5NuLX7XD_Dgr0stXanwfvKFhlIKOlBMFoYBdMZsuoFFuPoC8pGyCNFi0oozaagkrktPh8AfCAOGc:1u4YHx:FQZPUAR09WNIlWsBprrcpuz8XoSx7EBRboU291ZJWY8','2025-04-29 04:52:49.510043');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_cart`
--

DROP TABLE IF EXISTS `food_order_api_cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_cart` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quantity` int unsigned NOT NULL,
  `date_override` date DEFAULT NULL,
  `menu_item_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_cart_per_day` (`user_id`,`menu_item_id`,`date_override`),
  KEY `food_order_api_cart_menu_item_id_e650ec9c_fk_food_orde` (`menu_item_id`),
  CONSTRAINT `food_order_api_cart_menu_item_id_e650ec9c_fk_food_orde` FOREIGN KEY (`menu_item_id`) REFERENCES `food_order_api_menuitem` (`id`),
  CONSTRAINT `food_order_api_cart_user_id_9ec92f24_fk_food_orde` FOREIGN KEY (`user_id`) REFERENCES `food_order_api_customuser` (`id`),
  CONSTRAINT `food_order_api_cart_chk_1` CHECK ((`quantity` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb3;
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_customersupportprofile`
--

LOCK TABLES `food_order_api_customersupportprofile` WRITE;
/*!40000 ALTER TABLE `food_order_api_customersupportprofile` DISABLE KEYS */;
INSERT INTO `food_order_api_customersupportprofile` VALUES (2,'Elizabeth','Arroyo','Elizabeth@fshealthymeals.com','8187975881',NULL,''),(3,'Julie','Arroyo','Julie@fshealthymeals.com','8187975881',NULL,''),(4,'Pablo','Arroyo','pablo@fshealthymeals.com','8187975881',NULL,'');
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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_customuser`
--

LOCK TABLES `food_order_api_customuser` WRITE;
/*!40000 ALTER TABLE `food_order_api_customuser` DISABLE KEYS */;
INSERT INTO `food_order_api_customuser` VALUES (1,'pbkdf2_sha256$600000$lZSvQmmaPJMd7QyzNDgotb$j3Ddwwszt8psYYdGEuFxbdCGfi6UUdoLSQ8s3XF1e+s=','2025-05-01 10:37:08.052896',1,'admin','Phillip','Marzouk','phillipmarzouk@gmail.com',1,1,'2025-04-13 01:49:40.287440',NULL),(5,'pbkdf2_sha256$600000$VDBSJH8HJHIqmpGx27fGrJ$15y6g3uy+vJ7HKUo3NJ54+SYiZKwUEFhPSZn1QhQBo0=','2025-04-14 04:20:46.503447',0,'LAUSD_Lunch_program','Bob','Bobokavitch','phillip@digitalonbrand.com',0,1,'2025-04-14 04:19:16.599555',NULL),(14,'pbkdf2_sha256$600000$5QbiBPtBq3UT3k1Jc2UMrk$zJwUkN/91wSnzIs9M21xnyiOMXxL7JnizjMCNzT2aEg=','2025-05-01 21:48:07.348902',0,'Carlitos','Carlitos','Saucedo','nutrition@fshealthymeals.com',1,1,'2025-04-24 04:29:47.408479',NULL),(15,'pbkdf2_sha256$600000$c0uskrBM0vxsKdBvMSnkFy$YruqElbQNIhYoK1vdZrqfgLAMbazzyuuHa4+y1PEo/o=',NULL,0,'Armando','Armando','Arroyo','Nutritionassistant@fshealthymeals.com',1,1,'2025-04-24 04:30:39.628551',NULL),(16,'pbkdf2_sha256$600000$ivfYOMDDyjQQKcJPmc7t7N$gCHy1/PoB5EITKYi86ELYb0ltmLxaNEBscFJXzeOPd4=','2025-04-24 14:21:34.516742',0,'CustomerService','Customer','Service','customerservice@fshealthymeals.com',1,1,'2025-04-24 04:35:24.049999',NULL),(17,'pbkdf2_sha256$600000$kYRSS5MRKqWKDxd3bFwC4h$Pcu3rmq5QNGm3rk/xoKU3VBxwvhv1YIjBBYgaecUclY=','2025-04-30 23:39:35.507638',0,'Operations','Operations','','operations@fshealthymeals.com',1,1,'2025-04-24 04:36:13.054467',NULL),(18,'pbkdf2_sha256$600000$Z3LBm9432YpxtA6jUIjiNn$JH/DW7+Ci9ewySi3tZfRFwYCekW+1HSvu6zSWp+hrPE=',NULL,0,'Elizabeth','Elizabeth','','Elizabeth@fshealthymeals.com',1,1,'2025-04-24 04:36:40.132952',NULL),(19,'pbkdf2_sha256$600000$k06m6NrANPUofcRlLgweYQ$rdKktTNZqESMrTuVFbWQGtc70ALGdYJMtOwxhn1Gnqc=','2025-04-30 23:58:23.870839',0,'Julie','Julie','','Julie@fshealthymeals.com',1,1,'2025-04-24 04:37:14.878475',NULL),(20,'pbkdf2_sha256$600000$MA38ci8LCHLo9zVyZJ2gul$op08lkMtV3TwvONdRIbsogUo/buC4c+of3c+dL0Xzmg=',NULL,0,'Pablo','Pablo','','pablo@fshealthymeals.com',1,1,'2025-04-24 04:37:40.907441',NULL),(21,'pbkdf2_sha256$600000$FqXy8fWyhn27E1FSQ4CdD5$03A/VqHfq2/bdvCWoJiXMAI7cWnghOEf2D+NwMkenUI=','2025-04-24 04:39:44.238053',0,'Veronica','Veronica','Alcaraz','veronica@fshealthymeals.com',1,1,'2025-04-24 04:38:59.950585',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_customuser_groups`
--

LOCK TABLES `food_order_api_customuser_groups` WRITE;
/*!40000 ALTER TABLE `food_order_api_customuser_groups` DISABLE KEYS */;
INSERT INTO `food_order_api_customuser_groups` VALUES (5,1,1),(6,14,1),(7,15,1),(8,16,1),(9,17,1),(10,18,1),(11,19,1),(12,20,1),(13,21,1);
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
  `name` varchar(20) NOT NULL,
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
-- Table structure for table `food_order_api_fooditem`
--

DROP TABLE IF EXISTS `food_order_api_fooditem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_fooditem` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `price` decimal(6,2) NOT NULL,
  `food_type_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `food_order_api_foodi_food_type_id_0ff97852_fk_food_orde` (`food_type_id`),
  CONSTRAINT `food_order_api_foodi_food_type_id_0ff97852_fk_food_orde` FOREIGN KEY (`food_type_id`) REFERENCES `food_order_api_foodtype` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_fooditem`
--

LOCK TABLES `food_order_api_fooditem` WRITE;
/*!40000 ALTER TABLE `food_order_api_fooditem` DISABLE KEYS */;
/*!40000 ALTER TABLE `food_order_api_fooditem` ENABLE KEYS */;
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
INSERT INTO `food_order_api_lunchprogram` VALUES (3,'CACFP Adult'),(4,'CACFP K-12'),(5,'CACFP Pre-K'),(2,'NSLP 9-12'),(1,'NSLP K-8');
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
  `is_field_trip` tinyint(1) NOT NULL,
  `is_new` tinyint(1) NOT NULL,
  `available_date` date DEFAULT NULL,
  `image` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_menuitem`
--

LOCK TABLES `food_order_api_menuitem` WRITE;
/*!40000 ALTER TABLE `food_order_api_menuitem` DISABLE KEYS */;
INSERT INTO `food_order_api_menuitem` VALUES (1,'FIELD TRIP','Cold Meal',1,0,'2025-01-01',''),(2,'FIELD TRIP VEGETARIAN','Cold Vegetarian',1,0,'2025-01-01',''),(3,'1% Milk','Milk',0,0,NULL,''),(4,'Soy Milk','Milk',0,0,NULL,''),(5,'Whole Milk','Milk',0,0,NULL,''),(6,'Shelf Stable Milk','Milk',0,0,NULL,''),(7,'Fat-Free White Milk','Milk',0,0,NULL,''),(8,'Fat-Free Chocolate Milk','Milk',0,0,NULL,''),(9,'Hot Dog','Hot Meal',0,0,'2025-04-01',''),(10,'Hamburger w/ Sweet Potato (3/4c)','Hot Meal',0,0,'2025-04-01','');
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_menuitem_lunch_programs`
--

LOCK TABLES `food_order_api_menuitem_lunch_programs` WRITE;
/*!40000 ALTER TABLE `food_order_api_menuitem_lunch_programs` DISABLE KEYS */;
INSERT INTO `food_order_api_menuitem_lunch_programs` VALUES (1,1,1),(2,1,2),(3,1,3),(4,2,1),(5,2,2),(6,2,3),(7,9,1),(8,9,2),(9,9,3),(10,10,1),(11,10,2),(12,10,3);
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
  UNIQUE KEY `food_order_api_menuitem__menuitem_id_plateportion_381abc5e_uniq` (`menuitem_id`,`plateportion_id`),
  KEY `food_order_api_menui_plateportion_id_a0362416_fk_food_orde` (`plateportion_id`),
  CONSTRAINT `food_order_api_menui_menuitem_id_ed403a09_fk_food_orde` FOREIGN KEY (`menuitem_id`) REFERENCES `food_order_api_menuitem` (`id`),
  CONSTRAINT `food_order_api_menui_plateportion_id_a0362416_fk_food_orde` FOREIGN KEY (`plateportion_id`) REFERENCES `food_order_api_plateportion` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_menuitem_plate_portions`
--

LOCK TABLES `food_order_api_menuitem_plate_portions` WRITE;
/*!40000 ALTER TABLE `food_order_api_menuitem_plate_portions` DISABLE KEYS */;
INSERT INTO `food_order_api_menuitem_plate_portions` VALUES (1,1,2),(2,1,3),(3,1,4),(4,2,2),(5,2,4),(6,9,3),(7,9,4),(8,10,1),(9,10,2),(10,10,3),(11,10,4),(12,10,5);
/*!40000 ALTER TABLE `food_order_api_menuitem_plate_portions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_milktypeimage`
--

DROP TABLE IF EXISTS `food_order_api_milktypeimage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_milktypeimage` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `image` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_milktypeimage`
--

LOCK TABLES `food_order_api_milktypeimage` WRITE;
/*!40000 ALTER TABLE `food_order_api_milktypeimage` DISABLE KEYS */;
INSERT INTO `food_order_api_milktypeimage` VALUES (1,'1% Milk','milk_images/1percent_72bHsPG.png'),(2,'Fat-Free Chocolate Milk','milk_images/chocolate_zMusMpg.png'),(3,'Fat-Free White Milk','milk_images/nonfat-white_x2tfDpP.png'),(4,'Whole White Milk','milk_images/whole_B3T5I7w.png'),(5,'Soy Milk','milk_images/soy_3xHH0mw.png');
/*!40000 ALTER TABLE `food_order_api_milktypeimage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_orderitem`
--

DROP TABLE IF EXISTS `food_order_api_orderitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_orderitem` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quantity` int unsigned NOT NULL,
  `menu_item_date` date DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `menu_item_id` bigint NOT NULL,
  `order_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `food_order_api_order_menu_item_id_2e0bcc61_fk_food_orde` (`menu_item_id`),
  KEY `food_order_api_order_order_id_ec65ed70_fk_food_orde` (`order_id`),
  CONSTRAINT `food_order_api_order_menu_item_id_2e0bcc61_fk_food_orde` FOREIGN KEY (`menu_item_id`) REFERENCES `food_order_api_menuitem` (`id`),
  CONSTRAINT `food_order_api_order_order_id_ec65ed70_fk_food_orde` FOREIGN KEY (`order_id`) REFERENCES `food_order_api_userorder` (`id`),
  CONSTRAINT `food_order_api_orderitem_chk_1` CHECK ((`quantity` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=174 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_orderitem`
--

LOCK TABLES `food_order_api_orderitem` WRITE;
/*!40000 ALTER TABLE `food_order_api_orderitem` DISABLE KEYS */;
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
INSERT INTO `food_order_api_plateportion` VALUES (5,'Dairy'),(1,'Fruit'),(4,'Grain'),(3,'Protein'),(2,'Vegetable');
/*!40000 ALTER TABLE `food_order_api_plateportion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_school`
--

DROP TABLE IF EXISTS `food_order_api_school`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_school` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `breakfast_milk_distribution` json NOT NULL,
  `cereal_milk_distribution` json NOT NULL,
  `lunch_milk_distribution` json NOT NULL,
  `snack_milk_distribution` json NOT NULL,
  `vegan_milk_distribution` json NOT NULL,
  `therapeutic_milk_distribution` json NOT NULL,
  `grade_level` varchar(20) DEFAULT NULL,
  `route_number` varchar(2) DEFAULT NULL,
  `delivery_type` varchar(20) DEFAULT NULL,
  `group_id` bigint DEFAULT NULL,
  `pizza_days` json NOT NULL DEFAULT (_utf8mb3'[]'),
  `family_style_days` json NOT NULL DEFAULT (_utf8mb3'[]'),
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `food_order_api_schoo_group_id_596fd5b7_fk_food_orde` (`group_id`),
  CONSTRAINT `food_order_api_schoo_group_id_596fd5b7_fk_food_orde` FOREIGN KEY (`group_id`) REFERENCES `food_order_api_schoolgroup` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_school`
--

LOCK TABLES `food_order_api_school` WRITE;
/*!40000 ALTER TABLE `food_order_api_school` DISABLE KEYS */;
INSERT INTO `food_order_api_school` VALUES (1,'William R Anton Elementary','{\"1% Milk\": 50, \"Soy Milk\": 5, \"Whole Milk\": 20, \"Shelf Stable Milk\": 5, \"Fat-Free White Milk\": 0, \"Fat-Free Chocolate Milk\": 20}','{\"1% Milk\": 80, \"Soy Milk\": 5, \"Whole Milk\": 5, \"Shelf Stable Milk\": 5, \"Fat-Free White Milk\": 0, \"Fat-Free Chocolate Milk\": 5}','{\"1% Milk\": 50, \"Soy Milk\": 5, \"Whole Milk\": 10, \"Shelf Stable Milk\": 5, \"Fat-Free White Milk\": 10, \"Fat-Free Chocolate Milk\": 20}','{\"1% Milk\": 50, \"Soy Milk\": 0, \"Whole Milk\": 0, \"Shelf Stable Milk\": 0, \"Fat-Free White Milk\": 0, \"Fat-Free Chocolate Milk\": 50}','{}','{\"1% Milk\": 100, \"Soy Milk\": 0, \"Whole Milk\": 0, \"Shelf Stable Milk\": 0, \"Fat-Free White Milk\": 0, \"Fat-Free Chocolate Milk\": 0}','K-8','01','Ready to Serve',1,'[\"mon\", \"tue\", \"wed\", \"thu\", \"fri\"]','[\"mon\", \"wed\"]');
/*!40000 ALTER TABLE `food_order_api_school` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_school_delivery_schedule`
--

DROP TABLE IF EXISTS `food_order_api_school_delivery_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_school_delivery_schedule` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `school_id` bigint NOT NULL,
  `deliveryschedule_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `food_order_api_school_de_school_id_deliveryschedu_a5cc40e0_uniq` (`school_id`,`deliveryschedule_id`),
  KEY `food_order_api_schoo_deliveryschedule_id_28fcd029_fk_food_orde` (`deliveryschedule_id`),
  CONSTRAINT `food_order_api_schoo_deliveryschedule_id_28fcd029_fk_food_orde` FOREIGN KEY (`deliveryschedule_id`) REFERENCES `food_order_api_deliveryschedule` (`id`),
  CONSTRAINT `food_order_api_schoo_school_id_5b5b1b5c_fk_food_orde` FOREIGN KEY (`school_id`) REFERENCES `food_order_api_school` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_school_delivery_schedule`
--

LOCK TABLES `food_order_api_school_delivery_schedule` WRITE;
/*!40000 ALTER TABLE `food_order_api_school_delivery_schedule` DISABLE KEYS */;
INSERT INTO `food_order_api_school_delivery_schedule` VALUES (1,1,1),(2,1,3);
/*!40000 ALTER TABLE `food_order_api_school_delivery_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_school_lunch_programs`
--

DROP TABLE IF EXISTS `food_order_api_school_lunch_programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_school_lunch_programs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `school_id` bigint NOT NULL,
  `lunchprogram_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `food_order_api_school_lu_school_id_lunchprogram_i_02034900_uniq` (`school_id`,`lunchprogram_id`),
  KEY `food_order_api_schoo_lunchprogram_id_51c259bf_fk_food_orde` (`lunchprogram_id`),
  CONSTRAINT `food_order_api_schoo_lunchprogram_id_51c259bf_fk_food_orde` FOREIGN KEY (`lunchprogram_id`) REFERENCES `food_order_api_lunchprogram` (`id`),
  CONSTRAINT `food_order_api_schoo_school_id_f798125f_fk_food_orde` FOREIGN KEY (`school_id`) REFERENCES `food_order_api_school` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_school_lunch_programs`
--

LOCK TABLES `food_order_api_school_lunch_programs` WRITE;
/*!40000 ALTER TABLE `food_order_api_school_lunch_programs` DISABLE KEYS */;
INSERT INTO `food_order_api_school_lunch_programs` VALUES (1,1,1);
/*!40000 ALTER TABLE `food_order_api_school_lunch_programs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_school_users`
--

DROP TABLE IF EXISTS `food_order_api_school_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_school_users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `school_id` bigint NOT NULL,
  `customuser_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `food_order_api_school_us_school_id_customuser_id_fece7ccf_uniq` (`school_id`,`customuser_id`),
  KEY `food_order_api_schoo_customuser_id_d02851a3_fk_food_orde` (`customuser_id`),
  CONSTRAINT `food_order_api_schoo_customuser_id_d02851a3_fk_food_orde` FOREIGN KEY (`customuser_id`) REFERENCES `food_order_api_customuser` (`id`),
  CONSTRAINT `food_order_api_schoo_school_id_2c2dd61c_fk_food_orde` FOREIGN KEY (`school_id`) REFERENCES `food_order_api_school` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_school_users`
--

LOCK TABLES `food_order_api_school_users` WRITE;
/*!40000 ALTER TABLE `food_order_api_school_users` DISABLE KEYS */;
INSERT INTO `food_order_api_school_users` VALUES (1,1,1),(2,1,5);
/*!40000 ALTER TABLE `food_order_api_school_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_schoolgroup`
--

DROP TABLE IF EXISTS `food_order_api_schoolgroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_schoolgroup` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_schoolgroup`
--

LOCK TABLES `food_order_api_schoolgroup` WRITE;
/*!40000 ALTER TABLE `food_order_api_schoolgroup` DISABLE KEYS */;
INSERT INTO `food_order_api_schoolgroup` VALUES (1,'LAUSD');
/*!40000 ALTER TABLE `food_order_api_schoolgroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order_api_userorder`
--

DROP TABLE IF EXISTS `food_order_api_userorder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order_api_userorder` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `status` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `quantity` int unsigned NOT NULL,
  `notes` longtext,
  `staff_notes` longtext,
  `school_id` bigint DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `food_order_api_usero_school_id_4fb23c10_fk_food_orde` (`school_id`),
  KEY `food_order_api_usero_user_id_fe14d99b_fk_food_orde` (`user_id`),
  CONSTRAINT `food_order_api_usero_school_id_4fb23c10_fk_food_orde` FOREIGN KEY (`school_id`) REFERENCES `food_order_api_school` (`id`),
  CONSTRAINT `food_order_api_usero_user_id_fe14d99b_fk_food_orde` FOREIGN KEY (`user_id`) REFERENCES `food_order_api_customuser` (`id`),
  CONSTRAINT `food_order_api_userorder_chk_1` CHECK ((`quantity` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_userorder`
--

LOCK TABLES `food_order_api_userorder` WRITE;
/*!40000 ALTER TABLE `food_order_api_userorder` DISABLE KEYS */;
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
  UNIQUE KEY `food_order_api_userorder_userorder_id_menuitem_id_43138da1_uniq` (`userorder_id`,`menuitem_id`),
  KEY `food_order_api_usero_menuitem_id_23da6e39_fk_food_orde` (`menuitem_id`),
  CONSTRAINT `food_order_api_usero_menuitem_id_23da6e39_fk_food_orde` FOREIGN KEY (`menuitem_id`) REFERENCES `food_order_api_menuitem` (`id`),
  CONSTRAINT `food_order_api_usero_userorder_id_da3e8033_fk_food_orde` FOREIGN KEY (`userorder_id`) REFERENCES `food_order_api_userorder` (`id`)
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
  `additional_notes` longtext,
  `support_rep_id` bigint DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `food_order_api_userp_support_rep_id_019ae942_fk_food_orde` (`support_rep_id`),
  CONSTRAINT `food_order_api_userp_support_rep_id_019ae942_fk_food_orde` FOREIGN KEY (`support_rep_id`) REFERENCES `food_order_api_customersupportprofile` (`id`),
  CONSTRAINT `food_order_api_userp_user_id_0a311e2f_fk_food_orde` FOREIGN KEY (`user_id`) REFERENCES `food_order_api_customuser` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order_api_userprofile`
--

LOCK TABLES `food_order_api_userprofile` WRITE;
/*!40000 ALTER TABLE `food_order_api_userprofile` DISABLE KEYS */;
INSERT INTO `food_order_api_userprofile` VALUES (1,'',NULL,1),(8,'Test account - delete before moving to production',NULL,5),(17,NULL,NULL,14),(18,NULL,NULL,15),(19,NULL,NULL,16),(20,NULL,NULL,17),(21,NULL,NULL,18),(22,NULL,NULL,19),(23,NULL,NULL,20),(24,NULL,NULL,21);
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

-- Dump completed on 2025-05-05  3:30:47
