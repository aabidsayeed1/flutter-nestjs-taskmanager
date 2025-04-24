// import 'package:equatable/equatable.dart';
// import 'package:task_manager/app_imports.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// part 'settings_event.dart';
// part 'settings_state.dart';

// class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
//   SettingsBloc() : super(SettingsInitial()) {
//     on<SettingsEvent>((event, emit) {});

//     on<ChangeLocaleEvent>((event, emit) {
//       HelperUser.setLocale(event.strLanguageCode);
//       emit(ChangingLocaleState());
//       emit(ChangeLocaleState(locale: Locale(event.strLanguageCode)));
//     });
//   }
// }
