
/* 

CREATE DATABASE proyecto_final;
USE proyecto_final; 
DROP database proyecto_final;
select * from user;
DROP USER 'usuario_solo_lectura1'@'localhost';
*/

CREATE DATABASE proyecto_final;
USE proyecto_final; 
/*
CREACIÓN DE TABLAS: la base de datos cuenta con la creacion de unas 23 tablas. En la creacion se realizo en dos partes,primero
 se  comenzó por las tablas que están en el diagrama de ER (tablas padres,hijas e intermedias); 
 en segunda instancia se agregaron las tablas logs de los triggers.
*/
-- TABLAS PADRES--
CREATE TABLE desarrolladoras(
id_desarrolladora INT  AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR
(20) NOT NULL,
UNIQUE KEY(nombre)
);

CREATE TABLE puntajes(
id_puntaje INT  AUTO_INCREMENT PRIMARY KEY,
puntaje INT NOT NULL
);

CREATE TABLE distribuidoras(
id_distribuidora INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(20) NOT NULL,
UNIQUE KEY (nombre)
);

CREATE TABLE subgeneros(
id_subgenero INT  AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(18)
);

CREATE TABLE penalizaciones(
id_penalizacion INT  AUTO_INCREMENT PRIMARY KEY,
tipoPenalizacion VARCHAR(50) NOT NULL,
tiempoPenalizacion INT NOT NULL 
);

CREATE TABLE plataformas(
id_plataforma INT AUTO_INCREMENT PRIMARY KEY,
tipo_plataforma  VARCHAR(15) NOT NULL,
UNIQUE KEY(tipo_plataforma)
);

CREATE TABLE paises(
id_pais INT AUTO_INCREMENT  PRIMARY KEY,
nombre VARCHAR(20) NOT NULL,
UNIQUE KEY(nombre)
);


-- TABLAS HIJAS --

