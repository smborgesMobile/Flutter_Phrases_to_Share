String getMockPhrasesJson() {
  return '''
  {
    "phrases": [
      {"text": "A vida é feita de pequenas conquistas que, somadas, constroem grandes histórias.", "category": "Motivação"},
      {"text": "Compartilhar é multiplicar alegria. Quando espalhamos boas palavras e gestos sinceros, o mundo ao nosso redor também se ilumina.", "category": "Bondade"},
      {"text": "Gratidão transforma o que temos em suficiente, e o que vivemos em aprendizado.", "category": "Gratidão"},
      {"text": "Pequenos atos de bondade têm o poder de transformar o dia de alguém.", "category": "Bondade"},
      {"text": "Nem sempre o caminho mais rápido é o melhor. A jornada se torna mais bonita quando aprendemos a apreciar o que encontramos pelo caminho.", "category": "Jornada"}
    ]
  }
  ''';
}

String getMockImagesJson() {
  return '''
  {
    "images": [
      {"url": "https://picsum.photos/400?image=10", "category": "Paisagem"},
      {"url": "https://picsum.photos/400?image=20", "category": "Animais"},
      {"url": "https://picsum.photos/400?image=30", "category": "Paisagem"},
      {"url": "https://picsum.photos/400?image=40", "category": "Arte"},
      {"url": "https://picsum.photos/400?image=50", "category": "Animais"}
    ]
  }
  ''';
}
