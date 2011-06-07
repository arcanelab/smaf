-- samplemath application framework v2.0.16

-- phpMyAdmin SQL Dump
-- version 3.3.9.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 29, 2011 at 11:36 AM
-- Server version: 5.0.92
-- PHP Version: 5.2.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `press_press`
--

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE IF NOT EXISTS `account` (
  `user_id` varchar(64) collate utf8_unicode_ci NOT NULL,
  `variable` varchar(64) collate utf8_unicode_ci NOT NULL,
  `value` text collate utf8_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `asset`
--

CREATE TABLE IF NOT EXISTS `asset` (
  `uid` varchar(64) NOT NULL,
  `filename` varchar(64) NOT NULL,
  `type` varchar(64) NOT NULL,
  `filesize` int(11) NOT NULL,
  UNIQUE KEY `uid` (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `font`
--

CREATE TABLE IF NOT EXISTS `font` (
  `uid` varchar(64) NOT NULL,
  `fontname` varchar(64) NOT NULL,
  `asset` varchar(64) NOT NULL,
  UNIQUE KEY `uid` (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `session`
--

CREATE TABLE IF NOT EXISTS `session` (
  `uid` varchar(64) NOT NULL,
  `user_id` varchar(64) NOT NULL default '0',
  `ip` varchar(16) NOT NULL default '',
  `last_active` datetime NOT NULL default '0000-00-00 00:00:00',
  UNIQUE KEY `uid` (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `uid` varchar(64) NOT NULL,
  `username` varchar(64) NOT NULL default '',
  `password` varchar(64) NOT NULL default '',
  `avatar` varchar(64) NOT NULL default '0',
  `public` tinyint(4) NOT NULL,
  `level` tinyint(4) NOT NULL,
  `email` varchar(128) NOT NULL,
  `active` tinyint(1) NOT NULL,
  UNIQUE KEY `uid` (`uid`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;