const express = require('express');
const bParser = require('body-parser');
const mongoose = require('mongoose');
const keys = require('./config');
const helmet = require('helmet');


const favRoutes = require('./routes/api');
const authRoutes = require('./routes/auth');

const app = express();

app.use(bParser.json());

app.use((req, res, next) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, DELETE');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    next();
});

app.use((err, req, res, next) => {
    console.error(err);
    const status = err.statusCode || 500;
    const message = err.message;
    res.status(status).json({message: message});
  });

app.use('/api', favRoutes);
app.use('/auth', authRoutes);

// @ts-ignore
app.use(helmet());

mongoose.connect(keys.mdbKey).then(result => {
  app.listen(8080);
}).catch(e => {
  console.log(e);
})
