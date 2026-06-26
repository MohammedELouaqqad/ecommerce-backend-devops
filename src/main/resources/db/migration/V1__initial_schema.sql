-- Schéma initial généré depuis les entités JPA (Hibernate)
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE `address` (
  `address_id` int NOT NULL,
  `building_name` varchar(255) DEFAULT NULL,
  `city` varchar(255) NOT NULL,
  `locality` varchar(255) NOT NULL,
  `pincode` varchar(255) NOT NULL,
  `state` varchar(255) NOT NULL,
  `street_no` varchar(255) DEFAULT NULL,
  `customer_customer_id` int DEFAULT NULL,
  PRIMARY KEY (`address_id`),
  KEY `FK214xlexe9f13rdbg15mw73h5a` (`customer_customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `cart` (
  `cart_id` int NOT NULL,
  `cart_total` double DEFAULT NULL,
  `customer_customer_id` int DEFAULT NULL,
  PRIMARY KEY (`cart_id`),
  KEY `FK9hpirec8qm60sghwjqvu0s6ic` (`customer_customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `cart_item` (
  `cart_item_id` int NOT NULL,
  `cart_item_quantity` int DEFAULT NULL,
  `cart_product_product_id` int DEFAULT NULL,
  PRIMARY KEY (`cart_item_id`),
  KEY `FKp1ifyfdsfaq48tuqs28xra1kw` (`cart_product_product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `customer` (
  `customer_id` int NOT NULL,
  `created_on` datetime(6) DEFAULT NULL,
  `cardcvv` varchar(255) DEFAULT NULL,
  `card_number` varchar(255) DEFAULT NULL,
  `card_validity` varchar(255) DEFAULT NULL,
  `email_id` varchar(255) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `mobile_no` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `customer_cart_cart_id` int DEFAULT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `UK_p1nyof8six1aupbuhnlax3tkk` (`email_id`),
  UNIQUE KEY `UK_48sdtr54m4p8083qlovv5kgu3` (`mobile_no`),
  KEY `FKdfk6f90km8lu3re20sbm6pfms` (`customer_cart_cart_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `customer_address_mapping` (
  `customer_id` int NOT NULL,
  `address_id` int NOT NULL,
  `address_key` varchar(255) NOT NULL,
  PRIMARY KEY (`customer_id`,`address_key`),
  UNIQUE KEY `UK_o26f5oglpv8879niu125pagt2` (`address_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `hibernate_sequence` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `orders` (
  `order_id` int NOT NULL,
  `card_number` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `order_status` varchar(255) NOT NULL,
  `total` double DEFAULT NULL,
  `address_id` int DEFAULT NULL,
  `customer_id` int DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `FKf5464gxwc32ongdvka2rtvw96` (`address_id`),
  KEY `FK624gtjin3po807j3vix093tlf` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `product` (
  `product_id` int NOT NULL,
  `category` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `manufacturer` varchar(255) NOT NULL,
  `price` double NOT NULL,
  `product_name` varchar(30) NOT NULL,
  `quantity` int NOT NULL,
  `status` varchar(255) DEFAULT NULL,
  `seller_seller_id` int DEFAULT NULL,
  PRIMARY KEY (`product_id`),
  KEY `FKrxwpm6lqvddjvyr9vjymxqnlb` (`seller_seller_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `seller` (
  `seller_id` int NOT NULL,
  `email_id` varchar(255) DEFAULT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `mobile` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`seller_id`),
  UNIQUE KEY `UK_5bkvm98bjre616hi1jniweeet` (`mobile`),
  UNIQUE KEY `UK_oo27njgogd5779fn4pxo9sv7u` (`email_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `user_session` (
  `session_id` int NOT NULL,
  `session_end_time` datetime(6) DEFAULT NULL,
  `session_start_time` datetime(6) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `user_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`session_id`),
  UNIQUE KEY `UK_8gq4v10ega75qhpjsj51fh13v` (`token`),
  UNIQUE KEY `UK_p9ixbu6uq0wk83xq3823cpbom` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `cart_cart_items` (
  `cart_cart_id` int NOT NULL,
  `cart_items_cart_item_id` int NOT NULL,
  UNIQUE KEY `UK_6hs3sdvi9h5hb5wtgo3vls83g` (`cart_items_cart_item_id`),
  KEY `FK44su6cws1vcr95r0pn6md4jon` (`cart_cart_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `orders_ordercart_items` (
  `order_order_id` int NOT NULL,
  `ordercart_items_cart_item_id` int NOT NULL,
  UNIQUE KEY `UK_fma27srpqyf3cvwruephdd7or` (`ordercart_items_cart_item_id`),
  KEY `FK5of0bhae62onrn5to8sy80bo` (`order_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `seller_product` (
  `seller_seller_id` int NOT NULL,
  `product_product_id` int NOT NULL,
  UNIQUE KEY `UK_j8hju5mgrwlh9ml6423mf4kjr` (`product_product_id`),
  KEY `FK236mvsacc1n1mvfbcglfxu2bt` (`seller_seller_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

ALTER TABLE `address`
  ADD CONSTRAINT `FK214xlexe9f13rdbg15mw73h5a` FOREIGN KEY (`customer_customer_id`) REFERENCES `customer` (`customer_id`);

ALTER TABLE `cart`
  ADD CONSTRAINT `FK9hpirec8qm60sghwjqvu0s6ic` FOREIGN KEY (`customer_customer_id`) REFERENCES `customer` (`customer_id`);

ALTER TABLE `cart_item`
  ADD CONSTRAINT `FKp1ifyfdsfaq48tuqs28xra1kw` FOREIGN KEY (`cart_product_product_id`) REFERENCES `product` (`product_id`);

ALTER TABLE `customer`
  ADD CONSTRAINT `FKdfk6f90km8lu3re20sbm6pfms` FOREIGN KEY (`customer_cart_cart_id`) REFERENCES `cart` (`cart_id`);

ALTER TABLE `customer_address_mapping`
  ADD CONSTRAINT `FK3i4tethe1xoyrvrup8dvraijq` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`),
  ADD CONSTRAINT `FKfqe84yiec5jt6is4dcccb1rv7` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`);

ALTER TABLE `orders`
  ADD CONSTRAINT `FK624gtjin3po807j3vix093tlf` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`),
  ADD CONSTRAINT `FKf5464gxwc32ongdvka2rtvw96` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`);

ALTER TABLE `product`
  ADD CONSTRAINT `FKrxwpm6lqvddjvyr9vjymxqnlb` FOREIGN KEY (`seller_seller_id`) REFERENCES `seller` (`seller_id`);

ALTER TABLE `cart_cart_items`
  ADD CONSTRAINT `FK44su6cws1vcr95r0pn6md4jon` FOREIGN KEY (`cart_cart_id`) REFERENCES `cart` (`cart_id`),
  ADD CONSTRAINT `FKk9u7jarcxlxb896jsxjrhr2nn` FOREIGN KEY (`cart_items_cart_item_id`) REFERENCES `cart_item` (`cart_item_id`);

ALTER TABLE `orders_ordercart_items`
  ADD CONSTRAINT `FK5of0bhae62onrn5to8sy80bo` FOREIGN KEY (`order_order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `FKj8lvkdvy81176i4t1doili4ec` FOREIGN KEY (`ordercart_items_cart_item_id`) REFERENCES `cart_item` (`cart_item_id`);

ALTER TABLE `seller_product`
  ADD CONSTRAINT `FK236mvsacc1n1mvfbcglfxu2bt` FOREIGN KEY (`seller_seller_id`) REFERENCES `seller` (`seller_id`),
  ADD CONSTRAINT `FKktoeahm8f5smvb2ln1lxpl0rt` FOREIGN KEY (`product_product_id`) REFERENCES `product` (`product_id`);

INSERT INTO `hibernate_sequence` (`next_val`) VALUES (1);

SET FOREIGN_KEY_CHECKS = 1;
