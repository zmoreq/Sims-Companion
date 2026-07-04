class SimTraits {
  String? eyeColor;
  String? hairColor;
  String aspiration;
  String? zodiacSign;

  SimTraits({
    this.eyeColor,
    this.hairColor,
    this.aspiration = "Nieznana",
    this.zodiacSign,
  });

  Map<String, dynamic> toJson() {
    return {
      'eyeColor': eyeColor,
      'hairColor': hairColor,
      'aspiration': aspiration,
      'zodiacSign': zodiacSign,
    };
  }

  factory SimTraits.fromJson(Map<String, dynamic> json) {
    return SimTraits(
      eyeColor: json['eyeColor'],
      hairColor: json['hairColor'],
      aspiration: json['aspiration'] ?? "Nieznana",
      zodiacSign: json['zodiacSign'],
    );
  }
}