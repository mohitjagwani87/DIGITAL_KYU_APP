import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kycapp/ui/verification_done.dart';
import 'package:pinput/pinput.dart';

class Otppage extends StatefulWidget {
  final String mobileNumber;
  final String verificationId;

  const Otppage({
    super.key,
    required this.mobileNumber,
    required this.verificationId,
  });

  @override
  OtppageState createState() => OtppageState();
}

class OtppageState extends State<Otppage> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  // Function to verify OTP
  void _verifyOTP() async {
    if (otpController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter OTP")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Test mode verification
      if (widget.verificationId == "test_mode" &&
          otpController.text.trim() == "123456") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => VerificationDonePage()),
          (route) => false,
        );
        return;
      }

      // Regular Firebase flow
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpController.text.trim(),
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      if (userCredential.user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => VerificationDonePage()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid OTP. Try again.")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/jaadu_logo.png', height: 80),
            const SizedBox(height: 20),
            Text(
              'Verify OTP',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Enter the 6-digit OTP sent to +91 ${widget.mobileNumber}",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 30),

            // OTP Input Field (Using Pinput)
            Pinput(
              length: 6,
              controller: otpController,
              defaultPinTheme: PinTheme(
                width: 50,
                height: 50,
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Verify Button
            ElevatedButton(
              onPressed: isLoading ? null : _verifyOTP,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child:
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                        'Verify OTP',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
            ),
            const SizedBox(height: 20),

            // Resend OTP Option
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Resending OTP...")),
                );
                // Here, implement OTP resend logic
              },
              child: Text(
                "Resend OTP",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
