# Music Application

This project is a **Flutter** based music application designed to play audio, display playlists, and show song lyrics with state management using the **BLoC** pattern. The application includes three main screens: Home Screen, Current Music Screen, and a Tab-based screen for **Up Next** and **Lyrics**.

## Flutter Version and Environment

- **Flutter version**: 3.19.5 (Stable channel)
- **Dart version**: 3.3.3
- **Gradle version**: 8.13
- **Android Studio**: Pixel 9 Pro (Android 16.0, x86_64)
- **Operating System**: Windows 11

## How to Run the Project

To run this project, you need to set up an emulator or connect a physical device. I recommend using **Pixel 9 Pro** in Android Studio in **debug mode**.

Steps:

1. Open Android Studio.
2. Select **Pixel 9 Pro** in the device list.
3. Run the project in **debug mode**.

## Project Structure

 I have separated the code into distinct modules for better maintainability and readability. Here's the folder structure:

    lib/
    ├── views/          # Contains UI screens
    ├── bloc/           # Contains business logic (BLoC pattern)
    ├── repository/     # Manages data sources and API calls
    └── models/         # Contains data models

### Modules and Packages

- **`just_audio: ^0.9.46`**: This is the primary package for handling audio playback in this project. You can add it by running `flutter pub add just_audio`.
- For other dependencies, please check `pubspec.yaml`.

## State Management

The application uses the **BLoC** (Business Logic Component) pattern for state management. The following screens are implemented:

### Screens

1. **Home Screen**:  
   - Displays a list of available music tracks (playlists).
   - When the user taps on a song, a music bar appears at the bottom of the screen showing the current song.
  
2. **Current Music Screen**:  
   - Displays information about the currently playing song.
   - The user can **play**, **stop**, **skip to the next song**, or **go back to the previous song**.
   - When the user taps on the **Lyrics** or **Up Next** bar, it switches to the respective screen.

3. **Tab-based Screen for Lyrics and Up Next**:  
   - Displays the current song at the top of the screen.
   - Two tabs are provided:
     - **Up Next**: Displays the next music in the playlist and allows the user to skip to the next track.
     - **Lyrics**: Displays lyrics for the current song (set as example text for now).

### Notes

- **Recommended Device**: I suggest testing the application on the **Pixel 9 Pro** emulator.

## Additional Information

For a detailed list of the packages used in this project, please refer to the `pubspec.yaml` file.
