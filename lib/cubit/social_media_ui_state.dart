abstract class SocialMediaUiState {}

class SocialMediaUiInitial extends SocialMediaUiState {}

class PasswordHideen extends SocialMediaUiState {}

class LoadingState extends SocialMediaUiState {}

class SuccessState extends SocialMediaUiState {
  final String uId;

  SuccessState(this.uId);
}

class FailureState extends SocialMediaUiState {}

class CreateUserSuccess extends SocialMediaUiState {}

class CreateUserFailure extends SocialMediaUiState {
  final String error;

  CreateUserFailure(this.error);
}

class GetDataLoadingState extends SocialMediaUiState {}

class GetDataSuccessState extends SocialMediaUiState {}

class GetDataFailureState extends SocialMediaUiState {
  final String error;

  GetDataFailureState(this.error);

}
