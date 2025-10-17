import 'package:flutter/material.dart';
import 'package:phrases_to_share/features/images/presentation/pages/images_page.dart';
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
import 'features/images/presentation/cubit/images_cubit.dart';
import 'features/images/data/datasources/images_remote_data_source.dart';
import 'features/images/data/repositories/images_repository_impl.dart';
import 'features/images/domain/usecases/get_images.dart';
import 'features/phrases/presentation/pages/phrases_page.dart';
import 'features/common/presentation/pages/splash_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/domain/auth_user.dart';
import 'features/auth/data/auth_storage.dart';

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
  late final ImagesCubit _imagesCubit;
  bool _showSplash = true;
  AuthUser? _user;

  void _onNavItemSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();

    // Try load saved user
    _loadSavedUser();

    // Use a mock backend payload until the real backend is ready
    final jsonPayload = getMockPhrasesJson();
  final imagesJson = getMockImagesJson();

    final remote = PhrasesRemoteDataSourceImpl();
    final repo = PhrasesRepositoryImpl(
      remote: remote,
      jsonPayload: jsonPayload,
    );
    final usecase = GetPhrases(repo);
    _cubit = PhrasesCubit(getPhrases: usecase);
    _cubit.fetch();

    // Images cubit
    final imagesRemote = ImagesRemoteDataSourceImpl();
    final imagesRepo = ImagesRepositoryImpl(remote: imagesRemote, jsonPayload: imagesJson);
    final imagesUsecase = makeGetImages(imagesRepo);
    _imagesCubit = ImagesCubit(getImages: imagesUsecase);
    _imagesCubit.fetch();

    // Keep the splash screen visible briefly while initial fetches run.
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      setState(() => _showSplash = false);
    });
  }

  final _authStorage = AuthStorage();

  Future<void> _loadSavedUser() async {
    final saved = await _authStorage.loadUser();
    if (!mounted) return;
    if (saved != null) {
      setState(() => _user = saved);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bodies = [
      // Images tab
      BlocProvider.value(value: _imagesCubit, child: ImagesPage()),
      // Frases tab (provided cubit)
      BlocProvider.value(value: _cubit, child: PhrasesPage()),
      SharePage(),
    ];

    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(primaryColor: AppColors.primary),
      home: _showSplash
          ? const SplashPage()
          : (_user == null
              ? LoginPage(
                  onSignedIn: (user) async {
                    await _authStorage.saveUser(user);
                    if (!mounted) return;
                    setState(() {
                      _user = user;
                      _selectedIndex = 1; // show Phrases tab after sign-in
                    });
                  },
                )
              : Scaffold(
                  appBar: AppBarWidget(userName: _user?.name ?? "Sérgio"),
                  // Keep pages mounted so their state (e.g. scroll) is preserved when switching tabs.
                  body: IndexedStack(index: _selectedIndex, children: bodies),
                  bottomNavigationBar: BottomNavigationWidget(
                    initialIndex: _selectedIndex,
                    onItemSelected: _onNavItemSelected,
                  ),
                )),
    );
  }

  @override
  void dispose() {
    _cubit.close();
    _imagesCubit.close();
    super.dispose();
  }
}
