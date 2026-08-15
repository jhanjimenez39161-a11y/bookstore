const express = require('express');

const app = express();

const PORT = 3000;

app.use(express.json());

app.get('/', (req, res) => {
  res.json({
    mensaje: 'API REST de BookStore funcionando correctamente',
  });
});

app.get('/api/productos', (req, res) => {
  res.json([
    {
      id: 1,
      titulo: 'Clean Code',
      autor: 'Robert C. Martin',
      precio: 145000,
      categoria: 'Programación',
    },
    {
      id: 2,
      titulo: 'Hábitos Atómicos',
      autor: 'James Clear',
      precio: 74900,
      categoria: 'Desarrollo personal',
    },
    {
      id: 3,
      titulo: 'Cien años de soledad',
      autor: 'Gabriel García Márquez',
      precio: 59900,
      categoria: 'Novela',
    },
    {
      id: 4,
      titulo: 'El Principito',
      autor: 'Antoine de Saint-Exupéry',
      precio: 42900,
      categoria: 'Infantil',
    },
    {
      id: 5,
      titulo: 'Padre Rico, Padre Pobre',
      autor: 'Robert T. Kiyosaki',
      precio: 58000,
      categoria: 'Finanzas',
    },
  ]);
});

app.get('/api/pedidos/estado/:id', (req, res) => {
  const id = Number(req.params.id);

  res.json({
    id: id,
    estado: 'En preparación',
    mensaje: 'El pedido está siendo preparado.',
  });
});

app.post('/api/recuperar-password', (req, res) => {
  const { correo } = req.body;

  if (!correo || !correo.includes('@')) {
    return res.status(400).json({
      mensaje: 'Debes proporcionar un correo válido.',
    });
  }

  return res.json({
    mensaje:
        'Solicitud de recuperación recibida correctamente.',
    correo: correo,
  });
});

app.listen(PORT, () => {
  console.log(
    `API REST BookStore ejecutándose en http://localhost:${PORT}`,
  );
});