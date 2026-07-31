import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math' as math;

void main() {
  runApp(
    const LanguageManager(
      child: FontSizeManager(
        child: ElderConnectApp(),
      ),
    ),
  );
}

// ================= TRANSLATION / LOCALIZATION SYSTEM =================
class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'ElderConnect',
      'nav_home': 'Home',
      'nav_dash': 'Dashboard',
      'nav_profile': 'Profile',
      'avatar_greet': 'Hello! How are you feeling today?',
      'btn_speak': 'Speak',
      'btn_type': 'Type Message',
      'btn_listen': 'Listen',
      'card_med': 'Medication',
      'card_health': 'Health',
      'card_maps': 'Maps',
      'card_comm': 'Community',
      'card_emer': 'Emergency',
      'card_care': 'Caregiver',
      'user_guest': 'Guest User',
      'set_font': 'Font Size Settings',
      'set_font_sub': 'Adjust app layout scale for comfortable reading',
      'set_lang': 'Language Settings',
      'set_lang_sub': 'Switch between English and Korean',
      'set_about': 'About',
      'set_logout': 'Logout',
      'logout_confirm': 'Are you sure you want to logout?',
      'cancel': 'Cancel',
      'done': 'Done',
      'font_small': 'Small Fonts',
      'font_medium': 'Medium Fonts',
      'font_large': 'Large Fonts (Recommended)',
    },
    'ko': {
      'title': '엘더커넥트',
      'nav_home': '홈',
      'nav_dash': '대시보드',
      'nav_profile': '프로필',
      'avatar_greet': '안녕하세요! 오늘 기분은 어떠신가요?',
      'btn_speak': '말하기',
      'btn_type': '메시지 입력',
      'btn_listen': '듣기',
      'card_med': '복약 관리',
      'card_health': '건강 상태',
      'card_maps': '지도',
      'card_comm': '커뮤니티',
      'card_emer': '긴급 상황',
      'card_care': '보호자 연결',
      'user_guest': '게스트 사용자',
      'set_font': '글자 크기 설정',
      'set_font_sub': '편안한 독서를 위해 화면 크기를 조절합니다',
      'set_lang': '언어 설정',
      'set_lang_sub': '영어와 한국어 전환',
      'set_about': '앱 정보',
      'set_logout': '로그아웃',
      'logout_confirm': '정말 로그아웃 하시겠습니까?',
      'cancel': '취소',
      'done': '완료',
      'font_small': '작은 글꼴',
      'font_medium': '보통 글꼴',
      'font_large': '큰 글꼴 (추천)',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ko'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// ================= LANGUAGE MANAGER (STATE) =================
class LanguageManager extends StatefulWidget {
  final Widget child;
  const LanguageManager({super.key, required this.child});

  static _LanguageManagerState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_LanguageInheritedWidget>()!.state;
  }

  @override
  State<LanguageManager> createState() => _LanguageManagerState();
}

class _LanguageManagerState extends State<LanguageManager> {
  Locale _currentLocale = const Locale('ko');
  Locale get currentLocale => _currentLocale;

  void changeLanguage(Locale locale) {
    setState(() {
      _currentLocale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _LanguageInheritedWidget(
      state: this,
      currentLocale: _currentLocale,
      child: widget.child,
    );
  }
}

class _LanguageInheritedWidget extends InheritedWidget {
  final _LanguageManagerState state;
  final Locale currentLocale;

  const _LanguageInheritedWidget({
    required this.state,
    required this.currentLocale,
    required super.child,
  });

  @override
  bool updateShouldNotify(_LanguageInheritedWidget oldWidget) {
    return oldWidget.currentLocale != currentLocale;
  }
}

// ================= FONT SIZE MANAGER (STATE) =================
enum FontSizePreset { small, medium, large }

class FontSizeManager extends StatefulWidget {
  final Widget child;
  const FontSizeManager({super.key, required this.child});

  static _FontSizeManagerState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FontSizeInheritedWidget>()!.state;
  }

  @override
  State<FontSizeManager> createState() => _FontSizeManagerState();
}

class _FontSizeManagerState extends State<FontSizeManager> {
  FontSizePreset _currentPreset = FontSizePreset.large;
  FontSizePreset get currentPreset => _currentPreset;

