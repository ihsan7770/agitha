class AddJobVaccancys {
  String? documentId;
  String? jobTitle;
  String? jobCode;
  String? jobType;
  String? department;
  String? jobResponsibility;
  String? jobDescription;
  String? jobRequirements;
  String? jobLocation;
  String? salaryRange;
  // DateTime? applicationDeadline;

  AddJobVaccancys({
   required this.documentId,
   required this.jobTitle,
   required this.jobCode,
   required this.jobType,
   required this.department,
   required this.jobResponsibility,
   required this.jobDescription,
   required this.jobRequirements,
   required this.jobLocation,
   required this.salaryRange,
  //  required this.applicationDeadline,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId':documentId,
      'jobTitle': jobTitle,
      'jobCode':jobCode,
      'jobType':jobType,
      'department': department,
      'jobResponsibility':jobResponsibility,
      'jobDescription': jobDescription,
      'jobRequirements': jobRequirements,
      'jobLocation': jobLocation,
      'salaryRange': salaryRange,
      // 'applicationDeadline': applicationDeadline?.toIso8601String(),
    };
  }

  factory AddJobVaccancys.fromMap(Map<String, dynamic> map) {
    return AddJobVaccancys(
      documentId:map['documentId'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
      jobCode: map['jobCode'] ?? '',
      jobType: map['jobType'] ?? '',
      department: map['department'] ?? '',
      jobResponsibility:map['jobResponsibility'] ?? '',
      jobDescription: map['jobDescription'] ?? '',
      jobRequirements: map['jobRequirements'] ?? '',
      jobLocation: map['jobLocation'] ?? '',
      salaryRange: map['salaryRange'] ?? '',
      // applicationDeadline: map['applicationDeadline'] != null
      //     ? DateTime.parse(map['applicationDeadline'])
      //     : null,
    );
  }
}