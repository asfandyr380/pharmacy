import 'package:mysql1/mysql1.dart';

class DataBaseConnection {
  final settings = new ConnectionSettings(
      host: 'sql170.main-hosting.eu',
      user: 'u265587006_pharmacy',
      password: '3Sm;Uu1q^N~J',
      db: 'u265587006_pharmacy',
      characterSet: CharacterSet.UTF8);

  Future establishConnection() async {
    try {
      var conn = await MySqlConnection.connect(settings);
      return conn;
    } catch (e) {
      print(e);
    }
    return;
  }
}
