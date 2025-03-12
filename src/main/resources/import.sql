-- Initial data for the Todo application
-- Used when hibernate.hbm2ddl.auto is set to create-drop 
-- ID sequence starts at 1 and increments by 50

-- Basic Todo items
INSERT INTO Todo(id, title, completed, ordering) VALUES (1, 'Introduction to Quarkus', true, 0);
INSERT INTO Todo(id, title, completed, ordering) VALUES (51, 'Hibernate with Panache', false, 1);
INSERT INTO Todo(id, title, completed, ordering, url) VALUES (101, 'Visit Quarkus web site', false, 2, 'https://quarkus.io');
INSERT INTO Todo(id, title, completed, ordering, url) VALUES (151, 'Star Quarkus project', false, 3, 'https://github.com/quarkusio/quarkus/');

-- Set the sequence to start after the highest manually assigned ID
ALTER SEQUENCE todo_seq RESTART WITH 201;