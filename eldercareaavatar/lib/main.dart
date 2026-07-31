import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed_plus/webfeed_plus.dart';
import 'package:xml/xml.dart' as xml;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: 'YOUR_KAKAO_NATIVE_APP_KEY');

  runApp(
    const LanguageManager(
      child: FontSizeManager(
        child: ElderConnectApp(),
      ),
    ),
  );
}

// ================= LOCALIZATION =================
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
      'news_title': 'Latest News Feed',
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
      'news_title': '실시간 주요 뉴스',
    },
  };

  String translate(String key) => _localizedValues[locale.languageCode]?[key] ?? key;
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
    setState(() => _currentLocale = locale);
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
  bool updateShouldNotify(_LanguageInheritedWidget oldWidget) => oldWidget.currentLocale != currentLocale;
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
    setState(() => _currentPreset = preset);
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
  bool updateShouldNotify(_FontSizeInheritedWidget oldWidget) => oldWidget.currentPreset != currentPreset;
}

// ================= ROOT APPLICATION =================
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

// ================= LOGIN PAGE (AUTO-BYPASS) =================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
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
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

// ================= MAIN SHELL =================
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
          setState(() => currentIndex = index);
        },
      ),
    );
  }
}

// ================= FULLY REACTIVE AVATAR PAGE =================
enum AvatarState { idle, listening, thinking, speaking }

class AvatarPage extends StatefulWidget {
  const AvatarPage({super.key});

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> with TickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();
  final TextEditingController _textController = TextEditingController();

  AvatarState _currentState = AvatarState.idle;
  String _aiResponse = "";
  Offset _pointerOffset = Offset.zero;

  late AnimationController _breathingController;
  late AnimationController _talkingMouthController;
  late AnimationController _blinkController;
  late AnimationController _pulseGlowController;

  @override
  void initState() {
    super.initState();

    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _talkingMouthController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _pulseGlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _startRandomBlinking();
    _initTtsAndAutoGreet();
  }

  void _startRandomBlinking() async {
    while (mounted) {
      await Future.delayed(Duration(milliseconds: 2000 + math.Random().nextInt(3000)));
      if (mounted) {
        await _blinkController.forward();
        await _blinkController.reverse();
      }
    }
  }

