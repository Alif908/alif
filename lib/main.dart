import 'dart:typed_data';
import 'package:alif/imgcons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muhammed Alif - Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        fontFamily: 'Poppins',
      ),
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({Key? key}) : super(key: key);

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final ScrollController _scrollController = ScrollController();

  Future<void> _openResume() async {
    try {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Downloading resume...'),
            duration: Duration(seconds: 2),
            backgroundColor: Color(0xFF3B82F6),
          ),
        );
      }

      if (kIsWeb) {
        // For Web - Download the PDF
        final ByteData data = await rootBundle.load(
          'assets/resume/Muhammed_Alif_Flutter_Developer_.pdf',
        );
        final Uint8List bytes = data.buffer.asUint8List();

        // Create blob and download
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', 'Muhammed_Alif_Flutter_Developer.pdf')
          ..click();
        html.Url.revokeObjectUrl(url);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Resume downloaded successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        // For Mobile - Direct download link (You can update this with your hosted resume)
        const resumeUrl =
            'https://drive.google.com/uc?export=download&id=YOUR_DRIVE_FILE_ID';
        final Uri uri = Uri.parse(resumeUrl);

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Opening resume...'),
                backgroundColor: Color(0xFF3B82F6),
                duration: Duration(seconds: 2),
              ),
            );
          }
        } else {
          throw Exception('Could not open resume');
        }
      }
    } catch (e) {
      debugPrint("Resume error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'For mobile app: Please upload resume to Google Drive',
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildHeroSection(context),
                _buildAboutSection(context),
                _buildSkillsSection(context),
                _buildExperienceSection(context),
                _buildProjectsSection(context),
                _buildEducationSection(context),
                _buildContactSection(context),
                _buildFooter(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor: const Color(0xFF1E293B).withOpacity(0.95),
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text('MA', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Muhammed Alif',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
      actions: _buildNavItems(context),
    );
  }

  List<Widget> _buildNavItems(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    if (isMobile) {
      return [
        PopupMenuButton<String>(
          icon: const Icon(Icons.menu),
          color: const Color(0xFF1E293B),
          onSelected: (value) => _scrollToSection(value),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'about', child: Text('About')),
            const PopupMenuItem(value: 'skills', child: Text('Skills')),
            const PopupMenuItem(value: 'experience', child: Text('Experience')),
            const PopupMenuItem(value: 'projects', child: Text('Projects')),
            const PopupMenuItem(value: 'education', child: Text('Education')),
            const PopupMenuItem(value: 'contact', child: Text('Contact')),
          ],
        ),
      ];
    }

    return [
      _navButton('About', 'about'),
      _navButton('Skills', 'skills'),
      _navButton('Experience', 'experience'),
      _navButton('Projects', 'projects'),
      _navButton('Education', 'education'),
      _navButton('Contact', 'contact'),
      const SizedBox(width: 16),
    ];
  }

  Widget _navButton(String text, String section) {
    return TextButton(
      onPressed: () => _scrollToSection(section),
      child: Text(text, style: const TextStyle(color: Color(0xFFCBD5E1))),
    );
  }

  void _scrollToSection(String section) {
    double offset = 0;
    switch (section) {
      case 'about':
        offset = 700;
        break;
      case 'skills':
        offset = 1400;
        break;
      case 'experience':
        offset = 2200;
        break;
      case 'projects':
        offset = 2900;
        break;
      case 'education':
        offset = 3800;
        break;
      case 'contact':
        offset = 4300;
        break;
    }
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 700;
    final isTablet = size.width >= 700 && size.width < 1100;

    return Container(
      constraints: BoxConstraints(minHeight: size.height * 0.95),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF1E40AF)],
        ),
      ),
      child: Stack(
        children: [
          _buildAnimatedBackground(),
          Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24.0 : 48.0,
                  vertical: 48.0,
                ),
                child: isMobile || isTablet
                    ? _buildMobileHero(isMobile)
                    : _buildDesktopHero(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileHero(bool isMobile) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildProfileImage(isMobile ? 120.0 : 160.0),
        SizedBox(height: isMobile ? 20 : 28),
        _buildHeroText(isMobile, TextAlign.center),
        const SizedBox(height: 28),
        _buildSocialButtons(),
        const SizedBox(height: 24),
        _buildCTAButtons(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDesktopHero() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeroText(false, TextAlign.left),
              const SizedBox(height: 32),
              _buildSocialButtons(),
              const SizedBox(height: 24),
              _buildCTAButtons(),
            ],
          ),
        ),
        const SizedBox(width: 60),
        _buildProfileImage(280.0),
      ],
    );
  }

  Widget _buildProfileImage(double size) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1200),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6), Color(0xFF06B6D4)],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF3B82F6).withOpacity(0.4),
              blurRadius: 40,
              spreadRadius: 8,
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF1E293B),
          ),
          child: ClipOval(
            child: Image.asset(Imgcons.profile, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroText(bool isMobile, TextAlign align) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: align == TextAlign.center
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Text(
            'Hi, I\'m',
            style: TextStyle(
              fontSize: isMobile ? 18 : 22,
              color: Color(0xFF94A3B8),
            ),
            textAlign: align,
          ),
          const SizedBox(height: 8),
          Text(
            'MUHAMMED ALIF',
            style: TextStyle(
              fontSize: isMobile ? 36 : 56,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF1F5F9),
              letterSpacing: -1,
            ),
            textAlign: align,
          ),
          const SizedBox(height: 12),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
            ).createShader(bounds),
            child: Text(
              'Flutter Developer',
              style: TextStyle(
                fontSize: isMobile ? 24 : 32,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: align,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'Building smooth, responsive & visually appealing mobile applications with expertise in Flutter, Dart, and modern state management',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                color: Color(0xFF94A3B8),
                height: 1.6,
              ),
              textAlign: align,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: align == TextAlign.center
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: const [
              Icon(Icons.location_on, color: Color(0xFF3B82F6), size: 20),
              SizedBox(width: 8),
              Text('Kochi, Kerala', style: TextStyle(color: Color(0xFF94A3B8))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) =>
            CustomPaint(painter: CirclePainter(_controller.value)),
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _socialButton(Icons.email, 'mailto:Muhammedalif918@gmail.com'),
        _socialButton(Icons.phone, 'tel:+917736193302'),
        _socialButton(Icons.link, 'http://www.linkedin.com/in/ALIF908'),

        //  RESUME DOWNLOAD BUTTON
        ElevatedButton.icon(
          onPressed: _openResume,
          icon: const Icon(Icons.download, size: 18),
          label: const Text('Resume'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E293B),
            foregroundColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFF334155)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _socialButton(IconData icon, String url) {
    return InkWell(
      onTap: () => _launchURL(url),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Icon(icon, color: const Color(0xFF3B82F6)),
      ),
    );
  }

  Widget _buildCTAButtons() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        ElevatedButton.icon(
          onPressed: () => _launchURL('mailto:Muhammedalif918@gmail.com'),
          icon: const Icon(Icons.email_outlined),
          label: const Text('Hire Me'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => _scrollToSection('projects'),
          icon: const Icon(Icons.work_outline),
          label: const Text('View Projects'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF3B82F6),
            side: const BorderSide(color: Color(0xFF3B82F6)),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return _buildSection(
      context,
      'About Me',
      Container(
        constraints: const BoxConstraints(maxWidth: 900),
        padding: const EdgeInsets.all(32.0),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: const Text(
          "I'm a Flutter Developer skilled in building smooth, responsive, and visually appealing mobile apps using Flutter & Dart. I have hands-on experience with Firebase, REST APIs, JSON, and state management tools like Provider, Riverpod, and GetX. I enjoy turning UI/UX designs into clean, scalable, and user-friendly applications while staying updated with the latest Flutter features and best practices.",
          style: TextStyle(fontSize: 17, height: 1.8, color: Color(0xFF94A3B8)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSkillsSection(BuildContext context) {
    final skills = {
      'Languages': ['Dart', 'Java', 'Kotlin', 'JavaScript'],
      'Frameworks': [
        'Flutter',
        'Provider',
        'Riverpod',
        'GetX',
        'Bloc',
        'Firebase',
      ],
      'Backend & APIs': ['REST API', 'GraphQL', 'Firebase', 'Django'],
      'Tools': ['Android Studio', 'VS Code', 'Git/GitHub', 'Postman', 'Figma'],
      'Databases': ['SQLite', 'MySQL', 'Cloud Firestore'],
      'Platforms': ['Android', 'iOS', 'Web', 'Windows', 'macOS'],
    };

    return _buildSection(
      context,
      'Technical Skills',
      LayoutBuilder(
        builder: (context, constraints) {
          final cols = constraints.maxWidth < 600
              ? 1
              : constraints.maxWidth < 900
              ? 2
              : 3;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              childAspectRatio: 1.3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: skills.length,
            itemBuilder: (context, i) => _buildSkillCard(
              skills.keys.elementAt(i),
              skills.values.elementAt(i),
              i,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkillCard(String category, List<String> items, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 100)),
      builder: (context, double value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: child,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.code, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF1F5F9),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: items
                    .map(
                      (item) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceSection(BuildContext context) {
    return _buildSection(
      context,
      'Experience',
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.work,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Flutter Developer',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF1F5F9),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Luminar Technolab • Full-time',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF3B82F6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Icon(
                    Icons.calendar_today,
                    color: Color(0xFF64748B),
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'June 2025 - December 2025',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                  SizedBox(width: 24),
                  Icon(Icons.location_on, color: Color(0xFF64748B), size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Kochi, Kerala',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: Color(0xFF334155)),
              const SizedBox(height: 24),
              ...[
                'App Performance Optimization: Refactored Flutter app architecture to improve speed and scalability, ensuring smooth performance even with large datasets',
                'UI/UX Design Implementation: Designed and developed intuitive, responsive, and visually appealing user interfaces in Flutter',
                'Real-Time Updates: Implemented WebSocket-based features for live data sync, instant notifications, and real-time UI updates',
                'API and Firebase Integration: Worked with RESTful APIs and implemented Firebase Authentication and Cloud Firestore',
              ].map(
                (point) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          point,
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            height: 1.6,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectsSection(BuildContext context) {
    final projects = [
      {
        'title': 'Wedding Package Management App',
        'desc':
            'Ongoing Flutter project with modules for events, catering, dresses, auditorium booking, and wedding cars',
        'status': 'Development',
        'tech': ['Flutter', 'Firebase', 'REST API'],
        'icon': Icons.celebration,
      },
      {
        'title': 'Expense Tracker App',
        'desc':
            'A modern expense tracking application with beautiful dark-green gradient UI. Features include dashboard with balance overview, income & expense analytics, circular progress chart, transaction history, add income/expense forms, category selection, date picker, and secure logout confirmation. Designed with smooth animations and clean UX.',
        'status': 'Completed',
        'tech': ['Flutter', 'SQLite', 'Charts', 'UI/UX'],
        'icon': Icons.account_balance_wallet,
        'images': [
          Imgcons.welcome,
          Imgcons.dashboard,
          Imgcons.expenses,
          Imgcons.income,
          Imgcons.addexpenses,
          Imgcons.addincome,
          Imgcons.logout,
        ],
      },
      {
        'title': 'CLONO – OLX UI/UX Clone App',
        'desc':
            'A complete UI/UX clone of the OLX mobile application built using Flutter. Includes home feed, product listing, search, category browsing, chat UI, and post-ad interface with pixel-perfect design and smooth animations',
        'status': 'Completed',
        'tech': ['Flutter', 'Dart', 'UI/UX', 'Animations'],
        'icon': Icons.shopping_bag,
      },
    ];

    return _buildSection(
      context,
      'Projects',
      LayoutBuilder(
        builder: (context, constraints) {
          final cols = constraints.maxWidth < 700 ? 1 : 2;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              childAspectRatio: constraints.maxWidth < 700 ? 0.95 : 0.85,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: projects.length,
            itemBuilder: (context, i) => _buildProjectCard(projects[i], i),
          );
        },
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project, int index) {
    final hasImages =
        project.containsKey('images') && (project['images'] as List).isNotEmpty;

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 100)),
      builder: (context, double value, child) => Opacity(
        opacity: value,
        child: Transform.scale(scale: 0.9 + (0.1 * value), child: child),
      ),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    project['icon'] as IconData,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: project['status'] == 'Completed'
                        ? Colors.green.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: project['status'] == 'Completed'
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                  child: Text(
                    project['status'],
                    style: TextStyle(
                      fontSize: 12,
                      color: project['status'] == 'Completed'
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              project['title'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF1F5F9),
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              project['desc'],
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                height: 1.5,
                fontSize: 14,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),

            // Image Gallery (if images exist)
            if (hasImages) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: (project['images'] as List).length,
                  itemBuilder: (context, imgIndex) {
                    return GestureDetector(
                      onTap: () => _showFullScreenImage(
                        context,
                        project['images'] as List,
                        imgIndex,
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            (project['images'] as List)[imgIndex],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFF0F172A),
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Tech Stack
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (project['tech'] as List<String>)
                  .map(
                    (tech) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Text(
                        tech,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationSection(BuildContext context) {
    return _buildSection(
      context,
      'Education',
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.school, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 24),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bachelor of Computer Applications',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF1F5F9),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'ILAHIA College of Arts and Science',
                      style: TextStyle(fontSize: 18, color: Color(0xFF3B82F6)),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '2022 - 2025',
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return _buildSection(
      context,
      'Get In Touch',
      Column(
        children: [
          const Text(
            'Let\'s work together on your next project!',
            style: TextStyle(fontSize: 18, color: Color(0xFF94A3B8)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _buildContactCard(
                Icons.email,
                'Email',
                'Muhammedalif918@gmail.com',
                'mailto:Muhammedalif918@gmail.com',
              ),
              _buildContactCard(
                Icons.phone,
                'Phone',
                '+91 7736193302',
                'tel:+917736193302',
              ),
              _buildContactCard(
                Icons.link,
                'LinkedIn',
                'Connect on LinkedIn',
                'http://www.linkedin.com/in/ALIF908',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
    IconData icon,
    String title,
    String value,
    String url,
  ) {
    return InkWell(
      onTap: () => _launchURL(url),
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF1F5F9),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(color: Color(0xFF94A3B8)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      color: const Color(0xFF0F172A),
      child: const Column(
        children: [
          Text(
            '© 2025 Muhammed Alif. All rights reserved.',
            style: TextStyle(color: Color(0xFF64748B)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Built with Flutter ❤️',
            style: TextStyle(color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF1F5F9),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 40),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: child,
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  void _showFullScreenImage(
    BuildContext context,
    List images,
    int initialIndex,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            FullScreenImageViewer(images: images, initialIndex: initialIndex),
      ),
    );
  }
}

class FullScreenImageViewer extends StatefulWidget {
  final List images;
  final int initialIndex;

  const FullScreenImageViewer({
    Key? key,
    required this.images,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image PageView
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.asset(
                    widget.images[index],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.white54,
                          size: 80,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),

          // Top Bar with Close Button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Expense Tracker - ${_currentIndex + 1}/${widget.images.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation Dots
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),

          // Previous Button (Left)
          if (_currentIndex > 0)
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ),
            ),

          // Next Button (Right)
          if (_currentIndex < widget.images.length - 1)
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double animationValue;
  CirclePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (int i = 0; i < 3; i++) {
      final radius = (size.width / 3) * (1 + animationValue) + (i * 100);
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}
