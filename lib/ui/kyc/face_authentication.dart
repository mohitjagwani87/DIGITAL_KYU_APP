import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FaceAuthenticationScreen extends StatefulWidget {
  const FaceAuthenticationScreen({super.key});

  @override
  State<FaceAuthenticationScreen> createState() => _FaceAuthenticationScreenState();
}

class _FaceAuthenticationScreenState extends State<FaceAuthenticationScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _consentGiven = false;
  bool _isLoading = false;
  bool _isVerified = false;
  bool _isCaptured = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _simulateCapture() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _isCaptured = true;
    });

    // Navigate to next page after capture
    if (_isCaptured) {
      _nextPage();
    }
  }

  void _simulateVerification() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _isVerified = true;
    });

    // Navigate to success page after verification
    if (_isVerified) {
      _nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Face Authentication',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          _buildConsentPage(),
          _buildFaceCaptureInstructionsPage(),
          _buildFaceCapturePage(),
          _buildVerificationResultPage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _currentPage > 0
                  ? ElevatedButton(
                      onPressed: _previousPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                      ),
                      child: const Text('Back'),
                    )
                  : const SizedBox(width: 80),
              Text(
                'Step ${_currentPage + 1} of 4',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    if (_currentPage == 0) {
      return ElevatedButton(
        onPressed: _consentGiven ? _nextPage : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[400],
        ),
        child: const Text('Continue'),
      );
    } else if (_currentPage == 1) {
      return ElevatedButton(
        onPressed: _nextPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
          foregroundColor: Colors.white,
        ),
        child: const Text('Start Capture'),
      );
    } else if (_currentPage == 2) {
      return ElevatedButton(
        onPressed: _isCaptured ? _simulateVerification : _simulateCapture,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isCaptured ? Colors.green[600] : Colors.blue[800],
          foregroundColor: Colors.white,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(_isCaptured ? 'Verify' : 'Capture'),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[600],
          foregroundColor: Colors.white,
        ),
        child: const Text('Finish'),
      );
    }
  }

  Widget _buildConsentPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Consent for Face Authentication',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Important Information',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We need your consent to capture and process your facial data for authentication purposes.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'By providing consent, you authorize us to:',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          _buildConsentItem(
            icon: Icons.face,
            title: 'Capture your facial data',
            description: 'We will capture your facial features for authentication.',
          ),
          _buildConsentItem(
            icon: Icons.verified_user_outlined,
            title: 'Verify your identity',
            description: 'We will use your facial data to verify your identity for KYC purposes.',
          ),
          _buildConsentItem(
            icon: Icons.security_outlined,
            title: 'Secure your data',
            description: 'Your facial data will be encrypted and stored securely as per regulations.',
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Consent Declaration',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'I hereby consent to the capture and processing of my facial data for the purpose of KYC verification. I understand that my data will be handled in accordance with the privacy policy.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _consentGiven,
                      onChanged: (value) {
                        setState(() {
                          _consentGiven = value ?? false;
                        });
                      },
                      activeColor: Colors.blue[800],
                    ),
                    Expanded(
                      child: Text(
                        'I agree to the terms and provide my consent',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.blue[800],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaceCaptureInstructionsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Face Capture Instructions',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Please follow these instructions for a successful face capture:',
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInstructionItem(
                  icon: Icons.light_mode,
                  title: 'Good Lighting',
                  description: 'Ensure your face is well-lit with even lighting.',
                ),
                const SizedBox(height: 16),
                _buildInstructionItem(
                  icon: Icons.remove_red_eye,
                  title: 'Look Directly at Camera',
                  description: 'Face the camera directly with a neutral expression.',
                ),
                const SizedBox(height: 16),
                _buildInstructionItem(
                  icon: Icons.face,
                  title: 'Remove Obstructions',
                  description: 'Remove glasses, masks, or anything covering your face.',
                ),
                const SizedBox(height: 16),
                _buildInstructionItem(
                  icon: Icons.stay_current_portrait,
                  title: 'Hold Device Steady',
                  description: 'Keep your device steady during the capture process.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue.shade400, width: 2),
              ),
              child: Center(
                child: Icon(
                  Icons.face,
                  size: 100,
                  color: Colors.blue[800],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Position your face within the circle',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.blue[800],
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFaceCapturePage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _isCaptured ? Colors.green.shade400 : Colors.blue.shade400,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Colors.blue[800],
                          )
                        : Icon(
                            _isCaptured ? Icons.check_circle : Icons.face,
                            size: 120,
                            color: _isCaptured ? Colors.green[600] : Colors.blue[800],
                          ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  _isCaptured
                      ? 'Face captured successfully!'
                      : 'Position your face within the circle',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: _isCaptured ? Colors.green[700] : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isCaptured
                      ? 'Click Verify to continue'
                      : 'Click Capture when ready',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationResultPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.green[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              color: Colors.green[600],
              size: 80,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Verification Successful!',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your face authentication has been completed successfully.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildVerificationDetail(
                  title: 'Authentication Type',
                  value: 'Face Authentication',
                  icon: Icons.face,
                ),
                const Divider(),
                _buildVerificationDetail(
                  title: 'Verification ID',
                  value: 'FACE-KYC-${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8)}',
                  icon: Icons.numbers,
                ),
                const Divider(),
                _buildVerificationDetail(
                  title: 'Timestamp',
                  value: DateTime.now().toString().substring(0, 16),
                  icon: Icons.access_time,
                ),
                const Divider(),
                _buildVerificationDetail(
                  title: 'Status',
                  value: 'Verified',
                  icon: Icons.verified,
                  valueColor: Colors.green[700],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: Colors.blue[800],
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'What happens next?',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Your KYC verification is now complete. You can proceed with using our services. A confirmation email has been sent to your registered email address.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationDetail({
    required String title,
    required String value,
    required IconData icon,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}