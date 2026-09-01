/// A single saved compliment — mirrors the `{id, text, who, date}` shape
/// the .dc.html prototype keeps in `localStorage['is-compliments']`.
class Compliment {
  const Compliment({
    required this.id,
    required this.text,
    required this.who,
    required this.date,
  });

  final int id;
  final String text;
  final String who;
  final DateTime date;

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'who': who,
        'date': date.toIso8601String(),
      };

  factory Compliment.fromJson(Map<String, dynamic> json) => Compliment(
        id: json['id'] as int,
        text: json['text'] as String? ?? '',
        who: json['who'] as String? ?? '',
        date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      );
}

const _trMonths = [
  'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
  'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara',
];

/// Mirrors the prototype's `dateLabel(iso)`: "bugün" / "dün" / "N gün önce"
/// / "12 Eki" once the compliment is a week old or more.
String dateLabel(DateTime date) {
  final now = DateTime.now();
  final d0 = DateTime(date.year, date.month, date.day);
  final n0 = DateTime(now.year, now.month, now.day);
  final days = n0.difference(d0).inDays;
  if (days <= 0) return 'bugün';
  if (days == 1) return 'dün';
  if (days < 7) return '$days gün önce';
  return '${date.day} ${_trMonths[date.month - 1]}';
}