CREATE TABLE provincias(
id_provincia INT AUTO_INCREMENT  PRIMARY KEY,
nombre VARCHAR(20) NOT NULL,
id_pais INT NOT NULL,
FOREIGN KEY (id_pais) REFERENCES paises(id_pais) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE codigosAreas(
id_codigoArea INT AUTO_INCREMENT PRIMARY KEY,
codigoArea INT NOT NULL,
id_pais INT NOT NULL ,
id_provincia INT NOT NULL,
UNIQUE KEY (codigoArea),
FOREIGN KEY (id_pais) REFERENCES paises(id_pais) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (id_provincia) REFERENCES provincias(id_provincia) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE generos(
id_genero INT AUTO_INCREMENT,
nombre VARCHAR(20) NOT NULL,
id_subgenero INT NOT NULL,
PRIMARY KEY (id_genero),
FOREIGN KEY (id_subgenero) REFERENCES subgeneros(id_subgenero) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE celulares(
id_celular INT AUTO_INCREMENT,
numero INT ,
id_codigoArea INT NOT NULL,
UNIQUE KEY (numero),
PRIMARY KEY (id_celular),
FOREIGN KEY (id_codigoArea) REFERENCES codigosAreas(id_codigoArea)
);

CREATE TABLE juegos(
id_juego INT AUTO_INCREMENT,
nombre VARCHAR(20),
fecha_creacion DATE NOT NULL,
PRIMARY KEY (id_juego)
);

CREATE TABLE problemas(
id_problema INT AUTO_INCREMENT PRIMARY KEY,
detalles VARCHAR(100) NOT NULL,
id_juego INT NOT NULL,
id_plataforma INT NOT NULL,
FOREIGN KEY (id_juego) REFERENCES  juegos(id_juego) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (id_plataforma) REFERENCES plataformas(id_plataforma) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE jugadores(
id_jugador INT AUTO_INCREMENT ,
nick VARCHAR(30) NOT NULL,
id_penalizacion INT NOT NULL,
id_plataforma INT NOT NULL,
id_juego INT NULL,
PRIMARY KEY(id_jugador),
FOREIGN KEY (id_juego) REFERENCES  juegos(id_juego) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (id_penalizacion) REFERENCES penalizaciones(id_penalizacion) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (id_plataforma) REFERENCES plataformas(id_plataforma) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE usuarios(
id_usuario INT AUTO_INCREMENT,
fecha_nac DATE NOT NULL,
nick VARCHAR(30) NOT NULL,
id_celular INT NOT NULL,
id_provincia INT NOT NULL,
id_pais INT NOT NULL ,
UNIQUE KEY(nick),
PRIMARY KEY (id_usuario),
FOREIGN KEY (id_celular) REFERENCES celulares(id_celular) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (id_provincia) REFERENCES provincias(id_provincia) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (id_pais) REFERENCES paises(id_pais) ON UPDATE CASCADE ON DELETE CASCADE
);


-- TABLAS INTERMEDIAS --

CREATE TABLE usuariosProblemas(
id_problema INT NOT NULL,
id_usuario INT NOT NULL,
PRIMARY	KEY(id_problema,id_usuario ),
FOREIGN KEY (id_problema ) REFERENCES problemas(id_problema ) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE usuariosJugadores(
id_jugador INT NOT NULL,
id_usuario INT NOT NULL,
PRIMARY KEY(id_jugador,id_usuario),
FOREIGN KEY (id_jugador) REFERENCES jugadores(id_jugador) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE usuariosJuegos(
id_juego INT NOT NULL,
id_usuario INT NOT NULL,
PRIMARY KEY(id_juego,id_usuario),
FOREIGN KEY (id_juego) REFERENCES juegos(id_juego) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE);


CREATE TABLE usuarioPlataformas(
id_plataforma INT NOT NULL,
id_usuario INT NOT NULL,
PRIMARY KEY(id_plataforma,id_usuario),
FOREIGN KEY (id_plataforma ) REFERENCES plataformas(id_plataforma) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE juegosGeneros(
id_juego INT NOT NULL,
id_genero INT NOT NULL,
PRIMARY KEY(id_juego,id_genero),
FOREIGN KEY (id_juego) REFERENCES juegos(id_juego) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (id_genero) REFERENCES generos(id_genero) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE juegosDesarrolladoras(
id_juego INT NOT NULL,
id_desarrolladora INT NOT NULL,
PRIMARY KEY(id_juego,id_desarrolladora),
FOREIGN KEY (id_juego) REFERENCES juegos(id_juego) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (id_desarrolladora) REFERENCES desarrolladoras(id_desarrolladora) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE juegosPlataformas(
id_juego INT NOT NULL,
id_plataforma INT NOT NULL,
PRIMARY KEY(id_juego,id_plataforma),
FOREIGN KEY (id_juego) REFERENCES juegos(id_juego) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (id_plataforma ) REFERENCES plataformas(id_plataforma) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE  juegosDistribuidoras(
id_juego INT NOT NULL,
id_distribuidora INT NOT NULL,
PRIMARY KEY(id_juego,id_distribuidora),
FOREIGN KEY (id_juego) REFERENCES juegos(id_juego) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (id_distribuidora) REFERENCES distribuidoras(id_distribuidora) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE juegosPuntajes(
id_juego INT NOT NULL,
id_puntaje INT NOT NULL,
PRIMARY KEY(id_juego,id_puntaje),
FOREIGN KEY (id_juego) REFERENCES juegos(id_juego) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (id_puntaje) REFERENCES puntajes(id_puntaje) ON UPDATE CASCADE ON DELETE CASCADE
);

-- TABLAS LOGS DE TRIGGER -- 
CREATE TABLE  log_del_usuario(
id_log INT AUTO_INCREMENT,
id_usuario INT,
nick VARCHAR(50),
usuario VARCHAR(50),
fecha DATE,
hora TIME,
PRIMARY KEY(id_log)
);

CREATE TABLE  log_ins_usuario(
id_log INT AUTO_INCREMENT,
id_usuario INT,
nick VARCHAR(50),
usuario VARCHAR(50),
fecha DATE,
hora TIME,
PRIMARY KEY(id_log)
);


CREATE TABLE  log_del_juego(
id_log INT AUTO_INCREMENT,
id_juego INT,
nick VARCHAR(50),
usuario VARCHAR(50),
fecha DATE,
hora TIME,
PRIMARY KEY(id_log)
);

CREATE TABLE  log_ins_juego(
id_log INT AUTO_INCREMENT,
id_juego INT,
nick VARCHAR(50),
usuario VARCHAR(50),
fecha DATE,
hora TIME,
PRIMARY KEY(id_log)
);

/*
INSERCIÓN DE DATOS: la inserción de registros a cada una de las tablas se realizó de manera manual, aunque se puede 
utilizar el asistente para la importación, esta herramienta se utiliza para una carga masiva de datos. 
Al igual que en la creación de las tablas, la inserción también se tuvo en cuenta el orden ya que hay subconsultas 
para inserción de los valores, primero se insertan los registros de las tablas padres, siguen los registro de 
tablas hijas y por último los registros de la tablas intermedias. 
*/

-- TABLAS PADRES-- 
-- INSERCIÓN DE DATOS --
INSERT INTO desarrolladoras(nombre) VALUES
("Techland"),("Game Freak"),("Guerrilla Games"),("Polyphony Digital"),("Iron Galaxy"),("Gearbox"),
("FromSoftware"),("Sony Santa Monica"),("Ubisoft"),("Kojima Productions"),("Xbox"),("Sony"),
("Valve"),("Nintendo"),("Beteshda Softworks"),	("Rockstar Games"),("Konami"),("Capcom"),
("Activision"),	("Electronic Arts"),("Riot Games"),("Codemasters"),("Naughty Dog"),
("Raven Software"),("Infinity Ward"),("Epic Games"),("People Can Fly"),("4A Games");

INSERT INTO puntajes(puntaje) VALUES
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10);

-- INSERCIÓN DE DATOS --
INSERT INTO distribuidoras(nombre) VALUES
("Sony"),
("Xbox"),
("Valve"),
("Nintendo"),
("Activision"),
("Electronic Arts"),
("Take-Two Interactive"),
("Warner Bros"),
("Sega"),
("Codemasters");

-- INSERCIÓN DE DATOS --
INSERT INTO subgeneros(nombre) VALUES
("Lucha"),	
("Arcade"),	
("Plataforma"),	
("FPS"),	
("TPS"),	
("En tiempo real"),	
("Por turnos"),	
("Hack and Slash"),	
("Carreras"),	
("Deporte"),	
("Battle Royale"),	
("Sandbbox"),	
("Aventura Grafica"),	
("Sigilo"),	
("Accion RPG"),	
("MMORPG");	

-- INSERCIÓN DE DATOS --
INSERT INTO  penalizaciones(tiempoPenalizacion,tipoPenalizacion) VALUES
(1,"Bloqueo el Ingreso a plataforma"),
(3,"Bloqueo el Ingreso a plataforma"),
(5,"Bloqueo el Ingreso a plataforma"),
(10,"Bloqueo el Ingreso a plataforma"),
(1,"Bloqueo el Ingreso a torneos"),
(3,"Bloqueo el Ingreso a torneos"),
(5,"Bloqueo el Ingreso a torneos"),
(10,"Bloqueo el Ingreso a torneos"),
(30,"Bloqueo el Ingreso a torneos"),
(0,"Expulsion total");

-- INSERCIÓN DE DATOS --
INSERT INTO plataformas(tipo_plataforma) VALUES
("PC"),("Celular"),("Playstation"),("Xbox"),("Nintendo"),("Sega");

-- INSERCIÓN DE DATOS --
INSERT INTO paises(nombre) VALUES
("Argentina"),("EEUU"),("Brasil"),("Chile"),
("Japon"),("China"),("España"),
("Mexico"),("Inglaterra"),("Canada");

-- TABLAS HIJAS --
-- INSERCIÓN DE DATOS --
INSERT INTO provincias(nombre,id_pais) VALUES
("Buenos Aires",(SELECT id_pais FROM paises where nombre  like "Argent%")),
("Cordoba",(SELECT id_pais FROM paises where nombre  like "Argent%")),
("New York",(SELECT id_pais FROM paises where nombre  like "EE%")),
("Orlando",(SELECT id_pais FROM paises where nombre  like "EE%")),
("Sao Paulo",(SELECT id_pais FROM paises where nombre  like "Bra%")),
("Bahia",(SELECT id_pais FROM paises where nombre  like "Bra%")),
("Santiago de Chile",(SELECT id_pais FROM paises where nombre  like "%le")),
("Tokio",(SELECT id_pais FROM paises where nombre  like "%pon")),
("Osaka",(SELECT id_pais FROM paises where nombre  like "%pon")),
("Pekin",(SELECT id_pais FROM paises where nombre  like "Chin%")),
("Shangai",(SELECT id_pais FROM paises where nombre  like "Chin%")),
("Madrid",(SELECT id_pais FROM paises where nombre  like "Es%")),
("Barcelona",(SELECT id_pais FROM paises where nombre  like "Es%")),
("Ciudad De Mexico",(SELECT id_pais FROM paises where nombre  like "Mex%")),
("Chiapas",(SELECT id_pais FROM paises where nombre  like "Mex%")),
("Londres",(SELECT id_pais FROM paises where nombre  like "Ing%")),
("Leeds",(SELECT id_pais FROM paises where nombre  like "Ing%")),
("Ontario",(SELECT id_pais FROM paises where nombre  like "Can%")),
("Quebec",(SELECT id_pais FROM paises where nombre  like "Can%"));

-- INSERCIÓN DE DATOS --
INSERT INTO codigosAreas(codigoArea,id_pais,id_provincia) VALUES
(54911,(SELECT id_pais FROM paises where nombre  like "Argent%"),(SELECT id_provincia FROM provincias where nombre  like "Bue%")),
(549351,(SELECT id_pais FROM paises where nombre  like "Argent%"),(SELECT id_provincia FROM provincias where nombre  like "Cor%")),
(1212,(SELECT id_pais FROM paises where nombre  like "EE%"),(SELECT id_provincia FROM provincias where nombre  like "New%")),
(1927,(SELECT id_pais FROM paises where nombre  like "EE%"),(SELECT id_provincia FROM provincias where nombre  like "Orl%")),
(5511,(SELECT id_pais FROM paises where nombre  like "Bra%"),(SELECT id_provincia FROM provincias where nombre  like "Sao%")),
(5574,(SELECT id_pais FROM paises where nombre  like "Bra%"),(SELECT id_provincia FROM provincias where nombre  like "Bah%")),
(562,(SELECT id_pais FROM paises where nombre  like "%le"),(SELECT id_provincia FROM provincias where nombre  like "San%")),
(813,(SELECT id_pais FROM paises where nombre  like "%pon"),(SELECT id_provincia FROM provincias where nombre  like "Tok%")),
(8166,(SELECT id_pais FROM paises where nombre  like "%pon"),(SELECT id_provincia FROM provincias where nombre  like "Osa%")),
(8610,(SELECT id_pais FROM paises where nombre  like "Chin%"),(SELECT id_provincia FROM provincias where nombre  like "Pek%")),
(8621,(SELECT id_pais FROM paises where nombre  like "Chin%"),(SELECT id_provincia FROM provincias where nombre  like "Sha%")),
(9181,(SELECT id_pais FROM paises where nombre  like "Es%"),(SELECT id_provincia FROM provincias where nombre  like "Mad%")),
(9383,(SELECT id_pais FROM paises where nombre  like "Es%"),(SELECT id_provincia FROM provincias where nombre  like "Bar%")),
(5255,(SELECT id_pais FROM paises where nombre  like "Mex%"),(SELECT id_provincia FROM provincias where nombre  like "Ciu%")),
(52916,(SELECT id_pais FROM paises where nombre  like "Mex%"),(SELECT id_provincia FROM provincias where nombre  like "Chi%")),
(44,(SELECT id_pais FROM paises where nombre  like "Ing%"),(SELECT id_provincia FROM provincias where nombre  like "Lon%")),
(44113,(SELECT id_pais FROM paises where nombre  like "Ing%"),(SELECT id_provincia FROM provincias where nombre  like "Lee%")),
(1437,(SELECT id_pais FROM paises where nombre  like "Can%"),(SELECT id_provincia FROM provincias where nombre  like "Ont%")),
(1418,(SELECT id_pais FROM paises where nombre  like "Can%"),(SELECT id_provincia FROM provincias where nombre  like "Que%"));

-- INSERCIÓN DE DATOS --
INSERT INTO generos(NOMBRE,id_subgenero) VALUES
("Accion",(SELECT id_subgenero FROM subgeneros WHERE nombre like "Luc%")),
("Accion",(SELECT id_subgenero FROM subgeneros WHERE nombre like "Arc%")),
("Accion",(SELECT id_subgenero FROM subgeneros WHERE nombre like "Plat%")),
("Disparos",(SELECT id_subgenero FROM subgeneros WHERE nombre like "FP%")),
("Disparos",(SELECT id_subgenero FROM subgeneros WHERE nombre like "TP%")),
("Estrategia",(SELECT id_subgenero FROM subgeneros WHERE nombre like "En %")),
("Estrategia",(SELECT id_subgenero FROM subgeneros WHERE nombre like "Por %")),
("Hack and Slash ",(SELECT id_subgenero FROM subgeneros WHERE nombre like "Hac%")),
("Otros",(SELECT id_subgenero FROM subgeneros WHERE nombre like "Car%")),
("Otros",(SELECT id_subgenero FROM subgeneros WHERE nombre like "Dep%")),
("Otros",(SELECT id_subgenero FROM subgeneros WHERE nombre like "Bat%")),
("Otros",(SELECT id_subgenero FROM subgeneros WHERE nombre like "Sand%")),
("Otros",(SELECT id_subgenero FROM subgeneros WHERE nombre like "Aventura%")),
("Otros",(SELECT id_subgenero FROM subgeneros WHERE nombre like "Sig%")),
("Accion",(SELECT id_subgenero FROM subgeneros WHERE nombre like "Acci%")),
("Otros",(SELECT id_subgenero FROM subgeneros WHERE nombre like "MMOR%"));

-- INSERCIÓN DE DATOS --
INSERT INTO celulares(numero,id_codigoArea) VALUES
(69325874,(SELECT id_codigoArea FROM codigosAreas WHERE (id_pais=(SELECT id_pais FROM paises where nombre  like "Argent%") AND id_provincia=(SELECT id_provincia FROM provincias where nombre  like "Bue%")))),
(5332674,(SELECT id_codigoArea FROM codigosAreas WHERE (id_pais=(SELECT id_pais FROM paises where nombre  like "Argent%") AND id_provincia=(SELECT id_provincia FROM provincias where nombre  like "Cor%")))),
(234561234,(SELECT id_codigoArea FROM codigosAreas WHERE (id_pais=(SELECT id_pais FROM paises where nombre  like "Ing%") AND id_provincia=(SELECT id_provincia FROM provincias where nombre  like "Lon%")))),
(4564648,(SELECT id_codigoArea FROM codigosAreas WHERE (id_pais=(SELECT id_pais FROM paises where nombre  like "Can%") AND id_provincia=(SELECT id_provincia FROM provincias where nombre  like "Que%")))),
(13551889,(SELECT id_codigoArea FROM codigosAreas WHERE (id_pais=(SELECT id_pais FROM paises where nombre  like "Chin%") AND id_provincia=(SELECT id_provincia FROM provincias where nombre  like "Pek%")))),
(13135641,(SELECT id_codigoArea FROM codigosAreas WHERE (id_pais=(SELECT id_pais FROM paises where nombre  like "%pon") AND id_provincia=(SELECT id_provincia FROM provincias where nombre  like "Tok%")))),
(15651313,(SELECT id_codigoArea FROM codigosAreas WHERE (id_pais=(SELECT id_pais FROM paises where nombre  like "Argent%") AND id_provincia=(SELECT id_provincia FROM provincias where nombre  like "Bue%")))),
(897456189,(SELECT id_codigoArea FROM codigosAreas WHERE (id_pais=(SELECT id_pais FROM paises where nombre  like "Argent%") AND id_provincia=(SELECT id_provincia FROM provincias where nombre  like "Bue%")))),
(6554232,(SELECT id_codigoArea FROM codigosAreas WHERE (id_pais=(SELECT id_pais FROM paises where nombre  like "Argent%") AND id_provincia=(SELECT id_provincia FROM provincias where nombre  like "Cor%")))),
(65441218,(SELECT id_codigoArea FROM codigosAreas WHERE (id_pais=(SELECT id_pais FROM paises where nombre  like "Argent%") AND id_provincia=(SELECT id_provincia FROM provincias where nombre  like "Bue%"))));

-- INSERCIÓN DE DATOS --
INSERT INTO juegos(nombre,fecha_creacion) VALUES
("God of War","2018-04-20"),
("New World","2021-09-09"),
("Super Mario","1999-01-21"),
("Pokemon Arceus","2022-01-28"),
("Metro 2033","2010-03-16"),
("Grand Theft Auto V","2013-09-17"),
("Fornite","2017-07-21"),
("Cod WarZone","2020-10-03"),
("Uncharted 4","2016-05-10"),
("Age of Empires 2","1999-09-30");

-- INSERCIÓN DE DATOS --
INSERT INTO problemas(detalles,id_juego,id_plataforma) VALUES
("Problema de texturas/Solución: actualizar juegos a versión 1.0.3 .",(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "God%"),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "PC")),
("Problema de ingreso a los servidores de New World.",(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "%New%"),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "PC")),
("Caída masiva de ingreso.Fecha:08/02/2022",(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "%For%"),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "PC")),
("Caída masiva de ingreso.Fecha:08/02/2022",(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "%For%"),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "Cel%")),
("Caída masiva de ingreso.Fecha:08/02/2022",(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "%For%"),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "Pla%")),
("Caída masiva de ingreso.Fecha:08/02/2022",(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "For%"),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "X%")),
("Caída masiva de ingreso.Fecha:08/02/2022",(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "For%"),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "Ni%")),
("Error:ERR_GFX_D3D_INIT Crash. ",(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "God%"),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "PC")),
("Los servidores te expulsan. Error: se agoto el tiempo de espera.",(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "Cod%"),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "PC")),
("Despues de la actulización, perdí mi equipamiento",(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "Cod%"),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "Pla%")),
("Despuede actualización 1.0.6 no puedo atrapar ningún rhyhorn",(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "Pok%"),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "Ni%"));

