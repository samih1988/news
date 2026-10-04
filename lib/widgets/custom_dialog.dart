import 'package:flutter/material.dart';

/// أنواع الأزرار المتاحة
enum AppButtonType { elevated, text, outlined }

class CustomDialog extends StatelessWidget {
  final String? title;
  final String? bodyText;
  final Widget? customBody;
  final IconData? icon;

  final String? confirmText;
  final VoidCallback? onConfirm;
  final AppButtonType confirmButtonType;

  final String? cancelText;
  final VoidCallback? onCancel;
  final AppButtonType cancelButtonType;

  final bool isLoading;
  final String loadingText;

  final Color? backgroundColor;
  final Color? titleColor;
  final Color? bodyColor;
  final Color? iconColor;
  final Color? confirmButtonColor;
  final Color? confirmTextColor;
  final Color? cancelButtonColor;
  final Color? cancelTextColor;
  final Color? progressIndicatorColor;
  final double borderRadius;

  const CustomDialog({
    super.key,
    this.title,
    this.bodyText,
    this.customBody,
    this.icon,
    this.confirmText,
    this.onConfirm,
    this.confirmButtonType = AppButtonType.elevated,
    this.cancelText,
    this.onCancel,
    this.cancelButtonType = AppButtonType.text,
    this.isLoading = false,
    this.loadingText = 'جاري التحميل...',
    this.backgroundColor,
    this.titleColor,
    this.bodyColor,
    this.iconColor,
    this.confirmButtonColor,
    this.confirmTextColor,
    this.cancelButtonColor,
    this.cancelTextColor,
    this.progressIndicatorColor,
    this.borderRadius = 20.0,
  });

  // ===========================================================================
  // 🚀 طرق الاستدعاء المباشرة (Static Methods) بدون showDialog
  // ===========================================================================

  /// 1. حالة التحميل (Loading)
  static void showLoading(
    BuildContext context, {
    String text = 'جاري التحميل...',
    Color? progressColor,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomDialog(
        isLoading: true,
        loadingText: text,
        progressIndicatorColor: progressColor,
      ),
    );
  }

  /// 2. حالة (Title + Body + اتنين أزرار)
  static void showTwoButtons({
    required BuildContext context,
    String? title,
    required String body,
    IconData? icon,
    Color? iconColor,
    required String confirmText,
    required VoidCallback onConfirm,
    AppButtonType confirmType = AppButtonType.elevated,
    Color? confirmColor,
    required String cancelText,
    required VoidCallback onCancel,
    AppButtonType cancelType = AppButtonType.text,
    Color? cancelColor,
  }) {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: title,
        bodyText: body,
        icon: icon,
        iconColor: iconColor,
        confirmText: confirmText,
        onConfirm: onConfirm,
        confirmButtonType: confirmType,
        confirmButtonColor: confirmColor,
        cancelText: cancelText,
        onCancel: onCancel,
        cancelButtonType: cancelType,
        cancelButtonColor: cancelColor,
      ),
    );
  }

  /// 3. حالة (Title + Body + زرار واحد فقط)
  static void showOneButton({
    required BuildContext context,
    String? title,
    required String body,
    IconData? icon,
    Color? iconColor,
    required String buttonText,
    VoidCallback? onTap,
    AppButtonType buttonType = AppButtonType.elevated,
    Color? buttonColor,
  }) {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: title,
        bodyText: body,
        icon: icon,
        iconColor: iconColor,
        confirmText: buttonText,
        confirmButtonType: buttonType,
        confirmButtonColor: buttonColor,
        onConfirm: () {
          Navigator.of(context).pop();
          if (onTap != null) onTap();
        },
      ),
    );
  }

  /// 4. حالة محتوى مخصص (Custom Body + أزرار)
  static void showCustom({
    required BuildContext context,
    String? title,
    required Widget body,
    String? confirmText,
    VoidCallback? onConfirm,
    AppButtonType confirmType = AppButtonType.elevated,
    String? cancelText,
    VoidCallback? onCancel,
    AppButtonType cancelType = AppButtonType.text,
  }) {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: title,
        customBody: body,
        confirmText: confirmText,
        onConfirm: onConfirm,
        confirmButtonType: confirmType,
        cancelText: cancelText,
        onCancel: onCancel,
        cancelButtonType: cancelType,
      ),
    );
  }

  // ===========================================================================
  // 🎨 بناء التصميم (Build Logic)
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: backgroundColor ?? theme.dialogBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      contentPadding: const EdgeInsets.all(24),
      content: isLoading
          ? _buildLoadingContent(theme)
          : _buildStandardContent(context, theme),
    );
  }

  Widget _buildLoadingContent(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(
          valueColor: progressIndicatorColor != null
              ? AlwaysStoppedAnimation<Color>(progressIndicatorColor!)
              : null,
        ),
        const SizedBox(width: 20),
        Flexible(
          child: Text(
            loadingText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: bodyColor ?? theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStandardContent(BuildContext context, ThemeData theme) {
    final hasCancelButton = cancelText != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: .start,
      children: [
        if (icon != null) ...[
          Align(
            alignment: Alignment.center,
            child: Icon(icon, size: 48, color: iconColor ?? theme.primaryColor),
          ),
          const SizedBox(height: 16),
        ],
        if (title != null) ...[
          Text(
            title!,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: titleColor ?? theme.textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (customBody != null)
          customBody!
        else if (bodyText != null)
          Text(
            bodyText!,
            style: TextStyle(
              fontSize: 14,
              color: bodyColor ?? theme.textTheme.bodyMedium?.color,
            ),
          ),
        if (confirmText != null || cancelText != null) ...[
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (hasCancelButton) ...[
                Expanded(
                  child: _buildButton(
                    type: cancelButtonType,
                    text: cancelText!,
                    onPressed: onCancel ?? () => Navigator.of(context).pop(),
                    bgColor: cancelButtonColor,
                    textColor: cancelTextColor ?? Colors.grey[700],
                    defaultBgColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(width: 12),
              ],
              if (confirmText != null)
                Expanded(
                  child: _buildButton(
                    type: confirmButtonType,
                    text: confirmText!,
                    onPressed: () {
                      if (onConfirm != null) {
                        onConfirm!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    bgColor: confirmButtonColor,
                    textColor: confirmTextColor,
                    defaultBgColor: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildButton({
    required AppButtonType type,
    required String text,
    required VoidCallback onPressed,
    Color? bgColor,
    Color? textColor,
    Color? defaultBgColor,
  }) {
    final effectiveBgColor = bgColor ?? defaultBgColor;

    switch (type) {
      case AppButtonType.elevated:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveBgColor,
            foregroundColor: textColor ?? Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          child: Text(text),
        );

      case AppButtonType.text:
        return TextButton(
          style: TextButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: textColor ?? effectiveBgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          child: Text(text),
        );

      case AppButtonType.outlined:
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? effectiveBgColor,
            side: BorderSide(color: effectiveBgColor ?? Colors.grey),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          child: Text(text),
        );
    }
  }
}
