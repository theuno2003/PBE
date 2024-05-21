-- Database creation
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Verano2024$';
flush privileges;
CREATE DATABASE if not exists app_db3;

USE app_db3;

-- Table users creation
CREATE TABLE if not exists USUARIO(
    cedula VARCHAR(100),
    contrasena VARCHAR(100),
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    telefono VARCHAR(20)
);
INSERT INTO USUARIO VALUES('Paucli', 'pbe1', 'Pau', 'Climent', '3101234446');
INSERT INTO USUARIO VALUES('Lukas', 'pbe2', 'Lukas', 'Mira', '3111245556');
INSERT INTO USUARIO VALUES('Burgos', 'pbe3', 'Pau', 'Burgos', '3101234344');
INSERT INTO USUARIO VALUES('Joaquin', 'pbe4', 'Joaquin', 'Mas', '3109234446');
INSERT INTO USUARIO VALUES('Alberto', 'pbe5', 'Alberto', 'de Antonio', '3101238446');