-- INSERCIÓN DE DATOS --
INSERT INTO jugadores(nick,id_penalizacion,id_plataforma,id_juego) VALUES
("farger256",(SELECT id_penalizacion FROM PENALIZACIONES  WHERE (tiempoPenalizacion = 1) AND (tipoPenalizacion LIKE "%Ingreso a plata%")),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "PC"),(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "For%")),
("bart263",(SELECT id_penalizacion FROM PENALIZACIONES  WHERE (tiempoPenalizacion = 1) AND (tipoPenalizacion LIKE "%Ingreso a plata%")),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "PC"),(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "For%")),
("Briba6",(SELECT id_penalizacion FROM PENALIZACIONES  WHERE (tiempoPenalizacion = 1) AND (tipoPenalizacion LIKE "%Ingreso a plata%")),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "PC"),(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "For%")),
("leiton12",(SELECT id_penalizacion FROM PENALIZACIONES  WHERE (tiempoPenalizacion = 5) AND (tipoPenalizacion LIKE "%Ingreso a plata%")),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "PC"),(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "For%")),
("Razor2000",(SELECT id_penalizacion FROM PENALIZACIONES  WHERE (tiempoPenalizacion = 0) AND (tipoPenalizacion LIKE "%tota%")),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "Pla%"),(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "Cod%")),
("John_Connor",(SELECT id_penalizacion FROM PENALIZACIONES  WHERE (tiempoPenalizacion = 10) AND (tipoPenalizacion LIKE "%Ingreso a torn%")),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "Pla%"),(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "Cod%")),
("McFly1985",(SELECT id_penalizacion FROM PENALIZACIONES  WHERE (tiempoPenalizacion = 10) AND (tipoPenalizacion LIKE "%Ingreso a torn%")),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "Pla%"),(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "Cod%")),
(" John_James_Rambo",(SELECT id_penalizacion FROM PENALIZACIONES  WHERE (tiempoPenalizacion = 5) AND (tipoPenalizacion LIKE "%Ingreso a torneos%")),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "PC"),(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "For%")),
("bobaFET",(SELECT id_penalizacion FROM PENALIZACIONES  WHERE (tiempoPenalizacion = 30) AND (tipoPenalizacion LIKE "%Ingreso a torneos%")),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "PC"),(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "For%")),
("Arteus326",(SELECT id_penalizacion FROM PENALIZACIONES  WHERE (tiempoPenalizacion = 30) AND (tipoPenalizacion LIKE "%Ingreso a torneos%")),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "Pla%"),(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "Cod%")),
("Rasputin_15",(SELECT id_penalizacion FROM PENALIZACIONES  WHERE (tiempoPenalizacion = 10) AND (tipoPenalizacion LIKE "%Ingreso a plata%")),(SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "PC"),(SELECT id_juego FROM JUEGOS WHERE  nombre LIKE "For%"));

