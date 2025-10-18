import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../auth/auth_controller.dart';

class QrGeneratePage extends StatefulWidget {
  const QrGeneratePage({super.key});

  static const String routeName = '/qr/generate';

  @override
  State<QrGeneratePage> createState() => _QrGeneratePageState();
}

class _QrGeneratePageState extends State<QrGeneratePage> {
  // Base URL for self-service
  final String baseUrl = 'https://self-service.kasair.id/';
  final _authController = Get.find<AuthController>();

  // Selected values
  String? _selectedOutlet;
  String? _selectedTable;

  // Mock data - In production, fetch from API or database
  final List<Map<String, String>> _allOutlets = [
    {'id': '3307', 'name': 'Outlet 1 - Main Branch'},
    {'id': '3308', 'name': 'Outlet 2 - Downtown'},
    {'id': '3309', 'name': 'Outlet 3 - Mall'},
    {'id': '3310', 'name': 'Outlet 4 - Airport'},
  ];

  // Get outlets accessible to current user
  List<Map<String, String>> get _outlets {
    final user = _authController.currentUser;
    if (user == null) return [];
    
    // Filter outlets based on user access
    return _allOutlets.where((outlet) {
      return user.hasAccessToOutlet(outlet['id']!);
    }).toList();
  }

  final List<Map<String, String>> _tables = [
    {'id': '3486', 'name': 'Table 1'},
    {'id': '3487', 'name': 'Table 2'},
    {'id': '3488', 'name': 'Table 3'},
    {'id': '3489', 'name': 'Table 4'},
    {'id': '3490', 'name': 'Table 5'},
    {'id': '3491', 'name': 'Table 6'},
    {'id': '3492', 'name': 'Table 7'},
    {'id': '3493', 'name': 'Table 8'},
  ];

  String _generateUrl() {
    if (_selectedOutlet == null || _selectedTable == null) {
      return '';
    }
    return '$baseUrl?outlet=$_selectedOutlet&table=$_selectedTable';
  }

  bool get _canGenerateQr => _selectedOutlet != null && _selectedTable != null;

  @override
  void initState() {
    super.initState();
    // Auto-select outlet if user has access to only one
    if (_outlets.length == 1) {
      _selectedOutlet = _outlets[0]['id'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayUrl = _generateUrl();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'QR Code Generator',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            HapticFeedback.selectionClick();
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Info Card
            _buildInfoCard(),
            const SizedBox(height: 24),

            // Outlet Access Info (for restricted users)
            if (_authController.currentUser?.outletIds.isNotEmpty ?? false)
              _buildOutletAccessInfo(),
            if (_authController.currentUser?.outletIds.isNotEmpty ?? false)
              const SizedBox(height: 24),

            // Selection Form
            _buildSelectionForm(),
            const SizedBox(height: 24),

            // QR Code Display (only show if outlet and table are selected)
            if (_canGenerateQr) ...[
              _buildQrCodeCard(displayUrl),
              const SizedBox(height: 24),

              // URL Display
              _buildUrlDisplay(displayUrl),
              const SizedBox(height: 24),
            ] else
              _buildPlaceholder(),

            const SizedBox(height: 24),

            // Instructions
            _buildInstructions(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.purple[50]!, Colors.white]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple[100]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.qr_code_2, color: Colors.purple[700], size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'QR Code Self-Service',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pilih outlet dan meja untuk generate QR Code',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutletAccessInfo() {
    final user = _authController.currentUser;
    if (user == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue[50]!, Colors.white]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.store, color: Colors.blue[700], size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Akses Outlet Terbatas',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.outletName ?? 'Anda hanya dapat mengakses outlet tertentu',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCodeCard(String data) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // QR Code
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!, width: 2),
            ),
            child: QrImageView(
              data: data,
              version: QrVersions.auto,
              size: 280.0,
              backgroundColor: Colors.white,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
              embeddedImage: const AssetImage('assets/images/logo.png'),
              embeddedImageStyle: const QrEmbeddedImageStyle(
                size: Size(40, 40),
              ),
              eyeStyle: QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Colors.purple[700],
              ),
              dataModuleStyle: QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Download/Share Buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  label: 'Download',
                  icon: Icons.download,
                  color: Colors.blue,
                  onTap: _downloadQrCode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  label: 'Share',
                  icon: Icons.share,
                  color: Colors.green,
                  onTap: _shareQrCode,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings, color: Colors.purple[700], size: 22),
              const SizedBox(width: 8),
              Text(
                'Konfigurasi QR Code',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Outlet Dropdown
          Text(
            'Pilih Outlet',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedOutlet,
                isExpanded: true,
                hint: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Pilih outlet...',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                icon: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                ),
                borderRadius: BorderRadius.circular(12),
                items: _outlets.map((outlet) {
                  return DropdownMenuItem<String>(
                    value: outlet['id'],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        outlet['name']!,
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedOutlet = value;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Table Dropdown
          Text(
            'Pilih Meja',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedTable,
                isExpanded: true,
                hint: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Pilih meja...',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                icon: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                ),
                borderRadius: BorderRadius.circular(12),
                items: _tables.map((table) {
                  return DropdownMenuItem<String>(
                    value: table['id'],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        table['name']!,
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedTable = value;
                  });
                },
              ),
            ),
          ),

          // Reset Button
          if (_canGenerateQr) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedOutlet = null;
                    _selectedTable = null;
                  });
                },
                icon: const Icon(Icons.refresh),
                label: Text(
                  'Reset Pilihan',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.purple[700],
                  side: BorderSide(color: Colors.purple[300]!),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.qr_code_2, size: 80, color: Colors.grey[400]),
          ),
          const SizedBox(height: 20),
          Text(
            'Pilih Outlet dan Meja',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'QR Code akan ditampilkan setelah\nAnda memilih outlet dan meja',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildUrlDisplay(String url) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(Icons.link, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              url,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[800]),
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy, color: Colors.purple[700]),
            onPressed: () {
              HapticFeedback.mediumImpact();
              Clipboard.setData(ClipboardData(text: url));
              Get.snackbar(
                'Copied',
                'URL disalin ke clipboard',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.orange[700]),
              const SizedBox(width: 8),
              Text(
                'Cara Menggunakan',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInstructionItem(
            '1',
            'Pilih Outlet & Meja',
            'Pilih outlet dan nomor meja di form',
          ),
          const SizedBox(height: 12),
          _buildInstructionItem(
            '2',
            'Generate QR Code',
            'QR Code akan otomatis dibuat',
          ),
          const SizedBox(height: 12),
          _buildInstructionItem(
            '3',
            'Download & Print',
            'Download dan print QR code',
          ),
          const SizedBox(height: 12),
          _buildInstructionItem(
            '4',
            'Pasang di Meja',
            'Tempelkan QR di meja yang sesuai',
          ),
          const SizedBox(height: 12),
          _buildInstructionItem(
            '5',
            'Customer Self-Service',
            'Pelanggan scan untuk akses menu',
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(
    String number,
    String title,
    String description,
  ) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple[400]!, Colors.purple[600]!],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color),
        ),
        child: InkWell(
          onTap: () {
            HapticFeedback.mediumImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _downloadQrCode() {
    // In production, implement actual download functionality
    // Use packages like path_provider and image to save QR code
    Get.snackbar(
      'Download',
      'Fitur download akan diimplementasikan',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _shareQrCode() {
    // In production, implement actual share functionality
    // Use share_plus package to share QR code image
    Get.snackbar(
      'Share',
      'Fitur share akan diimplementasikan',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
