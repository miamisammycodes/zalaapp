class PredefiendReasonsModel {
  String? id;
  String? returnReason;
  String? message;
  String? image;

  PredefiendReasonsModel({
    this.id,
    this.returnReason,
    this.message,
    this.image,
  });

  PredefiendReasonsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    returnReason = json['return_reason'];
    message = json['message'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['return_reason'] = returnReason;
    data['message'] = message;
    data['image'] = image;
    return data;
  }
}
