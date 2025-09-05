import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kycapp/ui/register_otppage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  bool _obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers to store user input
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String verificationId = "";

  @override
  void dispose() {
    mobileController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // Function to send OTP
  Future<void> _sendOTP() async {
    String mobileNumber = mobileController.text.trim();
    if (mobileNumber.isEmpty || mobileNumber.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid 10-digit mobile number")),
      );
      return;
    }

    // Test mode for specific number
    if (mobileNumber == "1234567890") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => Otppage(
                mobileNumber: mobileNumber,
                verificationId: "test_mode",
              ),
        ),
      );
      return;
    }

    // Regular Firebase flow for other numbers
    await _auth.verifyPhoneNumber(
      phoneNumber: "+91$mobileNumber",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification failed: ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId;
        });

        // Navigate to OTP Page with mobile number & verificationId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => Otppage(
                  mobileNumber: mobileNumber,
                  verificationId: verificationId,
                ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: const Duration(seconds: 60),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset('assets/images/jaadu_logo.png', height: 80),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Create an\naccount',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Sign up with',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _socialButton(
                  'Google',
                  'assets/images/Google_Icons.png',
                  () {},
                ),
                const SizedBox(width: 15),
                _socialButton(
                  'Facebook',
                  'assets/images/Facebook_Icons.png',
                  () {},
                ),
              ],
            ),
            const SizedBox(height: 30),
            _inputField(
              'Mobile Number',
              false,
              TextInputType.number,
              mobileController,
            ),
            const SizedBox(height: 15),
            _inputField(
              'Email',
              false,
              TextInputType.emailAddress,
              emailController,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _sendOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  'Register',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(
    String label,
    bool isPassword,
    TextInputType keyboardType,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscureText : false,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
                : null,
      ),
    );
  }

  Widget _socialButton(String text, String asset, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(150, 50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(asset, width: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
