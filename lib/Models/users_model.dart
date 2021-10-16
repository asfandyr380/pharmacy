class UserModel {
  int? id = 0;
  String? name = '';
  String? shopename = '';
  String? email = '';
  int? phone = 0;
  String? role = '';
  int? settingId = 0;
  String? address1 = '';
  String? address2 = '';
  String? licenceNo = '';
  String? expirationDate = '';
  int? employeeUserId = 0;
  UserModel({
    this.email,
    this.id,
    this.name,
    this.phone,
    this.role,
    this.shopename,
    this.settingId,
    this.address1,
  });

  UserModel.fromJson(Map map)
      : id = map['id'],
        name = map['name'],
        email = map['email'],
        phone = map['phone'],
        shopename = map['shop_name'],
        role = map['role'],
        settingId = map['settings_Id'],
        address1 = map['address1'],
        address2 = map['address2'],
        licenceNo = map['lisence_no'],
        employeeUserId = map['employee_user_Id'],
        expirationDate = map['date'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "shop_name": shopename,
        "role": role,
        "settings_Id": settingId,
        'address1': address1,
        'address2': address2,
        'lisence_no': licenceNo,
        'employee_user_Id': employeeUserId,
        'date': expirationDate,
      };
}
