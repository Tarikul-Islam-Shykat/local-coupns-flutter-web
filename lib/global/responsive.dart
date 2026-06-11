import 'package:flutter/material.dart';

enum ResponsiveBreakpoint { mobile, tablet, desktop }

class ResponsiveInfo {
  const ResponsiveInfo({required this.width, required this.height});

  final double width;
  final double height;

  bool get isMobile => width < 720;

  bool get isTablet => width >= 720 && width < 1024;

  bool get isDesktop => width >= 1024;

  ResponsiveBreakpoint get breakpoint {
    if (isDesktop) return ResponsiveBreakpoint.desktop;
    if (isTablet) return ResponsiveBreakpoint.tablet;
    return ResponsiveBreakpoint.mobile;
  }

  double get horizontalPadding => switch (breakpoint) {
    ResponsiveBreakpoint.mobile => 16,
    ResponsiveBreakpoint.tablet => 24,
    ResponsiveBreakpoint.desktop => 32,
  };

  double get verticalPadding => switch (breakpoint) {
    ResponsiveBreakpoint.mobile => 20,
    ResponsiveBreakpoint.tablet => 24,
    ResponsiveBreakpoint.desktop => 32,
  };

  double get contentWidth => switch (breakpoint) {
    ResponsiveBreakpoint.mobile => width,
    ResponsiveBreakpoint.tablet => 560,
    ResponsiveBreakpoint.desktop => 1180,
  };

  double get gap => switch (breakpoint) {
    ResponsiveBreakpoint.mobile => 12,
    ResponsiveBreakpoint.tablet => 16,
    ResponsiveBreakpoint.desktop => 24,
  };

  T value<T>({required T mobile, T? tablet, T? desktop}) {
    switch (breakpoint) {
      case ResponsiveBreakpoint.mobile:
        return mobile;
      case ResponsiveBreakpoint.tablet:
        return tablet ?? mobile;
      case ResponsiveBreakpoint.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key, required this.builder});

  final Widget Function(BuildContext context, ResponsiveInfo info) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaSize = MediaQuery.sizeOf(context);
        final width = constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : mediaSize.width;

        return builder(
          context,
          ResponsiveInfo(width: width, height: mediaSize.height),
        );
      },
    );
  }
}

extension ResponsiveContextX on BuildContext {
  ResponsiveInfo get responsive => ResponsiveInfo(
    width: MediaQuery.sizeOf(this).width,
    height: MediaQuery.sizeOf(this).height,
  );

  bool get isMobile => responsive.isMobile;
  bool get isTablet => responsive.isTablet;
  bool get isDesktop => responsive.isDesktop;

  T responsiveValue<T>({required T mobile, T? tablet, T? desktop}) {
    return responsive.value(mobile: mobile, tablet: tablet, desktop: desktop);
  }
}
