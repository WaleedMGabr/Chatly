// Manages theme mode (light/dark) toggling for the entire application.
// Emits ThemeMode values that the MaterialApp listens to for switching themes.

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void toggleMode() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }
}
