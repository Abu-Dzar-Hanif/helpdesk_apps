class TeknisiModel {
  String? id_teknisi;
  String? nama_teknisi;
  String? gender_teknisi;
  TeknisiModel(this.id_teknisi, this.nama_teknisi, this.gender_teknisi);
  TeknisiModel.fromJson(Map<String, dynamic> json) {
    id_teknisi = json['id_teknisi'];
    nama_teknisi = json['nama_teknisi'];
    gender_teknisi = json['gender_teknisi'];
  }
}
