import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/feedback_model.dart';
import '../../../core/repositories/feedback_repository.dart';

// Events
abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();

  @override
  List<Object?> get props => [];
}

class CreateFeedback extends FeedbackEvent {
  final int star;
  final String feedbackContent;
  final int scale;

  const CreateFeedback({
    required this.star,
    required this.feedbackContent,
    required this.scale,
  });

  @override
  List<Object?> get props => [star, feedbackContent, scale];
}

class LoadAllFeedbacks extends FeedbackEvent {
  const LoadAllFeedbacks();
}

class SearchFeedbacks extends FeedbackEvent {
  final String query;

  const SearchFeedbacks(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadFeedbackById extends FeedbackEvent {
  final int id;

  const LoadFeedbackById(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateFeedback extends FeedbackEvent {
  final int id;
  final int star;
  final String feedbackContent;
  final int scale;

  const UpdateFeedback({
    required this.id,
    required this.star,
    required this.feedbackContent,
    required this.scale,
  });

  @override
  List<Object?> get props => [id, star, feedbackContent, scale];
}

class DeleteFeedback extends FeedbackEvent {
  final int id;

  const DeleteFeedback(this.id);

  @override
  List<Object?> get props => [id];
}

class ResetFeedbackState extends FeedbackEvent {
  const ResetFeedbackState();
}

// States
abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object?> get props => [];
}

class FeedbackInitial extends FeedbackState {
  const FeedbackInitial();
}

class FeedbackLoading extends FeedbackState {
  const FeedbackLoading();
}

class FeedbackCreated extends FeedbackState {
  final Feedback feedback;

  const FeedbackCreated(this.feedback);

  @override
  List<Object?> get props => [feedback];
}

class FeedbacksLoaded extends FeedbackState {
  final List<Feedback> feedbacks;

  const FeedbacksLoaded(this.feedbacks);

  @override
  List<Object?> get props => [feedbacks];
}

class FeedbackLoaded extends FeedbackState {
  final Feedback feedback;

  const FeedbackLoaded(this.feedback);

  @override
  List<Object?> get props => [feedback];
}

class FeedbackUpdated extends FeedbackState {
  final Feedback feedback;

  const FeedbackUpdated(this.feedback);

  @override
  List<Object?> get props => [feedback];
}

class FeedbackDeleted extends FeedbackState {
  final int deletedId;

  const FeedbackDeleted(this.deletedId);

  @override
  List<Object?> get props => [deletedId];
}

class FeedbackError extends FeedbackState {
  final String message;

  const FeedbackError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final FeedbackRepository _feedbackRepository;

  FeedbackBloc(this._feedbackRepository) : super(const FeedbackInitial()) {
    // ignore: avoid_print
    print('[FeedbackBloc] Created');
    on<CreateFeedback>(_onCreateFeedback);
    on<LoadAllFeedbacks>(_onLoadAllFeedbacks);
    on<SearchFeedbacks>(_onSearchFeedbacks);
    on<LoadFeedbackById>(_onLoadFeedbackById);
    on<UpdateFeedback>(_onUpdateFeedback);
    on<DeleteFeedback>(_onDeleteFeedback);
    on<ResetFeedbackState>(_onResetFeedbackState);
  }

  Future<void> _onCreateFeedback(
    CreateFeedback event,
    Emitter<FeedbackState> emit,
  ) async {
    // ignore: avoid_print
    print(
      '[FeedbackBloc] Event: CreateFeedback { star: ${event.star}, scale: ${event.scale} }',
    );
    emit(const FeedbackLoading());

    final response = await _feedbackRepository.createFeedback(
      star: event.star,
      feedbackContent: event.feedbackContent,
      scale: event.scale,
    );

    if (response.isSuccess && response.data != null) {
      // ignore: avoid_print
      print('[FeedbackBloc] Feedback created: ${response.data!.id}');
      emit(FeedbackCreated(response.data!));
    } else {
      // ignore: avoid_print
      print('[FeedbackBloc] Create failed: ${response.error}');
      emit(FeedbackError(response.error ?? 'Failed to create feedback'));
    }
  }

  Future<void> _onLoadAllFeedbacks(
    LoadAllFeedbacks event,
    Emitter<FeedbackState> emit,
  ) async {
    // ignore: avoid_print
    print('[FeedbackBloc] Event: LoadAllFeedbacks');
    emit(const FeedbackLoading());

    final response = await _feedbackRepository.getAllFeedbacks();

    if (response.isSuccess && response.data != null) {
      // ignore: avoid_print
      print('[FeedbackBloc] Loaded feedbacks: ${response.data!.length}');
      emit(FeedbacksLoaded(response.data!));
    } else {
      // ignore: avoid_print
      print('[FeedbackBloc] Load all failed: ${response.error}');
      emit(FeedbackError(response.error ?? 'Failed to load feedbacks'));
    }
  }

  Future<void> _onSearchFeedbacks(
    SearchFeedbacks event,
    Emitter<FeedbackState> emit,
  ) async {
    // ignore: avoid_print
    print('[FeedbackBloc] Event: SearchFeedbacks { query: ${event.query} }');
    emit(const FeedbackLoading());

    final response = await _feedbackRepository.searchFeedbacks(event.query);

    if (response.isSuccess && response.data != null) {
      // ignore: avoid_print
      print('[FeedbackBloc] Search results: ${response.data!.length}');
      emit(FeedbacksLoaded(response.data!));
    } else {
      // ignore: avoid_print
      print('[FeedbackBloc] Search failed: ${response.error}');
      emit(FeedbackError(response.error ?? 'Failed to search feedbacks'));
    }
  }

  Future<void> _onLoadFeedbackById(
    LoadFeedbackById event,
    Emitter<FeedbackState> emit,
  ) async {
    // ignore: avoid_print
    print('[FeedbackBloc] Event: LoadFeedbackById { id: ${event.id} }');
    emit(const FeedbackLoading());

    final response = await _feedbackRepository.getFeedbackById(event.id);

    if (response.isSuccess && response.data != null) {
      // ignore: avoid_print
      print('[FeedbackBloc] Loaded feedback id: ${response.data!.id}');
      emit(FeedbackLoaded(response.data!));
    } else {
      // ignore: avoid_print
      print('[FeedbackBloc] Load by id failed: ${response.error}');
      emit(FeedbackError(response.error ?? 'Failed to load feedback'));
    }
  }

  Future<void> _onUpdateFeedback(
    UpdateFeedback event,
    Emitter<FeedbackState> emit,
  ) async {
    // ignore: avoid_print
    print('[FeedbackBloc] Event: UpdateFeedback { id: ${event.id} }');
    emit(const FeedbackLoading());

    final response = await _feedbackRepository.updateFeedback(
      id: event.id,
      star: event.star,
      feedbackContent: event.feedbackContent,
      scale: event.scale,
    );

    if (response.isSuccess && response.data != null) {
      // ignore: avoid_print
      print('[FeedbackBloc] Updated feedback id: ${response.data!.id}');
      emit(FeedbackUpdated(response.data!));
    } else {
      // ignore: avoid_print
      print('[FeedbackBloc] Update failed: ${response.error}');
      emit(FeedbackError(response.error ?? 'Failed to update feedback'));
    }
  }

  Future<void> _onDeleteFeedback(
    DeleteFeedback event,
    Emitter<FeedbackState> emit,
  ) async {
    // ignore: avoid_print
    print('[FeedbackBloc] Event: DeleteFeedback { id: ${event.id} }');
    emit(const FeedbackLoading());

    final response = await _feedbackRepository.deleteFeedback(event.id);

    if (response.isSuccess) {
      // ignore: avoid_print
      print('[FeedbackBloc] Deleted feedback id: ${event.id}');
      emit(FeedbackDeleted(event.id));
    } else {
      // ignore: avoid_print
      print('[FeedbackBloc] Delete failed: ${response.error}');
      emit(FeedbackError(response.error ?? 'Failed to delete feedback'));
    }
  }

  Future<void> _onResetFeedbackState(
    ResetFeedbackState event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(const FeedbackInitial());
  }
}
