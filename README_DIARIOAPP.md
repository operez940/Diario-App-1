# Documentación para Principiantes: Proyecto DiarioApp

Este documento explica, de manera sencilla, la estructura y funcionamiento general del proyecto DiarioApp (NestJS + Prisma + Flutter).

---

## ¿Qué es DiarioApp?
Es una aplicación que permite crear, editar, eliminar y organizar entradas (notas o registros), con soporte para etiquetas y usuarios. Tiene:
- **Backend:** API en NestJS (Node.js) usando Prisma para la base de datos.
- **Frontend:** App móvil en Flutter.

---

## Estructura del Proyecto

```
proyecto/
├── backend/      # API y lógica de negocio (NestJS + Prisma)
└── frontend/     # Aplicación móvil (Flutter)
```

### 1. backend/
- **src/**: Código fuente principal.
  - **app.controller.ts / app.service.ts**: Controlador y lógica principal de la app.
  - **entry/**: Todo lo relacionado con las entradas (notas).
    - `entry.controller.ts`: Define los endpoints (rutas) para crear, leer, actualizar, eliminar, restaurar y borrar definitivamente entradas.
    - `entry.service.ts`: Lógica de negocio para manejar las entradas y sus etiquetas.
    - `tag/`, `user/`: Módulos para etiquetas y usuarios.
  - **prisma.service.ts**: Conexión con la base de datos usando Prisma.
- **prisma/**: Esquema de la base de datos y migraciones.
- **generated/**: Código generado automáticamente por Prisma.

### 2. frontend/
- **lib/**: Código fuente principal de Flutter.
  - **models/**: Definición de las clases de datos (entrada, usuario, etiqueta).
  - **screens/**: Pantallas de la app (lista de entradas, papelera, etc).
  - **services/**: Lógica para conectarse con la API (EntryService, UserService, etc).
- **android/**, **ios/**, **web/**, **linux/**, **macos/**, **windows/**: Archivos para compilar la app en cada plataforma.

---

## ¿Cómo funciona el flujo de datos?
1. El usuario usa la app Flutter (frontend) para crear, ver o eliminar notas.
2. La app se comunica con el backend (NestJS) a través de peticiones HTTP (API REST).
3. El backend recibe la petición, ejecuta la lógica (por ejemplo, crear una entrada) y usa Prisma para guardar o leer datos en la base de datos.
4. El backend responde a la app con los datos solicitados o el resultado de la operación.

---

## Funcionalidades principales
- **Crear entrada:** El usuario puede crear una nota con etiquetas.
- **Editar entrada:** Modificar el contenido o etiquetas de una nota.
- **Eliminar (soft delete):** Manda la nota a la papelera (no se borra realmente).
- **Restaurar:** Recupera una nota de la papelera.
- **Eliminar definitivamente (hard delete):** Borra la nota para siempre.
- **Ver papelera:** Listar las notas eliminadas.
- **Etiquetas:** Organizar las notas por categorías.
- **Usuarios:** Cada entrada pertenece a un usuario.

---

## ¿Qué tecnologías se usan?
- **NestJS:** Framework para crear APIs en Node.js de forma estructurada y segura.
- **Prisma:** ORM para manejar la base de datos de manera sencilla y segura.
- **Flutter:** Framework de Google para crear apps móviles multiplataforma.
- **PostgreSQL:** Base de datos relacional.

---

## Glosario rápido
- **API REST:** Forma estándar de comunicar apps y servidores usando HTTP.
- **Endpoint:** Ruta de la API (ejemplo: `/entry`, `/entry/:id/restore`).
- **Soft delete:** Marcar como eliminada sin borrar realmente.
- **Hard delete:** Borrar definitivamente de la base de datos.
- **ORM:** Herramienta para trabajar con bases de datos usando código en vez de SQL directo.

---

## Consejos para principiantes
- Si quieres agregar una nueva funcionalidad, primero piensa si es del backend (API) o del frontend (app).
- Si ves errores, revisa los logs de la terminal y busca el archivo o línea mencionada.
- Usa la documentación oficial de NestJS, Prisma y Flutter para aprender más.
- Haz pruebas con la app y la API usando herramientas como Postman o Insomnia.

---

¡Listo! Así tienes una visión general y sencilla de cómo funciona y se organiza tu proyecto DiarioApp.
