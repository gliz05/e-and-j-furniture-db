-- =====================================================================
-- E and J Furniture - database schema (MySQL / MariaDB, XAMPP)
-- Generated from the corrected ERD and Data Dictionary_EJ_Furniture.
-- Creates a NEW database; it does not alter or drop anything existing.
-- =====================================================================

CREATE DATABASE ej_furniture
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ej_furniture;

-- Referential rules used below:
--   ON UPDATE CASCADE everywhere.
--   ON DELETE CASCADE  : detail/child rows that make no sense without the parent
--                        (address, order items, status history, notes, adjustments,
--                         reservations, estimate items, price rule details).
--   ON DELETE SET NULL : optional links (order_id / material_id that may be empty).
--   ON DELETE RESTRICT : everything else (cannot delete a record still in use).

CREATE TABLE `CUSTOMER` (
  `customer_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer_name` VARCHAR(100) NOT NULL,
  `contact_number` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ADDRESS` (
  `address_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer_id` BIGINT UNSIGNED NOT NULL,
  `street` VARCHAR(150) NOT NULL,
  `city` VARCHAR(50) NOT NULL,
  `postal_code` VARCHAR(10) NULL,
  PRIMARY KEY (`address_id`),
  CONSTRAINT `fk_address_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `CUSTOMER` (`customer_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ROLE` (
  `role_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_name` VARCHAR(30) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`role_id`),
  CONSTRAINT `uq_role_role_name` UNIQUE (`role_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `STAFF` (
  `staff_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_id` BIGINT UNSIGNED NOT NULL,
  `first_name` VARCHAR(50) NOT NULL,
  `middle_name` VARCHAR(50) NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `username` VARCHAR(50) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`staff_id`),
  CONSTRAINT `uq_staff_username` UNIQUE (`username`),
  CONSTRAINT `fk_staff_role_id` FOREIGN KEY (`role_id`) REFERENCES `ROLE` (`role_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `UNIT_TYPE` (
  `unit_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `unit_name` VARCHAR(30) NOT NULL,
  `unit_abbreviation` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`unit_id`),
  CONSTRAINT `uq_unit_type_unit_name` UNIQUE (`unit_name`),
  CONSTRAINT `uq_unit_type_unit_abbreviation` UNIQUE (`unit_abbreviation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `MATERIAL_CATEGORY` (
  `material_category_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(50) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`material_category_id`),
  CONSTRAINT `uq_material_category_category_name` UNIQUE (`category_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `MATERIALS` (
  `material_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `material_category_id` BIGINT UNSIGNED NOT NULL,
  `unit_id` BIGINT UNSIGNED NOT NULL,
  `material_name` VARCHAR(100) NOT NULL,
  `unit_cost` DECIMAL(10,2) NOT NULL,
  `minimum_stock` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`material_id`),
  CONSTRAINT `uq_materials_material_name` UNIQUE (`material_name`),
  CONSTRAINT `fk_materials_material_category_id` FOREIGN KEY (`material_category_id`) REFERENCES `MATERIAL_CATEGORY` (`material_category_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_materials_unit_id` FOREIGN KEY (`unit_id`) REFERENCES `UNIT_TYPE` (`unit_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_materials_unit_cost` CHECK (`unit_cost` > 0),
  CONSTRAINT `chk_materials_minimum_stock` CHECK (`minimum_stock` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `INVENTORY` (
  `inventory_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `material_id` BIGINT UNSIGNED NOT NULL,
  `stock_quantity` DECIMAL(10,2) NOT NULL,
  `last_updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`inventory_id`),
  CONSTRAINT `uq_inventory_material_id` UNIQUE (`material_id`),
  CONSTRAINT `fk_inventory_material_id` FOREIGN KEY (`material_id`) REFERENCES `MATERIALS` (`material_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_inventory_stock_quantity` CHECK (`stock_quantity` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `TRANSACTION_TYPE` (
  `transaction_type_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `type_name` VARCHAR(30) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`transaction_type_id`),
  CONSTRAINT `uq_transaction_type_type_name` UNIQUE (`type_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `FURNITURE_CATEGORY` (
  `category_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(50) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`category_id`),
  CONSTRAINT `uq_furniture_category_category_name` UNIQUE (`category_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `FURNITURE` (
  `furniture_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_id` BIGINT UNSIGNED NOT NULL,
  `furniture_name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`furniture_id`),
  CONSTRAINT `uq_furniture_furniture_name` UNIQUE (`furniture_name`),
  CONSTRAINT `fk_furniture_category_id` FOREIGN KEY (`category_id`) REFERENCES `FURNITURE_CATEGORY` (`category_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `COMPUTATION_TYPE` (
  `computation_type_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `computation_type_name` VARCHAR(30) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`computation_type_id`),
  CONSTRAINT `uq_computation_type_computation_type_name` UNIQUE (`computation_type_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `MATERIAL_REQUIREMENT` (
  `requirement_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `furniture_id` BIGINT UNSIGNED NOT NULL,
  `material_id` BIGINT UNSIGNED NOT NULL,
  `computation_type_id` BIGINT UNSIGNED NOT NULL,
  `required_quantity` DECIMAL(10,4) NOT NULL,
  PRIMARY KEY (`requirement_id`),
  CONSTRAINT `fk_material_requirement_furniture_id` FOREIGN KEY (`furniture_id`) REFERENCES `FURNITURE` (`furniture_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_material_requirement_material_id` FOREIGN KEY (`material_id`) REFERENCES `MATERIALS` (`material_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_material_requirement_computation_type_id` FOREIGN KEY (`computation_type_id`) REFERENCES `COMPUTATION_TYPE` (`computation_type_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_material_requirement_required_quantity` CHECK (`required_quantity` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `DELIVERY_TYPE` (
  `delivery_type_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `delivery_name` VARCHAR(30) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`delivery_type_id`),
  CONSTRAINT `uq_delivery_type_delivery_name` UNIQUE (`delivery_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ORDER_STATUS` (
  `order_status_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `status_name` VARCHAR(30) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`order_status_id`),
  CONSTRAINT `uq_order_status_status_name` UNIQUE (`status_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `CUSTOMER_ORDER` (
  `order_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer_id` BIGINT UNSIGNED NOT NULL,
  `staff_id` BIGINT UNSIGNED NOT NULL,
  `delivery_type_id` BIGINT UNSIGNED NOT NULL,
  `order_status_id` BIGINT UNSIGNED NOT NULL,
  `order_date` DATE NOT NULL,
  `expected_delivery_date` DATE NOT NULL,
  `total_amount` DECIMAL(10,2) NOT NULL,
  `remarks` TEXT NULL,
  PRIMARY KEY (`order_id`),
  CONSTRAINT `fk_customer_order_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `CUSTOMER` (`customer_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_customer_order_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `STAFF` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_customer_order_delivery_type_id` FOREIGN KEY (`delivery_type_id`) REFERENCES `DELIVERY_TYPE` (`delivery_type_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_customer_order_order_status_id` FOREIGN KEY (`order_status_id`) REFERENCES `ORDER_STATUS` (`order_status_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_customer_order_total_amount` CHECK (`total_amount` >= 0),
  CONSTRAINT `chk_customer_order_dates` CHECK (`expected_delivery_date` >= `order_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `INVENTORY_TRANSACTION` (
  `transaction_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `material_id` BIGINT UNSIGNED NOT NULL,
  `staff_id` BIGINT UNSIGNED NOT NULL,
  `order_id` BIGINT UNSIGNED NULL,
  `transaction_type_id` BIGINT UNSIGNED NOT NULL,
  `quantity` DECIMAL(10,2) NOT NULL,
  `transaction_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `remarks` TEXT NULL,
  PRIMARY KEY (`transaction_id`),
  CONSTRAINT `fk_inventory_transaction_material_id` FOREIGN KEY (`material_id`) REFERENCES `MATERIALS` (`material_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_inventory_transaction_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `STAFF` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_inventory_transaction_order_id` FOREIGN KEY (`order_id`) REFERENCES `CUSTOMER_ORDER` (`order_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_inventory_transaction_transaction_type_id` FOREIGN KEY (`transaction_type_id`) REFERENCES `TRANSACTION_TYPE` (`transaction_type_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_inventory_transaction_quantity` CHECK (`quantity` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ORDER_STATUS_HISTORY` (
  `history_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` BIGINT UNSIGNED NOT NULL,
  `staff_id` BIGINT UNSIGNED NOT NULL,
  `order_status_id` BIGINT UNSIGNED NOT NULL,
  `status_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `remarks` TEXT NULL,
  PRIMARY KEY (`history_id`),
  CONSTRAINT `fk_order_status_history_order_id` FOREIGN KEY (`order_id`) REFERENCES `CUSTOMER_ORDER` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_order_status_history_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `STAFF` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_order_status_history_order_status_id` FOREIGN KEY (`order_status_id`) REFERENCES `ORDER_STATUS` (`order_status_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ORDER_ITEM` (
  `order_item_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` BIGINT UNSIGNED NOT NULL,
  `furniture_id` BIGINT UNSIGNED NOT NULL,
  `wood_material_id` BIGINT UNSIGNED NOT NULL,
  `length` DECIMAL(8,2) NOT NULL,
  `width` DECIMAL(8,2) NOT NULL,
  `height` DECIMAL(8,2) NOT NULL,
  `quantity` INT NOT NULL,
  `agreed_price` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`order_item_id`),
  CONSTRAINT `fk_order_item_order_id` FOREIGN KEY (`order_id`) REFERENCES `CUSTOMER_ORDER` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_order_item_furniture_id` FOREIGN KEY (`furniture_id`) REFERENCES `FURNITURE` (`furniture_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_order_item_wood_material_id` FOREIGN KEY (`wood_material_id`) REFERENCES `MATERIALS` (`material_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_order_item_length` CHECK (`length` > 0),
  CONSTRAINT `chk_order_item_width` CHECK (`width` > 0),
  CONSTRAINT `chk_order_item_height` CHECK (`height` > 0),
  CONSTRAINT `chk_order_item_quantity` CHECK (`quantity` >= 1),
  CONSTRAINT `chk_order_item_agreed_price` CHECK (`agreed_price` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `DELIVERY` (
  `delivery_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` BIGINT UNSIGNED NOT NULL,
  `staff_id` BIGINT UNSIGNED NOT NULL,
  `actual_delivery_date` DATE NULL,
  `delivery_status` VARCHAR(20) NOT NULL,
  `remarks` TEXT NULL,
  PRIMARY KEY (`delivery_id`),
  CONSTRAINT `fk_delivery_order_id` FOREIGN KEY (`order_id`) REFERENCES `CUSTOMER_ORDER` (`order_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_delivery_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `STAFF` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ADJUSTMENT_TYPE` (
  `adjustment_type_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `adjustment_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`adjustment_type_id`),
  CONSTRAINT `uq_adjustment_type_adjustment_name` UNIQUE (`adjustment_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ORDER_ADJUSTMENT` (
  `adjustment_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` BIGINT UNSIGNED NOT NULL,
  `staff_id` BIGINT UNSIGNED NOT NULL,
  `adjustment_type_id` BIGINT UNSIGNED NOT NULL,
  `description` TEXT NOT NULL,
  `adjustment_date` DATE NOT NULL,
  PRIMARY KEY (`adjustment_id`),
  CONSTRAINT `fk_order_adjustment_order_id` FOREIGN KEY (`order_id`) REFERENCES `CUSTOMER_ORDER` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_order_adjustment_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `STAFF` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_order_adjustment_adjustment_type_id` FOREIGN KEY (`adjustment_type_id`) REFERENCES `ADJUSTMENT_TYPE` (`adjustment_type_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ORDER_NOTE` (
  `note_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` BIGINT UNSIGNED NOT NULL,
  `staff_id` BIGINT UNSIGNED NOT NULL,
  `note_content` TEXT NOT NULL,
  `date_created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`note_id`),
  CONSTRAINT `fk_order_note_order_id` FOREIGN KEY (`order_id`) REFERENCES `CUSTOMER_ORDER` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_order_note_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `STAFF` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `RULE_STATUS` (
  `rule_status_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `rule_status_name` VARCHAR(30) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`rule_status_id`),
  CONSTRAINT `uq_rule_status_rule_status_name` UNIQUE (`rule_status_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `PRICE_RULE` (
  `price_rule_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `rule_name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL,
  `markup_percentage` DECIMAL(5,2) NOT NULL,
  `rule_status_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`price_rule_id`),
  CONSTRAINT `uq_price_rule_rule_name` UNIQUE (`rule_name`),
  CONSTRAINT `fk_price_rule_rule_status_id` FOREIGN KEY (`rule_status_id`) REFERENCES `RULE_STATUS` (`rule_status_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_price_rule_markup_percentage` CHECK (`markup_percentage` BETWEEN 0 AND 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `PRICE_RULE_DETAIL` (
  `rule_detail_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `price_rule_id` BIGINT UNSIGNED NOT NULL,
  `furniture_id` BIGINT UNSIGNED NOT NULL,
  `material_id` BIGINT UNSIGNED NOT NULL,
  `rate_per_unit` DECIMAL(10,2) NOT NULL,
  `labor_rate` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`rule_detail_id`),
  CONSTRAINT `fk_price_rule_detail_price_rule_id` FOREIGN KEY (`price_rule_id`) REFERENCES `PRICE_RULE` (`price_rule_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_price_rule_detail_furniture_id` FOREIGN KEY (`furniture_id`) REFERENCES `FURNITURE` (`furniture_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_price_rule_detail_material_id` FOREIGN KEY (`material_id`) REFERENCES `MATERIALS` (`material_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_price_rule_detail_rate_per_unit` CHECK (`rate_per_unit` > 0),
  CONSTRAINT `chk_price_rule_detail_labor_rate` CHECK (`labor_rate` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `PRICE_ESTIMATE` (
  `estimate_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer_id` BIGINT UNSIGNED NOT NULL,
  `order_id` BIGINT UNSIGNED NULL,
  `staff_id` BIGINT UNSIGNED NOT NULL,
  `price_rule_id` BIGINT UNSIGNED NOT NULL,
  `labor_cost` DECIMAL(10,2) NOT NULL,
  `markup` DECIMAL(10,2) NOT NULL,
  `total_estimated_price` DECIMAL(10,2) NOT NULL,
  `estimated_date` DATE NOT NULL,
  PRIMARY KEY (`estimate_id`),
  CONSTRAINT `fk_price_estimate_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `CUSTOMER` (`customer_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_price_estimate_order_id` FOREIGN KEY (`order_id`) REFERENCES `CUSTOMER_ORDER` (`order_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_price_estimate_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `STAFF` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_price_estimate_price_rule_id` FOREIGN KEY (`price_rule_id`) REFERENCES `PRICE_RULE` (`price_rule_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_price_estimate_labor_cost` CHECK (`labor_cost` >= 0),
  CONSTRAINT `chk_price_estimate_markup` CHECK (`markup` >= 0),
  CONSTRAINT `chk_price_estimate_total_estimated_price` CHECK (`total_estimated_price` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `PRICE_ESTIMATE_ITEM` (
  `estimate_item_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `estimate_id` BIGINT UNSIGNED NOT NULL,
  `material_id` BIGINT UNSIGNED NOT NULL,
  `quantity` DECIMAL(10,2) NOT NULL,
  `unit_cost` DECIMAL(10,2) NOT NULL,
  `subtotal` DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (`estimate_item_id`),
  CONSTRAINT `fk_price_estimate_item_estimate_id` FOREIGN KEY (`estimate_id`) REFERENCES `PRICE_ESTIMATE` (`estimate_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_price_estimate_item_material_id` FOREIGN KEY (`material_id`) REFERENCES `MATERIALS` (`material_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_price_estimate_item_quantity` CHECK (`quantity` > 0),
  CONSTRAINT `chk_price_estimate_item_unit_cost` CHECK (`unit_cost` > 0),
  CONSTRAINT `chk_price_estimate_item_subtotal` CHECK (`subtotal` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `MATERIAL_RESERVATION` (
  `reservation_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` BIGINT UNSIGNED NOT NULL,
  `material_id` BIGINT UNSIGNED NOT NULL,
  `reserved_quantity` DECIMAL(10,2) NOT NULL,
  `reservation_status` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`reservation_id`),
  CONSTRAINT `fk_material_reservation_order_id` FOREIGN KEY (`order_id`) REFERENCES `CUSTOMER_ORDER` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_material_reservation_material_id` FOREIGN KEY (`material_id`) REFERENCES `MATERIALS` (`material_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_material_reservation_reserved_quantity` CHECK (`reserved_quantity` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `PAYMENT_STATUS` (
  `payment_status_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `payment_status_name` VARCHAR(30) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`payment_status_id`),
  CONSTRAINT `uq_payment_status_payment_status_name` UNIQUE (`payment_status_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `PAYMENT` (
  `payment_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` BIGINT UNSIGNED NOT NULL,
  `payment_status_id` BIGINT UNSIGNED NOT NULL,
  `cash_tendered` DECIMAL(10,2) NOT NULL,
  `change_amount` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`payment_id`),
  CONSTRAINT `fk_payment_order_id` FOREIGN KEY (`order_id`) REFERENCES `CUSTOMER_ORDER` (`order_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_payment_payment_status_id` FOREIGN KEY (`payment_status_id`) REFERENCES `PAYMENT_STATUS` (`payment_status_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_payment_cash_tendered` CHECK (`cash_tendered` > 0),
  CONSTRAINT `chk_payment_change_amount` CHECK (`change_amount` >= 0),
  CONSTRAINT `chk_payment_cash` CHECK (`cash_tendered` > `change_amount`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `NOTIFICATION_TYPE` (
  `notification_type_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `type_name` VARCHAR(30) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`notification_type_id`),
  CONSTRAINT `uq_notification_type_type_name` UNIQUE (`type_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `SYSTEM_NOTIFICATION` (
  `notification_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `staff_id` BIGINT UNSIGNED NOT NULL,
  `order_id` BIGINT UNSIGNED NULL,
  `material_id` BIGINT UNSIGNED NULL,
  `notification_type_id` BIGINT UNSIGNED NOT NULL,
  `message` TEXT NOT NULL,
  `notification_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `notification_status` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`notification_id`),
  CONSTRAINT `fk_system_notification_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `STAFF` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_system_notification_order_id` FOREIGN KEY (`order_id`) REFERENCES `CUSTOMER_ORDER` (`order_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_system_notification_material_id` FOREIGN KEY (`material_id`) REFERENCES `MATERIALS` (`material_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_system_notification_notification_type_id` FOREIGN KEY (`notification_type_id`) REFERENCES `NOTIFICATION_TYPE` (`notification_type_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `SYSTEM_LOG` (
  `log_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `staff_id` BIGINT UNSIGNED NOT NULL,
  `date` DATE NOT NULL,
  `log_in` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `log_out` TIMESTAMP NULL DEFAULT NULL,
  `remarks` TEXT NULL,
  PRIMARY KEY (`log_id`),
  CONSTRAINT `fk_system_log_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `STAFF` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_system_log_times` CHECK (`log_out` IS NULL OR `log_out` >= `log_in`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `SYSTEM_BACKUP` (
  `backup_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `staff_id` BIGINT UNSIGNED NOT NULL,
  `backup_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `backup_location` VARCHAR(255) NOT NULL,
  `backup_status` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`backup_id`),
  CONSTRAINT `fk_system_backup_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `STAFF` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
