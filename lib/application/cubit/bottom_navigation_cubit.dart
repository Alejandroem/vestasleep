import 'package:hydrated_bloc/hydrated_bloc.dart';

enum SelectedTab {
  home,
  settings, graphs,
}

class BottomNavigationCubit extends HydratedCubit<SelectedTab> {
  BottomNavigationCubit() : super(SelectedTab.home);

  void updateSelectedTab(SelectedTab selectedTab) => emit(selectedTab);

  @override
  SelectedTab? fromJson(Map<String, dynamic> json) {
    return SelectedTab.values.firstWhere(
      (element) => element.toString() == json['selectedTab'],
      orElse: () => SelectedTab.home,
    );
  }

  @override
  Map<String, dynamic>? toJson(SelectedTab state) {
    return {'selectedTab': state.toString()};
  }
}
