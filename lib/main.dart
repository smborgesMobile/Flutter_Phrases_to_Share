import 'package:flutter/material.dart';
import 'package:phrases_to_share/features/phrases/presentation/pages/home_page.dart';
import 'package:phrases_to_share/features/phrases/presentation/pages/share_page.dart';
import 'package:phrases_to_share/shared/themes/app_colors.dart';
import 'package:phrases_to_share/shared/widgets/app_bar/app_bar_widget.dart';
import 'package:phrases_to_share/shared/widgets/bottom_navigation/bottom_navigation_widget.dart';
import 'package:phrases_to_share/l10n/app_localizations.dart';
import 'features/phrases/data/datasources/phrases_remote_data_source.dart';
import 'core/mock_backend.dart';
import 'features/phrases/data/repositories/phrases_repository_impl.dart';
import 'features/phrases/domain/usecases/get_phrases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/phrases/presentation/cubit/phrases_cubit.dart';
import 'features/phrases/presentation/pages/phrases_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  late final PhrasesCubit _cubit;

  void _onNavItemSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();

    // Use a mock backend payload until the real backend is ready
    final jsonPayload = getMockPhrasesJson();

    final remote = PhrasesRemoteDataSourceImpl();
    final repo = PhrasesRepositoryImpl(
      remote: remote,
      jsonPayload: jsonPayload,
    );
    final usecase = GetPhrases(repo);
    _cubit = PhrasesCubit(getPhrases: usecase);
    _cubit.fetch();
  }

  @override
  Widget build(BuildContext context) {
    final bodies = [
      HomePage(),
      // Home page (provided cubit)
      BlocProvider.value(value: _cubit, child: PhrasesPage()),
      SharePage(),
    ];

    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(primaryColor: AppColors.primary),
      home: Scaffold(
        appBar: AppBarWidget(userName: "Sérgio"),
        // Keep pages mounted so their state (e.g. scroll) is preserved when switching tabs.
        body: IndexedStack(index: _selectedIndex, children: bodies),
        bottomNavigationBar: BottomNavigationWidget(
          initialIndex: _selectedIndex,
          onItemSelected: _onNavItemSelected,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }
}
