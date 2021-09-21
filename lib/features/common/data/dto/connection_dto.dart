class ConnectionDto {
  String accessToken;
  String username;
  String password;
  String registrationId;
  // String phoneInfo;
  // String newPassword;
  // String oldPassword;
  // String keycentre;

  ConnectionDto();

  ConnectionDto.create({
    this.accessToken,
    this.username,
    this.password,
    this.registrationId,
    /*// this.phoneInfo,
    this.newPassword,
    this.oldPassword,
    // this.keycentre,*/
  });

  @override
  factory ConnectionDto.fromJson(Map<String, dynamic> json) {
    return ConnectionDto.create(
      accessToken: json['acces_token'],
      username: json['username'],
      password: json['password'],
      registrationId: json['registration_id'],
      // keycentre: json['keycentre'],
      // phoneInfo: json['phone_info'],
      // newPassword: json['new_password'],
      // oldPassword: json['old_password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'username': username,
      'password': password,
      'registration_id': registrationId,
      // 'keycentre': keycentre,
      // 'phone_info': phoneInfo,
      // 'new_password': newPassword,
      // 'old_password': oldPassword,
      // 'time_send': DateTime.now().millisecondsSinceEpoch,
    };
  }
}
