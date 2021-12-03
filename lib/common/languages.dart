// This is the boringest file ever

class _Language {
  final String settings,
      savedCities,
      currentPosition,
      barometer,
      language,
      fullName,
      currentCondition,
      unitOfMeasure,
      addNew;
  const _Language({
    required this.fullName,
    required this.settings,
    required this.savedCities,
    required this.currentPosition,
    required this.barometer,
    required this.language,
    required this.currentCondition,
    required this.unitOfMeasure,
    required this.addNew,
  });
}

const Map<String, _Language> languages = {
  "it": _italian,
  "en": _english,
};

const _Language _italian = _Language(
  fullName: "Italiano",
  barometer: "Barometro",
  savedCities: "Città Salvate",
  currentPosition: "Posizione Attuale",
  settings: "Impostazioni",
  language: "Lingua",
  currentCondition: "Condizione Attuale",
  unitOfMeasure: "Unità di Misura",
  addNew: "Aggiungi una città",
);

const _Language _english = _Language(
  fullName: "English",
  barometer: "Barometer",
  savedCities: "Saved Cities",
  currentPosition: "Current Position",
  settings: "Settings",
  language: "Language",
  currentCondition: "Current Condition",
  unitOfMeasure: "Unit of Measure",
  addNew: "Add a city",
);
