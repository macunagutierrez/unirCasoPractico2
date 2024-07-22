const express = require('express');
const mongoose = require('mongoose');
const tasksRouter = require('./routes/tasks');

const app = express();
const port = process.env.PORT || 3000;
const mongoUrl = process.env.MONGO_URL || 'mongodb://localhost:27017/tareas';

mongoose.connect(mongoUrl, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.error(err));

app.use(express.json());
app.use('/tasks', tasksRouter);

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