  double getScaleFactor() {
    switch (_currentPreset) {
      case FontSizePreset.small: return 0.85;
      case FontSizePreset.medium: return 1.0;
      case FontSizePreset.large: return 1.4;
    }
  }

  void changeFontSize(FontSizePreset preset) {
    setState(() {
      _currentPreset = preset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _FontSizeInheritedWidget(
      state: this,
      currentPreset: _currentPreset,
      child: widget.child,
    );
  }
}

class _FontSizeInheritedWidget extends InheritedWidget {
  final _FontSizeManagerState state;
  final FontSizePreset currentPreset;

  const _FontSizeInheritedWidget({
    required this.state,
    required this.currentPreset,
    required super.child,
  });

  @override
  bool updateShouldNotify(_FontSizeInheritedWidget oldWidget) {
    return oldWidget.currentPreset != currentPreset;
  }
}

// ================= APP ROOT =================
class ElderConnectApp extends StatelessWidget {
  const ElderConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    final fontManager = FontSizeManager.of(context);
    final langManager = LanguageManager.of(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ElderConnect',
      theme: ThemeData(
        colorSchemeSeed: Colors.pinkAccent,
        useMaterial3: true,
      ),
      locale: langManager.currentLocale,
      supportedLocales: const [Locale('en'), Locale('ko')],
      localizationsDelegates: const [
        _AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(fontManager.getScaleFactor()),
          ),
          child: child!,
        );
      },
      home: const HomePage(),
    );
  }
}

// ================= MAIN HOLDER / HOME PAGE =================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final pages = const [
    AvatarPage(),
    DashboardPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(local.translate('title')),
        centerTitle: true,
        elevation: 1,
      ),
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.face_3), label: local.translate('nav_home')),
          NavigationDestination(icon: const Icon(Icons.dashboard), label: local.translate('nav_dash')),
          NavigationDestination(icon: const Icon(Icons.person), label: local.translate('nav_profile')),
        ],
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

// ================= KOREAN WOMAN HUMAN AVATAR VECTOR PAINTER =================
class KoreanWomanAvatarPainter extends CustomPainter {
  final double animationValue;

  KoreanWomanAvatarPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final skinPaint = Paint()..color = const Color(0xFFFFE3D6);
    final hairPaint = Paint()..color = const Color(0xFF211510);
    final hanbokPink = Paint()..color = const Color(0xFFFF8FA3);
    final hanbokCollar = Paint()..color = Colors.white;
    final cheekPaint = Paint()..color = const Color(0xFFFF758F).withOpacity(0.35);
    final lipPaint = Paint()..color = const Color(0xFFE63946);
    final eyePaint = Paint()..color = const Color(0xFF2B1E1A);

    // Torso / Hanbok
    final hanbokPath = Path();
    hanbokPath.moveTo(width * 0.1, height);
    hanbokPath.quadraticBezierTo(width * 0.25, height * 0.65, width * 0.35, height * 0.68);
    hanbokPath.lineTo(width * 0.65, height * 0.68);
    hanbokPath.quadraticBezierTo(width * 0.75, height * 0.65, width * 0.9, height);
    hanbokPath.close();
    canvas.drawPath(hanbokPath, hanbokPink);

    // Collar
    final collarPath = Path();
    collarPath.moveTo(width * 0.4, height * 0.73);
    collarPath.lineTo(width * 0.5, height * 0.85);
    collarPath.lineTo(width * 0.6, height * 0.73);
    collarPath.lineTo(width * 0.54, height * 0.68);
    collarPath.lineTo(width * 0.46, height * 0.68);
    collarPath.close();
    canvas.drawPath(collarPath, hanbokCollar);

