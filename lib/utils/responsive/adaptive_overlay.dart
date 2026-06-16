import 'package:flutter/material.dart';

import 'responsive.dart';

typedef AdaptiveOverlayBuilder = Widget Function(BuildContext context);

/// Shows a bottom sheet on phone (and tablet by default) or a dialog on desktop.
///
/// ```dart
/// await AdaptiveOverlay.show<void>(
///   context: context,
///   builder: (ctx) => MyFormWidget(),
/// );
/// ```
abstract final class AdaptiveOverlay {
  static Future<T?> show<T>({
    required BuildContext context,
    required AdaptiveOverlayBuilder builder,
    bool? forceBottomSheetOnTablet,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useRootNavigator = true,
    bool isScrollControlled = true,
    Color? barrierColor,
    Color? backgroundColor,
    ShapeBorder? shape,
    EdgeInsets? dialogInsetPadding,
    double dialogMaxWidth = 560,
    double dialogMaxHeightFactor = 0.9,
  }) {
    final useBottomSheet = Responsive.isMobile(context) ||
        (Responsive.isTablet(context) && (forceBottomSheetOnTablet ?? true));

    if (useBottomSheet) {
      return showModalBottomSheet<T>(
        context: context,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        useRootNavigator: useRootNavigator,
        isScrollControlled: isScrollControlled,
        barrierColor: barrierColor,
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
        shape: shape ??
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
        builder: builder,
      );
    }

    return showDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      useRootNavigator: useRootNavigator,
      barrierColor: barrierColor,
      builder: (dialogContext) {
        final screenHeight = MediaQuery.sizeOf(dialogContext).height;

        return Dialog(
          insetPadding: dialogInsetPadding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          backgroundColor:
              backgroundColor ?? Theme.of(dialogContext).colorScheme.surface,
          shape: shape ??
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: dialogMaxWidth,
              maxHeight: screenHeight * dialogMaxHeightFactor,
            ),
            child: builder(dialogContext),
          ),
        );
      },
    );
  }
}
