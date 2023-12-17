import 'package:concordium_wallet/designsystem/theme/ThemeState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ThemeEvent { toggleDark, toggleLight }

class AppTheme extends Bloc<ThemeEvent, ThemeState> {
  AppTheme() : super(ThemeState.lightTheme);

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    switch (event) {
      case ThemeEvent.toggleDark:
        yield ThemeState.darkTheme;
        break;
      case ThemeEvent.toggleLight:
        yield ThemeState.lightTheme;
        break;
    }
  }
}
