import 'package:intl/intl.dart';

class taskModel {
  String? sId;
  String? title;
  String? description;
  String? status;
  String? email;
  String? createdDate;

  taskModel({
    this.sId,
    this.title,
    this.description,
    this.status,
    this.email,
    String? createdDate,
  }) : createdDate = createdDate ?? DateTime.now().toString();

  taskModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    email = json['email'];
    createdDate = json['createdDate'] ?? DateTime.now().toString();
  }

  String getFormattedDate() {
    if (createdDate == null) return '';
    final dateTime = DateTime.parse(createdDate!);
    return DateFormat('dd/MM/yyyy, hh:mm a').format(dateTime);
  }
}
