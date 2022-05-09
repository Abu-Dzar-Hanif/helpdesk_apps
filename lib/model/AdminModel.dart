class AdminModel {
  String? id_admin;
  String? nama;
  String? username;
  String? password;
  String? level;
  AdminModel(
      this.id_admin, this.nama, this.username, this.password, this.level);
  AdminModel.fromJson(Map<String, dynamic> json) {
    id_admin = json['id_admin'];
    nama = json['nama'];
    username = json['username'];
    password = json['password'];
    level = json['level'];
  }
}
