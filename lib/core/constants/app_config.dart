/// Client-side configuration for third-party services.
///
/// Cloudinary unsigned uploads only need [cloudinaryCloudName] and
/// [cloudinaryUploadPreset] — both are safe to embed in the app.
/// Create an unsigned upload preset at https://cloudinary.com/console.
abstract final class AppConfig {
  static const String cloudinaryCloudName = 'dulianses';
  static const String cloudinaryUploadPreset = 'pos_products_preset';

  /// Dynamic folder path for product images (Cloudinary folder mode).
  static const String cloudinaryProductsFolder = 'pos_saas/products';

  /// Dynamic folder path for business logos.
  static const String cloudinaryLogosFolder = 'pos_saas/logos';
}
