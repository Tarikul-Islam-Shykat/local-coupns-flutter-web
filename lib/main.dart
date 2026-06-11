import 'package:flutter/material.dart';

void main() {
  runApp(const LocalCouponsApp());
}

class LocalCouponsApp extends StatelessWidget {
  const LocalCouponsApp({super.key});

  @override
  Widget build(BuildContext context) {
    const deepBlue = Color(0xFF102A43);
    const teal = Color(0xFF0EA5A4);
    const sand = Color(0xFFF8F5EF);
    const coral = Color(0xFFF97316);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Local Coupons',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: teal,
          brightness: Brightness.light,
          primary: teal,
          secondary: coral,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: sand,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.w800,
            height: 1.05,
            letterSpacing: -1.5,
            color: deepBlue,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: deepBlue,
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: deepBlue,
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            height: 1.55,
            color: Color(0xFF334E68),
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Color(0xFF52606D),
          ),
        ),
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF0EA5A4);
    const dark = Color(0xFF102A43);
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 920;

    return Scaffold(
      body: Stack(
        children: [
          const _Background(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TopBar(isWide: isWide),
                      const SizedBox(height: 40),
                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 28),
                                child: _IntroPanel(accent: accent, dark: dark),
                              ),
                            ),
                            const SizedBox(width: 0),
                            const Expanded(flex: 4, child: _ShowcasePanel()),
                          ],
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _IntroPanel(accent: accent, dark: dark),
                            const SizedBox(height: 24),
                            const _ShowcasePanel(),
                          ],
                        ),
                      const SizedBox(height: 34),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: const [
                          _FeatureCard(
                            icon: Icons.search_rounded,
                            title: 'Find quickly',
                            description:
                                'Filter by category, distance, or deal type in seconds.',
                          ),
                          _FeatureCard(
                            icon: Icons.map_outlined,
                            title: 'Shop nearby',
                            description:
                                'Highlight promotions from businesses right around the corner.',
                          ),
                          _FeatureCard(
                            icon: Icons.phone_iphone_outlined,
                            title: 'Built for web',
                            description:
                                'A lightweight experience that feels smooth on desktop and mobile.',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF0EA5A4),
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Color(0x220EA5A4),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.local_offer_rounded, color: Colors.white),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Local Coupons',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 2),
              Text(
                'Your neighborhood savings hub',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        if (isWide) TextButton(onPressed: () {}, child: const Text('Sign in')),
      ],
    );
  }
}

class _IntroPanel extends StatelessWidget {
  const _IntroPanel({required this.accent, required this.dark});

  final Color accent;
  final Color dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Pill(
          label: 'Fresh local deals, one tap away',
          color: accent.withValues(alpha: 0.14),
          textColor: accent,
        ),
        const SizedBox(height: 22),
        Text(
          'Discover the best offers near you.',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 18),
        const Text(
          'Local Coupons helps people find nearby savings, special offers, and neighborhood favorites in one fast, friendly web experience.',
          style: TextStyle(fontSize: 18, height: 1.6, color: Color(0xFF334E68)),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.local_offer_outlined),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Browse coupons'),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('See how it works'),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFD6E0EA)),
                foregroundColor: dark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: const [
            _MiniStat(value: '120+', label: 'local businesses'),
            _MiniStat(value: '3 taps', label: 'to a coupon'),
            _MiniStat(value: '24/7', label: 'web access'),
          ],
        ),
      ],
    );
  }
}

class _ShowcasePanel extends StatelessWidget {
  const _ShowcasePanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _HeroCard(),
        const SizedBox(height: 18),
        const _DealStrip(
          title: 'Hot this week',
          subtitle: 'Save at nearby cafes, salons, and shops.',
          price: 'Up to 40% off',
        ),
      ],
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFBF5), Color(0xFFF3FAFF), Color(0xFFF8F5EF)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -40,
            child: _Glow(color: Color(0x330EA5A4), size: 220),
          ),
          Positioned(
            bottom: -100,
            left: -60,
            child: _Glow(color: Color(0x33F97316), size: 260),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6EEF6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF102A43),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE6EEF6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 30,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0EA5A4), Color(0xFF2563EB)],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 20,
                  right: 20,
                  child: _Badge(
                    icon: Icons.flash_on_rounded,
                    text: 'Limited time',
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Weekend meal deal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Local favorite bakery and cafe bundle',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(
                child: _InfoTile(label: 'Savings', value: '25%'),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _InfoTile(label: 'Redeem', value: '1 tap'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF102A43),
            ),
          ),
        ],
      ),
    );
  }
}

class _DealStrip extends StatelessWidget {
  const _DealStrip({
    required this.title,
    required this.subtitle,
    required this.price,
  });

  final String title;
  final String subtitle;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF102A43),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            price,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xFFFBBF24),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE6EEF6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFE6FFFB),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFF0EA5A4)),
          ),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(description, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
