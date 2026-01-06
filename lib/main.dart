import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adnan Mujahid - Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF22D3EE),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        fontFamily: 'Inter',
      ),
      home: const PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  bool _isScrolled = false;
  String _activeSection = 'home';
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _isScrolled = _scrollController.offset > 50;
    });
  }

  void _scrollToSection(GlobalKey key, String section) {
    setState(() {
      _activeSection = section;
    });

    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Handle error - you can show a snackbar or dialog
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF020617),
                  Color(0xFF1E3A8A),
                  Color(0xFF0F172A),
                ],
              ),
            ),
          ),

          // Content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildHeroSection(),
                _buildAboutSection(),
                _buildSkillsSection(),
                _buildProjectsSection(),
                _buildContactSection(),
                _buildFooter(),
              ],
            ),
          ),

          // Navigation Bar
          _buildNavBar(),

          // Mobile Menu
          if (_isMenuOpen)
            Positioned(
              top: 70,
              right: 0,
              left: 0,
              child: Container(
                color: const Color(0xFF0F172A).withOpacity(0.98),
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    _mobileNavButton('Home', 'home', _homeKey),
                    _mobileNavButton('About', 'about', _aboutKey),
                    _mobileNavButton('Skills', 'skills', _skillsKey),
                    _mobileNavButton('Projects', 'projects', _projectsKey),
                    _mobileNavButton('Contact', 'contact', _contactKey),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _mobileNavButton(String label, String section, GlobalKey key) {
    final isActive = _activeSection == section;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _scrollToSection(key, section);
          setState(() {
            _isMenuOpen = false;
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: isActive ? const Color(0xFF22D3EE) : Colors.white,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: _isScrolled
            ? const Color(0xFF0F172A).withOpacity(0.95)
            : Colors.transparent,
        boxShadow: _isScrolled
            ? [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10)]
            : [],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 768) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF22D3EE), Color(0xFF3B82F6)],
                    ).createShader(bounds),
                    child: const Text(
                      'AM',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      _navButton('Home', 'home', _homeKey),
                      const SizedBox(width: 32),
                      _navButton('About', 'about', _aboutKey),
                      const SizedBox(width: 32),
                      _navButton('Skills', 'skills', _skillsKey),
                      const SizedBox(width: 32),
                      _navButton('Projects', 'projects', _projectsKey),
                      const SizedBox(width: 32),
                      _navButton('Contact', 'contact', _contactKey),
                    ],
                  ),
                ],
              );
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF22D3EE), Color(0xFF3B82F6)],
                    ).createShader(bounds),
                    child: const Text(
                      'AM',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(_isMenuOpen ? Icons.close : Icons.menu, size: 28),
                    onPressed: () {
                      setState(() {
                        _isMenuOpen = !_isMenuOpen;
                      });
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _navButton(String label, String section, GlobalKey key) {
    final isActive = _activeSection == section;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _scrollToSection(key, section),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: isActive ? const Color(0xFF22D3EE) : Colors.white,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      key: _homeKey,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          // Animated background blobs
          Positioned(
            top: -200,
            left: -200,
            child: _animatedBlob(const Color(0xFF22D3EE), 400),
          ),
          Positioned(
            bottom: -200,
            right: -200,
            child: _animatedBlob(const Color(0xFF3B82F6), 400, delay: 1),
          ),

          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 768;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 800),
                        builder: (context, double value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          "Hello, I'm",
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 20,
                            color: const Color(0xFF22D3EE),
                            fontFamily: 'Courier',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 800),
                        builder: (context, double value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          'Adnan Mujahid',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isMobile ? 42 : 72,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Software Engineer & Flutter Developer',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isMobile ? 20 : 36,
                          color: const Color(0xFFD1D5DB),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Text(
                          'Building scalable cross-platform mobile apps with Flutter, Firebase, and AI integration. Turning ideas into reality.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 20,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialButton(
                            Icons.code,
                                () => _launchURL('https://github.com/AdnanMujahid'),
                          ),
                          const SizedBox(width: 24),
                          _socialButton(
                            Icons.work,
                                () => _launchURL('https://linkedin.com/in/adnanmujahid'),
                          ),
                          const SizedBox(width: 24),
                          _socialButton(
                            Icons.email,
                                () => _launchURL('mailto:adnanmujahid360@gmail.com'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 64),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => _scrollToSection(_aboutKey, 'about'),
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 48,
                            color: Color(0xFF22D3EE),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _animatedBlob(Color color, double size, {int delay = 0}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.8, end: 1.2),
      duration: const Duration(seconds: 2),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 100,
                  spreadRadius: 50,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _socialButton(IconData icon, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 24),
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      key: _aboutKey,
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 48),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const Text(
                'About Me',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 80),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 900) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _aboutCard(
                                Icons.phone_android,
                                'Mobile Development',
                                'Specialized in Flutter development, creating beautiful cross-platform apps for iOS and Android with seamless user experiences.',
                                const Color(0xFF22D3EE),
                              ),
                              const SizedBox(height: 24),
                              _aboutCard(
                                Icons.psychology,
                                'AI Integration',
                                'Building AI-powered chatbots with RAG (Retrieval-Augmented Generation) and integrating machine learning models into applications.',
                                const Color(0xFF3B82F6),
                              ),
                              const SizedBox(height: 24),
                              _aboutCard(
                                Icons.storage,
                                'Backend & Database',
                                'Proficient in Firebase, Node.js, and FastAPI. Building scalable REST APIs and managing complex database architectures.',
                                const Color(0xFF8B5CF6),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 48),
                        Expanded(child: _currentlyWorkingCard()),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _aboutCard(
                          Icons.phone_android,
                          'Mobile Development',
                          'Specialized in Flutter development, creating beautiful cross-platform apps for iOS and Android with seamless user experiences.',
                          const Color(0xFF22D3EE),
                        ),
                        const SizedBox(height: 24),
                        _aboutCard(
                          Icons.psychology,
                          'AI Integration',
                          'Building AI-powered chatbots with RAG (Retrieval-Augmented Generation) and integrating machine learning models into applications.',
                          const Color(0xFF3B82F6),
                        ),
                        const SizedBox(height: 24),
                        _aboutCard(
                          Icons.storage,
                          'Backend & Database',
                          'Proficient in Firebase, Node.js, and FastAPI. Building scalable REST APIs and managing complex database architectures.',
                          const Color(0xFF8B5CF6),
                        ),
                        const SizedBox(height: 24),
                        _currentlyWorkingCard(),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _currentlyWorkingCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF22D3EE).withOpacity(0.1),
            const Color(0xFF3B82F6).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF22D3EE).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Currently Working On',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _currentWorkItem('📱', 'Cross-platform Flutter applications'),
          _currentWorkItem('🔥', 'Firebase authentication & Firestore integration'),
          _currentWorkItem('🤖', 'AI chatbots with RAG technology'),
          _currentWorkItem('👥', 'Multi-role dashboard systems'),
          const SizedBox(height: 32),
          const Divider(color: Colors.white24),
          const SizedBox(height: 24),
          _infoRow('Location:', 'Islamabad, Pakistan'),
          const SizedBox(height: 16),
          _infoRow('Company:', 'AHAD SoftTech'),
        ],
      ),
    );
  }

  Widget _aboutCard(IconData icon, String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _currentWorkItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Color(0xFFD1D5DB)),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          TextSpan(text: ' $value'),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Container(
      key: _skillsKey,
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 48),
      color: Colors.white.withOpacity(0.03),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const Text(
                'Technical Skills',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 80),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  _skillCard('Mobile Development', Icons.phone_android,
                      ['Flutter', 'Dart', 'Android', 'iOS'], const Color(0xFF22D3EE)),
                  _skillCard('Backend', Icons.storage,
                      ['Node.js', 'FastAPI', 'Redis', 'REST APIs'], const Color(0xFF3B82F6)),
                  _skillCard('Database', Icons.data_object,
                      ['Firebase', 'MySQL', 'SQLite', 'Firestore'], const Color(0xFF8B5CF6)),
                  _skillCard('AI & ML', Icons.psychology,
                      ['Python', 'scikit-learn', 'Pandas', 'NumPy', 'RAG'], const Color(0xFFEC4899)),
                  _skillCard('Languages', Icons.code,
                      ['C++', 'Java', 'Kotlin', 'JavaScript', 'R'], const Color(0xFFF43F5E)),
                  _skillCard('Tools & Others', Icons.build,
                      ['Git', 'GitHub Actions', 'Nginx', 'VS Code'], const Color(0xFFF59E0B)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _skillCard(String title, IconData icon, List<String> skills, Color color) {
    return Container(
      width: 360,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills
                .map((skill) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                skill,
                style: const TextStyle(fontSize: 14),
              ),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsSection() {
    final projects = [
      {
        'name': 'PDF Reader',
        'description': 'Advanced PDF viewer and reader application with annotation, bookmarking, and search functionality',
        'tech': ['Flutter', 'Dart', 'PDF SDK'],
        'link': 'https://github.com/AdnanMujahid/PDF-Reader',
      },
      {
        'name': 'Blood Pressure App',
        'description': 'Health monitoring application for tracking and analyzing blood pressure readings with charts and insights',
        'tech': ['Flutter', 'Firebase', 'Health APIs'],
        'link': 'https://github.com/AdnanMujahid/Blood-Pressure-App',
      },
      {
        'name': 'Legal Ease Chatbot',
        'description': 'RAG-based AI legal assistant providing intelligent legal guidance and document analysis',
        'tech': ['Python', 'RAG', 'FastAPI', 'AI/ML'],
        'link': 'https://github.com/AdnanMujahid/Legal-Ease',
      },
    ];

    return Container(
      key: _projectsKey,
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 48),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const Text(
                'Featured Projects',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 80),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: projects.map((project) => _projectCard(project)).toList(),
              ),
              const SizedBox(height: 64),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _launchURL('https://github.com/AdnanMujahid?tab=repositories'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF22D3EE), Color(0xFF3B82F6)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View All Projects on GitHub',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _projectCard(Map<String, dynamic> project) {
    return Container(
      width: 360,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.code, size: 32, color: Color(0xFF22D3EE)),
              Row(
                children: [
                  if (project['stars'] != null) ...[
                    const Icon(Icons.star, size: 16, color: Color(0xFFFBBF24)),
                    const SizedBox(width: 4),
                    Text('${project['stars']}', style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 12),
                  ],
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => _launchURL(project['link']),
                      child: const Icon(Icons.open_in_new, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            project['name'],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            project['description'],
            style: const TextStyle(color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (project['tech'] as List<String>)
                .map((tech) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF22D3EE).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                tech,
                style: const TextStyle(
                  color: Color(0xFF22D3EE),
                  fontSize: 12,
                ),
              ),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      key: _contactKey,
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 48),
      color: Colors.white.withOpacity(0.03),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              const Text(
                "Let's Work Together",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "I'm open to freelance opportunities and collaborations. Let's build something amazing together!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 64),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 900) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _contactCard(
                          Icons.email,
                          'Email',
                          'adnanmujahid360@gmail.com',
                              () => _launchURL('mailto:adnanmujahid360@gmail.com'),
                        ),
                        const SizedBox(width: 24),
                        _contactCard(
                          Icons.work,
                          'LinkedIn',
                          'in/adnanmujahid',
                              () => _launchURL('https://linkedin.com/in/adnanmujahid'),
                        ),
                        const SizedBox(width: 24),
                        _contactCard(
                          Icons.code,
                          'GitHub',
                          '@AdnanMujahid',
                              () => _launchURL('https://github.com/AdnanMujahid'),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _contactCard(
                          Icons.email,
                          'Email',
                          'adnanmujahid360@gmail.com',
                              () => _launchURL('mailto:adnanmujahid360@gmail.com'),
                        ),
                        const SizedBox(height: 24),
                        _contactCard(
                          Icons.work,
                          'LinkedIn',
                          'in/adnanmujahid',
                              () => _launchURL('https://linkedin.com/in/adnanmujahid'),
                        ),
                        const SizedBox(height: 24),
                        _contactCard(
                          Icons.code,
                          'GitHub',
                          '@AdnanMujahid',
                              () => _launchURL('https://github.com/AdnanMujahid'),
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 64),
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF22D3EE).withOpacity(0.1),
                      const Color(0xFF3B82F6).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF22D3EE).withOpacity(0.2),
                  ),
                ),
                child: const Text(
                  '"The only way to do great work is to love what you do." - Steve Jobs',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFFD1D5DB),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactCard(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              Icon(icon, size: 32, color: const Color(0xFF22D3EE)),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 48),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: const Column(
        children: [
          Text(
            '© 2026 Adnan Mujahid. Built with Flutter',
            style: TextStyle(color: Color(0xFF9CA3AF)),
          ),
          SizedBox(height: 8),
          Text(
            'Software Engineer | Flutter Developer | Open to Opportunities',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}