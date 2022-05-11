class JenisModel {
  String? id_jenis;
  String? jenis;
  JenisModel(this.id_jenis, this.jenis);
  JenisModel.fromJson(Map<String, dynamic> json) {
    id_jenis = json['id_jenis'];
    jenis = json['jenis'];
  }
}
