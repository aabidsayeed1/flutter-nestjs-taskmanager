import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/app_localizations.dart';
import 'package:task_manager/core/constants/app_values.dart';
import 'package:task_manager/core/managers/general/overlay_manager.dart';
import 'package:task_manager/features/tasks/presentation/bloc/bloc_exports.dart';
import 'package:task_manager/core/generic/blocs/switch_bloc/switch_bloc.dart';
import 'package:task_manager/features/tasks/presentation/pages/dashboard_page.dart';
import 'package:task_manager/injection_container.dart';
import 'package:task_manager/route/app_pages.dart';
import 'package:task_manager/route/app_routes.dart' as route;
import 'package:task_manager/route/global_navigator.dart';
import 'package:task_manager/route/navigator_observer.dart';
import 'package:task_manager/services/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'flavors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<TasksBloc>()..add(SyncOfflineTasks())),
        BlocProvider(create: (context) => SwitchBloc()),
      ],
      child: ScreenUtilInit(
          designSize: const Size(AppValues.VALUE_FIGMA_DESIGN_WIDTH,
              AppValues.VALUE_FIGMA_DESIGN_HEIGHT),
          minTextAdapt: true,
          splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<SwitchBloc, SwitchState>(
            builder:
                (context, state) => MaterialApp(
                  title: F.title,
                  theme:
                      state.switchValue
                          ? AppThemes.appThemeData[AppTheme.darkTheme]
                          : AppThemes.appThemeData[AppTheme.lightTheme],
                  onGenerateRoute: route.controller,
                  debugShowCheckedModeBanner: false,
                  supportedLocales: const [
                    Locale('en', ''),
                    Locale('hi', ''),
                    Locale('mr', ''),
                    Locale('kn', ''),
                    Locale('ta', ''),
                  ],
                  locale: Locale('en', ''),
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  localeResolutionCallback: (deviceLocale, supportedLocales) {
                    for (var locale in supportedLocales) {
                      if (deviceLocale != null && deviceLocale.languageCode == locale.languageCode) {
                        return deviceLocale;
                      }
                    }
          
                    return supportedLocales.first;
                  },
                  initialRoute: AppPages.PAGE_DASHBOARD,
                  navigatorKey: sl<NavigationService>().navigatorKey,
                  builder: OverlayManager.transitionBuilder(),
                  navigatorObservers: [AppNavigatorObserver()],
                  home: _flavorBanner(child: DashBoardPage(), show: kDebugMode),
                ),
          );
        }
      ),
    );
  }

  Widget _flavorBanner({required Widget child, bool show = true}) =>
      show
          ? Banner(
            location: BannerLocation.topStart,
            message: F.name,
            color: Colors.green.withAlpha(150),
            textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.0, letterSpacing: 1.0),
            textDirection: TextDirection.ltr,
            child: child,
          )
          : child;
}
