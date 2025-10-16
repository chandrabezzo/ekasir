import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/app_colors.dart';

class AppStyles {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      // scaffoldBackgroundColor: AppColors.lightGreyBg100,
      brightness: Brightness.light,
      // primaryColor: AppColors.orange,
      colorScheme: ColorScheme.light(
        // primary: AppColors.orange,
        // secondary: AppColors.secondary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 51),
          // backgroundColor: AppColors.orange,
          foregroundColor: AppColors.white,
          // disabledBackgroundColor: AppColors.orange.withValues(alpha: 0.3),
          disabledForegroundColor: AppColors.white.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.inter(
            color: AppColors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          // side: BorderSide(color: AppColors.lightGreyBg100, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      radioTheme: RadioThemeData(
        // fillColor: WidgetStateProperty.resolveWith((states) {
        //   if (states.contains(WidgetState.selected)) {
        //     return AppColors.orange;
        //   } else {
        //     return AppColors.grey800;
        //   }
        // }),
      ),
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: AppColors.white,
        elevation: 0,
        titleSpacing: -12,
        // iconTheme: const IconThemeData(color: AppColors.darkGrey900, size: 16),
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.black,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        centerTitle: false,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        // color: AppColors.orange,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        // selectedIconTheme: const IconThemeData(color: AppColors.orange),
        // selectedItemColor: AppColors.orange,
        selectedLabelStyle: GoogleFonts.inter(
          // color: AppColors.orange,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        type: BottomNavigationBarType.fixed,
        // unselectedItemColor: AppColors.darkGrey900,
        // unselectedIconTheme: const IconThemeData(color: AppColors.darkGrey900),
        unselectedLabelStyle: GoogleFonts.inter(
          // color: AppColors.darkGrey900,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          // borderSide: BorderSide(color: AppColors.gray, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          // borderSide: BorderSide(color: AppColors.gray, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          // borderSide: BorderSide(color: AppColors.red, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          // borderSide: BorderSide(color: AppColors.gray, width: 1),
        ),
        hintStyle: GoogleFonts.inter(color: Colors.black.withAlpha(64)),
        // errorStyle: GoogleFonts.inter(color: AppColors.red),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          // side: BorderSide(color: AppColors.gray, width: 1),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.white,
        modalBackgroundColor: AppColors.white,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.black,
        // unselectedLabelColor: AppColors.gray,
        indicatorColor: AppColors.black,
      ),
      dividerTheme: DividerThemeData(
        // color: AppColors.lightGreyBg100,
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        padding: EdgeInsets.zero,
        showCheckmark: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        secondarySelectedColor: Colors.transparent,
        color: WidgetStateProperty.resolveWith((state) {
          if (state.contains(WidgetState.selected)) {
            return AppColors.white;
          }
          // return AppColors.lightGreyBg100;
          return null;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.resolveWith((state) {
          if (state.contains(WidgetState.selected)) {
            return AppColors.white;
          }
          return null;
        }),
        fillColor: WidgetStateProperty.resolveWith((state) {
          if (state.contains(WidgetState.selected)) {
            // return AppColors.orange;
          }
          return null;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        // side: BorderSide(color: AppColors.grey800, width: 1),
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return lightTheme(context);
  }

  static Color bottomSheetBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : Colors.white;
  }

  static Color separatorColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }
}
