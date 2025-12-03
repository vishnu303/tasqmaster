## TasqMaster

TasqMaster is a Flutter app. It uses a simple mock API using `json-server` (via `db.json`) during development to simulate a backend.

---

## Setup Instructions

### 1. Prerequisites

- **Node.js + npm** (you need to run the mock API with `json-server`).

### 2. Install Flutter dependencies
From the project root:

```bash
flutter pub get
```

### 3. Run the mock API
Install `json-server` :

```bash
npm install -g json-server
```

Then, from the project root, start the mock API:

```bash
json-server --watch db.json --port 3000
```

This will expose the tasks at `http://localhost:3000/tasks` or `http://10.0.2.2:3000`(for android emulator) .

### 4. Run the Flutter app

Select your desired emulator to run the app.

---

## Architecture Overview

TasqMaster follows a simple MVVM-style structure with clear separation between UI, state management, and data services.

**Layers**
- **Models (`lib/src/models`)**
  - Contains the core data classes such as `Task` s.
- **Services (`lib/src/services`)**
  - Handles API communication (`task_api_service.dart`) for fetching, creating and updating.
- **ViewModels (`lib/src/viewmodels`)**
  - Contains presentation logic and state (`task_list_view_model.dart`, `task_detail_view_model.dart`).
  - Exposes ChangeNotifiers used by the UI to react to changes.
- **Views (`lib/src/views`)**
  - Flutter UI screens such as `task_list_screen.dart` and `task_detail_screen.dart`.
  - Consume ViewModels to display data and trigger actions (load, create, update, delete).
- **Widgets (`lib/src/widgets`)**
  - Reusable UI components such as `task_card.dart` for rendering individual tasks or shared UI pieces.

**Data flow**
- Views (UI) interact with **ViewModels** (user actions like tapping, completing tasks).
- ViewModels call **Services** to perform network operations against the mock API.
- Services read/write data from/to the mock API (`db.json` via `json-server`).
- Responses are mapped into **Models**, which are then exposed back to the UI via ViewModels.
