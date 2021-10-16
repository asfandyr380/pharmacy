class CategoryModel {
  int? id = 0;
  String? name = '';
  String? desc = '';

  CategoryModel({this.name, this.desc});

  CategoryModel.fromJson(Map map)
      : id = map['id'],
        name = map['name'],
        desc = map['desc'];

  Map<String, dynamic> toJson() => {
        "name": name,
        "desc": desc,
      };
}
