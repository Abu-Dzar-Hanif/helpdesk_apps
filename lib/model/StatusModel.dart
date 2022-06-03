class StatusModel {
  String? id_sts;
  String? status;
  StatusModel(this.id_sts, this.status);
  StatusModel.fromJson(Map<String, dynamic> json) {
    id_sts = json['id_sts'];
    status = json['status'];
  }
}
