import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';

class AppTableDashText extends StatelessWidget {
  const AppTableDashText({super.key, this.style});

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      '—',
      style: style ??
          const TextStyle(fontSize: 13, color: AppColors.textSecondary),
    );
  }
}

class AppTableProductThumb extends StatelessWidget {
  const AppTableProductThumb({super.key, this.imageUrl, this.size = 48});

  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();
    final hasImage =
        url != null && url.isNotEmpty && url.startsWith('http');

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasImage
          ? CachedNetworkImage(imageUrl: url, fit: BoxFit.cover)
          : const Icon(
              Icons.inventory_2_outlined,
              size: 22,
              color: AppColors.textSecondary,
            ),
    );
  }
}

class AppTableVariantBadge extends StatelessWidget {
  const AppTableVariantBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class AppTableCategoryBadge extends StatelessWidget {
  const AppTableCategoryBadge({super.key, required this.name});

  final String name;

  IconData get _icon {
    final lower = name.toLowerCase();
    if (lower.contains('beverage') || lower.contains('drink')) {
      return Icons.local_cafe_outlined;
    }
    if (lower.contains('food') || lower.contains('fast')) {
      return Icons.restaurant_outlined;
    }
    if (lower.contains('retail') || lower.contains('cloth')) {
      return Icons.shopping_bag_outlined;
    }
    return Icons.category_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppTableTypeBadge extends StatelessWidget {
  const AppTableTypeBadge({super.key, required this.type});

  final String type;

  String get _label {
    if (type.isEmpty) return type;
    return type[0].toUpperCase() + type.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.info,
        ),
      ),
    );
  }
}

class AppTableStatusBadge extends StatelessWidget {
  const AppTableStatusBadge({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class AppTableActionButton extends StatelessWidget {
  const AppTableActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor = AppColors.textSecondary,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color iconColor;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.border),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 34,
            height: 34,
            child: Icon(icon, size: 16, color: iconColor),
          ),
        ),
      ),
    );
  }
}

class AppTableProductCell extends StatelessWidget {
  const AppTableProductCell({
    super.key,
    required this.name,
    required this.code,
    required this.variantLabel,
    this.imageUrl,
    this.subtitle = 'No tax',
  });

  final String name;
  final String code;
  final String variantLabel;
  final String? imageUrl;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppTableProductThumb(imageUrl: imageUrl),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    code,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '•',
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                  ),
                  AppTableVariantBadge(label: variantLabel),
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

String appTableProductCode({String? sku, required String id}) {
  if (sku != null && sku.isNotEmpty) return sku;
  final compact = id.replaceAll('-', '');
  return compact.length > 4 ? compact.substring(compact.length - 4) : compact;
}
