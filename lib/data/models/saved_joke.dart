import 'package:meta/meta.dart';

import 'package:hive/hive.dart';

part 'saved_joke.g.dart';

@HiveType(typeId: 0)
class SavedJoke extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String body;

  SavedJoke({@required this.id, @required this.body});

  @override
  String toString() {
    return '$id: $body';
  }
}
