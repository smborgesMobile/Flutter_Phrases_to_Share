import 'package:flutter/material.dart';
import 'package:phrases_to_share/shared/themes/app_colors.dart';
import 'package:phrases_to_share/shared/widgets/app_bar/app_bar_widget.dart';
import 'package:phrases_to_share/shared/widgets/bottom_navigation/bottom_navigation_widget.dart';
import 'package:phrases_to_share/shared/widgets/phrase_card/phrase_card.dart';

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

  void _onNavItemSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final samplePhrases = [
      'A vida é feita de pequenas conquistas que, somadas, constroem grandes histórias. Valorize cada passo, mesmo que pareça pequeno, pois é ele que te leva mais longe.',
      'Compartilhar é multiplicar alegria. Quando espalhamos boas palavras e gestos sinceros, o mundo ao nosso redor também se ilumina.',
      'Sorria, mesmo nos dias nublados. Às vezes, o seu sorriso é o raio de sol que alguém precisa para continuar acreditando na vida.',
      'Pequenos atos de bondade têm o poder de transformar o dia de alguém — e talvez até o rumo de uma história inteira.',
      'Nem sempre o caminho mais rápido é o melhor. A jornada se torna mais bonita quando aprendemos a apreciar o que encontramos pelo caminho.',
      'Gratidão transforma o que temos em suficiente, e o que vivemos em aprendizado. É o primeiro passo para uma vida mais leve.',
      'Você não precisa ter todas as respostas agora. Às vezes, basta dar o próximo passo com fé de que o caminho vai se revelar.',
      'O tempo passa, as coisas mudam, mas as boas intenções e os gestos verdadeiros permanecem como marcas de amor no coração das pessoas.',
    ];

    final bodies = [
      // Home -> lista de frases
      ListView.builder(
        key: const PageStorageKey('homeList'),
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        itemCount: samplePhrases.length,
        itemBuilder: (context, i) {
          return PhraseCard(
            phrase: samplePhrases[i],
            onShare: () {
              // placeholder: imprimir no console por enquanto
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Compartilhar: ${samplePhrases[i]}')),
              );
            },
          );
        },
      ),
      const Center(child: Text('Frases')),
      const Center(child: Text('Share')),
    ];

    return MaterialApp(
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
}
