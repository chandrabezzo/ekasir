import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../app/constant/app_colors.dart';
import '../menu_controller.dart' as menu_mgmt;
import '../../category/category_controller.dart';
import '../../category/pages/category_list_page.dart';
import 'menu_form_page.dart';

class MenuListPage extends StatelessWidget {
  const MenuListPage({super.key});

  static const String routeName = '/menu-list';

  @override
  Widget build(BuildContext context) {
    // Ensure category controller is initialized first
    Get.put(CategoryManagementController());
    final menuController = Get.put(menu_mgmt.MenuManagementController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Kelola Menu',
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
            icon: const Icon(Icons.category, color: Colors.blue),
            tooltip: 'Kelola Kategori',
            onPressed: () {
              HapticFeedback.lightImpact();
              Get.toNamed(CategoryListPage.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: () {
              HapticFeedback.lightImpact();
              menuController.refreshMenus();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter
          _buildSearchAndFilter(menuController),

          // Category Filter
          _buildCategoryFilter(menuController),

          // Menu List
          Expanded(
            child: Obx(() {
              if (menuController.isLoading && menuController.menus.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final menus = menuController.filteredMenus;

              if (menus.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: menuController.refreshMenus,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: menus.length,
                  itemBuilder: (context, index) {
                    final menu = menus[index];
                    return _buildMenuCard(context, menu, menuController);
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
          Get.toNamed(MenuFormPage.routeName);
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: Text(
          'Tambah Menu',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter(menu_mgmt.MenuManagementController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: controller.searchMenus,
        decoration: InputDecoration(
          hintText: 'Cari menu...',
          hintStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          filled: true,
          fillColor: AppColors.gray100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(menu_mgmt.MenuManagementController controller) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            final isSelected = controller.selectedCategory == category;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.purpleGradient : null,
                    color: isSelected ? null : AppColors.gray100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      controller.filterByCategory(category);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      child: Text(
                        category == 'all' ? 'Semua' : category,
                        style: GoogleFonts.poppins(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.textPrimary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    dynamic menu,
    menu_mgmt.MenuManagementController controller,
  ) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          Get.toNamed(MenuFormPage.routeName, arguments: menu);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Menu Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.gray100,
                  image: menu.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(menu.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: menu.imageUrl == null
                    ? const Icon(
                        Icons.restaurant_menu,
                        size: 40,
                        color: AppColors.gray400,
                      )
                    : null,
              ),
              const SizedBox(width: 16),

              // Menu Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            menu.name,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Availability Toggle
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: menu.isAvailable,
                            onChanged: (_) {
                              HapticFeedback.selectionClick();
                              controller.toggleAvailability(menu.id);
                            },
                            activeColor: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      menu.description,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            menu.category,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          currencyFormat.format(menu.price),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.warning,
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
                    Get.toNamed(MenuFormPage.routeName, arguments: menu);
                  } else if (value == 'delete') {
                    HapticFeedback.mediumImpact();
                    _showDeleteDialog(context, menu, controller);
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
              Icons.restaurant_menu,
              size: 80,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Belum ada menu',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan menu pertama Anda',
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
    dynamic menu,
    menu_mgmt.MenuManagementController controller,
  ) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Hapus Menu',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus "${menu.name}"?',
          style: GoogleFonts.poppins(),
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
              await controller.deleteMenu(menu.id);
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
}
