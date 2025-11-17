import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/constants/colors_const.dart';
import '../../../core/constants/intro_const.dart';
import '../../../domain/entities/intro_page_entity.dart';

class IntroWidgets {
  static LinearGradient background(bool isDark) {
    return LinearGradient(
      colors: isDark
          ? [Colors.black, ColorsConst.accentColor]
          : [Colors.white, ColorsConst.accentColor],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  static PreferredSize appBar({
    required bool isDark,
    required String currentLang,
    required VoidCallback onThemeToggle,
    required Function(String) onLanguageChange,
  }) {
    final languages = IntroConst.languages();
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: onThemeToggle,
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentLang,
              items: languages
                  .map(
                    (l) => DropdownMenuItem(
                      value: l,
                      child: Text(l.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) onLanguageChange(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Page Content
  static Widget pageContent({
    required PageController controller,
    required List<IntroPageEntity> pages,
    required Function(int) onPageChange,
    required bool isDark,
  }) {
    return Expanded(
      child: PageView.builder(
        controller: controller,
        itemCount: pages.length,
        onPageChanged: onPageChange,
        itemBuilder: (context, index) {
          final page = pages[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.2),
                    boxShadow: [
                      BoxShadow(
                        color: ColorsConst.accentColor.withOpacity(0.5),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Image.asset(page.image, height: 250),
                ),
                const SizedBox(height: 20),
                Text(
                  page.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  page.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// SmoothPageIndicator
  static SmoothPageIndicator smoothPageIndicator({
    required PageController controller,
    required int length,
    required bool isDark,
  }) {
    return SmoothPageIndicator(
      controller: controller,
      count: length,
      effect: ExpandingDotsEffect(
        dotColor: ColorsConst.secondaryColor.withOpacity(0.3),
        activeDotColor: ColorsConst.secondaryColor,
        dotHeight: 10,
        dotWidth: 10,
      ),
    );
  }

  /// Button
  static Widget button({
    required bool isLastPage,
    required String label,
    required bool isDark,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 55),
          backgroundColor: ColorsConst.backgroundDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 10,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
