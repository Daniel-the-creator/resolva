/// Responsive breakpoints and helper constants for RESOLVA.
class AppConstants {
  AppConstants._();

  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Max content width
  static const double maxContentWidth = 1280;
  static const double maxFormWidth = 480;

  // Spacing scale
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacing2xl = 48;
  static const double spacing3xl = 64;
  static const double spacing4xl = 96;

  // Border radius
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radiusFull = 999;

  // Icon sizes
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 32;

  // Dashboard sidebar width
  static const double sidebarWidth = 280;
  static const double sidebarCollapsedWidth = 72;

  // Legal policy versions
  static const String termsVersion = '1.0.0';
  static const String privacyVersion = '1.0.0';
}

/// Helper to determine responsive layout type.
enum ScreenType { mobile, tablet, desktop }

ScreenType getScreenType(double width) {
  if (width < AppConstants.mobileBreakpoint) return ScreenType.mobile;
  if (width < AppConstants.desktopBreakpoint) return ScreenType.tablet;
  return ScreenType.desktop;
}

bool isMobile(double width) => width < AppConstants.mobileBreakpoint;
bool isTablet(double width) =>
    width >= AppConstants.mobileBreakpoint && width < AppConstants.desktopBreakpoint;
bool isDesktop(double width) => width >= AppConstants.desktopBreakpoint;
