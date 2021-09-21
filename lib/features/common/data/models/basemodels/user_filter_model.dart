class UserFilterModel {
  String filterCountry1;

  UserFilterModel();

  UserFilterModel.create({this.filterCountry1});

  @override
  factory UserFilterModel.fromJson(Map<String, dynamic> json) {
    return UserFilterModel.create(
      filterCountry1: json['filterCountry1'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filterCountry1': filterCountry1,
    };
  }
}
