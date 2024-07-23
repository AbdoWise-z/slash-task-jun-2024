# Slash Task Jun 2024

This document outlines the steps to build and run the `slash-task-jun-2024` Flutter project.

## Demo
Demo of the application for the <strong>Mobile</strong> and <strong>Web</strong> versions.
<center>
<image src="images/phone_demo.gif" width="21.1%" height="100%"/>
<image src="images/web_demo.gif" width="60%" height="100%"/>
</center>
## Prerequisites

Before you begin, ensure you have the following software installed on your machine:
1. **Git** - For cloning the repository.
2. **Flutter SDK** - Ensure you have Flutter installed. Follow the instructions [here](https://flutter.dev/docs/get-started/install) to install Flutter.
3. **Android Studio or Visual Studio Code** - For Flutter development. Ensure you have the Flutter and Dart plugins installed.

## Cloning the Repository

1. Open a terminal.
2. Clone the repository:
    ```sh
    git clone https://github.com/AbdoWise-z/slash-task-jun-2024.git
    ```
3. Navigate into the project directory:
    ```sh
    cd slash-task-jun-2024
    ```

## Setting Up Flutter
1. Ensure Flutter is installed correctly by running:
    ```sh
    flutter doctor
    ```
   Address any issues that `flutter doctor` identifies.

2. Install the project dependencies:

    ```sh
    flutter pub get
    ```
   
## Running the Project

### On an Emulator
1. Ensure you have an emulator set up. You can use Android Studio to create an Android emulator.
2. Start the emulator.
3. Run the project:

    ```sh
    flutter run
    ```

### On a Physical Device
1. Connect your physical device via USB and ensure USB debugging is enabled.
2. Verify that your device is connected and recognized:
    ```sh
    flutter devices
    ```
3. Run the project:
    ```sh
    flutter run
    ```

## Additional Notes
- Ensure your development environment is properly set up for Flutter development, including any necessary device or emulator configurations.
- If you encounter any issues, check the terminal output for error messages.

## Troubleshooting

### Common Issues
1. **Dependency Issues**: Ensure all dependencies are installed correctly by running `flutter pub get`.
2. **Device Connection Issues**: Ensure your emulator or physical device is properly set up and recognized by Flutter.
3. **Build Issues**: Ensure your Flutter SDK and project dependencies are up to date by running `flutter upgrade` and `flutter pub get`.

### Getting Help
If you encounter any problems or have questions, feel free to open an issue in the [GitHub repository](https://github.com/AbdoWise-z/slash-task-jun-2024/issues).

---

This README provides the essential steps to build and run the `slash-task-jun-2024` Flutter project. For more detailed information on the project, refer to the documentation or the comments within the code.
