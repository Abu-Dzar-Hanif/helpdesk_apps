class GenderModel {
  String? inisial;
  String? jenis_gender;
  GenderModel(this.inisial, this.jenis_gender);
  GenderModel.formJson(Map<String, dynamic> json) {
    inisial = json['inisial'];
    jenis_gender = json['jenis_gender'];
  }
}
