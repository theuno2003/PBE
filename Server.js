const express = require('express');
const expressApp = express();
const PORT = 3000;
const mysql = require('mysql');

//Parsear en Json i urlencoded
expressApp.use(express.json());
expressApp.use(express.urlencoded({ extended: true }));


// Conexion a Base de datos
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    database: 'pbe_db',
    password: 'aBurgos1234567',
    port: '3306',
})

connection.connect((err) => {
    if (err) {
        console.log(err);
        return;
    }

    console.log("Conexion a la base de datos exitosa");

})

//Definir que fer si introduim uid
expressApp.get("/:uid", (req, res) => {
    const uid = req.params.uid;
    const consulta = req.query.consulta;

    connection.query('SELECT * FROM students WHERE uid = ?', uid, (error, results, fields) => {
        if (error) {
            console.error('Error al ejecutar la consulta:', error);
            res.status(500).send('Error del servidor');
            return;
        }

        // Verificar si se encontraron resultados
        if (results.length === 0) {
            res.status(404).send('Cliente no encontrado');
            return;
        }




        // Si se encontraron resultados, enviar el nombre del cliente
        const nombreCliente = results[0].name;

        //Si volem veure les notes:
        if (consulta == 'marks') {
            connection.query('SELECT * FROM marks WHERE uid = ?', uid, (errormarks, results, fields) => {
                if (errormarks) {
                    console.error('Error al obtener las notas del estudiante:', errormarks);
                    res.status(500).send('Error del servidor');
                    return;
                }
                notas = results;

                //Enviar notas
                res.json({ nombreCliente, notas })

            })

        } 
        //Si volem veure les tasques:
        else if (consulta == 'tasks') {
            connection.query('SELECT * FROM tasks WHERE uid = ?', uid, (errormarks, results, fields) => {
                if (errormarks) {
                    console.error('Error al obtener las tasks del estudiante:', errormarks);
                    res.status(500).send('Error del servidor');
                    return;
                }
                tasks = results;

                //Enviar notas
                res.json({ nombreCliente, tasks })

            })

        }
        // Si volem veure timetables
        
        else if (consulta == 'timetables') {
            connection.query('SELECT * FROM timetables WHERE uid = ?', uid, (errormarks, results, fields) => {
                if (errormarks) {
                    console.error('Error al obtener los horarios del estudiante:', errormarks);
                    res.status(500).send('Error del servidor');
                    return;
                }
                timetables = results;

                //Enviar notas
                res.json({ nombreCliente, timetables })

            })

        } 
         else {
            //Si no se solicitan las notas enviar solo el nombre:
            res.json({ nombreCliente });
        }

    });
});





expressApp.listen(PORT, () => {
    console.log("Servidor levantado");
})
