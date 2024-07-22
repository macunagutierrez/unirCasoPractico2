const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const notesRouter = require('./routes/notes');

const app = express();
const PORT = process.env.PORT || 3000;
const MONGO_URL = process.env.MONGO_URL || 'mongodb://mongo:27017/notesapp';

app.use(bodyParser.json());
app.use('/notes', notesRouter);

mongoose.connect(MONGO_URL, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => {
    console.log('Connected to MongoDB');
    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });
  })
  .catch(err => {
    console.error('MongoDB connection error:', err);
  });

