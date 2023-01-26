import 'dart:io';

import 'package:dry_cleaners/constants/config.dart';
import 'package:dry_cleaners/constants/hive_contants.dart';
import 'package:dry_cleaners/providers/misc_providers.dart';
import 'package:dry_cleaners/utils/context_less_nav.dart';
import 'package:dry_cleaners/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = AppConfig.publicKey;
  await oneSignalHandler();
  await Hive.initFlutter();
  await Hive.openBox(AppHSC.appSettingsBox);
  await Hive.openBox(AppHSC.authBox);
  await Hive.openBox(AppHSC.userBox);
  await Hive.openBox(AppHSC.cartBox);
  HttpOverrides.global = MyHttpOverrides();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> oneSignalHandler() async {
  await OneSignal.shared.setAppId(AppConfig.oneSignalAppID).then((value) {});
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    debugPrint("Accepted permission: $accepted");
  });

  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
    debugPrint('FOREGROUND HANDLER CALLED WITH: $event');

    /// Display Notification, send null to not display
    event.complete(event.notification);
  });

  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    // Get.off(() => MainPage());
    // _userctrl.pageController.value.jumpToPage(1);
    debugPrint('${result.notification.title} ${result.notification.body}');
  });
}

Future<void> getPlayerID(WidgetRef ref) async {
  final OSDeviceState? deviciestate = await OneSignal.shared.getDeviceState();

  if (deviciestate?.userId == null) {
    return getPlayerID(ref);
  } else {
    ref.watch(onesignalDeviceIDProvider.notifier).state = deviciestate!.userId!;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerID = ref.watch(onesignalDeviceIDProvider);
    if (playerID == '') {
      getPlayerID(ref);
    }
    return ScreenUtilInit(
      designSize: const Size(375, 812), // XD Design Size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Gold Star Dry Cleaner',
          localizationsDelegates: const [
            FormBuilderLocalizations.delegate,
          ],
          theme: ThemeData(
            fontFamily: "Poppins",
          ),
          navigatorKey: ContextLess
              .navigatorkey, //Setting Global navigator key to navigate from anywhere without Context

          onGenerateRoute: (settings) => generatedRoutes(settings),
          initialRoute: Routes.splash,
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