-- INSERCIÓN DE DATOS --
INSERT INTO usuarios(fecha_nac,nick,id_celular,id_provincia,id_pais) VALUES
("1995/09/06","Usopp12",1,(SELECT id_provincia FROM provincias WHERE nombre LIKE "Buenos%"),(SELECT id_pais FROM paises WHERE nombre LIKE "Arg%")),
("1990/10/26","12Eren",2,(SELECT id_provincia FROM provincias WHERE nombre LIKE "Cord%"),(SELECT id_pais FROM paises WHERE nombre LIKE "Arg%")),
("1986/08/16","Armin266",3,(SELECT id_provincia FROM provincias WHERE nombre LIKE "Lon%"),(SELECT id_pais FROM paises WHERE nombre LIKE "Ing%")),
("2000/06/05","Yondu_XD",4,(SELECT id_provincia FROM provincias WHERE nombre LIKE "Que%"),(SELECT id_pais FROM paises WHERE nombre LIKE "Can%")),
("2009/03/03","Jon_Snow",5,(SELECT id_provincia FROM provincias WHERE nombre LIKE "Pek%"),(SELECT id_pais FROM paises WHERE nombre LIKE "Chin%")),
("1990/03/29","Khal_Drogo",6,(SELECT id_provincia FROM provincias WHERE nombre LIKE "Tok%"),(SELECT id_pais FROM paises WHERE nombre LIKE "Jap%")),
("2008/01/31","Noctis_223",7,(SELECT id_provincia FROM provincias WHERE nombre LIKE "Buenos%"),(SELECT id_pais FROM paises WHERE nombre LIKE "Arg%")),
("2013/02/26","Noxius",8,(SELECT id_provincia FROM provincias WHERE nombre LIKE "Buenos%"),(SELECT id_pais FROM paises WHERE nombre LIKE "Arg%")),
("2005/02/16","PANDA",9,(SELECT id_provincia FROM provincias WHERE nombre LIKE "Cord%"),(SELECT id_pais FROM paises WHERE nombre LIKE "Arg%")),
("2010/04/18","farger256",10,(SELECT id_provincia FROM provincias WHERE nombre LIKE "Buenos%"),(SELECT id_pais FROM paises WHERE nombre LIKE "Arg%"));

