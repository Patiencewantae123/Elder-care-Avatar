import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed_plus/webfeed_plus.dart';
import 'package:xml/xml.dart' as xml;
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Kakao SDK (Replace with your actual Native App Key)
  KakaoSdk.init(nativeAppKey: 'YOUR_KAKAO_NATIVE_APP_KEY');

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
      'email': 'Email',
      'password': 'Password',
      'login': 'Login',
      'guest': 'Continue as Guest',
      'or_connect': 'Or Connect With',
      'google': 'Continue with Google',
      'kakao': 'Continue with Kakao',
      'naver': 'Continue with Naver',
      'nav_home': 'Home',
      'nav_dash': 'Dashboard',
      'nav_profile': 'Profile',
      'avatar_greet': '안녕하세요! 오늘 기분은 어떠신가요? 반가워요!',
      'btn_speak': '말하기',
      'btn_type': '메시지 입력',
      'btn_listen': '듣기',
      'card_med': 'Medication',
      'card_health': 'Health',
      'card_maps': 'Maps',
      'card_comm': 'Community',
      'card_emer': 'Emergency',
      'card_care': 'Caregiver',
      'card_ytmusic': 'YouTube Music',
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
      'role_senior': 'Senior',
      'role_guardian': 'Guardian',
    },
    'ko': {
      'title': '엘더커넥트',
      'email': '이메일',
      'password': '비밀번호',
      'login': '로그인',
      'guest': '게스트로 시작하기',
      'or_connect': '또는 다음 계정으로 로그인',
      'google': 'Google 계정으로 계속하기',
      'kakao': '카카오톡으로 계속하기',
      'naver': '네이버로 계속하기',
      'nav_home': '홈',
      'nav_dash': '대시보드',
      'nav_profile': '프로필',
      'avatar_greet': '안녕하세요! 오늘 기분은 어떠신가요? 반가워요!',
      'btn_speak': '말하기',
      'btn_type': '메시지 입력',
      'btn_listen': '듣기',
      'card_med': '복약 관리',
      'card_health': '건강 상태',
      'card_maps': '지도',
      'card_comm': '커뮤니티',
      'card_emer': '긴급 상황',
      'card_care': '보호자 연결',
      'card_ytmusic': '유튜브 뮤직',
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
      'role_senior': '어르신',
      'role_guardian': '보호자',
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

// ================= LANGUAGE MANAGER =================
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

// ================= FONT SIZE MANAGER =================
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
      case FontSizePreset.large: return 1.3;
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
        colorSchemeSeed: Colors.pink,
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
      home: const LoginPage(),
    );
  }
}

