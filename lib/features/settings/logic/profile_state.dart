abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String phone;
  final String email;
  final String address;

  ProfileLoaded({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
  });
}

class ProfileSuccess extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
