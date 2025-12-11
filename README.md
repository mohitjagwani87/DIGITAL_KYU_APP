# Digital KYC App

A comprehensive Flutter-based Digital Know Your Customer (KYC) application that provides three distinct methods for identity verification: Digilocker KYC, Document-based KYC, and Face Authentication.

## 📱 Overview

This application simplifies the KYC verification process by offering multiple verification methods, making it accessible and convenient for users to complete their identity verification. The app follows a step-by-step guided process for each verification method, ensuring a smooth user experience.

## Features

### 1. **Digilocker KYC**
   - **Login with Digilocker**: Secure authentication using Digilocker credentials
   - **Need Help Button**: Provides assistance and guidance
   - **Consent Declaration**: User consent for document access
   - **Document Selection**: Choose from available documents:
     - Aadhaar Card
     - PAN Card
     - Driving License
     - Voter ID
   - **Next Steps**: Clear guidance on what happens after verification

### 2. **Document-based KYC**
   - **Document Selection**: Choose from multiple document types:
     - Aadhaar Card
     - PAN Card
     - Driving License
     - Voter ID
     - Passport
   - **Document Upload**: Upload documents with clear guidelines
   - **Take Photo Button**: Capture document photos directly
   - **Upload Success**: Confirmation after successful upload
   - **KYC Email**: Automated email notifications upon successful verification

### 3. **Face Authentication**
   - **Camera Integration**: Open camera for face capture
   - **Consent & Guidelines**: Clear instructions and consent declaration
   - **Lighting Suggestions**: Tips for optimal lighting conditions
   - **Verification Successful**: Confirmation upon successful face verification

## 🏗️ Architecture

The app follows a clean architecture pattern with:

- **UI Layer**: Flutter widgets organized by feature
- **Core Services**: Business logic and API integrations
- **Widget Components**: Reusable UI components
- **State Management**: Riverpod for state management

### Project Structure

