# MagicSlides Flutter App

A Flutter application that generates PowerPoint presentations from topics using the MagicSlides API.

## Features

- **Authentication**: Secure Signup and Login via Supabase.
- **Presentation Generation**: 
  - Generate PPTs from any topic.
  - Customize slide count, language, and templates.
  - AI Image generation options.
- **PDF Preview & Download**: View and download your presentations directly on your device.
- **Modern UI**: Clean design with animated loading states and error handling.

## Getting Started

### Prerequisites

- Flutter SDK 
- Android Studio / Xcode/VSCode
- A MagicSlides API Key
- A Supabase Project

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/yourusername/magicslides-flutter.git
    cd magicslides-flutter
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Configuration**:
    - Update `lib/core/constants/api_constants.dart` (or similar config) with your API keys if not using `.env`.
4.  **Run the App**:
    ```bash
    flutter run
    ```

## Architecture

This project follows **Clean Architecture** with **BLoC** pattern.

- `lib/presentation`: UI, BLoCs, Widgets.
- `lib/domain`: Entities, Use Cases, Repository Interfaces.
- `lib/data`: Models, Data Sources, Repository Implementations.

## Testing

Run unit and widget tests:

```bash
flutter test
```

## Report

For a detailed overview of the project status and architecture, see [repot_and_overview.md](repot_and_overview.md).
