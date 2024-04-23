CREATE DATABASE if not exists PBE_DB;
use PBE_DB;
CREATE TABLE if not exists students(name varchar(50), uid varchar(255) PRIMARY KEY);
INSERT IGNORE INTO students(name, uid) VALUES 
	('Lucas Mira', '1347AF0F'),
    ('Pablo Burgos', 'F6177882'),
    ('Pau Climent', '76FB7782'),
    ('JoaquÃ­n', 'DDF1BFF6'),
    ('Alberto de Antonio','5657A214');

CREATE TABLE if not exists marks(
    uid varchar(255), 
    subject varchar(50),
    name varchar(50),
    mark float,
    FOREIGN KEY (uid) REFERENCES students(uid)
);

INSERT IGNORE INTO marks(uid, subject, name, mark) VALUES
    ('F6177882', 'DSBM', 'Memoria 1', 9);
   
CREATE TABLE if not exists tasks(
    uid varchar(255),
    date varchar(255),
    subject varchar(255),
    name varchar(255),
    FOREIGN KEY (uid) REFERENCES students(uid)
);

INSERT IGNORE INTO tasks(uid, date, subject, name) VALUES
    ('F6177882', '2024-03-14', 'DSBM', 'Memoria 1'),
	('F6177882','2024-03-25','RP','PR1'),
	('F6177882','2024-4-02','PBE','Puzzle1'),
	('F6177882','2024-4-05','DSBM','PR2'),
	('F6177882','2024-4-09','RP','PR2'),
	('F6177882','2024-4-23','PBE','Puzzle2'),
	('F6177882','2024-4-19','DSBM','PR3'),
	('F6177882','2024-4-23','RP','PR3'),
	('F6177882','2024-5-02','DSBM','Control LAB'),
	('F6177882','2024-5-06','RP','Control LAB'),
	('F6177882','2024-5-08','PSAVC','Parcial'),
	('F6177882','2024-5-16','DSBM','PR4'),
	('F6177882','2024-5-20','RP','PR4'),
	('F6177882','2024-5-20','PBE','CDR'),
	('F6177882','2024-5-22','RP','Parcial'),
	('F6177882','2024-5-29','DSBM','Parcial');

    
CREATE TABLE if not exists timetables(
    day varchar(255),
    hour varchar(50),
    subject varchar(50),
    room varchar(50)
);

INSERT IGNORE INTO timetables(day, hour, subject, room) VALUES
    ('Lunes', '08:00', 'TD', 'A3-205'),
    ('Lunes', '10:00', 'DSBM-LAB', 'C3S-105'),
    ('Lunes', '12:00', 'PSAVC', 'A3-205'),
    ('Martes', '08:00', 'DSBM', 'A3-205'),
    ('Mirecoles', '08:00', 'RP', 'A3-205'),
    ('Miercoles', '10:00','RP-LAB', 'D3-006'),
    ('Jueves', '08:00', 'PSAVC', 'A3-205'),
    ('Jueves', '11:00', 'TD', 'A3-205'),
    ('Viernes', '08:00', 'PBE', 'A3-205'),
    ('Viernes', '10:00', 'RP', 'A3-205'),
    ('Viernes', '12:00', 'DSBM', 'A3-205');
