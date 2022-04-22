class Teknisi {
  String? id_teknisi;
  String? nama_teknisi;
  String? gender_teknisi;
  Teknisi({this.id_teknisi, this.nama_teknisi, this.gender_teknisi});
  factory Teknisi.fromJson(Map<String, dynamic> parsedJson){
    return Teknisi(
      id_teknisi: parsedJson['id_teknisi'] as String,
      nama_teknisi: parsedJson['nama_teknisi'] as String,
      gender_teknisi: parsedJson['gender_teknisi'] as String
    );
  }
}