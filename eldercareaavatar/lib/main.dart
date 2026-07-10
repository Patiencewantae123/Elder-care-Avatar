import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Added missing imports for your social sign-in tools
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

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
      'avatar_greet': 'Hello!\nHow are you feeling today?',
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
      'avatar_greet': '안녕하세요!\n오늘 기분은 어떠신가요?',
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
  bool shouldReload(_AppLocalizationsDelegate old) => true; 
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
  Locale _currentLocale = const Locale('en');
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
  FontSizePreset _currentPreset = FontSizePreset.medium;
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
        colorSchemeSeed: Colors.green,
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

// ================= LOGIN PAGE =================
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      debugPrint("Attempting Google Sign-In...");
      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
      }
    } catch (error) {
      debugPrint("Google Sign In Failed: $error");
    }
  }

  Future<void> _handleKakaoSignIn(BuildContext context) async {
    try {
      debugPrint("Attempting Kakao Sign-In...");
      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
      }
    } catch (error) {
      debugPrint("Kakao Sign In Failed: $error");
    }
  }

  Future<void> _handleNaverSignIn(BuildContext context) async {
    try {
      debugPrint("Attempting Naver Sign-In...");
      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
      }
    } catch (error) {
      debugPrint("Naver Sign In Failed: $error");
    }
  }

  Widget _socialLoginButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
    Widget? icon,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[icon, const SizedBox(width: 8)],
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.favorite, color: Colors.white, size: 50),
                ),
                const SizedBox(height: 20),
                Text(
                  local.translate('title'),
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    labelText: local.translate('email'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: local.translate('password'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
                    },
                    child: Text(local.translate('login')),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
                  },
                  child: Text(local.translate('guest')),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(local.translate('or_connect'), style: const TextStyle(color: Colors.grey)),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                ),
                _socialLoginButton(
                  label: local.translate('google'),
                  color: Colors.white,
                  textColor: Colors.black87,
                  icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.red),
                  onPressed: () => _handleGoogleSignIn(context),
                ),
                const SizedBox(height: 10),
                _socialLoginButton(
                  label: local.translate('kakao'),
                  color: const Color(0xFFFEE500),
                  textColor: const Color(0xFF191919),
                  icon: const Icon(Icons.chat_bubble, size: 18, color: Color(0xFF191919)),
                  onPressed: () => _handleKakaoSignIn(context),
                ),
                const SizedBox(height: 10),
                _socialLoginButton(
                  label: local.translate('naver'),
                  color: const Color(0xFF03C75A),
                  textColor: Colors.white,
                  icon: const Text("N", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 18)),
                  onPressed: () => _handleNaverSignIn(context),
                ),
              ],
            ),
          ),
        ),
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

  Widget card(String title, IconData icon) {
    return Card(
      child: SizedBox(
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 35, color: Colors.green),
              const SizedBox(height: 8),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(15),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          card(local.translate('card_med'), Icons.medication),
          card(local.translate('card_health'), Icons.favorite),
          card(local.translate('card_maps'), Icons.map),
          card(local.translate('card_comm'), Icons.groups),
          card(local.translate('card_emer'), Icons.warning),
          card(local.translate('card_care'), Icons.family_restroom),
        ],
      ),
    );
  }
}

