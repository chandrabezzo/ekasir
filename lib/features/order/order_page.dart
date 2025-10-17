import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../app/constant/app_colors.dart';

import 'order_controller.dart';
import '../../shared/models/product_model.dart';
import 'widgets/product_detail_modal.dart';
import 'widgets/cart_modal.dart';
import 'widgets/product_card_shimmer.dart';
import '../auth/auth_controller.dart';
import '../auth/login_page.dart';
import '../dashboard/dashboard_page.dart';

class OrderPage extends GetView<OrderController> {
  const OrderPage({super.key});

  static const String routeName = '/order';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildCategoryTabs(),
            _buildSearchBar(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
                  return _buildShimmerLoading();
                }
                return _buildProductList();
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildCartButton(),
    );
  }

  Widget _buildHeader() {
    final authController = Get.find<AuthController>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.secondarySurface, AppColors.white],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Login/Dashboard button at top right
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Obx(() {
                final isLoggedIn = authController.isLoggedIn;

                return Material(
                  color: isLoggedIn
                      ? AppColors.primarySurface
                      : AppColors.infoSurface,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      if (isLoggedIn) {
                        // Go to Dashboard
                        Get.toNamed(DashboardPage.routeName);
                      } else {
                        // Go to Login
                        Get.toNamed(LoginPage.routeName);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isLoggedIn ? Icons.dashboard : Icons.login,
                            color: isLoggedIn
                                ? AppColors.primary
                                : AppColors.info,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isLoggedIn ? 'Dashboard' : 'Login',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isLoggedIn
                                  ? AppColors.primary
                                  : AppColors.info,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 16),

          // Logo and title
          Hero(
            tag: 'cafe_logo',
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.orangeGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: const Icon(
                  Icons.local_cafe,
                  size: 50,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Kampung Kanyaah Cafe',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.restaurant_menu,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                'Food & Drinks',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          final isSelected = controller.selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _buildCategoryChip(
              label: category,
              isSelected: isSelected,
              onTap: () {
                HapticFeedback.selectionClick();
                controller.selectCategory(category);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: BoxDecoration(
              gradient: isSelected ? AppColors.purpleGradient : null,
              color: isSelected ? null : AppColors.gray50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 2 : 1.5,
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected) ...[
                    Icon(Icons.check_circle, size: 16, color: AppColors.white),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      fontSize: 13,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.white,
      child: TextField(
        onChanged: controller.search,
        decoration: InputDecoration(
          hintText: 'Cari Disini',
          prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
          filled: true,
          fillColor: AppColors.gray100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return Obx(() {
      final products = controller.filteredProducts;

      if (products.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        onRefresh: () async {
          HapticFeedback.lightImpact();
          await Future.delayed(const Duration(seconds: 1));
          // In production: await controller.refreshProducts();
        },
        color: Colors.orange,
        child: AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: _buildProductCard(product, index),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
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
              color: AppColors.secondarySurface,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 80,
              color: AppColors.secondary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Tidak ada produk',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba cari dengan kata kunci lain',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return const ProductCardShimmer();
      },
    );
  }

  Widget _buildProductCard(ProductModel product, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          _showProductDetail(product);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'product_${product.id}',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl ?? '',
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.grey[200]!, Colors.grey[100]!],
                          ),
                        ),
                        child: Icon(
                          Icons.restaurant,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.grey[200]!, Colors.grey[100]!],
                          ),
                        ),
                        child: Icon(
                          Icons.restaurant,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                          ),
                        ),
                        if (index < 2)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Favorit',
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange[700],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.description,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rp ${product.price.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[700],
                          ),
                        ),
                        Material(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              _showProductDetail(product);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.add_shopping_cart,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Pilih',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
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
        ),
      ),
    );
  }

  void _showProductDetail(ProductModel product) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(Get.context!),
        duration: const Duration(milliseconds: 300),
      ),
      builder: (context) => ProductDetailModal(product: product),
    );
  }

  Widget _buildCartButton() {
    return Obx(() {
      final itemCount = controller.cartItemCount;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: AnimatedScale(
            scale: itemCount > 0 ? 1.0 : 0.98,
            duration: const Duration(milliseconds: 200),
            child: Material(
              elevation: itemCount > 0 ? 8 : 2,
              borderRadius: BorderRadius.circular(16),
              color: itemCount > 0 ? Colors.teal : Colors.grey[400],
              child: InkWell(
                onTap: () {
                  if (itemCount > 0) {
                    HapticFeedback.mediumImpact();
                    showModalBottomSheet(
                      context: Get.context!,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      transitionAnimationController: AnimationController(
                        vsync: Navigator.of(Get.context!),
                        duration: const Duration(milliseconds: 300),
                      ),
                      builder: (context) => const CartModal(),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        itemCount > 0
                            ? Icons.shopping_cart
                            : Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        itemCount > 0 ? 'Lihat Keranjang' : 'Keranjang Kosong',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      if (itemCount > 0) ...[
                        const SizedBox(width: 12),
                        AnimatedScale(
                          scale: 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.red[400]!, Colors.red[600]!],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              itemCount.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
