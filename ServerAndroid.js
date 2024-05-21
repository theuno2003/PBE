const express = require('express');
const mysql = require('mysql');
const app = express();
const port = 3001;


app.use(express.json());
app.use(express.urlencoded({ extended: false }));


// MySQL connection
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'Verano2024$',
    database: 'app_db3'
});


connection.connect((err) => {
    if (err) throw err;
    console.log('Connected to MySQL!');
   
});


// Endpoint for login
app.post('/login', (req, res) => {
    const { username, password } = req.body;
   
    // Validate the username and password
    const query = 'SELECT * FROM users WHERE username = ? AND password = ?';
    connection.query(query, [username, password], (err, results) => {
        if (err) {
            res.status(500).json({ error: 'Database error' });
        } else if (results.length > 0) {
            res.status(200).json({ message: 'Login successful' });
        } else {
            res.status(401).json({ message: 'Invalid credentials' });
        }
    });
});


app.route('/')


.get((req, res) => {
    let cedula = req.query.cedula;
    let contrasena = req.query.contrasena;


    let query_iniciar = "SELECT * FROM USUARIO WHERE cedula = ? AND contrasena = ?";


    connection.query(query_iniciar, [cedula, contrasena], (err, results, fields) => {
        if (err) {
            console.log("There was an error");
            console.log(err);
            res.json({
                    'code': 500,
                    'message': "There was an server error."
            });
        } else {


            if (results.length > 0) {
                res.json({
                    'code': 200,
                    'message': 'Get values with success.',
                    'data': results[0]
                });
            } else {
                res.json({
                    'code': 300,
                    'message': 'There are no users in the database with that values.',
                });
            }
        }
    })
})


 


// Start server
app.listen(port, () => {
    console.log(Server running on port ${port});
});
