import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/constant/app_colors.dart';
import '../../../shared/models/category_model.dart';
import '../../../shared/widget/gradient_button.dart';
import '../category_controller.dart';

class CategoryFormPage extends StatefulWidget {
  const CategoryFormPage({super.key});

  static const String routeName = '/category-form';

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final categoryController = Get.find<CategoryManagementController>();

  String? _selectedIcon;
  bool _isActive = true;
  bool _isEditMode = false;
  CategoryModel? _editingCategory;

  // Available icons for categories
  final List<Map<String, dynamic>> _availableIcons = [
    {'name': 'restaurant', 'icon': Icons.restaurant, 'label': 'Restaurant'},
    {'name': 'local_cafe', 'icon': Icons.local_cafe, 'label': 'Cafe'},
    {'name': 'fastfood', 'icon': Icons.fastfood, 'label': 'Fast Food'},
    {'name': 'cake', 'icon': Icons.cake, 'label': 'Cake'},
    {'name': 'lunch_dining', 'icon': Icons.lunch_dining, 'label': 'Lunch'},
    {'name': 'local_pizza', 'icon': Icons.local_pizza, 'label': 'Pizza'},
    {'name': 'icecream', 'icon': Icons.icecream, 'label': 'Ice Cream'},
    {'name': 'coffee', 'icon': Icons.coffee, 'label': 'Coffee'},
  ];

  @override
  void initState() {
    super.initState();

    // Check if editing existing category
    final category = Get.arguments as CategoryModel?;
    if (category != null) {
      _isEditMode = true;
      _editingCategory = category;
      _nameController.text = category.name;
      _descriptionController.text = category.description;
      _selectedIcon = category.iconName;
      _isActive = category.isActive;
    } else {
      // Default icon for new category
      _selectedIcon = 'restaurant';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();

      final category = CategoryModel(
        id: _isEditMode
            ? _editingCategory!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        iconName: _selectedIcon,
        isActive: _isActive,
      );

      bool success;
      if (_isEditMode) {
        success = await categoryController.updateCategory(category);
      } else {
        success = await categoryController.addCategory(category);
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
          _isEditMode ? 'Edit Kategori' : 'Tambah Kategori',
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
                    _buildLabel('Nama Kategori'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: _buildInputDecoration(
                        hint: 'Contoh: Makanan Berat',
                        prefixIcon: Icons.label,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama kategori tidak boleh kosong';
                        }
                        if (value.length < 3) {
                          return 'Nama kategori minimal 3 karakter';
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
                        hint: 'Deskripsi kategori',
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

                    // Icon Selection
                    _buildLabel('Pilih Icon'),
                    const SizedBox(height: 12),
                    _buildIconSelector(),
                    const SizedBox(height: 20),

                    // Active Status Switch
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
                            _isActive ? Icons.check_circle : Icons.cancel,
                            color: _isActive
                                ? AppColors.success
                                : AppColors.gray600,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Status Kategori',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  _isActive ? 'Aktif' : 'Nonaktif',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _isActive,
                            onChanged: (value) {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _isActive = value;
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
                  label: _isEditMode ? 'Simpan Perubahan' : 'Tambah Kategori',
                  icon: _isEditMode ? Icons.save : Icons.add,
                  onPressed: _handleSubmit,
                  gradient: AppColors.purpleGradient,
                  isLoading: categoryController.isLoading,
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
                  _isEditMode ? 'Edit Kategori' : 'Tambah Kategori Baru',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _isEditMode
                      ? 'Perbarui informasi kategori'
                      : 'Buat kategori baru untuk menu Anda',
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

  Widget _buildIconSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _availableIcons.map((iconData) {
        final isSelected = _selectedIcon == iconData['name'];
        return InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() {
              _selectedIcon = iconData['name'] as String;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 70,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? AppColors.purpleGradient
                  : null,
              color: isSelected ? null : AppColors.gray100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              children: [
                Icon(
                  iconData['icon'] as IconData,
                  color: isSelected
                      ? AppColors.white
                      : AppColors.gray600,
                  size: 28,
                ),
                const SizedBox(height: 4),
                Text(
                  iconData['label'] as String,
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.white
                        : AppColors.gray600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
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