-- TABLAS INTERMEDIAS --
-- INSERCIÓN DE DATOS --
INSERT INTO usuariosProblemas(id_problema,id_usuario) VALUES
((SELECT id_problema FROM problemas WHERE detalles LIKE "Los servido%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Usop%")),
((SELECT id_problema FROM problemas WHERE detalles LIKE "Los servido%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Armi%")),
((SELECT id_problema FROM problemas WHERE detalles LIKE "Los servido%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Jon%")),
((SELECT id_problema FROM problemas WHERE detalles LIKE "Los servido%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Noc%")),
((SELECT id_problema FROM problemas WHERE detalles LIKE "Los servido%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Panda%")),
((SELECT id_problema FROM problemas WHERE detalles LIKE "Caida%" AND id_plataforma= (SELECT id_plataforma FROM plataformas WHERE tipo_plataforma = "PC")),(SELECT id_usuario FROM usuarios WHERE nick LIKE "12%")),
((SELECT id_problema FROM problemas WHERE detalles LIKE "Caida%" AND id_plataforma= (SELECT id_plataforma FROM plataformas WHERE tipo_plataforma = "PC")),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Yond%")),
((SELECT id_problema FROM problemas WHERE detalles LIKE "Caida%" AND id_plataforma= (SELECT id_plataforma FROM plataformas WHERE tipo_plataforma = "PC")),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Khal%")),
((SELECT id_problema FROM problemas WHERE detalles LIKE "Caida%" AND id_plataforma= (SELECT id_plataforma FROM plataformas WHERE tipo_plataforma = "PC")),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Nox%")),
((SELECT id_problema FROM problemas WHERE detalles LIKE "Caida%" AND id_plataforma= (SELECT id_plataforma FROM plataformas WHERE tipo_plataforma = "PC")),(SELECT id_usuario FROM usuarios WHERE nick LIKE "far%"));

-- INSERCIÓN DE DATOS --
INSERT INTO usuariosJugadores(id_jugador,id_usuario) VALUES
((SELECT id_jugador FROM jugadores WHERE nick LIKE "far%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Usop%")),
((SELECT id_jugador FROM jugadores WHERE nick LIKE "bar%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Usop%")),
((SELECT id_jugador FROM jugadores WHERE nick LIKE "Bri%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "12%")),
((SELECT id_jugador FROM jugadores WHERE nick LIKE "lei%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "12%")),
((SELECT id_jugador FROM jugadores WHERE nick LIKE "bob%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Armi%")),
((SELECT id_jugador FROM jugadores WHERE nick LIKE "Bri%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Jon%")),
((SELECT id_jugador FROM jugadores WHERE nick LIKE "Bri%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Yond%")),
((SELECT id_jugador FROM jugadores WHERE nick LIKE "Bri%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Khal%")),
((SELECT id_jugador FROM jugadores WHERE nick LIKE "Bri%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Nox%")),
((SELECT id_jugador FROM jugadores WHERE nick LIKE "Bri%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "far%"));

-- INSERCIÓN DE DATOS --
INSERT INTO usuariosJuegos(id_juego,id_usuario) VALUES
((SELECT id_juego FROM juegos WHERE nombre LIKE "for%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "12%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "for%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Yond%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "for%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Khal%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "for%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Nox%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "for%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "far%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "Cod%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Usop%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "Cod%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Armi%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "Cod%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Jon%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "Cod%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Noc%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "Cod%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Pan%"));

-- INSERCIÓN DE DATOS --
INSERT INTO usuarioPlataformas(id_plataforma,id_usuario) VALUES
((SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "PC"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "12%")),
((SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "PC"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Yond%")),
((SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "PC"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Khal%")),
((SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "PC"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Nox%")),
((SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "PC"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "far%")),
((SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "Play%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Usop%")),
((SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "Play%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Armi%")),
((SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "Play%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Jon%")),
((SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "Play%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Noc%")),
((SELECT id_plataforma FROM PLATAFORMAS WHERE  tipo_plataforma LIKE "Play%"),(SELECT id_usuario FROM usuarios WHERE nick LIKE "Pan%"));

-- INSERCIÓN DE DATOS --
INSERT INTO juegosGeneros(id_juego,id_genero) VALUES
((SELECT id_juego FROM juegos WHERE nombre LIKE "God%"),(SELECT id_genero FROM generos WHERE (nombre LIKE "hac%") AND (id_subgenero = 8))),
((SELECT id_juego FROM juegos WHERE nombre LIKE "God%"),(SELECT id_genero FROM generos WHERE (nombre LIKE "acc%") AND (id_subgenero = 15))),
((SELECT id_juego FROM juegos WHERE nombre LIKE "New%"),(SELECT id_genero FROM generos WHERE (nombre LIKE "ot%") AND (id_subgenero = 16))),
((SELECT id_juego FROM juegos WHERE nombre LIKE "New%"),(SELECT id_genero FROM generos WHERE (nombre LIKE "dis%") AND (id_subgenero = 5))),
((SELECT id_juego FROM juegos WHERE nombre LIKE "New%"),(SELECT id_genero FROM generos WHERE (nombre LIKE "acc%") AND (id_subgenero = 1))),
((SELECT id_juego FROM juegos WHERE nombre LIKE "New%"),(SELECT id_genero FROM generos WHERE (nombre LIKE "otr%") AND (id_subgenero = 13))),
((SELECT id_juego FROM juegos WHERE nombre LIKE "Sup%"),(SELECT id_genero FROM generos WHERE (nombre LIKE "acc%") AND (id_subgenero = 3))),
((SELECT id_juego FROM juegos WHERE nombre LIKE "pok%"),(SELECT id_genero FROM generos WHERE (nombre LIKE "acc%") AND (id_subgenero = 15))),
((SELECT id_juego FROM juegos WHERE nombre LIKE "pok%"),(SELECT id_genero FROM generos WHERE (nombre LIKE "otr%") AND (id_subgenero = 13))),
((SELECT id_juego FROM juegos WHERE nombre LIKE "for%"),(SELECT id_genero FROM generos WHERE (nombre LIKE "otr%") AND (id_subgenero = 12))),
((SELECT id_juego FROM juegos WHERE nombre LIKE "for%"),(SELECT id_genero FROM generos WHERE (nombre LIKE "acc%") AND (id_subgenero = 15))),
((SELECT id_juego FROM juegos WHERE nombre LIKE "for%"),(SELECT id_genero FROM generos WHERE (nombre LIKE "dis%") AND (id_subgenero = 5))),
((SELECT id_juego FROM juegos WHERE nombre LIKE "for%"),(SELECT id_genero FROM generos WHERE (nombre LIKE "otr%") AND (id_subgenero = 11)));

-- INSERCIÓN DE DATOS --
INSERT INTO juegosDesarrolladoras(id_juego,id_desarrolladora) VALUES
((SELECT id_juego FROM juegos WHERE nombre LIKE "god%"),(SELECT id_desarrolladora FROM desarrolladoras WHERE nombre LIKE "%sant%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "sup%"),(SELECT id_desarrolladora FROM desarrolladoras WHERE nombre LIKE "nin%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "pok%"),(SELECT id_desarrolladora FROM desarrolladoras WHERE nombre LIKE "gam%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "gran%"),(SELECT id_desarrolladora FROM desarrolladoras WHERE nombre LIKE "rock%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "met%"),(SELECT id_desarrolladora FROM desarrolladoras WHERE nombre LIKE "4a%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "for%"),(SELECT id_desarrolladora FROM desarrolladoras WHERE nombre LIKE "Epic%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "for%"),(SELECT id_desarrolladora FROM desarrolladoras WHERE nombre LIKE "Peo%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "cod%"),(SELECT id_desarrolladora FROM desarrolladoras WHERE nombre LIKE "Inf%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "cod%"),(SELECT id_desarrolladora FROM desarrolladoras WHERE nombre LIKE "Rav%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "unc%"),(SELECT id_desarrolladora FROM desarrolladoras WHERE nombre LIKE "Nau%"));

-- INSERCIÓN DE DATOS --
INSERT INTO juegosPlataformas(id_juego,id_plataforma) VALUES
((SELECT id_juego FROM juegos WHERE nombre LIKE "God%"),3),
((SELECT id_juego FROM juegos WHERE nombre LIKE "God%"),(SELECT id_plataforma FROM plataformas WHERE tipo_plataforma LIKE "PC")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "new%"),(SELECT id_plataforma FROM plataformas WHERE tipo_plataforma LIKE "PC")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "sup%"),(SELECT id_plataforma FROM plataformas WHERE tipo_plataforma LIKE "PC")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "sup%"),(SELECT id_plataforma FROM plataformas WHERE tipo_plataforma LIKE "Nin%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "pok%"),(SELECT id_plataforma FROM plataformas WHERE tipo_plataforma LIKE "Nin%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "Met%"),(SELECT id_plataforma FROM plataformas WHERE tipo_plataforma LIKE "PC")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "Met%"),(SELECT id_plataforma FROM plataformas WHERE tipo_plataforma LIKE "Pla%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "Met%"),(SELECT id_plataforma FROM plataformas WHERE tipo_plataforma LIKE "x%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "Met%"),(SELECT id_plataforma FROM plataformas WHERE tipo_plataforma LIKE "Nin%"));

-- INSERCIÓN DE DATOS --
INSERT INTO juegosDistribuidoras(id_juego,id_distribuidora) VALUES
((SELECT id_juego FROM juegos WHERE nombre LIKE "God%"),(SELECT id_distribuidora FROM distribuidoras WHERE nombre LIKE "Son%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "Sup%"),(SELECT id_distribuidora FROM distribuidoras WHERE nombre LIKE "Nin%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "Pok%"),(SELECT id_distribuidora FROM distribuidoras WHERE nombre LIKE "Nin%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "Met%"),(SELECT id_distribuidora FROM distribuidoras WHERE nombre LIKE "Son%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "Met%"),(SELECT id_distribuidora FROM distribuidoras WHERE nombre LIKE "x%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "Pok%"),(SELECT id_distribuidora FROM distribuidoras WHERE nombre LIKE "Act%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "Gran%"),(SELECT id_distribuidora FROM distribuidoras WHERE nombre LIKE "Son%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "Gran%"),(SELECT id_distribuidora FROM distribuidoras WHERE nombre LIKE "x%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "Cod%"),(SELECT id_distribuidora FROM distribuidoras WHERE nombre LIKE "Act%")),
((SELECT id_juego FROM juegos WHERE nombre LIKE "Unc%"),(SELECT id_distribuidora FROM distribuidoras WHERE nombre LIKE "Son%"));

-- INSERCIÓN DE DATOS --
INSERT INTO juegosPuntajes VALUES
((SELECT id_juego FROM juegos WHERE nombre LIKE "God%"),10),
((SELECT id_juego FROM juegos WHERE nombre LIKE "new%"),7),
((SELECT id_juego FROM juegos WHERE nombre LIKE "pok%"),6),
((SELECT id_juego FROM juegos WHERE nombre LIKE "for%"),1),
((SELECT id_juego FROM juegos WHERE nombre LIKE "God%"),8),
((SELECT id_juego FROM juegos WHERE nombre LIKE "sup%"),5),
((SELECT id_juego FROM juegos WHERE nombre LIKE "unch%"),9),
((SELECT id_juego FROM juegos WHERE nombre LIKE "age%"),2),
((SELECT id_juego FROM juegos WHERE nombre LIKE "cod%"),5),
((SELECT id_juego FROM juegos WHERE nombre LIKE "unch%"),1);

/*
VISTAS: en esta sección es referida a las vista de las tablas presenten informacion más relevante.La vista creadas son:
Usuarios: muestra los datos de los usuarios.
Juego: muestra los datos de los juegos.
Juegos y puntajes: muestra los juegos y sus puntajes.
Desarrolladora: muestra los datos de las desarrolladoras.
Distribuidora: muestra los datos de las distribuidoras.
Cantidad de usuarios por plataforma: muestra la cantidad de usuarios por plataforma.
*/
-- Vista Usuario --
CREATE VIEW Usuario 
AS SELECT 
    u.id_usuario AS 'ID',u.nick AS 'Nick',
    DATE_FORMAT(u.fecha_nac,'%d-%m-%Y') AS 'Fecha de nacimiento',pl.tipo_plataforma AS 'Plataforma',
    co.codigoArea AS 'Código de Área',c.numero AS'Número Celular',
    p.nombre AS 'Provincia',pa.nombre AS 'País',
    j.nombre AS 'Juegos'
FROM
    usuarios AS u 
 INNER JOIN celulares AS c  ON u.id_celular = c.id_celular
 INNER JOIN codigosareas AS co ON c.id_codigoArea = co.id_codigoArea
 INNER JOIN provincias AS p ON u.id_provincia = p.id_provincia
 INNER JOIN paises AS pa ON p.id_pais = pa.id_pais
 INNER JOIN usuarioplataformas AS up ON u.id_usuario = up.id_usuario
 INNER JOIN plataformas AS pl ON up.id_plataforma = pl.id_plataforma
 INNER JOIN usuariosjuegos AS uj ON u.id_usuario = uj.id_usuario 
 INNER JOIN juegos AS j ON uj.id_juego = j.id_juego;
-- Fin del Código -- 

-- Vista Juego -- 
CREATE VIEW Juego
AS SELECT 
j.nombre AS 'Nombre', DATE_FORMAT(j.fecha_creacion,'%d-%m-%Y') AS 'Fecha de Creación',
di.nombre AS 'Nombre de Distribuidora/as',de.nombre AS 'Nombre de Desarrolladora/as',
pl.tipo_plataforma AS 'Plataforma',g.nombre AS 'Género'
FROM 
	juegos AS j
INNER JOIN juegosdesarrolladoras AS jde ON j.id_juego = jde.id_juego
INNER JOIN desarrolladoras AS de  ON jde.id_desarrolladora = de.id_desarrolladora
INNER JOIN juegosdistribuidoras AS jdi ON j.id_juego = jdi.id_juego
INNER JOIN distribuidoras AS di  ON jdi.id_distribuidora = di.id_distribuidora
INNER JOIN juegosplataformas AS jpl ON j.id_juego = jpl.id_juego
INNER JOIN plataformas AS pl  ON jpl.id_plataforma = pl.id_plataforma
INNER JOIN juegosgeneros AS jg ON j.id_juego = jg.id_juego
INNER JOIN generos AS g  ON jg.id_genero = g.id_genero ;
-- Fin del Código -- 

-- Vista de los Juegos y sus Puntuaciones Promedios -- 
CREATE VIEW JuegosYPuntajes
AS SELECT 
j.nombre AS 'Nombre', DATE_FORMAT(j.fecha_creacion,'%d-%m-%Y') AS 'Fecha de Creación',
di.nombre AS 'Nombre de Distribuidora/as',de.nombre AS 'Nombre de Desarrolladora/as',
pl.tipo_plataforma AS 'Plataforma',g.nombre AS 'Género', AVG(p.puntaje) AS 'Puntaje'
FROM 
	juegos AS j
INNER JOIN juegosdesarrolladoras AS jde ON j.id_juego = jde.id_juego
INNER JOIN desarrolladoras AS de  ON jde.id_desarrolladora = de.id_desarrolladora
INNER JOIN juegosdistribuidoras AS jdi ON j.id_juego = jdi.id_juego
INNER JOIN distribuidoras AS di  ON jdi.id_distribuidora = di.id_distribuidora
INNER JOIN juegosplataformas AS jpl ON j.id_juego = jpl.id_juego
INNER JOIN plataformas AS pl  ON jpl.id_plataforma = pl.id_plataforma
INNER JOIN juegosgeneros AS jg ON j.id_juego = jg.id_juego
INNER JOIN generos AS g  ON jg.id_genero = g.id_genero 
INNER JOIN juegosPuntajes AS jp ON j.id_juego = jp.id_juego
INNER JOIN puntajes AS p ON jp.id_puntaje = p.id_puntaje
GROUP BY j.nombre
ORDER BY Puntaje DESC;
-- Fin del Código -- 


-- Vista Desarrolladora -- 
CREATE VIEW Desarrolladora
AS SELECT  d.nombre AS 'Nombre de Desarrolladora/as',j.nombre 'Juego',j.fecha_creacion 'Fecha de creación'
FROM 
	desarrolladoras AS d
INNER JOIN juegosdesarrolladoras AS jd ON d.id_desarrolladora = jd.id_desarrolladora
INNER JOIN juegos AS j ON jd.id_juego = j.id_juego
ORDER BY d.nombre;
-- Fin del Código -- 

-- Vista Distribuidora -- 
CREATE VIEW Distribuidora
AS SELECT  d.nombre AS 'Nombre de Distribuidora/as',j.nombre 'Juego',j.fecha_creacion 'Fecha de creación'
FROM 
	distribuidoras AS d
INNER JOIN juegosdistribuidoras AS jd ON d.id_distribuidora = jd.id_distribuidora
INNER JOIN juegos AS j ON jd.id_juego = j.id_juego
ORDER BY d.nombre;
-- Fin del Código -- 

-- Vista  Usuarios por Plataforma -- 
CREATE VIEW Usuarios_por_Plataforma
AS SELECT p.tipo_plataforma AS 'Plataforma',
u.nick AS 'Usuario'
FROM 
	plataformas AS p
INNER JOIN usuarioplataformas AS up ON p.id_plataforma = up.id_plataforma
INNER JOIN usuarios AS u ON up.id_usuario = u.id_usuario
ORDER BY p.tipo_plataforma DESC
;
-- Fin del Código -- 

-- Vista  cantidad de Usuarios por Plataforma -- 
CREATE VIEW Cantidad_Usuarios_por_Plataforma
AS SELECT p.tipo_plataforma AS 'Plataforma',
COUNT(up.id_usuario) AS 'Cantidad de Usuarios'
FROM 
	plataformas AS p
INNER JOIN usuarioplataformas AS up ON p.id_plataforma = up.id_plataforma
GROUP BY up.id_plataforma
ORDER BY p.tipo_plataforma DESC;
-- Fin del Código -- 

/*
FUNCIONES: son códigos de SQL que reciben datos de entrada, realizan operaciones con ellos y luego devuelven un resultado.
Se realizan 2 funciones, su finalidad se encuentran comentadas al inicio de ejecutar cada una de ellas.
*/

/*
1ra FUNCION: la funcion se llama usuarios_por_ plataforma, se le da como atributo un varchar (ej:pc) y después esta devuelve la 
cantidad de usuarios que pertenecen a la plataforma.*/
DELIMITER #
CREATE FUNCTION USUARIOS_POR_PLATAFORMA(plataforma VARCHAR(20))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE cantidad_usuarios INT;
    SELECT COUNT(u.id_plataforma) INTO cantidad_usuarios FROM usuarioplataformas AS u
	INNER JOIN plataformas AS p ON u.id_plataforma = p.id_plataforma 
	WHERE p.tipo_plataforma = plataforma;
    RETURN cantidad_usuarios;
END#
DELIMITER ;
/* Ejecutar esta sentencia:  
SELECT  USUARIOS_POR_PLATAFORMA("Pc") AS "USUARIOS POR PLATAFORMA"; */


/*
2da FUNCIÓN: la función se llama CANTIDAD_DE_ERRORES, se le asigna 2 atributos varchar (1ro nombre de un juego y 2do una plataforma)
y después esta función devuelve la cantidad de errores que tiene el juego y la plataforma.
*/
DELIMITER #
CREATE FUNCTION CANTIDAD_DE_ERRORES(nom_juego VARCHAR(20),nom_plat VARCHAR(10) )
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE cant_errores INT;
    SELECT  COUNT(id_problema) INTO cant_errores from problemas AS p
	INNER JOIN juegos AS j ON p.id_juego = j.id_juego
	INNER JOIN plataformas AS pl ON p.id_plataforma = pl.id_plataforma
	WHERE (j.nombre like CONCAT('%',nom_juego,'%')) AND (pl.tipo_plataforma like CONCAT('%',nom_plat,'%'));
    RETURN cant_errores;
END#
DELIMITER ;

/* Ejemplo: 
SELECT CANTIDAD_DE_ERRORES('g','p') AS "CANTIDAD DE ERRORES" ; */

/*
STORED PROCEDURES: Su objetivo es realizar una tarea determinada, desde operaciones sencillas hasta tareas muy complejas.
Se realizan 4 stored procedures, su finalidad se encuentran comentadas al inicio de ejecutar cada una de ellos.
*/

/* 1re Store Procedure: este stored procedure ordena la tabla juegos según un campo de la tabla y si coloca 1 lo ordena de manera descendente */
DELIMITER #
CREATE PROCEDURE SP_Tabla_Juegos(IN condicion INT,IN campo VARCHAR(20) ) -- Primero defino 2 parametros de entrada, condicion y campo. --
BEGIN
	IF condicion = 1 THEN  -- Si el parámetro condición es igual a 1 --
    SET @ordenar = CONCAT('ORDER BY ',campo,' DESC'); -- se crea la variable @ordernar.Esta es igual a la concatenación --
    -- de ORDER BY, el parámetro campo  y DESC. Esta variable más adelante se utiliza para ordernar según el campo dado como parámetro de manera descendente. --
    ELSE
    -- Sino la variable @ordenar es a igual a la concatenacion de order by y el parametro campo. El resultado se ordenaría según el parámetro  dado de manera ascendente. --
	SET @ordenar = CONCAT('ORDER BY ',campo); 	
    END IF;
    -- En esta parte, creamos la variable sentencia_select, es igual a la concatenación de la sentencia select y la variable ordenar --
    SET @sentencia_select = concat('SELECT j.id_juego "ID" ,j.nombre AS "Nombre", DATE_FORMAT(j.fecha_creacion,"%d-%m-%Y") AS "Fecha de Creación",
			di.nombre AS "Nombre de Distribuidora/as",de.nombre AS "Nombre de Desarrolladora/as",
			pl.tipo_plataforma AS "Plataforma",g.nombre AS "Género"
		FROM 
			juegos AS j
		INNER JOIN juegosdesarrolladoras AS jde ON j.id_juego = jde.id_juego
		INNER JOIN desarrolladoras AS de  ON jde.id_desarrolladora = de.id_desarrolladora
		INNER JOIN juegosdistribuidoras AS jdi ON j.id_juego = jdi.id_juego
		INNER JOIN distribuidoras AS di  ON jdi.id_distribuidora = di.id_distribuidora
		INNER JOIN juegosplataformas AS jpl ON j.id_juego = jpl.id_juego
		INNER JOIN plataformas AS pl  ON jpl.id_plataforma = pl.id_plataforma
		INNER JOIN juegosgeneros AS jg ON j.id_juego = jg.id_juego
		INNER JOIN generos AS g  ON jg.id_genero = g.id_genero ' , @ordenar); 
    PREPARE ejecucion FROM @sentencia_select; 
    EXECUTE ejecucion;
    DEALLOCATE PREPARE ejecucion;
END #
DELIMITER ;
/* Ejemplo 
call SP_Tabla_Juegos(1,'ID'); */

/* 2do Store Procedure: este stored procedure hace lo mismo que el anterior con la diferencia que se aplica a la tabla usuarios */
DELIMITER #
CREATE PROCEDURE SP_Tabla_Usuarios(IN condicion INT,IN campo VARCHAR(20) ) -- Primero defino 2 parametros de entrada, condicion y campo. --
BEGIN
	IF condicion = 1 THEN  -- Si el parámetro condición es igual a 1 --
    SET @ordenar = CONCAT('ORDER BY ',campo,' DESC'); -- se crea la variable @ordernar.Esta es igual a la concatenación --
    -- de ORDER BY, el parámetro campo  y DESC. Esta variable más adelante se utiliza para ordernar según el campo dado como parámetro de manera descendente. --
    ELSE
    -- Sino la variable @ordenar es a igual a la concatenacion de order by y el parametro campo. El resultado se ordenaría según el parámetro  dado de manera ascendente. --
	SET @ordenar = CONCAT('ORDER BY ',campo); 	
    END IF;
    -- En esta parte, creamos la variable sentencia_select, es igual a la concatenación de la sentencia select y la variable ordenar --
    SET @sentencia_select = concat("SELECT u.id_usuario AS ID,u.nick AS NICK ,concat(co.codigoArea,'-',c.numero ) AS CELULAR, 
p.nombre AS PROVINCIAS, pa.nombre AS PAISES
FROM  usuarios AS u
	INNER JOIN celulares AS c ON u.id_celular = c.id_celular
    INNER JOIN codigosareas AS co ON c.id_codigoArea = co.id_codigoArea
    INNER JOIN provincias AS p ON u.id_provincia = p.id_provincia
    INNER JOIN paises AS pa ON u.id_pais = pa.id_pais
GROUP BY u.nick ", @ordenar); 
    PREPARE ejecucion FROM @sentencia_select; 
    EXECUTE ejecucion;
    DEALLOCATE PREPARE ejecucion;
END #
DELIMITER ;
/*Ejemplo 
call SP_Tabla_Usuarios(1,'PAISES'); */

/*3er Store Procedure: este estored procedure se crea de manera de ejemplo , se deberia hacer para los demas tablas, lo cual varia la cantidad -- 
de campos y datos a incertar segun la tabla.*/
DELIMITER #
CREATE PROCEDURE SP_Tabla_Paises(IN nombre VARCHAR(20)) -- Crea el stored procdure SP_Tabla_Paises,tiene 1 parámetro de entrada nombre_país.--
BEGIN
	SET @nombre_pais = nombre; -- Se crea la variable @nombre_pais y se el asigna el parámetro de entrada nombre.
	INSERT INTO paises(nombre) values (@nombre_pais); -- Se inserta la variable anterior en el campo nombre de la tabla paises. -- 
END #
DELIMITER ;
/*Ejemplo, se aconseja a ejecutar en este orden para ver los cambios. 
SELECT * FROM paises;
call SP_Tabla_Paises('Ghana');
call SP_Tabla_Paises('Africa');
call SP_Tabla_Paises('Tonga');
SELECT * FROM paises; */

/* 4to Store Procedure: este estored procedure se crea de manera de genérica para elegir la tabla e insertar un registro nuevo 
en el campo nombre, en la tabla que se indique.  
En mi caso se peude aplicar a 4 tablas: paises,sugeneros,desarrolladoras y distribuidoras.Esta tabla tiene en comun el campo nombre.*/
DELIMITER #
CREATE PROCEDURE SP_Inserta_Nombre(IN tabla VARCHAR(20), IN nombre VARCHAR(20)) -- Crea el stored procdure SP_Inserta_Nombre,tiene 2 parámetro de entrada,tabla y nombre.--
BEGIN
	SET @nombre_tabla = tabla; -- Se crea la variable @nombre_tabla y se el asigna el parámetro de entrada tabla.
    SET @valor_campo = nombre; -- Se crea la variable @valor_campo y se el asigna el parámetro de entrada nombre.
    SET @contenar = concat("INSERT INTO ",@nombre_tabla,"(nombre) values ('",@valor_campo,"');");-- Se crea una nueva variable @concatenar--
    -- Concatena una sentencia insert, el nombredela tabla, el campo nombre y el valor que tomará dicho campo. -- 
	PREPARE ejecucion FROM @contenar;
    EXECUTE ejecucion;
    DEALLOCATE PREPARE ejecucion;
END #
DELIMITER ;

/*  Ejemplo, se aconseja a ejecutar en este orden para ver los cambios.   
CALL SP_Inserta_Nombre('desarrolladoras', 'SASs');
SELECT * FROM desarrolladoras;
CALL SP_Inserta_Nombre('distribuidoras', 'SASs');
SELECT * FROM distribuidoras;
*/


/*
Triggers: Los disparadores o triggers son objetos cuyo objetivo es ejecutar el código en respuesta a un evento que ocurre en una tabla. 
Los eventos pueden ser de tres tipos: INSERT, UPDATE o DELETE.
Se crearon 6 triggers, esto a aplicaron a las tablas que son mas importante pero también se puede extender a las demás tablas.
La funcionalidad de cada trigger está comentado antes de ejecutar el código.
*/

-- TABLA USUARIOS --  
/*1er Trigger: este trigger se dispara antes de eliminar un registro de la tabla usuarios e inserta datos en la tabla log_del_usuario  sobre: 
 Que id de usuario y nick se borró, que usuario lo hizo y la fecha y hora en que se eliminó. */
CREATE TRIGGER log_delete_usuario
BEFORE DELETE ON usuarios
FOR EACH ROW
INSERT INTO log_del_usuario VALUES (DEFAULT, OLD.id_usuario,OLD.nick,USER(),CURDATE(),CURTIME() );

/* A  modo de ejemplo ejecutar laS siguentes sentencias : 
SELECT *from log_del_usuario;
INSERT INTO  celulares VALUES (default,3059854,2);
INSERT INTO usuarios VALUES (default,'1995-12-02','bOND',11,2,1);
DELETE FROM usuarios WHERE id_usuario > 10;
SELECT *from log_del_usuario;
*/ 


-- 2do Trigger: este trigger se dispara después de que se inserte un registro en la tabla usuarios y crea un registro en la tabla log_ins_usuario de que,quien y cuando se inserto el registro.
CREATE TRIGGER log_insert_usuarios
AFTER INSERT ON usuarios
FOR EACH ROW
INSERT INTO log_ins_usuario VALUES (DEFAULT, NEW.id_usuario,NEW.nick,USER(),CURDATE(),CURTIME());
/* A  modo de ejemplo ejecutar la siguente sentencia : 
SELECT *from log_ins_usuario;
INSERT INTO  celulares VALUES (default,3059854,2);
INSERT INTO usuarios VALUES (DEFAULT,'1995-12-02','bOND',11,2,1);
SELECT *from log_ins_usuario;
SELECT *from usuarios;
*/


-- 3er Trigger: este trigger se dispara después de que se actualice un registro en la tabla usuarios y crea un registro en la tabla log_upd_usuario de que,quien y cuando se inserto el registro.
CREATE TRIGGER log_update_usuarios
AFTER UPDATE ON usuarios
FOR EACH ROW
INSERT INTO log_upd_usuario VALUES (DEFAULT, NEW.id_usuario,NEW.nick,USER(),CURDATE(),CURTIME());
/* A  modo de ejemplo ejecutar la siguente sentencia : 
SELECT *from log_upd_usuario;
INSERT INTO  celulares VALUES (default,3059854,2);
INSERT INTO usuarios VALUES (DEFAULT,'1995-12-02','bOND',11,2,1);
UPDATE usuarios SET fecha='1995-12-03' WHERE nick = 'bOND';
SELECT *from log_upd_usuario;
SELECT *from usuarios;
*/

-- TABLA JUEGOS --
-- 4to Trigger: este trigger es parecido al 1ro, se dispara antes de borrar un resgistro de la tabla juegos. --
CREATE TRIGGER log_delete_juego
BEFORE DELETE ON juegos
FOR EACH ROW
INSERT INTO log_del_juego VALUES (DEFAULT, OLD.id_juego,OLD.nombre,USER(),CURDATE(),CURTIME());
/* A  modo de ejemplo ejecutar laS siguentes sentencias : 
SELECT *from log_del_juego;
SELECT *from juegos;
INSERT INTO  juegos VALUES (DEFAULT,'Ciber Punk 2077','2020-12-10');
DELETE FROM juegos WHERE id_juego > 10;
SELECT *from log_del_juego;
*/

-- 5to Trigger: este trigger se dispara después de que se inserte un registro en la tabla juegos y crea un registro en la tabla log_ins_juego de que,quien y cuando se inserto el registro. --
CREATE TRIGGER log_insert_juegos
AFTER INSERT ON juegos
FOR EACH ROW
INSERT INTO log_ins_juego VALUES (DEFAULT, NEW.id_juego,NEW.nombre,USER(),CURDATE(),CURTIME());
/* A  modo de ejemplo ejecutar laS siguentes sentencias : 
SELECT * from log_ins_juego;
SELECT * from juegos;
INSERT INTO  juegos VALUES (DEFAULT,'Bloodbrne','2015-03-15');
SELECT *from log_ins_juego;
SELECT *from juegos;
*/

-- 6to Trigger: este trigger es parecido al 3ro, se dispara despues de actualizar un registro de la tabla juegos. --
CREATE TRIGGER log_update_juegos
AFTER UPDATE ON juegos
FOR EACH ROW
INSERT INTO log_ins_juego VALUES (DEFAULT, NEW.id_juego,NEW.nombre,USER(),CURDATE(),CURTIME());
/* A  modo de ejemplo ejecutar la siguente sentencia : 
SELECT *from log_upd_usuario;
INSERT INTO  celulares VALUES (default,3059854,2);
INSERT INTO usuarios VALUES (DEFAULT,'1995-12-02','bOND',11,2,1);
UPDATE usuarios SET fecha='1995-12-03' WHERE nick = 'bOND';
SELECT *from log_upd_usuario;
SELECT *from usuarios;
*/

/*
Sentencias TCL (commit y rollback): se utilizan para ejecutar código y aprobar dicha transacción(commit), 
volver a un punto de guardado(savepoint) o volver la bd a el mismo que estado que estaba antes de ejecutar 
cualquier transacción(rollback).
*/
-- Tabla juegos -- 
-- En esta transacción se insertan 3 registros nuevos --
SELECT @@AUTOCOMMIT; -- Verificamos que el autocommitt esta en 1 -- 
START TRANSACTION; -- El autocommitt al estar en 1 debemos inicializar la transacción --
INSERT INTO JUEGOS  VALUES (DEFAULT,'Crash Bandicoot 4','2020-09-16'),(DEFAULT,'Crash Bandicoot 4','2020-09-26'),
(DEFAULT,'Crash Bandicoot 4','2020-10-26');-- Inserto registros  nuevos, con  datos corrrectos e incorrectos --
COMMIT; -- Apruebo la inserción de los datos --
SELECT * FROM JUEGOS;

-- En esta transacción se eliminan  registros nuevos --
SET AUTOCOMMIT=0; -- Se asigna el valor 0 al AUTOCOMMIT -- 
SELECT @@AUTOCOMMIT; -- Verificamos que el autocommitt esta en 0 -- 
DELETE FROM JUEGOS where id_juego > 10; -- Elimino registros  nuevos, que tienen datos incorrectos --
COMMIT; -- Apruebo la eliminación de los datos --
SELECT * FROM JUEGOS;

-- En esta transacción se eliminan  todo los registros distintos, los cuento y aplico un rollback --
SET AUTOCOMMIT=1; -- Se asigna el valor 1 al AUTOCOMMIT -- 
SELECT @@AUTOCOMMIT; -- Verificamos que el autocommitt esta en 1 -- 
START TRANSACTION; -- El autocommitt al estar en 1 debemos inicializar la transacción --
DELETE FROM JUEGOS where nombre NOT LIKE 'Crash%'; -- Elimino registros que no contienen la palabra crash --
SELECT COUNT(id_juego) FROM JUEGOS ; --  Cuento la cantidad juegos que quedaron despues del DELETE -- 
ROLLBACK; -- Aplico el rollback para que se vuelva hacia hacia atras, es decir , la tabla juego no elimine ningun registro --
SELECT * FROM JUEGOS;

-- Tabla usuarios --
-- savepoint --
SELECT * FROM USUARIOS; -- VEMOS LA CNATIDAD DE USUARIOS
SELECT @@AUTOCOMMIT; -- Verificamos que el autocommitt esta en 1 -- 
START TRANSACTION; -- El autocommitt al estar en 1 debemos inicializar la transacción --
INSERT INTO usuarios(fecha_nac,nick,id_celular,id_provincia,id_pais) VALUES -- Se insertan 4 registros --
("1995/09/06","Usopp212",1,1,1),("1990/10/26","12Eren2",2,2,1),("1986/08/16","Armin2616",3,16,9),("2000/06/05","Yond1u_XD",4,19,10);
SAVEPOINT usuario_cuarto_registro; -- Se que indica un punto de guardado, se guarda hasta el registro 4 inclusive --
INSERT INTO usuarios(fecha_nac,nick,id_celular,id_provincia,id_pais) VALUES -- Se insertan 4 registros más --
("2009/03/03","Jon_Sn1ow",5,10,6),("1990/03/29","Khal_Dr1ogo",6,8,5), ("2008/01/31","No1ctis_223",7,1,1), ("2013/02/26","N1oxius",8,1,1);-- Se insertan 4 registros -
SAVEPOINT usuario_octavo_registro;-- Se que indica un punto de guardado, hasta se guarda desde el registro 5 y hasta el 8 inclusive --
INSERT INTO usuarios(fecha_nac,nick,id_celular,id_provincia,id_pais) VALUES("2005/02/16","PA1NDA",9,2,1), ("2010/04/18","1farger256",10,1,1);
-- Se insertan dos registro más --
-- ROLLBACK DE LOS SAVEPOINTS -- 
ROLLBACK TO SAVEPOINT usuario_octavo_registro;
SELECT  * FROM USUARIOS;
ROLLBACK TO SAVEPOINT usuario_cuarto_registro;
SELECT  * FROM USUARIOS;
COMMIT;-- Apruebo la inserción de los datos --



/*
Sentencias DCL: estás sentencias se utilza para otorgar, mostrar  y revocar(revoke, no se utilizó) permisos a un usuario determinado. 
*/
USE mysql;
-- Usuario sólo de lectura.--
CREATE USER 'usuario_solo_lectura'@'localhost' IDENTIFIED BY 'admin25'; -- Se crea un usuario de solo lectura.
GRANT SELECT ON *.* TO 'usuario_solo_lectura'@'localhost'; -- Se otorga los permisos de lectura (Sentencia: Select)
SHOW GRANTS FOR 'usuario_solo_lectura'@'localhost'; -- Se muestra los permisos de dicho usuario. 

-- Usuario con permisos.--
CREATE USER 'usuario_con_permisos'@'localhost' IDENTIFIED BY 'admin25'; -- Se crea un usuario de solo lectura.
GRANT SELECT,INSERT,UPDATE ON proyecto_final.* TO 'usuario_con_permisos'@'localhost';
-- GRANT SELECT ON proyecto_final.* TO 'usuario_con_permisos'@'localhost';-- Se otorga los permisos de lectura (Sentencia: Select)
-- GRANT INSERT ON proyecto_final.* TO 'usuario_con_permisos'@'localhost';-- Se otorga los permisos de insercion (Sentencia: Insert)
-- GRANT UPDATE ON proyecto_final.* TO 'usuario_con_permisos'@'localhost';-- Se otorga los permisos de lectura (Sentencia: Select)
/*GRANT SELECT,INSERT,UPDATE ON proyecto_final.* TO 'usuario_con_permisos'@'localhost';  Otra manera de otrogar los permisos anteriores en una sola línea.
*/
SHOW GRANTS FOR 'usuario_con_permisos'@'localhost';-- Se muestra los permisos de dicho usuario. 

