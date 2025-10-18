import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/constant/app_colors.dart';
import '../category_controller.dart';
import 'category_form_page.dart';

class CategoryListPage extends StatelessWidget {
  const CategoryListPage({super.key});

  static const String routeName = '/category-list';

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryManagementController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Kelola Kategori',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: () {
              HapticFeedback.lightImpact();
              categoryController.refreshCategories();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Info Banner
          _buildInfoBanner(),

          // Search Bar
          _buildSearchBar(categoryController),

          // Category List
          Expanded(
            child: Obx(() {
              if (categoryController.isLoading &&
                  categoryController.categories.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final categories = categoryController.filteredCategories;

              if (categories.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: categoryController.refreshCategories,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _buildCategoryCard(context, category, categoryController);
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.mediumImpact();
          Get.toNamed(CategoryFormPage.routeName);
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: Text(
          'Tambah Kategori',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.white],
        ),
        borderRadius: BorderRadius.circular(12),
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
            child: Icon(Icons.category, color: Colors.blue[700], size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manajemen Kategori Menu',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Kelola kategori untuk mengorganisir menu',
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

  Widget _buildSearchBar(CategoryManagementController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        onChanged: controller.searchCategories,
        decoration: InputDecoration(
          hintText: 'Cari kategori...',
          hintStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          filled: true,
          fillColor: AppColors.white,
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
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    dynamic category,
    CategoryManagementController controller,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          Get.toNamed(CategoryFormPage.routeName, arguments: category);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Category Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: category.isActive
                      ? AppColors.purpleGradient
                      : LinearGradient(
                          colors: [Colors.grey[300]!, Colors.grey[400]!],
                        ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: category.isActive
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  _getIconData(category.iconName),
                  color: AppColors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),

              // Category Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            category.name,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Active Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: category.isActive
                                ? AppColors.success.withValues(alpha: 0.1)
                                : AppColors.gray300,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            category.isActive ? 'Aktif' : 'Nonaktif',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: category.isActive
                                  ? AppColors.success
                                  : AppColors.gray600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.description,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Toggle Switch
                    Row(
                      children: [
                        Icon(
                          category.isActive
                              ? Icons.check_circle
                              : Icons.cancel,
                          size: 16,
                          color: category.isActive
                              ? AppColors.success
                              : AppColors.gray600,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          category.isActive
                              ? 'Tersedia untuk menu'
                              : 'Tidak tersedia',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: category.isActive,
                            onChanged: (_) {
                              HapticFeedback.selectionClick();
                              controller.toggleActive(category.id);
                            },
                            activeColor: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: AppColors.gray600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) async {
                  if (value == 'edit') {
                    HapticFeedback.selectionClick();
                    Get.toNamed(CategoryFormPage.routeName, arguments: category);
                  } else if (value == 'delete') {
                    HapticFeedback.mediumImpact();
                    _showDeleteDialog(context, category, controller);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(Icons.edit, size: 20, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Text('Edit', style: GoogleFonts.poppins()),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete, size: 20, color: AppColors.error),
                        const SizedBox(width: 12),
                        Text('Hapus', style: GoogleFonts.poppins()),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
            child: Icon(
              Icons.category,
              size: 80,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Belum ada kategori',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan kategori pertama Anda',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    dynamic category,
    CategoryManagementController controller,
  ) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Hapus Kategori',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apakah Anda yakin ingin menghapus kategori "${category.name}"?',
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Menu dengan kategori ini akan tetap ada',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.orange[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              Get.back();
            },
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(color: AppColors.gray600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              HapticFeedback.mediumImpact();
              Get.back();
              await controller.deleteCategory(category.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Hapus',
              style: GoogleFonts.poppins(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant;
      case 'local_cafe':
        return Icons.local_cafe;
      case 'fastfood':
        return Icons.fastfood;
      case 'cake':
        return Icons.cake;
      case 'lunch_dining':
        return Icons.lunch_dining;
      case 'local_pizza':
        return Icons.local_pizza;
      case 'icecream':
        return Icons.icecream;
      case 'coffee':
        return Icons.coffee;
      default:
        return Icons.category;
    }
  }
}
