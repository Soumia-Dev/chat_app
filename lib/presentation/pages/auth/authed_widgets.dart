import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/colors_const.dart';
import '../../../l10n/app_localizations.dart';

class AuthedWidgets {
  static backgroundPage(bool isDark) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          ColorsConst.primaryColor.withOpacity(0.1),
          ColorsConst.primaryColor,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  static circleTop({required bool isDark}) {
    return Positioned(
      top: -50,
      left: -100,
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? ColorsConst.primaryColor.withOpacity(0.3)
              : ColorsConst.accentColor.withOpacity(0.5),
        ),
      ),
    );
  }

  static circleDown({required bool isDark}) {
    return Positioned(
      bottom: -50,
      right: -50,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? ColorsConst.primaryColor.withOpacity(0.3)
              : ColorsConst.accentColor.withOpacity(0.5),
        ),
      ),
    );
  }

  static backdropFilter() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
      child: Container(color: Colors.transparent),
    );
  }

  static topTitle({required String title}) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
    );
  }

  static textFormField({
    required String type,
    required String typeInLang,
    required IconData icon,
    required TextEditingController controller,
    TextEditingController? passwordController,
    required BuildContext context,
  }) {
    bool isObscurePassword = true;
    return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          controller: controller,
          keyboardType: (type == 'email') ? TextInputType.emailAddress : null,
          obscureText: type == 'confirmPassword'
              ? true
              : type == 'password'
              ? isObscurePassword
                    ? true
                    : false
              : false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '${AppLocalizations.of(context)!.pleaseEnterYour} $typeInLang';
            } else if (type == 'email') {
              String pattern = r'^[^@]+@[^@]+\.[^@]+$';
              RegExp regex = RegExp(pattern);
              if (!regex.hasMatch(value)) {
                return AppLocalizations.of(context)!.invalidEmail;
              }
            } else if ((type == 'password' || type == 'confirmPassword') &&
                value.length < 6) {
              return AppLocalizations.of(context)!.yourPassIsShort;
            } else if (type == 'confirmPassword' &&
                passwordController != null &&
                value != passwordController.text) {
              return AppLocalizations.of(context)!.passwordsDoNotMatch;
            }
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            suffixIcon: type == 'password'
                ? IconButton(
                    icon: Icon(
                      isObscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isObscurePassword = !isObscurePassword;
                      });
                    },
                  )
                : null,
            hintText: typeInLang,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(
                color: ColorsConst.secondaryColor,
                width: 2,
              ),
            ),
          ),
        );
      },
    );
  }

  static subTitle({
    required String subTitle,
    required String richText,
    required bool isDark,
    required Function() function,
    required BuildContext context,
  }) {
    return Text.rich(
      TextSpan(
        text: subTitle,
        style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
        children: [
          TextSpan(
            text: ' $richText',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? ColorsConst.simpleColor
                  : ColorsConst.secondaryColor,
            ),
            recognizer: TapGestureRecognizer()..onTap = function,
          ),
        ],
      ),
    );
  }

  static forgetPass({
    required TextEditingController email,
    required BuildContext context,
    required Function() function,
  }) {
    return Align(
      alignment: Localizations.localeOf(context).languageCode == 'ar'
          ? Alignment.topLeft
          : Alignment.topRight,
      child: TextButton(
        onPressed: function,
        child: Text(
          AppLocalizations.of(context)!.forgetPassword,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  static submitButton({
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 55),
          backgroundColor: isDark
              ? ColorsConst.backgroundLight
              : ColorsConst.backgroundDark,
          foregroundColor: isDark ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 10,
        ),
        onPressed: onTap,
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

  static divider({required String signUp}) {
    return Row(
      children: [
        const Expanded(child: Divider(endIndent: 15)),
        Text(signUp, style: const TextStyle(fontSize: 16)),
        const Expanded(child: Divider(indent: 15)),
      ],
    );
  }

  static snackBar({
    required String content,
    required BuildContext context,
    int duration = 2,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(seconds: duration),
      ),
    );
  }

  //-----------------choose authed page
  static topIcon(bool isDark) {
    return SizedBox(
      height: 150,
      width: 150,

      child: Padding(
        padding: EdgeInsets.all(10),
        child: Image.asset('assets/logo.png', fit: BoxFit.cover),
      ),
    );
  }

  static appTitle(bool isDark, BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.appName,
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: [
                  ColorsConst.primaryColor,
                  ColorsConst.accentColor,
                  isDark ? Colors.white : Colors.black,
                ],
              ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          AppLocalizations.of(context)!.subTitle,
          style: TextStyle(
            fontSize: 16,
            color: isDark
                ? ColorsConst.backgroundLight
                : ColorsConst.backgroundDark,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  static joinTitle(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.joinUs,
      style: TextStyle(
        fontSize: 44,
        fontWeight: FontWeight.w900,
        color: ColorsConst.backgroundLight,
        shadows: [
          Shadow(
            color: ColorsConst.primaryColor.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(2, 2),
          ),
        ],
      ),
    );
  }
}
