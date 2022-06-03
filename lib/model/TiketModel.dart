class TiketModel {
  String? id_tiket;
  String? id_karyawan;
  String? nama_karyawan;
  String? keluhan;
  String? foto;
  String? tgl_buat;
  String? tgl_selesai;
  String? teknisi;
  String? status;
  TiketModel(this.id_tiket, this.id_karyawan, this.nama_karyawan, this.keluhan,
      this.foto, this.tgl_buat, this.tgl_selesai, this.teknisi, this.status);
  TiketModel.fromJson(Map<String, dynamic> json) {
    id_tiket = json['id_tiket'];
    id_karyawan = json['id_karyawan'];
    nama_karyawan = json['nama_karyawan'];
    keluhan = json['keluhan'];
    foto = json['foto'];
    tgl_buat = json['tgl_buat'];
    tgl_selesai = json['tgl_selesai'];
    teknisi = json['teknisi'];
    status = json['status'];
  }
}
