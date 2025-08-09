abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String name;
  final String phone;
  final String email;
  final String address;

  UpdateProfile({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
  });
}
