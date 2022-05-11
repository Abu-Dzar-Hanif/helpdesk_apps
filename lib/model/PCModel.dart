class PCModel {
  String? id_pc;
  String? nama_pc;
  String? tipe_pc;
  PCModel(this.id_pc, this.nama_pc, this.tipe_pc);
  PCModel.fromJson(Map<String, dynamic> json) {
    id_pc = json['id_pc'];
    nama_pc = json['nama_pc'];
    tipe_pc = json['tipe_pc'];
  }
}