```
lib/
├── core/
│   ├── const.dart                    # Constants
│   └── services/
│       ├── deep_link_handler.dart     # Deep link handling
│       ├── digilocker_service.dart    # Digilocker integration
│       └── gstn_verification_service.dart
├── ui/
│   ├── home_screen.dart              # Main home screen
│   ├── kyc/
│   │   ├── digilocker_kyc.dart      # Digilocker KYC flow
│   │   ├── document_kyc.dart        # Document-based KYC flow
│   │   └── face_authentication.dart  # Face authentication flow
│   ├── onboarding.dart
│   ├── register_page.dart
│   ├── register_otppage.dart
│   └── verification_done.dart
├── widget/
│   ├── app_buttons.dart
│   ├── app_cards.dart
│   ├── app_form_fields.dart
│   ├── app_layouts.dart
│   ├── app_themes.dart
│   ├── comman.dart
│   └── service_app_bar.dart
└── main.dart                         # App entry point
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.7.0 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Firebase account (for authentication and backend services)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/mohitjagwani87/DIGITAL_KYU_APP.git
   cd DIGITAL_KYU_APP/kycapp/kycapp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Set up Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Download `google-services.json` for Android
   - Place it in `android/app/` directory
   - For iOS, download `GoogleService-Info.plist` and add it to `ios/Runner/`

4. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

### Core Dependencies
- `flutter_riverpod: ^2.6.1` - State management
- `firebase_core: ^3.12.1` - Firebase integration
- `firebase_auth: ^5.5.1` - Authentication
- `google_fonts: ^6.2.1` - Typography
- `file_picker: 10.0.0` - File selection
- `http: ^1.1.0` - HTTP requests
- `url_launcher: ^6.1.11` - URL launching
- `app_links: ^3.5.0` - Deep linking
- `shared_preferences: ^2.2.0` - Local storage
- `pinput: ^5.0.1` - PIN input widget

## 🔄 KYC Flows

### Digilocker KYC Flow
1. **Authentication Page**: Login with Digilocker credentials
2. **Consent Page**: Provide consent for document access
3. **Document Selection**: Choose document type
4. **Verification Result**: View verification status
   
![WhatsApp Image 2025-12-12 at 00 38 59_422bdf24](https://github.com/user-attachments/assets/06acbd76-65e6-4e7f-a3f8-38ae4a8e3f81)
![WhatsApp Image 2025-12-12 at 00 38 59_d457b4bc](https://github.com/user-attachments/assets/7c480c28-a700-49ee-a1a6-4ddb9d399c68)
![WhatsApp Image 2025-12-12 at 00 38 58_b93688f8](https://github.com/user-attachments/assets/e7768314-ac92-4f40-a594-39a5023d5e22)
![WhatsApp Image 2025-12-12 at 00 38 58_cdd58368](https://github.com/user-attachments/assets/e2662577-3d34-4ef2-bd09-e8674a3ea5e8)



### Document-based KYC Flow
1. **Document Selection**: Choose document type
2. **Upload Page**: Upload document with guidelines
3. **Verification Page**: Document verification process
4. **Result Page**: Success confirmation with email notification
   
![WhatsApp Image 2025-12-12 at 00 38 57_a99834b8](https://github.com/user-attachments/assets/379e573d-01b1-40fb-bce6-858ce8906028)
![WhatsApp Image 2025-12-12 at 00 38 57_19b270fb](https://github.com/user-attachments/assets/373ff1c2-d202-4abc-ae29-4c032a309907)
![WhatsApp Image 2025-12-12 at 00 38 56_1ef010d5](https://github.com/user-attachments/assets/533bd1f7-ef84-4f73-ab08-0434ea6a7b73)
![WhatsApp Image 2025-12-12 at 00 38 56_2eb1db6f](https://github.com/user-attachments/assets/2d69daad-e0ce-45ce-bec1-719a8d9d58bb)





### Face Authentication Flow
1. **Consent Page**: Provide consent for face capture
2. **Guidelines Page**: Instructions for face capture
3. **Capture Page**: Face capture using camera
4. **Verification Result**: Verification status

![WhatsApp Image 2025-12-12 at 00 38 56_1f2f4268](https://github.com/user-attachments/assets/1816ef85-d99a-49c6-8325-0aacc9222b6d)
![WhatsApp Image 2025-12-12 at 00 38 55_1c1b780c](https://github.com/user-attachments/assets/883c9893-1ebb-4740-a220-eab4c0a722ac)
![WhatsApp Image 2025-12-12 at 00 38 55_7562b4c0](https://github.com/user-attachments/assets/170fe2fa-bbb5-410f-a0e6-4b3eaf76db38)
![WhatsApp Image 2025-12-12 at 00 38 54_72eab6d0](https://github.com/user-attachments/assets/e5c74663-acde-4703-804c-4e245d4635df)


## 🎨 UI/UX Features

- **Material Design 3**: Modern UI following Material Design guidelines
- **Google Fonts (Poppins)**: Consistent typography throughout the app
- **Step-by-step Navigation**: Clear progress indicators
- **Responsive Design**: Works across different screen sizes
- **Loading States**: Visual feedback during async operations
- **Error Handling**: User-friendly error messages

## 🔐 Security Features

- **Firebase Authentication**: Secure user authentication
- **Consent Management**: Explicit user consent for data processing
- **Secure Data Storage**: Encrypted data storage
- **Privacy Compliance**: Adherence to data protection regulations

## 🛠️ Development

### Building for Production

**Android:**
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

### Running Tests
```bash
flutter test
```

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🔮 Future Enhancements

- [ ] Real Digilocker API integration
- [ ] OCR for document extraction
- [ ] Biometric authentication
- [ ] Multi-language support
- [ ] Offline mode support
- [ ] Advanced analytics dashboard
- [ ] Document verification API integration
- [ ] Face recognition SDK integration

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Google Fonts for typography
- All contributors and open-source libraries used in this project

