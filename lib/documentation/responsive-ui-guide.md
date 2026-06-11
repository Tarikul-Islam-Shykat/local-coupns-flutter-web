# Responsive UI Guide

This project now includes a reusable responsive helper so you can build screens that adapt to mobile, tablet, and desktop without rewriting breakpoint logic every time.

## What to use

- `ResponsiveLayout`
- `context.responsive`
- `context.responsiveValue(...)`
- `ResponsiveInfo`

## How to set it up

You do not need to initialize anything special in `main.dart` for this helper.

Just import:

```dart
import 'package:flutter_application_1/global/responsive.dart';
```

## How to use it

Wrap a screen with `ResponsiveLayout` and read the current device info from the builder:

```dart
ResponsiveLayout(
  builder: (context, info) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: info.horizontalPadding,
        vertical: info.verticalPadding,
      ),
      child: info.isDesktop
          ? Row(
              children: const [
                Expanded(child: LeftPanel()),
                SizedBox(width: 24),
                Expanded(child: RightPanel()),
              ],
            )
          : Column(
              children: const [
                LeftPanel(),
                SizedBox(height: 16),
                RightPanel(),
              ],
            ),
    );
  },
)
```

## Useful values

`ResponsiveInfo` gives you:

- `isMobile`
- `isTablet`
- `isDesktop`
- `horizontalPadding`
- `verticalPadding`
- `contentWidth`
- `gap`
- `value(...)`

## Best pattern for new screens

Use this approach:

1. Wrap the page with `ResponsiveLayout`.
2. Use `info.contentWidth` to avoid the page stretching too far on large screens.
3. Use `info.value(...)` for responsive font sizes, icon sizes, and spacing.
4. Use `Expanded` and `Flexible` instead of fixed widths when possible.
5. Keep cards and forms centered with a max width.

## Example for a responsive size

```dart
final titleSize = context.responsiveValue<double>(
  mobile: 24,
  tablet: 28,
  desktop: 32,
);
```

## Example for a responsive container

```dart
Container(
  width: double.infinity,
  constraints: BoxConstraints(
    maxWidth: context.responsiveValue<double>(
      mobile: 420,
      tablet: 520,
      desktop: 640,
    ),
  ),
)
```

## Why this is better

- You keep one reusable pattern for all future pages.
- You avoid hardcoding a separate layout for every screen.
- The UI stays safe on small screens and roomy on large screens.
- It is easy to reuse for login, signup, dashboards, and settings pages.

## In this project

The login page now uses this helper instead of repeating width checks manually.

