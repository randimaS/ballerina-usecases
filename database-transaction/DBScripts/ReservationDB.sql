CREATE DATABASE  IF NOT EXISTS `Reservation` 
USE `Reservation`;

DROP TABLE IF EXISTS `Hotel1`;

CREATE TABLE `Hotel1` (
  `OrderNo` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerID` varchar(45) NOT NULL,
  `CustomerName` varchar(100) DEFAULT NULL,
  `CustomerAddress` text,
  `StartDate` datetime NOT NULL,
  `EndDate` datetime DEFAULT NULL,
  `Package` varchar(45) NOT NULL,
  `FullAmount` float DEFAULT NULL,
  `AdvanceAmount` float DEFAULT NULL,
  PRIMARY KEY (`OrderNo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `Hotel2`;

CREATE TABLE `Hotel2` (
  `OrderNo` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerID` varchar(45) NOT NULL,
  `CustomerName` varchar(100) DEFAULT NULL,
  `CustomerAddress` text,
  `StartDate` datetime NOT NULL,
  `EndDate` datetime DEFAULT NULL,
  `Package` varchar(45) NOT NULL,
  `FullAmount` float DEFAULT NULL,
  `AdvanceAmount` float DEFAULT NULL,
  PRIMARY KEY (`OrderNo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

