-- Add migration script here
CREATE TABLE IF NOT EXISTS messages ( id serial primary key, message varchar not null );