    // Neck
    final neckR = Rect.fromLTWH(width * 0.43, height * 0.58, width * 0.14, height * 0.15);
    canvas.drawRect(neckR, skinPaint);

    // Face Base
    final facePath = Path();
    facePath.moveTo(width * 0.28, height * 0.35);
    facePath.cubicTo(width * 0.28, height * 0.62, width * 0.72, height * 0.62, width * 0.72, height * 0.35);
    facePath.cubicTo(width * 0.72, height * 0.2, width * 0.28, height * 0.2, width * 0.28, height * 0.35);
    canvas.drawPath(facePath, skinPaint);

    // Cheeks
    canvas.drawCircle(Offset(width * 0.37, height * 0.48), width * 0.05, cheekPaint);
    canvas.drawCircle(Offset(width * 0.63, height * 0.48), width * 0.05, cheekPaint);

    // Eyes
    final double blinkFactor = (math.sin(animationValue * math.pi * 2) > 0.95) ? 0.1 : 1.0;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(width * 0.38, height * 0.42), width: width * 0.08, height: height * 0.05 * blinkFactor),
      eyePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(width * 0.62, height * 0.42), width: width * 0.08, height: height * 0.05 * blinkFactor),
      eyePaint,
    );

    if (blinkFactor > 0.5) {
      final highlightPaint = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(width * 0.39, height * 0.41), width * 0.012, highlightPaint);
      canvas.drawCircle(Offset(width * 0.63, height * 0.41), width * 0.012, highlightPaint);
    }

    // Eyebrows
    final browPaint = Paint()
      ..color = const Color(0xFF3D2B1F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final leftBrow = Path()
      ..moveTo(width * 0.33, height * 0.36)
      ..quadraticBezierTo(width * 0.38, height * 0.34, width * 0.43, height * 0.36);
    canvas.drawPath(leftBrow, browPaint);

    final rightBrow = Path()
      ..moveTo(width * 0.57, height * 0.36)
      ..quadraticBezierTo(width * 0.62, height * 0.34, width * 0.67, height * 0.36);
    canvas.drawPath(rightBrow, browPaint);

    // Lips
    final lipPath = Path();
    lipPath.moveTo(width * 0.43, height * 0.52);
    lipPath.quadraticBezierTo(width * 0.5, height * 0.57, width * 0.57, height * 0.52);
    lipPath.quadraticBezierTo(width * 0.5, height * 0.54, width * 0.43, height * 0.52);
    canvas.drawPath(lipPath, lipPaint);

    // Hair
    final hairPath = Path();
    hairPath.moveTo(width * 0.25, height * 0.35);
    hairPath.cubicTo(width * 0.22, height * 0.12, width * 0.78, height * 0.12, width * 0.75, height * 0.35);
    hairPath.cubicTo(width * 0.70, height * 0.20, width * 0.30, height * 0.20, width * 0.25, height * 0.35);
    canvas.drawPath(hairPath, hairPaint);

    canvas.drawOval(Rect.fromLTWH(width * 0.24, height * 0.25, width * 0.08, height * 0.25), hairPaint);
    canvas.drawOval(Rect.fromLTWH(width * 0.68, height * 0.25, width * 0.08, height * 0.25), hairPaint);

    final pinPaint = Paint()..color = const Color(0xFFFFD700);
    canvas.drawCircle(Offset(width * 0.74, height * 0.23), width * 0.025, pinPaint);
  }

  @override
  bool shouldRepaint(covariant KoreanWomanAvatarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class KoreanWomanAvatar extends StatefulWidget {
  final double size;
  const KoreanWomanAvatar({super.key, this.size = 250});

  @override
  State<KoreanWomanAvatar> createState() => _KoreanWomanAvatarState();
}

class _KoreanWomanAvatarState extends State<KoreanWomanAvatar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: KoreanWomanAvatarPainter(animationValue: _controller.value),
        );
      },
    );
  }
}