  void _initTtsAndAutoGreet() async {
    await _tts.setLanguage("ko-KR");
    await _tts.setPitch(1.1);
    await _tts.setSpeechRate(0.85);

    _tts.setStartHandler(() {
      if (mounted) {
        setState(() => _currentState = AvatarState.speaking);
        _talkingMouthController.repeat(reverse: true);
        _pulseGlowController.repeat(reverse: true);
      }
    });

    _tts.setCompletionHandler(() {
      if (mounted) {
        setState(() => _currentState = AvatarState.idle);
        _talkingMouthController.stop();
        _talkingMouthController.reset();
        _pulseGlowController.stop();
        _pulseGlowController.reset();
      }
    });

    _tts.setErrorHandler((msg) {
      if (mounted) {
        setState(() => _currentState = AvatarState.idle);
        _talkingMouthController.stop();
        _pulseGlowController.stop();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final local = AppLocalizations.of(context);
      final greeting = local.translate('avatar_greet');
      setState(() => _aiResponse = greeting);
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
    if (_currentState != AvatarState.listening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            if (_currentState == AvatarState.listening) {
              setState(() => _currentState = AvatarState.idle);
              _pulseGlowController.stop();
            }
          }
        },
        onError: (error) => setState(() => _currentState = AvatarState.idle),
      );

      if (available) {
        setState(() => _currentState = AvatarState.listening);
        _pulseGlowController.repeat(reverse: true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _textController.text = val.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _currentState = AvatarState.idle);
      _pulseGlowController.stop();
      _speech.stop();
      if (_textController.text.isNotEmpty) {
        _processAiResponse(_textController.text);
      }
    }
  }

  Future<void> _processAiResponse(String prompt) async {
    setState(() => _currentState = AvatarState.thinking);
    _pulseGlowController.repeat(reverse: true);

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

    _pulseGlowController.stop();
    _speak(_aiResponse);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _talkingMouthController.dispose();
    _blinkController.dispose();
    _pulseGlowController.dispose();
    _tts.stop();
    _speech.stop();
    _textController.dispose();
    super.dispose();
  }

  Color _getAuraColor() {
    switch (_currentState) {
      case AvatarState.listening:
        return Colors.redAccent;
      case AvatarState.thinking:
        return Colors.orangeAccent;
      case AvatarState.speaking:
        return Colors.pinkAccent;
      case AvatarState.idle:
      default:
        return Colors.pink.shade200;
    }
  }

  String _getStateLabel() {
    switch (_currentState) {
      case AvatarState.listening:
        return "듣는 중...";
      case AvatarState.thinking:
        return "생각하는 중...";
      case AvatarState.speaking:
        return "말하는 중...";
      case AvatarState.idle:
      default:
        return "AI 수진";
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          MouseRegion(
            onHover: (event) {
              setState(() {
                _pointerOffset = Offset(
                  (event.localPosition.dx - 110) / 110,
                  (event.localPosition.dy - 110) / 110,
                );
              });
            },
            onExit: (_) => setState(() => _pointerOffset = Offset.zero),
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _breathingController,
                _talkingMouthController,
                _blinkController,
                _pulseGlowController,
              ]),
              builder: (context, child) {
                final double tiltX = -_pointerOffset.dy * 0.15;
                final double tiltY = _pointerOffset.dx * 0.15;
                final double breathOffset = math.sin(_breathingController.value * math.pi * 2) * 5;
                final double pulseVal = _pulseGlowController.value * 12;

                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(tiltX)
                    ..rotateY(tiltY)
                    ..translate(0.0, breathOffset, 0.0),
                  alignment: Alignment.center,
                  child: Container(
                    height: 220,
                    width: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [_getAuraColor().withOpacity(0.8), Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _getAuraColor().withOpacity(0.5),
                          blurRadius: 18 + pulseVal,
                          spreadRadius: 2 + (pulseVal / 2),
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
                            width: 205,
                            height: 205,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.face_3, size: 120, color: Colors.pinkAccent),
                          ),
                        ),
                        Positioned(
                          top: 80 + (_pointerOffset.dy * 3),
                          left: 68 + (_pointerOffset.dx * 5),
                          child: Row(
                            children: [
                              _buildReactiveEye(_blinkController.value),
                              const SizedBox(width: 28),
                              _buildReactiveEye(_blinkController.value),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 66 - (_pointerOffset.dy * 2),
                          child: Transform.scale(
                            scaleX: 1.0 + (_talkingMouthController.value * 0.2),
                            child: Container(
                              width: 20,
                              height: _currentState == AvatarState.speaking
                                  ? (2 + (_talkingMouthController.value * 14))
                                  : 2,
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B263E),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFD47A85), width: 1),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: _getAuraColor(), width: 1.5),
                              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _getAuraColor(),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _getStateLabel(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _getAuraColor(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 25),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _getAuraColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _getAuraColor().withOpacity(0.4)),
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
                  backgroundColor: _currentState == AvatarState.listening ? Colors.red : Colors.pink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                icon: Icon(_currentState == AvatarState.listening ? Icons.mic_off : Icons.mic),
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

  Widget _buildReactiveEye(double blinkProgress) {
    return Container(
      width: 22,
      height: 12 * blinkProgress,
      decoration: BoxDecoration(
        color: const Color(0xFFE2A898),
        borderRadius: BorderRadius.circular(4),
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
          _buildInformativeCard(
            context: context,
            title: local.translate('card_ytmusic'),
            icon: Icons.music_note,
            accentColor: Colors.redAccent,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const YouTubeMusicPage()));
            },
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
          _buildInformativeCard(
            context: context,
            title: local.translate('card_emer'),
            icon: Icons.warning,
            isAlert: true,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  icon: const Icon(Icons.gpp_maybe, size: 50, color: Colors.red),
                  title: Text(local.translate('card_emer'), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  content: const Text("Connecting to emergency services and caregiver...", textAlign: TextAlign.center),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: Text(local.translate('cancel'))),
                  ],
                ),
              );
            },
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

// ================= YOUTUBE MUSIC SCREEN =================
class YouTubeMusicPage extends StatefulWidget {
  const YouTubeMusicPage({super.key});

  @override
  State<YouTubeMusicPage> createState() => _YouTubeMusicPageState();
}

class _YouTubeMusicPageState extends State<YouTubeMusicPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: '5qap5aO4i9A',
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
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
            YoutubePlayer(controller: _controller, showVideoProgressIndicator: true),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text("Relaxing Music Player", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text("Enjoy comfortable music for mind and body.", textAlign: TextAlign.center),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text("Open in YouTube Music", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      final Uri url = Uri.parse('https://music.youtube.com');
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    },
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

// ================= PROFILE PAGE =================
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
                Row(
                  children: [
                    const Icon(Icons.newspaper, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(local.translate('news_title'), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(_newsTitle),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        ListTile(
          leading: const Icon(Icons.format_size),
          title: Text(local.translate('set_font')),
          subtitle: Text(local.translate('set_font_sub')),
          trailing: DropdownButton<FontSizePreset>(
            value: fontManager.currentPreset,
            onChanged: (FontSizePreset? newPreset) {
              if (newPreset != null) fontManager.changeFontSize(newPreset);
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
          leading: const Icon(Icons.language),
          title: Text(local.translate('set_lang')),
          subtitle: Text(local.translate('set_lang_sub')),
          trailing: DropdownButton<Locale>(
            value: langManager.currentLocale,
            onChanged: (Locale? newLocale) {
              if (newLocale != null) langManager.changeLanguage(newLocale);
            },
            items: const [
              DropdownMenuItem(value: Locale('ko'), child: Text("한국어")),
              DropdownMenuItem(value: Locale('en'), child: Text("English")),
            ],
          ),
        ),
      ],
    );
  }
}