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

class ChangeNavBottom extends SocialMediaUiState {}

class NewPost extends SocialMediaUiState {}

class ProfileImagePickedSuccess extends SocialMediaUiState {}

class ProfileImagePickedError extends SocialMediaUiState {}

class CoverImagePickedSuccess extends SocialMediaUiState {}

class CoverImagePickedError extends SocialMediaUiState {}

class ProfileImageSuccessUpload extends SocialMediaUiState {}

class ProfileImageErrorUpload extends SocialMediaUiState {}

class CoverImageSuccessUpload extends SocialMediaUiState {}

class CoverImageErrorUpload extends SocialMediaUiState {}

class UpdateDataError extends SocialMediaUiState {}

class UpdateDataSuccess extends SocialMediaUiState {}

class UpdateDataLoading extends SocialMediaUiState {}

class PostCreateLoading extends SocialMediaUiState {}

class PostCreateSuccess extends SocialMediaUiState {}

class PostCreateError extends SocialMediaUiState {}

class PostImagePickedSuccess extends SocialMediaUiState {}

class PostImagePickedRemoveSuccess extends SocialMediaUiState {}

class GetPostsLoading extends SocialMediaUiState {}

class GetPostsSuccess extends SocialMediaUiState {}

class GetPostsError extends SocialMediaUiState {
  final String error;

  GetPostsError(this.error);
}

class LikeSuccess extends SocialMediaUiState {}

class LikeError extends SocialMediaUiState {}

class GetUsersLoading extends SocialMediaUiState {}

class GetUsersSuccess extends SocialMediaUiState {}

class GetUsersError extends SocialMediaUiState {
  final String error;

  GetUsersError(this.error);
}

class SendMessageLoading extends SocialMediaUiState {}

class SendMessageSuccess extends SocialMediaUiState {}

class SendMessageError extends SocialMediaUiState {
  final String error;

  SendMessageError(this.error);
}

class GetMessagesSuccess extends SocialMediaUiState {}
class GetMessagesLoading extends SocialMediaUiState {}

class PostDeletedLoading extends SocialMediaUiState {}
class PostDeletedSuccess extends SocialMediaUiState {}
class PostDeletedError extends SocialMediaUiState {}