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
  FontSizePreset _currentPreset = FontSizePreset.large; // Default changed to large for elderly users
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
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Keeps track of the selected role ('senior' or 'guardian')
  String _selectedRole = 'senior'; 

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      debugPrint("Attempting Google Sign-In as $_selectedRole...");
      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
      }
    } catch (error) {
      debugPrint("Google Sign In Failed: $error");
    }
  }

  Future<void> _handleKakaoSignIn(BuildContext context) async {
    try {
      debugPrint("Attempting Kakao Sign-In as $_selectedRole...");
      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
      }
    } catch (error) {
      debugPrint("Kakao Sign In Failed: $error");
    }
  }

  Future<void> _handleNaverSignIn(BuildContext context) async {
    try {
      debugPrint("Attempting Naver Sign-In as $_selectedRole...");
      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
      }
    } catch (error) {
      debugPrint("Naver Sign In Failed: $error");
    }
  }

  /// Opens a workflow selection sheet specifically for registering new credentials
  void _showSignUpSheet(BuildContext context, String seniorLabel, String guardianLabel) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Sign Up / 회원가입",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Choose your profile type to begin configuration",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade50,
                        foregroundColor: Colors.green.shade900,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        side: BorderSide(color: Colors.green.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      icon: const Icon(Icons.elderly, size: 28),
                      label: Text(seniorLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.pop(context);
                        debugPrint("Navigating to Senior Signup form...");
                        // TODO: Add your custom navigation target to your Senior Sign Up page form here
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                        foregroundColor: Colors.blue.shade900,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        side: BorderSide(color: Colors.blue.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      icon: const Icon(Icons.family_restroom, size: 28),
                      label: Text(guardianLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.pop(context);
                        debugPrint("Navigating to Guardian Signup form...");
                        // TODO: Add your custom navigation target to your Guardian Sign Up page form here
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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

  Widget _buildRoleSegmentButton({
    required String roleKey,
    required String title,
    required IconData icon,
  }) {
    final isSelected = _selectedRole == roleKey;
    return Expanded(
      child: OutlinedButton.icon(
        icon: Icon(icon, color: isSelected ? Colors.white : Colors.green),
        label: Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: isSelected ? Colors.green : Colors.transparent,
          foregroundColor: isSelected ? Colors.white : Colors.green,
          side: const BorderSide(color: Colors.green, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          setState(() {
            _selectedRole = roleKey;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    
    // Fallback localization handlers
    final seniorText = local.translate('role_senior').isEmpty ? "Senior" : local.translate('role_senior');
    final guardianText = local.translate('role_guardian').isEmpty ? "Guardian" : local.translate('role_guardian');

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
                const SizedBox(height: 25),
                
                // ROLE SELECTION TABS
                Row(
                  children: [
                    _buildRoleSegmentButton(
                      roleKey: 'senior',
                      title: seniorText,
                      icon: Icons.elderly,
                    ),
                    const SizedBox(width: 12),
                    _buildRoleSegmentButton(
                      roleKey: 'guardian',
                      title: guardianText,
                      icon: Icons.family_restroom,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                
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
                      debugPrint("Logging in as $_selectedRole");
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
                
                // --- SIGN UP NAVIGATION ACTION FOOTER ---
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? ", style: TextStyle(color: Colors.black54)),
                    GestureDetector(
                      onTap: () => _showSignUpSheet(context, seniorText, guardianText),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
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

  /// A highly visual, touch-friendly card that presents actionable data metrics.
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
          "Connecting to 911 dispatch and notifying your designated caregiver immediately...",
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
          // 1. MEDICATION TRACKER
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

          // 2. HEALTH METRICS
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

          // 3. MAPS / AREA SAFETY
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

          // 4. COMMUNITY EVENTS
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

          // 5. CAREGIVER BROADCASTS
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
// ================= AVATAR PAGE (INTEGRATED WITH STT & TTS) =================
class AvatarPage extends StatefulWidget {
  const AvatarPage({super.key});

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  String _avatarResponseText = "";
  bool _isListening = false;
  bool _isAvatarSpeaking = false;
  String? _suggestedYoutubeUrl; // Stores active YouTube link if AI recommends one
  final TextEditingController _textController = TextEditingController();

  // STT and TTS Native instances
  final stt.SpeechToText _speechEngine = stt.SpeechToText();
  final FlutterTts _ttsEngine = FlutterTts();

  // YouTube Player Controller
  YoutubePlayerController? _youtubeController;

  // Korean News Feed State Variables
  List<RssItem> _newsItems = [];
  bool _isLoadingNews = false;
  String? _newsErrorMessage;

  // ================= FRIEND & STORY PERSONALIZATION MEMORY =================
  final List<Map<String, String>> _conversationMemory = [];

  final Map<String, String> _userPersonalDetails = {
    'userName': 'Mary',
    'medicalHistory': 'right knee pain reported yesterday',
    'familyMembers': 'grandson Tommy',
    'hobbies': 'gardening, listening to old trot music',
    'favoriteYoutube': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  };
  // =========================================================================

  @override
  void initState() {
    super.initState();
    _fetchKoreanNews();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerInitialGreeting();
    });
  }

  @override
  void dispose() {
    _ttsEngine.stop();
    _speechEngine.stop();
    _textController.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  /// Fetches recent Korean headlines using Yonhap RSS
  Future<void> _fetchKoreanNews() async {
    setState(() {
      _isLoadingNews = true;
      _newsErrorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://www.yonhapnewstv.co.kr/browse/feed/'),
      );

      if (response.statusCode == 200) {
        final feed = RssFeed.parse(response.body);
        setState(() {
          _newsItems = feed.items ?? [];
          _isLoadingNews = false;
        });
      } else {
        setState(() {
          _newsErrorMessage = '뉴스 데이터를 불러올 수 없습니다 (Error: ${response.statusCode})';
          _isLoadingNews = false;
        });
      }
    } catch (e) {
      setState(() {
        _newsErrorMessage = '네트워크 오류가 발생했습니다.';
        _isLoadingNews = false;
      });
    }
  }

  Future<void> _launchNewsUrl(String? urlString) async {
    if (urlString == null) return;
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _setupYoutubePlayer(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null) {
      if (_youtubeController == null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );
      } else {
        _youtubeController!.load(videoId);
      }
    }
  }

  void _triggerInitialGreeting() {
    final local = AppLocalizations.of(context);
    final currentLang = LanguageManager.of(context).currentLocale.languageCode;

    setState(() {
      _avatarResponseText = local.translate('avatar_greet');
    });

    _speakVoiceOutput(_avatarResponseText, currentLang);
  }

  Future<void> _speakVoiceOutput(String text, String languageCode) async {
    setState(() => _isAvatarSpeaking = true);

    String ttsTargetLocale = languageCode == 'ko' ? 'ko-KR' : 'en-US';

    await _ttsEngine.setLanguage(ttsTargetLocale);
    await _ttsEngine.setSpeechRate(0.4);
    await _ttsEngine.setPitch(1.0);

    await _ttsEngine.speak(text);

    _ttsEngine.setCompletionHandler(() {
      if (mounted) {
        setState(() => _isAvatarSpeaking = false);
      }
    });
  }

  Future<void> _toggleVoiceRecording() async {
    final currentLang = LanguageManager.of(context).currentLocale.languageCode;
    String sttTargetLocale = currentLang == 'ko' ? 'ko_KR' : 'en_US';

    if (!_isListening) {
      bool available = await _speechEngine.initialize(
        onStatus: (status) {
          if (status == 'notListening' && mounted) {
            setState(() => _isListening = false);
          }
        },
        onError: (error) => debugPrint('STT Error: $error'),
      );

      if (available) {
        setState(() => _isListening = true);
        _speechEngine.listen(
          localeId: sttTargetLocale,
          onResult: (result) {
            if (result.finalResult && mounted) {
              setState(() => _isListening = false);
              _sendMessageToBackend(result.recognizedWords);
            }
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speechEngine.stop();
    }
  }

  String _buildSystemPrompt(String userQuery, String currentLang) {
    return '''
    SYSTEM INSTRUCTION: You are an AI companion for an elder person named ${_userPersonalDetails['userName']}.
    Long-term Memory Context:
    - Health Note: ${_userPersonalDetails['medicalHistory']}
    - Family: ${_userPersonalDetails['familyMembers']}
    - Hobbies: ${_userPersonalDetails['hobbies']}
    - Recent Chat Log: $_conversationMemory

    Current Input: "$userQuery"
    Language: $currentLang
    Goal: Speak warmly like a close friend, ask gentle follow-up questions, and offer Youtube music/videos when relevant.
    ''';
  }

  Future<void> _sendMessageToBackend(String userQuery) async {
    if (userQuery.trim().isEmpty) return;

    final currentLang = LanguageManager.of(context).currentLocale.languageCode;

    _conversationMemory.add({'role': 'user', 'content': userQuery});

    setState(() {
      _avatarResponseText = "...";
      _suggestedYoutubeUrl = null;
    });

    try {
      final prompt = _buildSystemPrompt(userQuery, currentLang);
      debugPrint("Prompt Payload: $prompt");

      await Future.delayed(const Duration(seconds: 2));

      String responseText = "";
      String? youtubeUrl;

      if (userQuery.contains("music") || userQuery.contains("노래") || userQuery.contains("음악")) {
        responseText = currentLang == 'ko'
            ? "좋아하시는 음악 유튜브 영상을 찾아보았어요! 아래에서 바로 감상하실 수 있어요."
            : "I found a YouTube music video you might enjoy! You can watch it directly below.";
        youtubeUrl = _userPersonalDetails['favoriteYoutube'];
      } else if (userQuery.contains("knee") || userQuery.contains("무릎")) {
        responseText = currentLang == 'ko'
            ? "어제 무릎이 아프다고 말씀하신 게 기억나요. 오늘은 좀 어떠신가요?"
            : "I remember you mentioned your knee was hurting yesterday. Is it feeling any better now?";
      } else if (userQuery.contains("Tommy") || userQuery.contains("손주")) {
        responseText = currentLang == 'ko'
            ? "손주 토미 이야기를 하시는군요! 토미는 요새도 자주 연락하나요?"
            : "Ah, speaking of your grandson Tommy! Has he visited you recently?";
      } else {
        responseText = currentLang == 'ko'
            ? "그렇군요! 오늘 화단 정원 가꾸기는 좀 하셨나요? 늘 이야기 나누어 주셔서 감사해요."
            : "I understand! Did you get a chance to tend to your garden today? It's always so nice chatting with you.";
      }

      _conversationMemory.add({'role': 'assistant', 'content': responseText});

      if (youtubeUrl != null) {
        _setupYoutubePlayer(youtubeUrl);
      }

      setState(() {
        _avatarResponseText = responseText;
        _suggestedYoutubeUrl = youtubeUrl;
      });

      _speakVoiceOutput(responseText, currentLang);
    } catch (e) {
      String errorMsg = currentLang == 'ko'
          ? "연결이 조금 불안정해요. 다시 한 번 말씀해 주세요."
          : "I'm having trouble connecting right now. Let's try again.";

      setState(() {
        _avatarResponseText = errorMsg;
      });
      _speakVoiceOutput(errorMsg, currentLang);
    }
  }

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
    final currentLang = LanguageManager.of(context).currentLocale.languageCode;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- CARTOON GIRL AVATAR VECTOR COMPONENT ---
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.shade50,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: CustomPaint(
                    painter: CartoonGirlPainter(
                      isSpeaking: _isAvatarSpeaking,
                      isListening: _isListening,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Avatar Response Text Card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Text(
                    _avatarResponseText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.4),
                  ),
                ),
              ),

              // Embedded YouTube Player Section
              if (_suggestedYoutubeUrl != null && _youtubeController != null) ...[
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        color: Colors.red,
                        child: const Row(
                          children: [
                            Icon(Icons.play_circle_fill, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "추천 영상 (YouTube)",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      YoutubePlayer(
                        controller: _youtubeController!,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.red,
                        progressColors: const ProgressBarColors(
                          playedColor: Colors.red,
                          handleColor: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 30),

              // Voice and Typing Controls
              SizedBox(
                width: 260,
                height: 65,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isListening ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: _toggleVoiceRecording,
                  icon: Icon(_isListening ? Icons.stop : Icons.mic, size: 32),
                  label: Text(
                    _isListening ? "Listening..." : local.translate('btn_speak'),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(260, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () => _showTypeDialog(context, local),
                icon: const Icon(Icons.keyboard, size: 24),
                label: Text(local.translate('btn_type'), style: const TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(260, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () => _speakVoiceOutput(_avatarResponseText, currentLang),
                icon: const Icon(Icons.volume_up, size: 24),
                label: Text(local.translate('btn_listen'), style: const TextStyle(fontSize: 18)),
              ),

              const SizedBox(height: 35),
              const Divider(thickness: 1.5),
              const SizedBox(height: 15),

              // Korean News Feed Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.newspaper, color: Colors.green, size: 28),
                      SizedBox(width: 8),
                      Text(
                        '실시간 한국 뉴스',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 26),
                    onPressed: _fetchKoreanNews,
                    tooltip: '뉴스 새로고침',
                  ),
                ],
              ),
              const SizedBox(height: 15),

              if (_isLoadingNews)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_newsErrorMessage != null)
                Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(_newsErrorMessage!, style: const TextStyle(color: Colors.red, fontSize: 16)),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: math.min(_newsItems.length, 5),
                  itemBuilder: (context, index) {
                    final item = _newsItems[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        title: Text(
                          item.title ?? '제목 없음',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: item.pubDate != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  item.pubDate.toString(),
                                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                                ),
                              )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.volume_up, color: Colors.green, size: 26),
                              onPressed: () => _speakVoiceOutput(item.title ?? '', currentLang),
                              tooltip: '뉴스 제목 듣기',
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                        onTap: () => _launchNewsUrl(item.link),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= THE CUSTOM CARTOON GIRL AVATAR PAINTER =================
class CartoonGirlPainter extends CustomPainter {
  final bool isSpeaking;
  final bool isListening;

  CartoonGirlPainter({required this.isSpeaking, required this.isListening});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // 1. Back Hair Layer
    final backHairPaint = Paint()..color = const Color(0xFF3D2B1F);
    canvas.drawCircle(center + const Offset(0, 4), size.width * 0.44, backHairPaint);

    // 2. Face Base
    final facePaint = Paint()..color = const Color(0xFFFFE3C6);
    canvas.drawCircle(center + const Offset(0, 12), size.width * 0.35, facePaint);

    // 3. Eyes Configuration
    final eyePaint = Paint()..color = const Color(0xFF232323);
    final highlightPaint = Paint()..color = Colors.white;
    
    Offset leftEye = center + const Offset(-22, 10);
    Offset rightEye = center + const Offset(22, 10);

    if (isListening) {
      // Curve up eyes for attentive, happy listening state
      final linePaint = Paint()
        ..color = const Color(0xFF232323)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(Rect.fromCircle(center: leftEye, radius: 7), math.pi, math.pi, false, linePaint);
      canvas.drawArc(Rect.fromCircle(center: rightEye, radius: 7), math.pi, math.pi, false, linePaint);
    } else {
      // Large classic friendly cartoon pupils
      canvas.drawCircle(leftEye, 8.5, eyePaint);
      canvas.drawCircle(rightEye, 8.5, eyePaint);
      
      // Eye reflection highlights
      canvas.drawCircle(leftEye + const Offset(-2.5, -2.5), 2.5, highlightPaint);
      canvas.drawCircle(rightEye + const Offset(-2.5, -2.5), 2.5, highlightPaint);
    }

    // 4. Rosy Cheeks
    final cheekPaint = Paint()..color = const Color(0xFFFF9EAA).withOpacity(0.55);
    canvas.drawCircle(center + const Offset(-36, 22), 8, cheekPaint);
    canvas.drawCircle(center + const Offset(36, 22), 8, cheekPaint);

    // 5. Dynamic Mouth (Changes shape if speaking or resting)
    final mouthPaint = Paint()..color = const Color(0xFFE55B5B);
    if (isSpeaking) {
      // Dynamic open oval mouth shape representing speech actions
      canvas.drawOval(
        Rect.fromCenter(center: center + const Offset(0, 26), width: 14, height: 16),
        mouthPaint,
      );
    } else {
      // Happy gentle classic smile line
      final smilePaint = Paint()
        ..color = const Color(0xFFE55B5B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCenter(center: center + const Offset(0, 24), width: 16, height: 8),
        0,
        math.pi,
        false,
        smilePaint,
      );
    }

    // 6. Front Hair Layer / Framing Bangs
    final frontHairPaint = Paint()..color = const Color(0xFF4A3525);
    Path hairPath = Path();
    hairPath.moveTo(size.width * 0.12, size.height * 0.22);
    hairPath.quadraticBezierTo(size.width * 0.32, size.height * 0.08, size.width * 0.5, size.height * 0.24);
    hairPath.quadraticBezierTo(size.width * 0.68, size.height * 0.08, size.width * 0.88, size.height * 0.22);
    hairPath.quadraticBezierTo(size.width * 0.94, size.height * 0.48, size.width * 0.84, size.height * 0.54);
    hairPath.quadraticBezierTo(size.width * 0.76, size.height * 0.26, size.width * 0.5, size.height * 0.32);
    hairPath.quadraticBezierTo(size.width * 0.24, size.height * 0.26, size.width * 0.16, size.height * 0.54);
    hairPath.quadraticBezierTo(size.width * 0.06, size.height * 0.48, size.width * 0.12, size.height * 0.22);
    canvas.drawPath(hairPath, frontHairPaint);

    // 7. Cute Hair Pin Accessory
    final clipPaint = Paint()..color = Colors.greenAccent.shade700;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.24, size.height * 0.24, 11, 4.5),
        const Radius.circular(2),
      ),
      clipPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CartoonGirlPainter oldDelegate) {
    return oldDelegate.isSpeaking != isSpeaking || oldDelegate.isListening != isListening;
  }
}

// ================= PROCEDURAL ANIMATED AVATAR WITH ARMS AND LEGS =================
class AnimatedAvatarWidget extends StatefulWidget {
  final bool isSpeaking;
  final bool isListening;

  const AnimatedAvatarWidget({
    super.key,
    required this.isSpeaking,
    required this.isListening,
  });

  @override
  State<AnimatedAvatarWidget> createState() => _AnimatedAvatarWidgetState();
}

class _AnimatedAvatarWidgetState extends State<AnimatedAvatarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
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
          size: const Size(200, 220),
          painter: AvatarPainter(
            progress: _controller.value,
            isSpeaking: widget.isSpeaking,
            isListening: widget.isListening,
          ),
        );
      },
    );
  }
}

class AvatarPainter extends CustomPainter {
  final double progress;
  final bool isSpeaking;
  final bool isListening;

  AvatarPainter({
    required this.progress,
    required this.isSpeaking,
    required this.isListening,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 10);

    final bobbingOffset = math.sin(progress * math.pi) * (isSpeaking ? 8.0 : 4.0);
    final avatarCenterY = center.dy + bobbingOffset;

    final primaryColor = isSpeaking
        ? Colors.blue
        : (isListening ? Colors.orange : Colors.green);

    final shadowPaint = Paint()..color = Colors.black.withOpacity(0.15);
    final bodyPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final limbPaint = Paint()
      ..color = primaryColor.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    // Floor Shadow
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, size.height - 15),
        width: 110 - (bobbingOffset * 2.5),
        height: 14,
      ),
      shadowPaint,
    );

    // Legs Motion
    final legSwing = math.sin(progress * math.pi) * (isSpeaking ? 0.25 : 0.08);
    _drawLimb(
      canvas,
      start: Offset(center.dx - 22, avatarCenterY + 45),
      length: 42,
      angle: math.pi / 2 + legSwing,
      paint: limbPaint,
    );
    _drawLimb(
      canvas,
      start: Offset(center.dx + 22, avatarCenterY + 45),
      length: 42,
      angle: math.pi / 2 - legSwing,
      paint: limbPaint,
    );

    // Torso
    canvas.drawCircle(Offset(center.dx, avatarCenterY + 15), 45, bodyPaint);

    // Arms Motion
    final armSwing = math.sin(progress * math.pi) * (isSpeaking ? 0.35 : 0.1);
    
    // Left Arm
    _drawLimb(
      canvas,
      start: Offset(center.dx - 38, avatarCenterY + 10),
      length: 38,
      angle: math.pi + 0.3 - armSwing,
      paint: limbPaint,
    );

    // Right Arm (Waves when speaking or listening)
    double rightArmAngle = 0.3 + armSwing;
    if (isSpeaking) {
      rightArmAngle = -math.pi / 3 + armSwing;
    } else if (isListening) {
      rightArmAngle = -math.pi / 4;
    }

    _drawLimb(
      canvas,
      start: Offset(center.dx + 38, avatarCenterY + 10),
      length: 38,
      angle: rightArmAngle,
      paint: limbPaint,
    );

    // Head
    canvas.drawCircle(Offset(center.dx, avatarCenterY - 35), 35, bodyPaint);

    // Eyes
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = Colors.black87;

    canvas.drawCircle(Offset(center.dx - 12, avatarCenterY - 40), 7, eyePaint);
    canvas.drawCircle(Offset(center.dx - 12, avatarCenterY - 40), 3, pupilPaint);

    canvas.drawCircle(Offset(center.dx + 12, avatarCenterY - 40), 7, eyePaint);
    canvas.drawCircle(Offset(center.dx + 12, avatarCenterY - 40), 3, pupilPaint);

    // Mouth
    if (isSpeaking) {
      final mouthHeight = (math.sin(progress * math.pi * 5).abs() * 10) + 3;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx, avatarCenterY - 22),
          width: 14,
          height: mouthHeight,
        ),
        Paint()..color = Colors.black87,
      );
    } else {
      final mouthPaint = Paint()
        ..color = Colors.black87
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round;

      final path = Path()
        ..moveTo(center.dx - 10, avatarCenterY - 25)
        ..quadraticBezierTo(center.dx, avatarCenterY - 18, center.dx + 10, avatarCenterY - 25);
      canvas.drawPath(path, mouthPaint);
    }
  }

  void _drawLimb(Canvas canvas,
      {required Offset start,
      required double length,
      required double angle,
      required Paint paint}) {
    final endX = start.dx + length * math.cos(angle);
    final endY = start.dy + length * math.sin(angle);
    canvas.drawLine(start, Offset(endX, endY), paint);
  }

  @override
  bool shouldRepaint(covariant AvatarPainter oldDelegate) => true;
}

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
                title: Text(local.translate('font_large'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                title: const Text("English (🇺🇸)", style: TextStyle(fontSize: 18)),
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
                title: const Text("한국어 (🇰🇷)", style: TextStyle(fontSize: 18)),
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