class ShelfModel {
  int? shelfId = 0;
  String? name = '';
  int? numericNo = 0;

  ShelfModel({this.name, this.numericNo, this.shelfId});

  ShelfModel.fromJson(Map map)
      : shelfId = map['id'],
        name = map['name'],
        numericNo = map['numericNo'];

  Map<String, dynamic> toJson() => {
        "name": name,
        "numericNo": numericNo,
      };
}
