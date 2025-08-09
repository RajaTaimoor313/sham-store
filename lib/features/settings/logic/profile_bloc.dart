import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) {
    // هنا تقدر تجيب البيانات من API أو local
    emit(ProfileLoaded(
      name: 'Baraa haj hasan',
      phone: '09xxxxxx',
      email: 'baraa@gmail.com',
      address: 'Damascus Dummer',
    ));
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    await Future.delayed(Duration(seconds: 1)); // محاكاة تأخير الحفظ
    emit(ProfileSuccess());
  }
}
