/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE TABLE `branches` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `opening_hours` json NOT NULL,
  `contact_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `delivery_radius` decimal(8,2) NOT NULL DEFAULT '5.00',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `image_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `extra_options` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `food_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(8,2) NOT NULL,
  `is_available` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `extra_options_food_id_foreign` (`food_id`),
  CONSTRAINT `extra_options_food_id_foreign` FOREIGN KEY (`food_id`) REFERENCES `food` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `favorites` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `food_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `favorites_user_id_food_id_unique` (`user_id`,`food_id`),
  KEY `favorites_food_id_foreign` (`food_id`),
  CONSTRAINT `favorites_food_id_foreign` FOREIGN KEY (`food_id`) REFERENCES `food` (`id`) ON DELETE CASCADE,
  CONSTRAINT `favorites_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `food` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `branch_id` bigint unsigned NOT NULL,
  `category_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `base_price` decimal(10,2) NOT NULL,
  `preparation_time` int NOT NULL DEFAULT '30',
  `image_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_vegetarian` tinyint(1) NOT NULL DEFAULT '0',
  `is_spicy` tinyint(1) NOT NULL DEFAULT '0',
  `allergens` json DEFAULT NULL,
  `is_available` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `food_branch_id_foreign` (`branch_id`),
  KEY `food_category_id_foreign` (`category_id`),
  CONSTRAINT `food_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `food_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `order_item_extras` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_item_id` bigint unsigned NOT NULL,
  `extra_option_id` bigint unsigned NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(8,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_item_extras_order_item_id_foreign` (`order_item_id`),
  KEY `order_item_extras_extra_option_id_foreign` (`extra_option_id`),
  CONSTRAINT `order_item_extras_extra_option_id_foreign` FOREIGN KEY (`extra_option_id`) REFERENCES `extra_options` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_item_extras_order_item_id_foreign` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `order_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint unsigned NOT NULL,
  `food_id` bigint unsigned NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(8,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `special_instructions` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_items_order_id_foreign` (`order_id`),
  KEY `order_items_food_id_foreign` (`food_id`),
  CONSTRAINT `order_items_food_id_foreign` FOREIGN KEY (`food_id`) REFERENCES `food` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `orders` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `branch_id` bigint unsigned NOT NULL,
  `order_type` enum('delivery','collection') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `delivery_fee` decimal(8,2) DEFAULT NULL,
  `tax` decimal(8,2) DEFAULT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `delivery_address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `delivery_latitude` decimal(10,8) DEFAULT NULL,
  `delivery_longitude` decimal(11,8) DEFAULT NULL,
  `status` enum('pending','confirmed','preparing','ready_for_delivery','out_for_delivery','delivered','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `payment_status` enum('pending','paid','failed','refunded') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `payment_method` enum('cash','card','upi','wallet') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'cash',
  `delivery_notes` text COLLATE utf8mb4_unicode_ci,
  `estimated_delivery_time` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `orders_user_id_foreign` (`user_id`),
  KEY `orders_branch_id_foreign` (`branch_id`),
  CONSTRAINT `orders_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `reviews` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `order_id` bigint unsigned NOT NULL,
  `branch_id` bigint unsigned NOT NULL,
  `food_rating` int DEFAULT NULL,
  `delivery_rating` int DEFAULT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `is_published` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `reviews_user_id_foreign` (`user_id`),
  KEY `reviews_order_id_foreign` (`order_id`),
  KEY `reviews_branch_id_foreign` (`branch_id`),
  CONSTRAINT `reviews_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `user_addresses` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `address_label` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_addresses_user_id_foreign` (`user_id`),
  CONSTRAINT `user_addresses_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `photo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `default_address` text COLLATE utf8mb4_unicode_ci,
  `role` enum('customer','branch_admin','super_admin') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'customer',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `branches` (`id`, `name`, `address`, `latitude`, `longitude`, `opening_hours`, `contact_number`, `delivery_radius`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Naogaon', 'Ukilpara, Nagoan Sadar, Naogaon', '24.36956160', '88.59484160', '[{\"day\": \"Monday\", \"open\": \"09:00\", \"close\": \"22:00\"}, {\"day\": \"Tuesday\", \"open\": \"09:00\", \"close\": \"22:00\"}, {\"day\": \"Wednesday\", \"open\": \"09:00\", \"close\": \"22:00\"}, {\"day\": \"Thursday\", \"open\": \"09:00\", \"close\": \"22:00\"}, {\"day\": \"Friday\", \"open\": \"09:00\", \"close\": \"22:00\"}, {\"day\": \"Saturday\", \"open\": \"09:00\", \"close\": \"22:00\"}, {\"day\": \"Sunday\", \"open\": \"09:00\", \"close\": \"22:00\"}]', '01717893432', '50.00', 1, '2024-10-29 07:36:36', '2024-10-29 07:37:37', NULL);






INSERT INTO `categories` (`id`, `name`, `description`, `image_path`, `sort_order`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Burger', 'Nothing just test', 'categories/JAvjfO8tdj8ekTEbhM2sJ9FB7V0WFugY0SjG5Fni.png', 0, 0, '2024-10-29 06:34:07', '2024-10-29 06:55:48', '2024-10-29 06:55:48');
INSERT INTO `categories` (`id`, `name`, `description`, `image_path`, `sort_order`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(2, 'Hello test', 'Nothing', 'categories/TNglchh6keFtUvcsSKe9tw8KALB6wWUoTUx4W2P6.jpg', 0, 1, '2024-10-29 06:56:27', '2024-10-29 06:56:27', NULL);


INSERT INTO `extra_options` (`id`, `food_id`, `name`, `price`, `is_available`, `sort_order`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'gsdfgdsfg', '4.00', 1, 0, '2024-10-30 04:35:29', '2024-10-30 04:35:29', NULL);






INSERT INTO `food` (`id`, `branch_id`, `category_id`, `name`, `description`, `base_price`, `preparation_time`, `image_path`, `is_vegetarian`, `is_spicy`, `allergens`, `is_available`, `sort_order`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 2, 'Hello Food', 'This is simple test', '20.00', 50, 'foods/g0kQF24YjvDhq5uF90hSj9ZXEbPs08hHqvq3T7Am.png', 1, 0, NULL, 1, 0, '2024-10-30 04:35:29', '2024-10-30 04:35:29', NULL);






INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(2, '0001_01_01_000001_create_cache_table', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(3, '0001_01_01_000002_create_jobs_table', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(4, '2024_10_29_053002_create_categories_table', 1),
(5, '2024_10_29_053029_create_branches_table', 1),
(6, '2024_10_29_053101_create_food_table', 1),
(7, '2024_10_29_053143_create_extra_options_table', 1),
(8, '2024_10_29_053302_create_orders_table', 1),
(9, '2024_10_29_053346_create_order_items_table', 1),
(10, '2024_10_29_053416_create_order_item_extras_table', 1),
(11, '2024_10_29_053447_create_user_addresses_table', 1),
(12, '2024_10_29_053518_create_reviews_table', 1),
(13, '2024_10_29_053552_create_favorites_table', 1),
(15, '2024_11_07_054652_add_order_type_to_orders_table', 2);

INSERT INTO `order_item_extras` (`id`, `order_item_id`, `extra_option_id`, `quantity`, `unit_price`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 1, 1, '4.00', '2024-10-30 07:05:50', '2024-10-30 07:05:50', NULL);


INSERT INTO `order_items` (`id`, `order_id`, `food_id`, `quantity`, `unit_price`, `subtotal`, `special_instructions`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 1, 3, '20.00', '72.00', 'Hello test', '2024-10-30 07:05:50', '2024-10-30 07:05:50', NULL);
INSERT INTO `order_items` (`id`, `order_id`, `food_id`, `quantity`, `unit_price`, `subtotal`, `special_instructions`, `created_at`, `updated_at`, `deleted_at`) VALUES
(5, 6, 1, 1, '20.00', '20.00', NULL, '2024-11-07 06:34:17', '2024-11-07 06:34:17', NULL);
INSERT INTO `order_items` (`id`, `order_id`, `food_id`, `quantity`, `unit_price`, `subtotal`, `special_instructions`, `created_at`, `updated_at`, `deleted_at`) VALUES
(7, 8, 1, 1, '20.00', '20.00', NULL, '2024-11-07 07:08:22', '2024-11-07 07:08:22', NULL);
INSERT INTO `order_items` (`id`, `order_id`, `food_id`, `quantity`, `unit_price`, `subtotal`, `special_instructions`, `created_at`, `updated_at`, `deleted_at`) VALUES
(10, 11, 1, 1, '20.00', '20.00', NULL, '2024-11-07 07:09:44', '2024-11-07 07:09:44', NULL),
(13, 14, 1, 1, '20.00', '20.00', NULL, '2024-11-07 08:45:53', '2024-11-07 08:45:53', NULL),
(16, 17, 1, 1, '20.00', '20.00', NULL, '2024-11-07 09:05:50', '2024-11-07 09:05:50', NULL),
(18, 19, 1, 1, '20.00', '20.00', NULL, '2024-11-07 09:24:14', '2024-11-07 09:24:14', NULL),
(19, 20, 1, 1, '20.00', '20.00', NULL, '2024-11-07 09:36:56', '2024-11-07 09:36:56', NULL);

INSERT INTO `orders` (`id`, `user_id`, `branch_id`, `order_type`, `subtotal`, `delivery_fee`, `tax`, `total_amount`, `delivery_address`, `delivery_latitude`, `delivery_longitude`, `status`, `payment_status`, `payment_method`, `delivery_notes`, `estimated_delivery_time`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 1, NULL, '72.00', '2.99', '14.40', '89.39', 'Bangas', NULL, NULL, 'pending', 'paid', 'card', 'fgdsfgsdg', '2024-10-30 07:50:50', '2024-10-30 07:05:50', '2024-10-30 07:05:50', NULL);
INSERT INTO `orders` (`id`, `user_id`, `branch_id`, `order_type`, `subtotal`, `delivery_fee`, `tax`, `total_amount`, `delivery_address`, `delivery_latitude`, `delivery_longitude`, `status`, `payment_status`, `payment_method`, `delivery_notes`, `estimated_delivery_time`, `created_at`, `updated_at`, `deleted_at`) VALUES
(6, 2, 1, NULL, '20.00', '2.99', '4.00', '26.99', 'sdfgfsdg', NULL, NULL, 'confirmed', 'paid', 'card', NULL, '2024-11-07 07:19:17', '2024-11-07 06:34:17', '2024-11-07 06:34:17', NULL);
INSERT INTO `orders` (`id`, `user_id`, `branch_id`, `order_type`, `subtotal`, `delivery_fee`, `tax`, `total_amount`, `delivery_address`, `delivery_latitude`, `delivery_longitude`, `status`, `payment_status`, `payment_method`, `delivery_notes`, `estimated_delivery_time`, `created_at`, `updated_at`, `deleted_at`) VALUES
(8, 2, 1, 'delivery', '20.00', '2.99', '4.00', '26.99', 'sdfgfsdg', NULL, NULL, 'confirmed', 'paid', 'card', 'safgsdf', '2024-11-07 07:53:22', '2024-11-07 07:08:22', '2024-11-07 07:08:22', NULL);
INSERT INTO `orders` (`id`, `user_id`, `branch_id`, `order_type`, `subtotal`, `delivery_fee`, `tax`, `total_amount`, `delivery_address`, `delivery_latitude`, `delivery_longitude`, `status`, `payment_status`, `payment_method`, `delivery_notes`, `estimated_delivery_time`, `created_at`, `updated_at`, `deleted_at`) VALUES
(11, 2, 1, 'delivery', '20.00', '2.99', '4.00', '26.99', 'dfghdfh', NULL, NULL, 'confirmed', 'paid', 'cash', 'sdfgsfdg', '2024-11-07 07:54:44', '2024-11-07 07:09:44', '2024-11-07 07:09:44', NULL),
(14, 2, 1, 'collection', '20.00', NULL, '4.00', '24.00', NULL, NULL, NULL, 'confirmed', 'paid', 'card', NULL, '2024-11-07 09:30:53', '2024-11-07 08:45:53', '2024-11-07 08:45:53', NULL),
(17, 2, 1, 'collection', '20.00', NULL, '4.00', '24.00', NULL, NULL, NULL, 'confirmed', 'paid', 'card', NULL, '2024-11-07 09:25:50', '2024-11-07 09:05:50', '2024-11-07 09:05:50', NULL),
(19, 2, 1, 'delivery', '20.00', '2.99', '4.00', '26.99', 'sdfgfsdg', NULL, NULL, 'confirmed', 'paid', 'card', 'Hello', '2024-11-07 10:09:14', '2024-11-07 09:24:14', '2024-11-07 09:24:14', NULL),
(20, 1, 1, 'collection', '20.00', NULL, NULL, '20.00', NULL, NULL, NULL, 'confirmed', 'paid', 'card', NULL, '2024-11-07 09:56:56', '2024-11-07 09:36:56', '2024-11-07 09:36:56', NULL);





INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('CDRpGiBDfmEav6GKJoFDSnPBNNalCeku69baFG9s', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiZEJpVGpQekZES1VNempNb2taa2dvbEIwQWowalJOODdIOHhoZTlYcSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1746675846);
INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('U4s88no9QjquQH4gIqsgsXVxGlgLJYZY3cC1xEtU', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoicXN5TXV0OHZlYXRFZ3V4dmk2TnMxSzR3aGpNVE9pbmlHcE1qdFV2ViI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjE7czoxNToic2VsZWN0ZWRfYnJhbmNoIjtPOjE3OiJBcHBcTW9kZWxzXEJyYW5jaCI6MzE6e3M6MTM6IgAqAGNvbm5lY3Rpb24iO3M6NToibXlzcWwiO3M6ODoiACoAdGFibGUiO3M6ODoiYnJhbmNoZXMiO3M6MTM6IgAqAHByaW1hcnlLZXkiO3M6MjoiaWQiO3M6MTA6IgAqAGtleVR5cGUiO3M6MzoiaW50IjtzOjEyOiJpbmNyZW1lbnRpbmciO2I6MTtzOjc6IgAqAHdpdGgiO2E6MDp7fXM6MTI6IgAqAHdpdGhDb3VudCI7YTowOnt9czoxOToicHJldmVudHNMYXp5TG9hZGluZyI7YjowO3M6MTA6IgAqAHBlclBhZ2UiO2k6MTU7czo2OiJleGlzdHMiO2I6MTtzOjE4OiJ3YXNSZWNlbnRseUNyZWF0ZWQiO2I6MDtzOjI4OiIAKgBlc2NhcGVXaGVuQ2FzdGluZ1RvU3RyaW5nIjtiOjA7czoxMzoiACoAYXR0cmlidXRlcyI7YToxMjp7czoyOiJpZCI7aToxO3M6NDoibmFtZSI7czo3OiJOYW9nYW9uIjtzOjc6ImFkZHJlc3MiO3M6MzE6IlVraWxwYXJhLCBOYWdvYW4gU2FkYXIsIE5hb2dhb24iO3M6ODoibGF0aXR1ZGUiO3M6MTE6IjI0LjM2OTU2MTYwIjtzOjk6ImxvbmdpdHVkZSI7czoxMToiODguNTk0ODQxNjAiO3M6MTM6Im9wZW5pbmdfaG91cnMiO3M6Mzg2OiJbeyJkYXkiOiAiTW9uZGF5IiwgIm9wZW4iOiAiMDk6MDAiLCAiY2xvc2UiOiAiMjI6MDAifSwgeyJkYXkiOiAiVHVlc2RheSIsICJvcGVuIjogIjA5OjAwIiwgImNsb3NlIjogIjIyOjAwIn0sIHsiZGF5IjogIldlZG5lc2RheSIsICJvcGVuIjogIjA5OjAwIiwgImNsb3NlIjogIjIyOjAwIn0sIHsiZGF5IjogIlRodXJzZGF5IiwgIm9wZW4iOiAiMDk6MDAiLCAiY2xvc2UiOiAiMjI6MDAifSwgeyJkYXkiOiAiRnJpZGF5IiwgIm9wZW4iOiAiMDk6MDAiLCAiY2xvc2UiOiAiMjI6MDAifSwgeyJkYXkiOiAiU2F0dXJkYXkiLCAib3BlbiI6ICIwOTowMCIsICJjbG9zZSI6ICIyMjowMCJ9LCB7ImRheSI6ICJTdW5kYXkiLCAib3BlbiI6ICIwOTowMCIsICJjbG9zZSI6ICIyMjowMCJ9XSI7czoxNDoiY29udGFjdF9udW1iZXIiO3M6MTE6IjAxNzE3ODkzNDMyIjtzOjE1OiJkZWxpdmVyeV9yYWRpdXMiO3M6NToiNTAuMDAiO3M6OToiaXNfYWN0aXZlIjtpOjE7czoxMDoiY3JlYXRlZF9hdCI7czoxOToiMjAyNC0xMC0yOSAwNzozNjozNiI7czoxMDoidXBkYXRlZF9hdCI7czoxOToiMjAyNC0xMC0yOSAwNzozNzozNyI7czoxMDoiZGVsZXRlZF9hdCI7Tjt9czoxMToiACoAb3JpZ2luYWwiO2E6MTI6e3M6MjoiaWQiO2k6MTtzOjQ6Im5hbWUiO3M6NzoiTmFvZ2FvbiI7czo3OiJhZGRyZXNzIjtzOjMxOiJVa2lscGFyYSwgTmFnb2FuIFNhZGFyLCBOYW9nYW9uIjtzOjg6ImxhdGl0dWRlIjtzOjExOiIyNC4zNjk1NjE2MCI7czo5OiJsb25naXR1ZGUiO3M6MTE6Ijg4LjU5NDg0MTYwIjtzOjEzOiJvcGVuaW5nX2hvdXJzIjtzOjM4NjoiW3siZGF5IjogIk1vbmRheSIsICJvcGVuIjogIjA5OjAwIiwgImNsb3NlIjogIjIyOjAwIn0sIHsiZGF5IjogIlR1ZXNkYXkiLCAib3BlbiI6ICIwOTowMCIsICJjbG9zZSI6ICIyMjowMCJ9LCB7ImRheSI6ICJXZWRuZXNkYXkiLCAib3BlbiI6ICIwOTowMCIsICJjbG9zZSI6ICIyMjowMCJ9LCB7ImRheSI6ICJUaHVyc2RheSIsICJvcGVuIjogIjA5OjAwIiwgImNsb3NlIjogIjIyOjAwIn0sIHsiZGF5IjogIkZyaWRheSIsICJvcGVuIjogIjA5OjAwIiwgImNsb3NlIjogIjIyOjAwIn0sIHsiZGF5IjogIlNhdHVyZGF5IiwgIm9wZW4iOiAiMDk6MDAiLCAiY2xvc2UiOiAiMjI6MDAifSwgeyJkYXkiOiAiU3VuZGF5IiwgIm9wZW4iOiAiMDk6MDAiLCAiY2xvc2UiOiAiMjI6MDAifV0iO3M6MTQ6ImNvbnRhY3RfbnVtYmVyIjtzOjExOiIwMTcxNzg5MzQzMiI7czoxNToiZGVsaXZlcnlfcmFkaXVzIjtzOjU6IjUwLjAwIjtzOjk6ImlzX2FjdGl2ZSI7aToxO3M6MTA6ImNyZWF0ZWRfYXQiO3M6MTk6IjIwMjQtMTAtMjkgMDc6MzY6MzYiO3M6MTA6InVwZGF0ZWRfYXQiO3M6MTk6IjIwMjQtMTAtMjkgMDc6Mzc6MzciO3M6MTA6ImRlbGV0ZWRfYXQiO047fXM6MTA6IgAqAGNoYW5nZXMiO2E6MDp7fXM6ODoiACoAY2FzdHMiO2E6Njp7czoxMzoib3BlbmluZ19ob3VycyI7czo1OiJhcnJheSI7czo4OiJsYXRpdHVkZSI7czo5OiJkZWNpbWFsOjgiO3M6OToibG9uZ2l0dWRlIjtzOjk6ImRlY2ltYWw6OCI7czoxNToiZGVsaXZlcnlfcmFkaXVzIjtzOjk6ImRlY2ltYWw6MiI7czo5OiJpc19hY3RpdmUiO3M6NzoiYm9vbGVhbiI7czoxMDoiZGVsZXRlZF9hdCI7czo4OiJkYXRldGltZSI7fXM6MTc6IgAqAGNsYXNzQ2FzdENhY2hlIjthOjA6e31zOjIxOiIAKgBhdHRyaWJ1dGVDYXN0Q2FjaGUiO2E6MDp7fXM6MTM6IgAqAGRhdGVGb3JtYXQiO047czoxMDoiACoAYXBwZW5kcyI7YTowOnt9czoxOToiACoAZGlzcGF0Y2hlc0V2ZW50cyI7YTowOnt9czoxNDoiACoAb2JzZXJ2YWJsZXMiO2E6MDp7fXM6MTI6IgAqAHJlbGF0aW9ucyI7YTowOnt9czoxMDoiACoAdG91Y2hlcyI7YTowOnt9czoxMDoidGltZXN0YW1wcyI7YjoxO3M6MTM6InVzZXNVbmlxdWVJZHMiO2I6MDtzOjk6IgAqAGhpZGRlbiI7YTowOnt9czoxMDoiACoAdmlzaWJsZSI7YTowOnt9czoxMToiACoAZmlsbGFibGUiO2E6ODp7aTowO3M6NDoibmFtZSI7aToxO3M6NzoiYWRkcmVzcyI7aToyO3M6ODoibGF0aXR1ZGUiO2k6MztzOjk6ImxvbmdpdHVkZSI7aTo0O3M6MTM6Im9wZW5pbmdfaG91cnMiO2k6NTtzOjE0OiJjb250YWN0X251bWJlciI7aTo2O3M6MTU6ImRlbGl2ZXJ5X3JhZGl1cyI7aTo3O3M6OToiaXNfYWN0aXZlIjt9czoxMDoiACoAZ3VhcmRlZCI7YToxOntpOjA7czoxOiIqIjt9czoxNjoiACoAZm9yY2VEZWxldGluZyI7YjowO319', 1731017802);
INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('WwhFB0iAh0t52kr1p1Ns525MGRVG2ShmGbTt8dDz', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoid0lZYlRKa0VnbE9HOHpFOHhYNEhweEpidkYzemk4REdxZUVIaGFBWiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1731228279);

INSERT INTO `user_addresses` (`id`, `user_id`, `address_label`, `address`, `latitude`, `longitude`, `is_default`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'Bangla', 'Bangas', NULL, NULL, 1, '2024-10-30 07:05:43', '2024-10-30 07:05:43', NULL);
INSERT INTO `user_addresses` (`id`, `user_id`, `address_label`, `address`, `latitude`, `longitude`, `is_default`, `created_at`, `updated_at`, `deleted_at`) VALUES
(2, 2, 'Hello', 'sdfgfsdg', NULL, NULL, 1, '2024-11-07 06:08:24', '2024-11-07 06:08:24', NULL);
INSERT INTO `user_addresses` (`id`, `user_id`, `address_label`, `address`, `latitude`, `longitude`, `is_default`, `created_at`, `updated_at`, `deleted_at`) VALUES
(3, 2, 'dhdg', 'dfghdfh', NULL, NULL, 0, '2024-11-07 07:09:08', '2024-11-07 07:09:08', NULL);

INSERT INTO `users` (`id`, `photo`, `name`, `email`, `email_verified_at`, `phone`, `default_address`, `role`, `is_active`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, NULL, 'Super Admin', 'superadmin@mail.com', '2024-10-29 05:56:28', NULL, NULL, 'super_admin', 1, '$2y$12$Lwtwu.dib7wtwAs4BpkloeoL1duXcgg1RL0Ba3hWgl9fR52/4XlsO', 'jMvdNE50UkSMPrFLG7HZZ99oaZRpHFLUDtz0Y0B3wkk9sSg9fy6mbhxmD0CP', '2024-10-29 05:56:29', '2024-10-29 05:56:29');
INSERT INTO `users` (`id`, `photo`, `name`, `email`, `email_verified_at`, `phone`, `default_address`, `role`, `is_active`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(2, NULL, 'Istiak', 'is@mail.com', NULL, '984753485', NULL, 'customer', 1, '$2y$12$XgkfIUYiicz/zYrNYqN8KOY6btYppQJtxNhu4jEcQylFbdN6/qyKq', NULL, '2024-11-07 06:07:38', '2024-11-07 06:07:38');



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;