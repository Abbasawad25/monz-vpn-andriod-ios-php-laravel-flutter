import 'package:nizvpn/core/models/model.dart';

class VpnConfig extends Model {
  VpnConfig({
    this.id,
    this.name,
    this.flag,
    this.slug,
    this.status,
    this.username,
    this.password,
    this.config,
  });

  int id;
  String name;
  String flag;
  String slug;
  int status;
  String username;
  String password;
  String config;

  factory VpnConfig.fromJson(Map<String, dynamic> json) => VpnConfig(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        flag: json["flag"] == null ? null : json["flag"],
        slug: json["slug"] == null ? null : json["slug"],
        status: json["status"] == null ? null : json["status"],
        username: json["username"] == null ? null : json["username"],
        password: json["password"] == null ? null : json["password"],
        config: json["config"] == null ? null : json["config"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "flag": flag == null ? null : flag,
        "slug": slug == null ? null : slug,
        "status": status == null ? null : status,
        "username": username == null ? null : username,
        "password": password == null ? null : password,
        "config": config == null ? null : config,
      };
}
