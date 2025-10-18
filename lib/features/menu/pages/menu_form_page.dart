import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/constant/app_colors.dart';
import '../../../shared/models/product_model.dart';
import '../../../shared/widget/gradient_button.dart';
import '../menu_controller.dart' as menu_mgmt;

class MenuFormPage extends StatefulWidget {
  const MenuFormPage({super.key});

  static const String routeName = '/menu-form';

  @override
  State<MenuFormPage> createState() => _MenuFormPageState();
}

class _MenuFormPageState extends State<MenuFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();

  final menuController = Get.find<menu_mgmt.MenuManagementController>();

  String? _selectedCategory;
  bool _isAvailable = true;
  bool _isEditMode = false;
  ProductModel? _editingMenu;

  @override
  void initState() {
    super.initState();

    // Check if editing existing menu
    final menu = Get.arguments as ProductModel?;
    if (menu != null) {
      _isEditMode = true;
      _editingMenu = menu;
      _nameController.text = menu.name;
      _descriptionController.text = menu.description;
      _priceController.text = menu.price.toString();
      _imageUrlController.text = menu.imageUrl ?? '';
      _selectedCategory = menu.category;
      _isAvailable = menu.isAvailable;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        Get.snackbar(
          'Peringatan',
          'Pilih kategori menu',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.warning,
          colorText: AppColors.white,
        );
        return;
      }

      HapticFeedback.mediumImpact();

      final menu = ProductModel(
        id: _isEditMode
            ? _editingMenu!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        imageUrl: _imageUrlController.text.isEmpty
            ? null
            : _imageUrlController.text,
        category: _selectedCategory!,
        isAvailable: _isAvailable,
      );

      bool success;
      if (_isEditMode) {
        success = await menuController.updateMenu(menu);
      } else {
        success = await menuController.addMenu(menu);
      }

      if (success) {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Menu' : 'Tambah Menu',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            HapticFeedback.selectionClick();
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Info
              _buildHeaderInfo(),
              const SizedBox(height: 24),

              // Form Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Field
                    _buildLabel('Nama Menu'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: _buildInputDecoration(
                        hint: 'Contoh: Nasi Goreng Spesial',
                        prefixIcon: Icons.restaurant_menu,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama menu tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Description Field
                    _buildLabel('Deskripsi'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: _buildInputDecoration(
                        hint: 'Deskripsi menu',
                        prefixIcon: Icons.description,
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Deskripsi tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Price Field
                    _buildLabel('Harga'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _priceController,
                      decoration: _buildInputDecoration(
                        hint: '25000',
                        prefixIcon: Icons.payments,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harga tidak boleh kosong';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Harga harus berupa angka';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Harga harus lebih dari 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Category Dropdown
                    _buildLabel('Kategori'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.gray100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          isExpanded: true,
                          hint: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.category,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Pilih kategori...',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.gray600,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(12),
                          items: menuController.categories
                              .where((cat) => cat != 'all')
                              .map((category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.category,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      category,
                                      style: GoogleFonts.poppins(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Image URL Field
                    _buildLabel('URL Gambar (opsional)'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: _buildInputDecoration(
                        hint: 'https://example.com/image.jpg',
                        prefixIcon: Icons.image,
                      ),
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 20),

                    // Availability Switch
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.gray100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isAvailable
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: _isAvailable
                                ? AppColors.success
                                : AppColors.gray600,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ketersediaan',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  _isAvailable ? 'Tersedia' : 'Tidak Tersedia',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _isAvailable,
                            onChanged: (value) {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _isAvailable = value;
                              });
                            },
                            activeColor: AppColors.success,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              Obx(() {
                return GradientButton(
                  label: _isEditMode ? 'Simpan Perubahan' : 'Tambah Menu',
                  icon: _isEditMode ? Icons.save : Icons.add,
                  onPressed: _handleSubmit,
                  gradient: AppColors.purpleGradient,
                  isLoading: menuController.isLoading,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.white],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _isEditMode ? Icons.edit : Icons.add_circle,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditMode ? 'Edit Menu' : 'Tambah Menu Baru',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _isEditMode
                      ? 'Perbarui informasi menu'
                      : 'Lengkapi form di bawah untuk menambah menu',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
      prefixIcon: Icon(prefixIcon, color: AppColors.primary),
      filled: true,
      fillColor: AppColors.gray100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
    );
  }
}
