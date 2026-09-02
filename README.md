# 🎬 Reel — Movie Discovery & Tracking App

A Flutter mobile application for discovering, searching, and organising movies using the TMDB API, with Firebase Authentication and per-user local movie lists powered by Hive.

---

## ⚙️ Quick Setup

### 1. Clone the repository

```bash
git clone https://github.com/roaajouda/iti-final-project.git
cd iti-final-project
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Add the required credentials

Follow the instructions below to configure the TMDB API and Firebase.

### 4. Run the application

```bash
flutter run
```

---

## 🔑 Required Credentials

### TMDB API Token

The TMDB token is stored in:

```text
lib/core/constants.dart
```

This file is **gitignored**, so you must create it locally:

```dart
class Constants {
  static const String tmdbToken = 'YOUR_TMDB_READ_ACCESS_TOKEN_HERE';
}
```

You can get your TMDB Read Access Token from your TMDB account:

[TMDB API Settings](https://www.themoviedb.org/settings/api)

---

### Firebase Configuration

Firebase configuration files are **gitignored** and must be generated for your Firebase project.

Install the required tools:

```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```

Then configure Firebase:

```bash
flutterfire configure
```

Select the platforms you want to support and connect the project to your Firebase project.

In the Firebase Console, enable:

```text
Authentication
→ Sign-in method
→ Email/Password
```

The application uses Firebase Authentication for user registration, login, and logout.

---

## 🛠 Tech Stack

| Technology              | Purpose                |
| ----------------------- | ---------------------- |
| Flutter / Dart          | Application framework  |
| Provider                | State management       |
| Firebase Authentication | User authentication    |
| TMDB REST API v3        | Movie data             |
| Hive                    | Local movie storage    |
| SharedPreferences       | Local user preferences |
| HTTP                    | API networking         |

---

## 🔐 User Data & Local Storage

Reel uses **Hive** to store movies locally.

Each Firebase user has separate Hive boxes based on their Firebase Authentication UID:

```text
favourites_<user_uid>
watch_now_<user_uid>
watch_later_<user_uid>
watched_<user_uid>
```

This keeps each user's movie lists separated from other users on the same device.

The application supports four types of movie lists:

* **Favourites**
* **Watching**
* **Want to Watch**
* **Watched**

---

## ✨ Features

### Authentication

* User registration
* Email/password login
* Logout
* Firebase Authentication
* Persistent authentication state

### Movie Discovery

* Browse popular movies
* Browse movies by genre
* View top-rated movies
* View latest releases
* Browse all movies in a genre
* Infinite/paginated movie lists

### Search

* Search for movies using TMDB
* Search suggestions / trending keywords
* Debounced search requests
* Loading and error states

### Movie Details

* Movie poster and information
* Rating
* Release year
* Genres
* Overview
* Similar movies
* Add/remove from Favourites
* Add/remove from Watching
* Add/remove from Want to Watch
* Add/remove from Watched

### My Lists

Users can manage their personal movie collections through:

* Watched
* Watching
* Want to Watch

### Profile

* Display user information
* View movie-list statistics
* Logout

---

## 🏗 Architecture

The project follows a **Feature-first MVC architecture** with Provider-based state management.

The general data flow is:

```text
View
  ↓
Provider
  ↓
Controller
  ↓
Service
  ↓
API / Firebase / Hive
```

### View

Responsible for:

* UI
* User interaction
* Displaying loading states
* Displaying errors
* Displaying data from providers

### Provider

Responsible for:

* Application state
* Loading states
* Error states
* Updating the UI using `ChangeNotifier`

### Controller

Responsible for:

* Feature-specific business logic
* Coordinating between providers and services
* Preparing data for the view

### Service

Responsible for external operations such as:

* TMDB API requests
* Firebase Authentication
* Hive local storage
* SharedPreferences

---

## 📁 Project Structure

```text
lib/
├── core/
│   ├── constants.dart
│   ├── exceptions/
│   ├── models/
│   ├── navigation/
│   ├── services/
│   └── theme/
│
├── features/
│   ├── auth/
│   ├── home/
│   ├── category/
│   ├── search/
│   ├── favourites/
│   ├── my_lists/
│   ├── profile/
│   └── movie_details/
│
│
└── widgets/
```

---

## 🧩 Error Handling

The application uses a shared exception hierarchy for consistent error handling.

Examples include:

```text
NetworkException
ApiException
InvalidResponseException
EmptyMoviesException
AuthException
InvalidCredentialsException
DatabaseException
```

Providers handle these exceptions and expose user-friendly error messages to the UI.

---

## 📱 Application Flow

```text
Splash Screen
      ↓
Check Firebase Authentication
      ↓
 ┌───────────────┐
 │               │
Logged In     Logged Out
 │               │
 ↓               ↓
Home           Login
 │               │
 │             Sign Up
 ↓               │
Movie Discovery  │
 │               │
 ├── Categories  │
 ├── Search      │
 ├── Details     │
 └── My Lists    │
```

---

## 🗄️ Hive Data Flow

```text
Firebase User
      ↓
     UID
      ↓
Open User-Specific Hive Boxes
      ↓
 ┌──────────────┬──────────────┬──────────────┬──────────────┐
 │              │              │              │
Favourites   Watching     Want to Watch    Watched
 │              │              │              │
 └──────────────┴──────────────┴──────────────┴──────────────┘
                         ↓
                    MovieRecord
```

---

## 📄 Project Documentation

The complete project documentation is available in:

```text
docs/Reel_Project_Document.pdf
```

It includes:

* Project overview
* Application architecture
* Architecture diagrams
* Application flow
* Database design
* Technologies used
* Features
* Implementation details
* Known limitations

---

## ⚠️ Important Notes

* TMDB credentials are required to load movie data.
* Firebase must be configured before authentication features can be used.
* Firebase configuration files and API credentials are intentionally excluded from the repository.
* Hive stores movie data locally on the user's device/browser.
* Movie lists are separated using the authenticated Firebase user's UID.

---

## 👩‍💻 Project

**Reel — Movie Discovery & Tracking App**

Built as an **ITI Summer Internship 2026 Flutter Graduation Project**.
