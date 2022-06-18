class StatusModel {
  String? id_sts;
  String? sts;
  StatusModel(this.id_sts, this.sts);
  StatusModel.fromJson(Map<String, dynamic> json) {
    id_sts = json['id_sts'];
    sts = json['sts'];
  }
}
