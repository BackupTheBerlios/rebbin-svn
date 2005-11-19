-- postgres_schema.sql: PostgreSQL 7.4 schema

create database rebbin
    encoding = 'UNICODE';

create table pastes
(
    id serial primary key,
    author varchar(20) not null,
    language varchar(20) not null,
    description varchar(50),
    body text not null,
    created_on timestamp not null
);


create table comments
(
    id serial primary key,
    paste_id integer references pastes (id) on update cascade on delete cascade,
    author varchar(30) not null,
    email varchar(40),
    uri varchar(70),
    body text not null,
    created_on timestamp not null
);