// ================= AVATAR PAGE (AUTO-SPEAK ON LOAD) =================
class AvatarPage extends StatefulWidget {
  const AvatarPage({super.key});

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  
  bool _isListening = false;
  String _dialogText = "";

  @override
  void initState() {
    super.initState();
    _initTtsAndSpeak();
  }

  void _initTtsAndSpeak() async {
    final langCode = LanguageManager.of(context).currentLocale.languageCode;
    await _flutterTts.setLanguage(langCode == 'ko' ? "ko-KR" : "en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.85);

    // Auto-speak greeting after widget finishes building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final greeting = AppLocalizations.of(context).translate('avatar_greet');
      _speakText(greeting);
    });
  }

  void _speakText(String text) async {
    await _flutterTts.speak(text);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _dialogText = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final String greeting = local.translate('avatar_greet');

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.pink.shade50,
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.15),
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: const KoreanWomanAvatar(size: 240),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.pink.shade200, width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Text(
                _dialogText.isNotEmpty ? _dialogText : greeting,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isListening ? Colors.red : Colors.pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  icon: Icon(_isListening ? Icons.mic_off : Icons.mic, size: 28),
                  label: Text(local.translate('btn_speak'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: _listen,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  icon: const Icon(Icons.volume_up, size: 28),
                  label: Text(local.translate('btn_listen'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: () => _speakText(_dialogText.isNotEmpty ? _dialogText : greeting),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// ================= DASHBOARD PAGE =================
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Widget _buildInformativeCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Widget statusWidget,
    required VoidCallback onTap,
    Color accentColor = Colors.green,
    bool isAlert = false,
  }) {
    return Card(
      elevation: isAlert ? 5 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: accentColor.withOpacity(0.15),
        child: Container(
          decoration: isAlert
              ? BoxDecoration(
                  border: Border.all(color: Colors.red.shade300, width: 2),
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.red.shade50,
                )
              : null,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 28, color: isAlert ? Colors.red : accentColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isAlert ? Colors.red.shade900 : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(child: statusWidget),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToFeature(BuildContext context, String featureName) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$featureName metric opened.'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _triggerEmergencySystem(BuildContext context, dynamic local) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.gpp_maybe, size: 50, color: Colors.red),
        title: Text(
          local.translate('card_emer'), 
          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Connecting to emergency services and notifying caregiver...",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          SizedBox(
            width: 140,
            height: 50,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
              child: Text(local.translate('cancel'), style: const TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    
    bool isKo = false;
    try {
      isKo = Localizations.localeOf(context).languageCode == 'ko';
    } catch (_) {}

    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
        children: [
          _buildInformativeCard(
            context: context,
            title: local.translate('card_med'),
            icon: Icons.medication,
            accentColor: Colors.purple,
            onTap: () => _navigateToFeature(context, local.translate('card_med')),
            statusWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isKo ? "오후 1:00" : "1:00 PM",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.purple),
                ),
                const SizedBox(height: 4),
                Text(
                  isKo ? "혈압약 • 식후 30분" : "Blood Pressure\nCapsule",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
          _buildInformativeCard(
            context: context,
            title: local.translate('card_health'),
            icon: Icons.favorite,
            accentColor: Colors.teal,
            onTap: () => _navigateToFeature(context, local.translate('card_health')),
            statusWidget: Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(
                  width: 65,
                  height: 65,
                  child: CircularProgressIndicator(
                    value: 0.72,
                    strokeWidth: 8,
                    backgroundColor: Colors.black12,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("72%", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    Text(isKo ? "걸음수" : "Steps", style: const TextStyle(fontSize: 10, color: Colors.black54)),
                  ],
                )
              ],
            ),
          ),
          _buildInformativeCard(
            context: context,
            title: local.translate('card_maps'),
            icon: Icons.map,
            accentColor: Colors.blue,
            onTap: () => _navigateToFeature(context, local.translate('card_maps')),
            statusWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.gpp_good, color: Colors.blue, size: 30),
                const SizedBox(height: 4),
                Text(
                  isKo ? "안심 구역 내 계심" : "Inside Safe Zone",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.blueGrey),
                ),
              ],
            ),
          ),
          _buildInformativeCard(
            context: context,
            title: local.translate('card_comm'),
            icon: Icons.groups,
            accentColor: Colors.orange,
            onTap: () => _navigateToFeature(context, local.translate('card_comm')),
            statusWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isKo ? "내일 일정" : "Tomorrow",
                  style: const TextStyle(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  isKo ? "복지관 노래교실\n오전 10시" : "Senior Center\nSinging at 10 AM",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
              ],
            ),
          ),
          _buildInformativeCard(
            context: context,
            title: local.translate('card_care'),
            icon: Icons.family_restroom,
            accentColor: Colors.green,
            onTap: () => _navigateToFeature(context, local.translate('card_care')),
            statusWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.mail, size: 16, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  isKo ? "아들이 보낸 메시지\n\"저녁에 방문할게요\"" : "Son's Note:\n\"Visiting at 6pm!\"",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.black87),
                ),
              ],
            ),
          ),
          _buildInformativeCard(
            context: context,
            title: local.translate('card_emer'),
            icon: Icons.warning,
            isAlert: true,
            onTap: () => _triggerEmergencySystem(context, local),
            statusWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.touch_app, color: Colors.red, size: 28),
                const SizedBox(height: 4),
                Text(
                  isKo ? "긴급 호출\n(즉시 전송)" : "TAP TO CALL\nEMERGENCY",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= RESTORED FULL PROFILE PAGE =================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final fontManager = FontSizeManager.of(context);
    final langManager = LanguageManager.of(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // User Profile Header
        Center(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 45,
                backgroundColor: Colors.pinkAccent,
                child: Icon(Icons.person, size: 55, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                local.translate('user_guest'),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Divider(),

        // Font Size Setting
        ListTile(
          leading: const Icon(Icons.text_fields, color: Colors.pinkAccent),
          title: Text(
            local.translate('set_font'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(local.translate('set_font_sub')),
          trailing: DropdownButton<FontSizePreset>(
            value: fontManager.currentPreset,
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(
                value: FontSizePreset.small,
                child: Text(local.translate('font_small')),
              ),
              DropdownMenuItem(
                value: FontSizePreset.medium,
                child: Text(local.translate('font_medium')),
              ),
              DropdownMenuItem(
                value: FontSizePreset.large,
                child: Text(local.translate('font_large')),
              ),
            ],
            onChanged: (preset) {
              if (preset != null) {
                fontManager.changeFontSize(preset);
              }
            },
          ),
        ),
        const Divider(),

        // Language Setting Switch (English <-> Korean)
        ListTile(
          leading: const Icon(Icons.language, color: Colors.pinkAccent),
          title: Text(
            local.translate('set_lang'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(local.translate('set_lang_sub')),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                langManager.currentLocale.languageCode == 'ko' ? '한국어' : 'English',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pinkAccent),
              ),
              const SizedBox(width: 8),
              Switch(
                value: langManager.currentLocale.languageCode == 'ko',
                activeColor: Colors.pinkAccent,
                onChanged: (isKo) {
                  langManager.changeLanguage(Locale(isKo ? 'ko' : 'en'));
                },
              ),
            ],
          ),
        ),
        const Divider(),

        // About Application
        ListTile(
          leading: const Icon(Icons.info_outline, color: Colors.pinkAccent),
          title: Text(
            local.translate('set_about'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: const Text('ElderConnect v1.0.0'),
          onTap: () {
            showAboutDialog(
              context: context,
              applicationName: 'ElderConnect',
              applicationVersion: '1.0.0',
              applicationIcon: const Icon(Icons.elderly, size: 40, color: Colors.pinkAccent),
            );
          },
        ),
      ],
    );
  }
}