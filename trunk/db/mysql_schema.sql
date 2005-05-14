-- mysql_schema.sql: Mysql 4 schema

create database if not exists rebbin
    default character set utf8;

use rebbin;

create table `pastes`
(
    `id` int unsigned auto_increment primary key,
    `author` varchar(20) not null,
    `language` varchar(20) not null,
    `description` varchar(50),
    `body` text not null,
    `created_on` timestamp not null
) TYPE=InnoDB CHARSET='utf8';