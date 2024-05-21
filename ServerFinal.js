const express = require('express');
const expressApp = express();
const PORT = 3000;
const mysql = require('mysql');
const {UniqueNumberId, UniqueStringId} = require('unique-string-generator');
const cookieParser = require("cookie-parser");
const path = require('path');

//Sesiones
const sessions = [];

//Conectar server con el archivo html
expressApp.use(express.static(__dirname));




//Parsear en Json i urlencoded
expressApp.use(express.json());
expressApp.use(express.urlencoded({ extended: true }));
expressApp.use(cookieParser());


// Conexion a Base de datos
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    database: 'bd_pbe',
    password: 'JoaquinMG02',
    port: '3306'
})

connection.connect((err) => {
    if (err) {
        console.log(err);
        return;
    }

    console.log("Conexion a la base de datos exitosa");

})


// Función para analizar la consulta
function parseQuery(url) {
    const querystring = url.split('?');
     if (querystring.length === 1) {
        const querytable = querystring[0];
        const query = {
            table: querytable,
        }
        return query;
    } else {
        const querytable = querystring[0];
        const queryconstraints = querystring[1];
        const constraints = queryconstraints.split('&').map(constraint => {
            return constraint.includes('=') ? constraint.split('=')[0] + "='" + constraint.split('=')[1] + "'" : constraint;
        });
        const query = {
            table: querytable,
            constraints: constraints,
        }
        return query;
    }
}



expressApp.post("/login", (req, res) => {
    const { user, password } = req.body;
    if (!user || !password) {
        return res.send("Datos no introducidos adecuadamente");
    }

    let sql = SELECT * FROM students WHERE username = "${user}" AND password = "${password}";
    connection.query(sql, (error, results, fields) => {
        if (error) {
            console.error('Usuario o contraseña Incorrectos', error);
            return res.send('Usuario o contraseña Incorrectos');
        }

        if (results.length > 0) {
            const usuario=results[0];
            const sessionId = UniqueStringId();
            sessions.push({sessionId,usuario});
            res.cookie('sessionId',sessionId,{
                httpOnly: true,
            });
            res.send(Bienvenido ${usuario.name});
        } else {
            res.send('Usuario o contraseña Incorrectos');
        }
    });
});


// Manejar las queries
expressApp.post("/query", (req, res) => {
    //Primero identificamos de que usuario se trata utilizando su cookie
    const cookies =req.cookies;
    if(!cookies.sessionId){ return res.sendStatus(401);}
    const userSession = sessions.find(
        (session)=> session.sessionId === cookies.sessionId
    );
    if(!userSession){ return res.sendStatus(401);}
    const usuario = userSession.usuario;
    
    // Parseamos la query que nos pide cliente
    const{ query} = req.body;
    const parsedquery = parseQuery(query);
    //Construimos la query
    let sql = SELECT * FROM ${parsedquery.table} WHERE uid = "${usuario.uid}";
    if (parsedquery.constraints) {
        parsedquery.constraints.forEach((constraint) => {
            sql += ` AND ${constraint}`;
        });
    }

    //Ejecutamos la query
    connection.query(sql,(error, results, fields) => {
        if (error) {
            console.error('Error al ejecutar la consulta:', error);
            res.status(500).send('Error del servidor');
            return;
        }
        res.json(results);

    });


   
});

expressApp.listen(PORT, () => {
    console.log("Servidor levantado");
});
