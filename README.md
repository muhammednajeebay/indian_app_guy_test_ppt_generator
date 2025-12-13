# MagicSlides PPT Generator

A Flutter application that allows users to generate PowerPoint presentations from topics using the MagicSlides API. The app includes authentication, presentation customization, and PDF preview/download capabilities.

## 🚀 How to Run

### Prerequisites
- Flutter SDK installed
- Android Studio or VS Code configured
- Connected Android device or Emulator

### Installation & Execution
1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    cd indian_app_guy_test_ppt_generator
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the application**:
    ```bash
    flutter run
    ```

4.  **Build Release APK**:
    ```bash
    flutter build apk --release
    ```

## 🗄️ Database Used

This project uses **Supabase** as the primary backend database.

*   **Authentication**: Supabase Auth handles user registration, login, and session management.
*   **User Data**: User profiles and metadata are stored in Supabase tables.
*   **Local Storage**: `flutter_secure_storage` and `shared_preferences` are used for persisting session tokens and local app preferences.

## 🏗️ Architecture

The application follows **Clean Architecture** principles to ensure separation of concerns, testability, and scalability. It utilizes the **BLoC (Business Logic Component)** pattern for state management.

### Layers
1.  **Presentation Layer** (`lib/presentation/`):
    *   Contains UI components (Screens, Widgets).
    *   Manages State using **BLoCs** (AuthBloc, PresentationBloc).
    *   Handles user events and renders states.

2.  **Domain Layer** (`lib/domain/`):
    *   The core business logic.
    *   Contains **Entities** (Immutable business objects).
    *   Defines **Repository Interfaces** (Contracts for data operations).
    *   Independent of external libraries and implementation details.

3.  **Data Layer** (`lib/data/`):
    *   Handles data retrieval and storage.
    *   **Models**: DTOs (Data Transfer Objects) that parse JSON.
    *   **Repositories**: Implement domain interfaces and coordinate data sources.
    *   **Data Sources**: Interact with external APIs (MagicSlides), Supabase, and local storage.

### Data Flow
```
User Input -> BLoC -> Repository impl -> Remote/Local DataSource -> API/DB
UI <- State <- BLoC <- Entity <- Repository Interface <- Model
```

## ⚠️ Known Issues

*   **PDF Preview**: The in-app PDF previewer (`flutter_pdfview`) may encounter rendering issues on certain device models or emulators.
*   **Performance**: Generating large presentations with high slide counts or AI images may take significant time depending on network speed and API processing.
*   **Templates**: Some requested template configurations might not be fully supported by the underlying API endpoint, defaulting to standard layouts.
*   **Internet Dependency**: The core functionality requires an active internet connection; offline mode is currently limited.
