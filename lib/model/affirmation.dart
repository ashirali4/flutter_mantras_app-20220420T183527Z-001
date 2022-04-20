class Affirmation {
  List<String>? subcategories;
  String? title;

  Affirmation({this.subcategories, this.title});

  Affirmation.fromSnapshot(dynamic value):
        subcategories = value["subcategories"].cast<String>(),
        title = value['title'];


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subcategories'] = this.subcategories;
    data['title'] = this.title;
    return data;
  }
}