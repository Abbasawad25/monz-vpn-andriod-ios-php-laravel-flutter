import 'package:nizvpn/core/models/model.dart';


class VpnServer extends Model {
    VpnServer({
        this.id,
        this.name,
        this.flag,
        this.slug,
        this.status,
    });

    int id;
    String name;
    String flag;
    String slug;
    int status;

    factory VpnServer.fromJson(Map<String, dynamic> json) => VpnServer(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        flag: json["flag"] == null ? null : json["flag"],
        slug: json["slug"] == null ? null : json["slug"],
        status: json["status"] == null ? null : json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "flag": flag == null ? null : flag,
        "slug": slug == null ? null : slug,
        "status": status == null ? null : status,
    };
}
