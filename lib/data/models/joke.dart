import 'package:joke_app/data/models/flags.dart';

class Joke {
  bool error;
  String category;
  String type;
  String joke;
  Flags flags;
  int id;
  bool safe;
  String lang;

  Joke(
      {this.error,
      this.category,
      this.type,
      this.joke,
      this.flags,
      this.id,
      this.safe,
      this.lang});

  Joke.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    category = json['category'];
    type = json['type'];
    joke = json['joke'];
    flags = json['flags'] != null ? new Flags.fromJson(json['flags']) : null;
    id = json['id'];
    safe = json['safe'];
    lang = json['lang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['category'] = this.category;
    data['type'] = this.type;
    data['joke'] = this.joke;
    if (this.flags != null) {
      data['flags'] = this.flags.toJson();
    }
    data['id'] = this.id;
    data['safe'] = this.safe;
    data['lang'] = this.lang;
    return data;
  }
}
