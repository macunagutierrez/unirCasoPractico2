const express = require('express');
const Note = require('../models/note');

const router = express.Router();

// Crear un nuevo apunte
router.post('/', async (req, res) => {
  try {
    const note = new Note({
      title: req.body.title,
      content: req.body.content
    });
    const savedNote = await note.save();
    res.status(201).json(savedNote);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Listar todos los apuntes
router.get('/', async (req, res) => {
  try {
    const notes = await Note.find();
    res.status(200).json(notes);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;

