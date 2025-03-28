# Face Detect Camera Packege

A Flutter application for real-time face detection using the device camera.

## Features
- Real-time face detection
- Camera integration for live analysis
- Smooth and optimized performance

## Getting Started

### Prerequisites
Ensure you have Flutter installed. If not, follow the [official Flutter installation guide](https://docs.flutter.dev/get-started/install).

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/face_detect_camara.git
   cd face_detect_camara
   ```

2. Install dependencies:
   ```sh
   flutter pub get
   ```

3. Run the app:
   ```sh
   flutter run
   ```

## Permissions
This app requires camera permissions. Add the following to your `AndroidManifest.xml` file:

```xml
 <uses-feature
        android:name="android.hardware.camera"
        android:required="false" />
        
    <uses-permission android:name="android.permission.CAMERA"/>
```

For iOS, add this to `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>We need access to your camera for face detection.</string>
```

## Contributing
Feel free to submit pull requests or open issues for improvements.

## License
[MIT License](LICENSE)