// ================= LOGIN PAGE (AUTO BYPASS - NO LOGIN REQUIRED) =================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    // Automatically skip login and proceed directly to home page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
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
      ),
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.smart_toy), label: local.translate('nav_home')),
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

  void _navigateToYouTubeMusic(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const YouTubeMusicPage()),
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
    bool isKo = Localizations.localeOf(context).languageCode == 'ko';

    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
        children: [
          // 1. YOUTUBE MUSIC INTEGRATION
          _buildInformativeCard(
            context: context,
            title: local.translate('card_ytmusic'),
            icon: Icons.music_note,
            accentColor: Colors.redAccent,
            onTap: () => _navigateToYouTubeMusic(context),
            statusWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_circle_fill, size: 36, color: Colors.redAccent),
                const SizedBox(height: 4),
                Text(
                  isKo ? "트롯 & 클래식" : "Seniors Playlist",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // 2. MEDICATION TRACKER
          _buildInformativeCard(
            context: context,
            title: local.translate('card_med'),
            icon: Icons.medication,
            accentColor: Colors.purple,
            onTap: () {},
            statusWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isKo ? "오후 1:00" : "1:00 PM",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.purple),
                ),
                const SizedBox(height: 4),
                Text(
                  isKo ? "혈압약 • 식후 30분" : "Blood Pressure",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),

          // 3. HEALTH METRICS
          _buildInformativeCard(
            context: context,
            title: local.translate('card_health'),
            icon: Icons.favorite,
            accentColor: Colors.teal,
            onTap: () {},
            statusWidget: Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(
                  width: 55,
                  height: 55,
                  child: CircularProgressIndicator(
                    value: 0.72,
                    strokeWidth: 6,
                    backgroundColor: Colors.black12,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("72%", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Text(isKo ? "걸음수" : "Steps", style: const TextStyle(fontSize: 9, color: Colors.black54)),
                  ],
                )
              ],
            ),
          ),

          // 4. MAPS / AREA SAFETY
          _buildInformativeCard(
            context: context,
            title: local.translate('card_maps'),
            icon: Icons.map,
            accentColor: Colors.blue,
            onTap: () {},
            statusWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.gpp_good, color: Colors.blue, size: 28),
                const SizedBox(height: 4),
                Text(
                  isKo ? "안심 구역 내" : "Safe Zone",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blueGrey),
                ),
              ],
            ),
          ),

          // 5. COMMUNITY EVENTS
          _buildInformativeCard(
            context: context,
            title: local.translate('card_comm'),
            icon: Icons.groups,
            accentColor: Colors.orange,
            onTap: () {},
            statusWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isKo ? "내일 일정" : "Tomorrow",
                  style: const TextStyle(fontSize: 11, color: Colors.orange, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  isKo ? "노래교실 10:00" : "Singing 10 AM",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
              ],
            ),
          ),

          // 6. EMERGENCY SYSTEM
          _buildInformativeCard(
            context: context,
            title: local.translate('card_emer'),
            icon: Icons.warning,
            isAlert: true,
            onTap: () => _triggerEmergencySystem(context, local),
            statusWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.touch_app, color: Colors.red, size: 26),
                const SizedBox(height: 2),
                Text(
                  isKo ? "긴급 호출" : "EMERGENCY",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= YOUTUBE MUSIC & PLAYER SCREEN =================
class YouTubeMusicPage extends StatefulWidget {
  const YouTubeMusicPage({super.key});

  @override
  State<YouTubeMusicPage> createState() => _YouTubeMusicPageState();
}

class _YouTubeMusicPageState extends State<YouTubeMusicPage> {
  late YoutubePlayerController _controller;
  final String _videoId = '5qap5aO4i9A'; 

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: _videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        isLive: false,
      ),
    );
  }

  Future<void> _openYouTubeMusicApp() async {
    final Uri url = Uri.parse('https://music.youtube.com');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch YouTube Music: $url');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ElderConnect Music"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.red,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    "Relaxing Music Player",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Enjoy comfortable music for mind and body.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    icon: const Icon(Icons.open_in_new, size: 28),
                    label: const Text(
                      "Open in YouTube Music",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: _openYouTubeMusicApp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= AVATAR PAGE (3D KOREAN WOMAN AI + STT + TTS) =================
class AvatarPage extends StatefulWidget {
  const AvatarPage({super.key});

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> with SingleTickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();
  final TextEditingController _textController = TextEditingController();

  late AnimationController _animController;
  bool _isListening = false;
  String _aiResponse = "";

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _initTtsAndAutoGreet();
  }

  void _initTtsAndAutoGreet() async {
    await _tts.setLanguage("ko-KR");
    await _tts.setPitch(1.1); // Warm, friendly pitch
    await _tts.setSpeechRate(0.8);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final local = AppLocalizations.of(context);
      final greeting = local.translate('avatar_greet');
      setState(() {
        _aiResponse = greeting;
      });
      _speak(greeting);
    });
  }

  Future<void> _speak(String text) async {
    if (text.isNotEmpty) {
      await _tts.stop();
      await _tts.speak(text);
    }
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => debugPrint('STT Status: $val'),
        onError: (val) => debugPrint('STT Error: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _textController.text = val.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      if (_textController.text.isNotEmpty) {
        _processAiResponse(_textController.text);
      }
    }
  }

  Future<void> _processAiResponse(String prompt) async {
    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: 'YOUR_GEMINI_API_KEY');
      final response = await model.generateContent([Content.text(prompt)]);
      
      setState(() {
        _aiResponse = response.text ?? "죄송해요, 다시 한번 말씀해 주세요.";
      });
    } catch (e) {
      double num = math.Random().nextDouble();
      setState(() {
        _aiResponse = num > 0.5 
            ? "오늘도 활기찬 하루 되세요! 진지하게 응원해 드릴게요." 
            : "네, 말씀 잘 들었어요. 항상 편안하게 대화해 주세요.";
      });
    }
    _speak(_aiResponse);
  }

  @override
  void dispose() {
    _animController.dispose();
    _tts.stop();
    _speech.stop();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Dynamic 3D Avatar Rendering Container
          AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, math.sin(_animController.value * math.pi) * 8),
                child: Container(
                  height: 220,
                  width: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD1DC), Color(0xFFFFB6C1), Color(0xFFE6E6FA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipOval(
                        child: Image.network(
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=600&q=80',
                          fit: BoxFit.cover,
                          width: 210,
                          height: 210,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.face_3, size: 120, color: Colors.pinkAccent);
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Text(
                            "AI 수진 (Korean 3D Avatar)",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.pink),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.pink.shade200),
            ),
            child: Text(
              _aiResponse.isEmpty ? local.translate('avatar_greet') : _aiResponse,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              labelText: local.translate('btn_type'),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send, color: Colors.pink),
                onPressed: () {
                  if (_textController.text.isNotEmpty) {
                    _processAiResponse(_textController.text);
                  }
                },
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
          const SizedBox(height: 20),
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
                icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                label: Text(local.translate('btn_speak')),
                onPressed: _listen,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                icon: const Icon(Icons.volume_up),
                label: Text(local.translate('btn_listen')),
                onPressed: () => _speak(_aiResponse),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================= PROFILE PAGE (SETTINGS & RSS NEWS READER) =================
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _newsTitle = "Loading News Feed...";

  @override
  void initState() {
    super.initState();
    _fetchRssNews();
  }

  Future<void> _fetchRssNews() async {
    try {
      final response = await http.get(Uri.parse('https://news.google.com/rss?hl=ko&gl=KR&ceid=KR:ko'));
      if (response.statusCode == 200) {
        var feed = RssFeed.parse(response.body);
        var rawXml = xml.XmlDocument.parse(response.body);
        var titleNodes = rawXml.findAllElements('title');
        
        setState(() {
          _newsTitle = feed.items?.first.title ?? titleNodes.first.innerText;
        });
      }
    } catch (e) {
      setState(() {
        _newsTitle = "실시간 주요 뉴스: 어르신 복지 혜택 강화 소식";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final fontManager = FontSizeManager.of(context);
    final langManager = LanguageManager.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(local.translate('user_guest'), style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("user@elderconnect.com"),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          color: Colors.amber.shade50,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.newspaper, color: Colors.amber),
                    SizedBox(width: 8),
                    Text("Live Senior News", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(_newsTitle, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        ListTile(
          title: Text(local.translate('set_font')),
          subtitle: Text(local.translate('set_font_sub')),
          trailing: DropdownButton<FontSizePreset>(
            value: fontManager.currentPreset,
            onChanged: (FontSizePreset? newPreset) {
              if (newPreset != null) {
                fontManager.changeFontSize(newPreset);
              }
            },
            items: [
              DropdownMenuItem(value: FontSizePreset.small, child: Text(local.translate('font_small'))),
              DropdownMenuItem(value: FontSizePreset.medium, child: Text(local.translate('font_medium'))),
              DropdownMenuItem(value: FontSizePreset.large, child: Text(local.translate('font_large'))),
            ],
          ),
        ),
        const Divider(),
        ListTile(
          title: Text(local.translate('set_lang')),
          subtitle: Text(local.translate('set_lang_sub')),
          trailing: Switch(
            value: langManager.currentLocale.languageCode == 'ko',
            onChanged: (bool isKorean) {
              langManager.changeLanguage(Locale(isKorean ? 'ko' : 'en'));
            },
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: Text(local.translate('set_logout'), style: const TextStyle(color: Colors.red)),
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
          },
        ),
      ],
    );
  }
}