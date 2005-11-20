-- sqlite3_schema.sql: SQLite 3.2.1 schema

create table pastes
(
    id integer primary key autoincrement,
    author text not null,
    language text not null,
    description text,
    body text,
    created_on timestamp not null
);

create table comments
(
    id integer primary key autoincrement,
    paste_id integer,
    author text not null,
    email text,
    uri text,
    body text,
    created_on timestamp not null
);
