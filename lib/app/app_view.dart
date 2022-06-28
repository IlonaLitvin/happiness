import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../audio_horn.dart';
import '../cards/cards_page.dart';
import '../config.dart';
import '../service_locator.dart';
import '../something_wrong.dart';
import 'app_bloc.dart';
import 'app_state.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AppViewState createState() => _AppViewState();
}

// ignore: prefer_mixin
class _AppViewState extends State<AppView> with WidgetsBindingObserver {
  AudioHorn get audio => sl.get<AudioHorn>();

  @mustCallSuper
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    audio.release();

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Fimber.i('AppLifecycleState is `$state`');
    switch (state) {
      case AppLifecycleState.resumed:
        _resumeCurrentActions();
        break;

      case AppLifecycleState.paused:
        _pauseCurrentActions();
        break;

      default:
        break;
    }
  }

  @override
  Future<bool> didPopRoute() async {
    _pauseCurrentActions();
    return false;
  }

  void _pauseCurrentActions() {
    audio.pause();
  }

  void _resumeCurrentActions() {
    audio.resume();
  }

  @override
  Widget build(BuildContext context) =>
      FlutterSizer(builder: _buildFlutterSizer);

  Widget _buildFlutterSizer(
    BuildContext context,
    Orientation orientation,
    ScreenType screenType,
  ) {
    Fimber.i('Device orientation in widget App by Sizer $orientation');
    Fimber.i('About device:'
        '\n\torientation $orientation'
        '\n\tscreen width ${Device.width}'
        '\n\tscreen height ${Device.height}'
        '\n\tscreen type $screenType'
        '\n\tpixel ratio ${Device.devicePixelRatio}'
        '\n\tboxConstraints ${Device.boxConstraints}');

    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (C.debugBloc) {
          Fimber.i('current state is $state');
        }

        if (state is SuccessConnectedToFirebaseAppState) {
          return const CardsPage();
        }

        if (state is InitAppState) {
          return Container(color: Colors.black);
        }

        return const SomethingWrong();
      },
    );
  }
}
