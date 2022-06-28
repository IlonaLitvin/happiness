import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../active_localization.dart';
import '../app_toast.dart';
import '../config.dart';
import '../purchase/purchase_bloc.dart';
import '../purchase/purchase_event.dart';
import '../routes.dart';
import '../service_locator.dart';
import '../something_wrong.dart';
import 'app_bloc.dart';
import 'app_event.dart';
import 'app_view.dart';

class AppPage extends StatelessWidget {
  static const initialRoute = Routes.home;

  static const routes = <String, WidgetBuilder>{
    Routes.home: _buildRouteHome,
    Routes.somethingWrong: _buildRouteSomethingWrong,
  };

  const AppPage({super.key});

  @override
  Widget build(BuildContext context) => AppToast(
        child: MaterialApp(
          routes: routes,
          initialRoute: initialRoute,
          title: C.defaultAppTitle,
          onGenerateTitle: (BuildContext context) {
            initServiceLocatorOnce(context);
            return ActiveLocalization(context).localization.app_title;
          },
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: C.supportedLocales,
          theme: ThemeData(
            fontFamily: C.defaultFontFamily,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            canvasColor: Colors.black,
          ),
          debugShowCheckedModeBanner: false,
        ),
      );

  static Widget _buildRouteHome(BuildContext context) => Scaffold(
        body: SafeArea(
          child: MultiBlocProvider(providers: [
            BlocProvider(
              create: (context) =>
                  AppBloc()..add(const ConnectToFirebaseAppEvent()),
              lazy: false,
            ),
            BlocProvider(
              create: (context) =>
                  PurchaseBloc()..add(const InitPurchaseEvent()),
              lazy: false,
            ),
          ], child: const AppView()),
        ),
      );

  static Widget _buildRouteSomethingWrong(BuildContext context) =>
      const SomethingWrong();
}
