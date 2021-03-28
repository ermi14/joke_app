class Flags {
  bool religious;
  bool political;
  bool racist;
  bool sexist;
  bool explicit;

  Flags(
      {this.religious,
      this.political,
      this.racist,
      this.sexist,
      this.explicit});

  Flags.fromJson(Map<String, dynamic> json) {
    religious = json['religious'];
    political = json['political'];
    racist = json['racist'];
    sexist = json['sexist'];
    explicit = json['explicit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['religious'] = this.religious;
    data['political'] = this.political;
    data['racist'] = this.racist;
    data['sexist'] = this.sexist;
    data['explicit'] = this.explicit;
    return data;
  }
}
