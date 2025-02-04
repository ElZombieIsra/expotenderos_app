import 'package:expotenderos_app/services/database.dart';

class Shopkeeper{

  final String tableName = "Shopkeepers";
  final List types = ["Dueño", "Trabajador"];
  final List genders = ["Hombre", "Mujer"];
  
  int id;
  int idServer;
  int type;
  String name;
  String email;
  String phone;
  int gender;
  int age;
  int alpura;
  int fridgeDoors;

  Shop shop;

  String code;
  int combo;
  bool privacy = false;
  bool synced = false;

  String referredName;
  String referredCode;

  Shopkeeper() {
    this.shop = Shop();
  }

  Shopkeeper.map(dynamic obj) {
    this.id = obj["id"];
    this.idServer = obj["id_server"];
    this.type = obj["type"];
    this.name = obj["name"];
    this.email = obj["email"];
    this.phone = obj["phone"];
    if (obj["gender"] != null) {
      try {
        this.gender = obj["gender"] is String ? int.parse(obj["gender"]) : obj["gender"];
      } catch (e) {
        print(e);
      }
      this.gender = obj["gender"];
    }
    if (obj["age"] != null) {
      try {
        this.age = obj["age"];
      } catch (e) {
        print(e);
      }  
      this.age = obj["age"];
    }

    this.alpura = obj["alpura"];
    if (obj["fridge_doors"] != null) this.fridgeDoors = obj["fridge_doors"] is String 
      ? int.parse(obj["fridge_doors"]) 
      : obj["fridge_doors"];
    
    this.shop = Shop.map(obj);
    this.code = obj["code"];
    this.combo = obj["combo"];
    this.privacy = obj["privacy"] == "1" ? true : false;
    this.synced = obj["synced"] == "1" ? true : false;
    this.referredName = obj["referred_name"];
    this.referredCode = obj["referred_code"];
  }

  Future<Shopkeeper> getKeeper(int id) async {

    DatabaseHelper db = DatabaseHelper();
    var client = await db.db;

    List<Map<String, dynamic>> keeper = await client.query(
      tableName, 
      where: "id = ?",
      whereArgs: [id],
    );

    return Shopkeeper.map(keeper[0]);
  }

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = Map<String, dynamic>();

    if(id != null) map["id"] = this.id;
    map["id_server"] = this.idServer;
    map["type"] = this.type;
    map["name"] = this.name;
    map["email"] = this.email;
    map["phone"] = this.phone;
    if (gender != null) map["gender"] = this.gender;
    if (age != null) map["age"] = this.age;
    map["alpura"] = this.alpura;
    map["fridge_doors"] = this.fridgeDoors;

    map["shop_name"] = this.shop.name;
    map["shop_address"] = this.shop.address;
    map["shop_postal_code"] = this.shop.postalCode;
    map["shop_picture"] = this.shop.picture;
    map["shop_location"] = this.shop.location;

    map["code"] = this.code;
    map["combo"] = this.combo;
    map["privacy"] = this.privacy ? 1 : 0;
    map["synced"] = this.synced ? 1 : 0;
    map["referred_name"] = this.referredName;
    map["referred_code"] = this.referredCode;
    
    return map;

  }

  Future<int> save() async {
    
    DatabaseHelper db = DatabaseHelper();
    var client = await db.db;

    Map keeper = this.toMap();
    // print(keeper);
    if (this.id != null) {
      try {
        int id = await client.update(tableName, keeper,
          where: "id = ?",
          whereArgs: [this.id],
        );
        return id;
      } catch (e) {
        print(e);
        return null;
      }
    }
    else {
      try {
        // print(this.toMap());
        int id = await client.insert(tableName, keeper);
        return id;
      } catch (e) {
        print(e);
        return null;
      }
    }

  }

}

class Shop {
  
  String name;
  String address;
  int postalCode;
  String picture;
  String location;

  Shop();

  Shop.map(dynamic obj) {
    this.name = obj["shop_name"];
    this.address = obj["shop_address"];
    this.postalCode = obj["shop_postal_code"];
    this.picture = obj["shop_picture"];
    this.location = obj["shop_location"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map["name"] = this.name;
    map["address"] = this.address;
    map["postal_code"] = this.postalCode;
    map["picture"] = this.picture;
    map["location"] = this.location;

    return map;
  }
}