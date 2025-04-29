# Lampsy Health - Flutter Mobile Application
Technical challenge developed by **Ing. Daniel De Faria** for **Lampsy Health**.

This project simulates the core functionalities of epilepsy monitoring devices

## 🚀 How to Run the Project

**Requirements:**

- Flutter and Dart SDK installed.

- Android Studio or Xcode with simulators/emulators properly configured.

- A working device emulator (Android/iOS) or physical device connected.

**Setup Instructions:**
1. **Clone the repository:** 
   git clone https://github.com/DeftoLabs/lampsyhealthapp

2. **Install dependencies:** flutter pub get

3. **Run the project:** 
    3.1. Open your preferred emulator.
    3.2. flutter run

**Test User Credentials:**

- Once the application is running, you can either register a new user or log in using the following test account:
    **Email: test@gmail.com**
    **Password: 123456**



📲 Alpha Version (Android & iOS)

Android:
https://play.google.com/apps/internaltest/4701689669883986335
Request to be added to the testing group via email.

iOS: Request to be added to the testing group via email.

For any questions, feel free to contact me at: daniel_defaria@yahoo.es.


🛠️ **Brief Explanation (Real-time Streaming)**
file: lib/screen/camerascreen.dart

 **VIDEO STREAMING:**

 The live video feed is handled using the `video_player` and `chewie` libraries.

 - `video_player` serves as the main engine that enables playback of video streams from a URL.
 - `chewie` acts as a presentation layer on top of `video_player`, providing a customized and user-friendly video player UI with built-in controls.

 A public `.m3u8` test stream is used to simulate real-time video playback:
 `https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8`

 The video controller (`VideoPlayerController`) is initialized inside the `initState()` method.
 Once the video is ready, it is assigned to the `ChewieController` to allow auto-play, continuous looping,
 and dynamic aspect ratio adjustment.

 A `Stack` widget is used to dynamically toggle between:
 - Displaying the video (`Chewie`)
 - Showing a black screen with the message "Privacy Mode Activated" when monitoring is turned off.

 The monitoring state (`isMonitoringActive`) is managed globally through a `Provider`,
 allowing the entire application to react consistently to changes.

 ## Future Cloud Services Integration
 ☁️**FUTURE CLOUD SERVICES INTEGRATION:**

 In this prototype version, the video stream is sourced from a public URL.
 In a real-world production scenario, cloud services would be integrated as follows:

 1. **Streaming Origin:**
    - The physical camera would send its live video feed to a cloud service.
    - Recommended services: AWS Kinesis Video Streams, AWS IVS, Google Cloud Media Streaming, or private servers using HLS protocols.

 2. **App Streaming:**
    - Instead of pointing to a hardcoded static URL, the `VideoPlayerController` would dynamically receive a secure streaming URL from the backend.
    - The backend (e.g., Lampsy Health's API) would manage the generation of access tokens or signed URLs for security.

 3. **Privacy and Security:**
    - All streams should use HTTPS encryption.
    - Streaming URLs should have short-lived expiration times.
    - End-to-end encryption should be considered for highly sensitive video streams.

 4. **Cloud Integration Points in Code:**
    - During screen initialization (`initState()`), instead of using a fixed URL, an API request would be made to the backend to retrieve the live stream URL.
    - Example: Making an HTTP GET request to an endpoint that returns a valid streaming URL.

 5. **Network Error Handling:**
    - Add detection for stream disconnections or expiration.
    - Display appropriate messages such as "Stream unavailable" if a connection issue occurs.

 This approach would allow the app to scale to monitor multiple cameras securely, while preserving user privacy and allowing for the secure storage of recorded footage if needed.
