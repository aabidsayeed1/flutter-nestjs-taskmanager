import 'package:flutter_bloc/flutter_bloc.dart';

// This is in case we use multoi bloc providers
class HelperBloc {
  ///Singleton factory
  static final HelperBloc _instance = HelperBloc._internal();

  factory HelperBloc() {
    return _instance;
  }

  HelperBloc._internal();

  static final List<BlocProvider> providers = [
    // BlocProvider<SettingsBloc>(
    //   create: (context) => sl<SettingsBloc>(),
    // ),
  ];
}
