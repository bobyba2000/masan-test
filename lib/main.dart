import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:web_test/generated/assets.gen.dart';
import 'package:web_test/service/auth.dart';
import 'package:web_test/service/local.dart';
import 'package:web_test/service/result.dart';
import 'package:web_test/ui/login/page.dart';
import 'package:web_test/ui/test/page.dart';
import 'package:web_test/ui/main/dialog/choose_test.dart';

import 'firebase.dart';
import 'router/definition.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.init();
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      child: MaterialApp.router(
        title: 'Masan\'s Test',
        theme: ThemeData(
          useMaterial3: false,
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: RouterDefinition.router,
        builder: EasyLoading.init(),
      ),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // final service = AuthService();
    // service.createAccountForTesting(500);
    checkLogin().then((value) {
      if (value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StartPage(),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    });
    super.initState();
  }

  Future<bool> checkLogin() async {
    final username = await LocalStorageUtility.getData('username');
    if (username != null && username.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            Assets.images.background.path,
          ),
        ),
      ),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final service = ResultService();
  bool canTakeTest = false;

  @override
  void initState() {
    getResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  Assets.images.background.path,
                ),
              ),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                Visibility(
                  visible: canTakeTest,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TestPage(
                            type: TestType.customType,
                          ),
                        ),
                      ).then((value) {
                        getResult();
                      });
                    },
                    child: Assets.images.takeTest.image(
                      width: 250.w,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                InkWell(
                  borderRadius: BorderRadius.circular(24.r),
                  onTap: () {
                    final authService = AuthService();
                    authService.logout().then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.r),
                      color: Colors.red,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                    child: Text(
                      'Sign out',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getResult() async {
    service.getResult().then((value) {
      canTakeTest = value == null;
      if (mounted) {
        setState(() {});
      }
    });
  }
}
