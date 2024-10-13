# dubhacks-24: LunaLogs

LunaLogs is a mobile app (tested in Android, but should successfully compile in iOS) developed with Flutter and Dart. Python backend is available in repo and served as outlines but was not used in final product. LunaLogs is developed by Sulaimaan Khurrum, Brian Yu, Chi Dang, and Tamsyn Henke for DubHacks 2024.

Title track: Universal Wellness (Angelfin)

### Concept
LunaLogs is a mobile app promoting the discourse of dreams. Inspired partly by BeReal's concept, users can post once a day upon waking up. This would be set as via a native OS call when the user first awakens their phone for the day; after ~8 hours of rest. This serves as an incentive to users to have healthy sleep habits. For the next 30 minutes, users can submit a dream journal via a text editor. Once the dream has been recorded, the user can then use an array of AI tools, such as text enhancement and image generation, to spice up their posts. On the home page, users can spend some time viewing and filtering through the dreamscapes of close friends and family.

### Implementation
#### APIs
This app currently runs on two AI APIs:
- DALL-E 3 image generation via OpenAI (not free; requires API key access)
- Perplexity's LLM for text enhancement (free; requires API key access)

### Downloading

Two options are available:

#### 1. APK

- Download the `.apk` file from the root of this repository.
- Alternatively, find all relevant files under "Releases".

#### 2. Source Code
- Download/clone this repository and locally open the project in an editor/environment.
- Ensure that [Flutter is installed](https://docs.flutter.dev/get-started/install/windows/mobile).
- Navigate to the project root in your terminal.
- Run `flutter pub get`.
- Run `flutter build windows --release`. The resulting .exe should appear under `...\build\windows\x64\runner\Release` and should be runnable.

Please note that this app will not function without working API keys. These are not provided.
Feel free to contact if any issues occur.