// ================= AVATAR PAGE =================
// ================= AVATAR PAGE (UPDATED WITH STATE & ENGINE CORES) =================
class AvatarPage extends StatefulWidget {
  const AvatarPage({super.key});

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  String _avatarResponseText = "";
  bool _isListening = false;
  bool _isAvatarSpeaking = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Default initial greeting text
    _avatarResponseText = "Hello!\nHow are you feeling today?";
  }

  // --- CONNECTS TO YOUR COMPANION BACKEND ---
  Future<void> _sendMessageToBackend(String userQuery) async {
    if (userQuery.trim().isEmpty) return;

    setState(() {
      _avatarResponseText = "..."; // Loading indicator
      _isAvatarSpeaking = true;
    });

    try {
      // TODO: Replace this with your actual HTTP URL call to your Python/Node server
      // final response = await http.post(
      //   Uri.parse('https://your-backend-api.com/chat'),
      //   body: jsonEncode({'userId': 'elderly_user_01', 'message': userQuery}),
      // );
      // Map data = jsonDecode(response.body);
      
      // Mocking a response with simulated long term memory recall
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _avatarResponseText = "I remember you mentioned your knee was hurting yesterday. Is it feeling any better now after your rest?";
        _isAvatarSpeaking = false;
      });
    } catch (e) {
      setState(() {
        _avatarResponseText = "I'm having trouble connecting right now. Let's try again.";
        _isAvatarSpeaking = false;
      });
    }
  }

  // --- SHOW TEXT BOX MANUAL INPUT ---
  void _showTypeDialog(BuildContext context, AppLocalizations local) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(local.translate('btn_type')),
        content: TextField(
          controller: _textController,
          autofocus: true,
          decoration: const InputDecoration(hintText: "Type a response..."),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(local.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              final text = _textController.text;
              Navigator.pop(context);
              _textController.clear();
              _sendMessageToBackend(text);
            },
            child: Text(local.translate('done')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // NOTE: Replace this CircleAvatar widget later with HeyGen / D-ID video surface player
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isAvatarSpeaking ? Colors.blue : Colors.green, 
                  width: 4
                ),
              ),
              child: CircleAvatar(
                radius: 75,
                backgroundColor: _isAvatarSpeaking ? Colors.blue.shade100 : Colors.green.shade100,
                child: Icon(
                  _isAvatarSpeaking ? Icons.record_voice_over : Icons.elderly, 
                  size: 80, 
                  color: _isAvatarSpeaking ? Colors.blue : Colors.green
                ),
              ),
            ),
            const SizedBox(height: 25),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  _avatarResponseText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, height: 1.4),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // SPEECH TO TEXT TRIGGER
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: _isListening ? Colors.red : Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _isListening = !_isListening;
                });
                if (_isListening) {
                  // Simulate picking up microphone speech input after 3 seconds
                  Future.delayed(const Duration(seconds: 3), () {
                    if (mounted && _isListening) {
                      setState(() => _isListening = false);
                      _sendMessageToBackend("I feel a bit lonely today.");
                    }
                  });
                }
              },
              icon: Icon(_isListening ? Icons.stop : Icons.mic, size: 24),
              label: Text(_isListening ? "Listening..." : local.translate('btn_speak')),
            ),
            const SizedBox(height: 12),
            // KEYBOARD TEXT OVERRIDE
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: const Size(200, 45)),
              onPressed: () => _showTypeDialog(context, local),
              icon: const Icon(Icons.keyboard),
              label: Text(local.translate('btn_type')),
            ),
            const SizedBox(height: 12),
            // RE-PLAY VOICE SPEECH AUDIO
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 45)),
              onPressed: () {
                // Trigger Text-to-Speech playback of context text manually if needed
              },
              icon: const Icon(Icons.volume_up),
              label: Text(local.translate('btn_listen')),
            ),
          ],
        ),
      ),
    );
  }
}r

// ================= PROFILE / SETTINGS PAGE =================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showFontSettingsDialog(BuildContext context) {
    final fontManager = FontSizeManager.of(context);
    final local = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(local.translate('set_font')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<FontSizePreset>(
                title: Text(local.translate('font_small'), style: const TextStyle(fontSize: 14)),
                value: FontSizePreset.small,
                groupValue: fontManager.currentPreset,
                onChanged: (value) {
                  if (value != null) {
                    fontManager.changeFontSize(value);
                    Navigator.pop(context); 
                  }
                },
              ),
              RadioListTile<FontSizePreset>(
                title: Text(local.translate('font_medium'), style: const TextStyle(fontSize: 16)),
                value: FontSizePreset.medium,
                groupValue: fontManager.currentPreset,
                onChanged: (value) {
                  if (value != null) {
                    fontManager.changeFontSize(value);
                    Navigator.pop(context);
                  }
                },
              ),
              RadioListTile<FontSizePreset>(
                title: Text(local.translate('font_large'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                value: FontSizePreset.large,
                groupValue: fontManager.currentPreset,
                onChanged: (value) {
                  if (value != null) {
                    fontManager.changeFontSize(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageSettingsDialog(BuildContext context) {
    final langManager = LanguageManager.of(context);
    final local = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(local.translate('set_lang')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<Locale>(
                title: const Text("English (🇺🇸)"),
                value: const Locale('en'),
                groupValue: langManager.currentLocale,
                onChanged: (value) {
                  if (value != null) {
                    langManager.changeLanguage(value);
                    Navigator.pop(context); 
                  }
                },
              ),
              RadioListTile<Locale>(
                title: const Text("한국어 (🇰🇷)"),
                value: const Locale('ko'),
                groupValue: langManager.currentLocale,
                onChanged: (value) {
                  if (value != null) {
                    langManager.changeLanguage(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    return ListView(
      children: [
        const SizedBox(height: 30),
        const CircleAvatar(
          radius: 50,
          child: Icon(Icons.person, size: 50),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            local.translate('user_guest'),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.text_fields),
          title: Text(local.translate('set_font')),
          subtitle: Text(local.translate('set_font_sub')),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showFontSettingsDialog(context),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(local.translate('set_lang')),
          subtitle: Text(local.translate('set_lang_sub')),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showLanguageSettingsDialog(context),
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: Text(local.translate('set_about')),
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: Text(local.translate('set_logout'), style: const TextStyle(color: Colors.red)),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(local.translate('set_logout')),
                content: Text(local.translate('logout_confirm')),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(local.translate('cancel')),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                      );
                    },
                    child: Text(local.translate('set_logout')),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}