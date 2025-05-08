DROP TABLE IF EXISTS `moonshinekit_buckets`;
CREATE TABLE IF NOT EXISTS `moonshinekit_buckets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uniqueid` varchar(50) DEFAULT NULL,
  `coords` text DEFAULT NULL,
  `data` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

DROP TABLE IF EXISTS `moonshining_stillkits`;
CREATE TABLE IF NOT EXISTS `moonshining_stillkits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uniqueid` varchar(50) DEFAULT NULL,
  `coords` text DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;