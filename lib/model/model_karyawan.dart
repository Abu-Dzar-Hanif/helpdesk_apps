class model_karyawan {
  String? id_karyawan;
  String? nama_karyawan;
  String? divisi;
  String? gender;
  String? level;
  String? username;
  String? password;
  model_karyawan(this.id_karyawan, this.nama_karyawan, this.divisi, this.gender,
      this.level, this.username, this.password);
  model_karyawan.fromJson(Map<String, dynamic> json) {
    id_karyawan = json['id_karyawan'];
    nama_karyawan = json['nama_karyawan'];
    divisi = json['divisi'];
    gender = json['password'];
    level = json['level'];
    username = json['username'];
    password = json['password'];
  }
}
