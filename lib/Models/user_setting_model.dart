class UserSetting {
  int id = 0;
  String currency = '';
  String web = '';
  String pNote = '';
  String sNote = '';
  int userId = 0;

  UserSetting(this.currency, this.id, this.pNote, this.sNote, this.web);

  UserSetting.fromJson(Map map)
      : id = map['id'],
        currency = map['currency'],
        web = map['web'] ?? '',
        pNote = map['Pnote'],
        sNote = map['Snote'],
        userId = map['user_Id'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "currency": currency,
        "web": web,
        "Pnote": pNote,
        "Snote": sNote,
        'user_Id': userId,
      };
}
