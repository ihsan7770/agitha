class InstructionModel {
  String? id;
  String title;
  String instruction;
  String role;

  InstructionModel({
    this.id,
    required this.title,
    required this.instruction,
    required this.role,
  });


  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'instruction': instruction,
      'role': role,
    };
  }


  factory InstructionModel.fromMap(Map<String, dynamic> map, String id) {
    return  InstructionModel(
      id: id,
      title: map['title'] ?? '',
      instruction: map['instruction'] ?? '',
      role: map['role'] ?? '',
    );
  }
}
