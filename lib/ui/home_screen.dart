import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kycapp/ui/kyc/digilocker_kyc.dart';
import 'package:kycapp/ui/kyc/document_kyc.dart';
import 'package:kycapp/ui/kyc/face_authentication.dart';
import 'package:kycapp/widget/app_cards.dart';

class KYCHomeScreen extends StatelessWidget {
  const KYCHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'KYC Services',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Digital KYC Solutions',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
              children: [
                FeatureCard(
                  icon: Icons.account_balance_wallet,
                  title: 'Digilocker KYC',
                  description: 'Verify identity via Digilocker',
                  bgColor: Colors.orange.shade50,
                  iconColor: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DigilockerKYCScreen(),
                      ),
                    );
                  },
                ),
                FeatureCard(
                  icon: Icons.document_scanner,
                  title: 'Document-based KYC',
                  description: 'Upload Aadhaar, PAN, DL, VoterID',
                  bgColor: Colors.red.shade50,
                  iconColor: Colors.red,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DocumentKYCScreen(),
                      ),
                    );
                  },
                ),
                FeatureCard(
                  icon: Icons.face,
                  title: 'Face Authentication',
                  description: 'Liveness and facematch checks',
                  bgColor: Colors.purple.shade50,
                  iconColor: Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FaceAuthenticationScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
