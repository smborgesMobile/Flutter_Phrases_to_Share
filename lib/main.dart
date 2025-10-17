import 'package:flutter/material.dart';
import 'package:phrases_to_share/shared/themes/app_colors.dart';
import 'package:phrases_to_share/shared/widgets/app_bar/app_bar_widget.dart';
import 'package:phrases_to_share/shared/widgets/bottom_navigation/bottom_navigation_widget.dart';
import 'package:phrases_to_share/shared/widgets/phrase_card/phrase_card.dart';
import 'package:phrases_to_share/l10n/app_localizations.dart';
import 'features/phrases/data/datasources/phrases_remote_data_source.dart';
import 'core/mock_backend.dart';
import 'features/phrases/data/repositories/phrases_repository_impl.dart';
import 'features/phrases/domain/usecases/get_phrases.dart';
import 'features/phrases/presentation/bloc/phrases_bloc.dart';
import 'features/phrases/presentation/bloc/phrases_event.dart';
import 'features/phrases/presentation/bloc/phrases_state.dart';

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
  late final PhrasesBloc _bloc;

  void _onNavItemSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();

    // Use a mock backend payload until the real backend is ready
    final jsonPayload = getMockPhrasesJson();

    final remote = PhrasesRemoteDataSourceImpl();
    final repo = PhrasesRepositoryImpl(remote: remote, jsonPayload: jsonPayload);
    final usecase = GetPhrases(repo);
    _bloc = PhrasesBloc(getPhrases: usecase);
    _bloc.eventSink.add(FetchPhrases());
  }

  @override
  Widget build(BuildContext context) {
    // UI driven by BLoC

    final bodies = [
      // Home -> chips de categorias + lista de frases
      // Bind UI to BLoC via StreamBuilder
      StreamBuilder<PhrasesState>(
        stream: _bloc.stream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state == null || state is PhrasesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PhrasesError) {
            return Center(child: Text('Erro: ${state.message}'));
          }
          if (state is PhrasesLoaded) {
            final cats = state.categories;
            final selected = state.selectedCategory;
            final filtered = selected == 'Todas' ? state.all : state.all.where((p) => p.category == selected).toList();
            return Column(
              children: [
                SizedBox(
                  height: 56,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: cats.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final cat = cats[i];
                      final isSelected = cat == selected;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (_) => _bloc.eventSink.add(SelectCategory(cat)),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    key: const PageStorageKey('homeList'),
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      return PhraseCard(
                        phrase: filtered[i],
                        onShare: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Compartilhar: ${filtered[i].text}')),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      const Center(child: Text('Frases')),
      const Center(child: Text('Share')),
    ];

    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(primaryColor: AppColors.primary),
      home: Scaffold(
        appBar: AppBarWidget(userName: "Sérgio"),
        // Keep pages mounted so their state (e.g. scroll) is preserved when switching tabs.
        body: IndexedStack(
          index: _selectedIndex,
          children: bodies,
        ),
        bottomNavigationBar: BottomNavigationWidget(
          initialIndex: _selectedIndex,
          onItemSelected: _onNavItemSelected,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
