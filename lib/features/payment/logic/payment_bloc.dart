import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_shamstore/core/repositories/payment_repository.dart';
import 'package:flutter_shamstore/core/models/payment_model.dart';
import 'package:flutter_shamstore/core/di/service_locator.dart';

// Events
abstract class PaymentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPaymentMethods extends PaymentEvent {}

class AddPaymentMethod extends PaymentEvent {
  final PaymentMethod paymentMethod;

  AddPaymentMethod({required this.paymentMethod});

  @override
  List<Object?> get props => [paymentMethod];
}

class UpdatePaymentMethod extends PaymentEvent {
  final String paymentMethodId;
  final PaymentMethod paymentMethod;

  UpdatePaymentMethod({
    required this.paymentMethodId,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [paymentMethodId, paymentMethod];
}

class DeletePaymentMethod extends PaymentEvent {
  final String paymentMethodId;

  DeletePaymentMethod({required this.paymentMethodId});

  @override
  List<Object?> get props => [paymentMethodId];
}

class SetDefaultPaymentMethod extends PaymentEvent {
  final String paymentMethodId;

  SetDefaultPaymentMethod({required this.paymentMethodId});

  @override
  List<Object?> get props => [paymentMethodId];
}

class ProcessPayment extends PaymentEvent {
  final Payment payment;

  ProcessPayment({required this.payment});

  @override
  List<Object?> get props => [payment];
}

class LoadPaymentById extends PaymentEvent {
  final String paymentId;

  LoadPaymentById({required this.paymentId});

  @override
  List<Object?> get props => [paymentId];
}

class LoadUserPayments extends PaymentEvent {
  final int page;
  final int limit;
  final String? status;

  LoadUserPayments({this.page = 1, this.limit = 10, this.status});

  @override
  List<Object?> get props => [page, limit, status];
}

class RefundPayment extends PaymentEvent {
  final String paymentId;
  final double amount;
  final String reason;

  RefundPayment({
    required this.paymentId,
    required this.amount,
    required this.reason,
  });

  @override
  List<Object?> get props => [paymentId, amount, reason];
}

class LoadPaymentSchedules extends PaymentEvent {}

class CreatePaymentSchedule extends PaymentEvent {
  final PaymentSchedule schedule;

  CreatePaymentSchedule({required this.schedule});

  @override
  List<Object?> get props => [schedule];
}

class UpdatePaymentSchedule extends PaymentEvent {
  final String scheduleId;
  final PaymentSchedule schedule;

  UpdatePaymentSchedule({required this.scheduleId, required this.schedule});

  @override
  List<Object?> get props => [scheduleId, schedule];
}

class DeletePaymentSchedule extends PaymentEvent {
  final String scheduleId;

  DeletePaymentSchedule({required this.scheduleId});

  @override
  List<Object?> get props => [scheduleId];
}

class ValidatePaymentMethod extends PaymentEvent {
  final PaymentMethod paymentMethod;

  ValidatePaymentMethod({required this.paymentMethod});

  @override
  List<Object?> get props => [paymentMethod];
}

class LoadPaymentStatistics extends PaymentEvent {}

// States
abstract class PaymentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentMethodsLoaded extends PaymentState {
  final List<PaymentMethod> paymentMethods;

  PaymentMethodsLoaded({required this.paymentMethods});

  @override
  List<Object?> get props => [paymentMethods];
}

class PaymentMethodAdded extends PaymentState {
  final PaymentMethod paymentMethod;
  final String message;

  PaymentMethodAdded({required this.paymentMethod, required this.message});

  @override
  List<Object?> get props => [paymentMethod, message];
}

class PaymentMethodUpdated extends PaymentState {
  final PaymentMethod paymentMethod;
  final String message;

  PaymentMethodUpdated({required this.paymentMethod, required this.message});

  @override
  List<Object?> get props => [paymentMethod, message];
}

class PaymentMethodDeleted extends PaymentState {
  final String message;

  PaymentMethodDeleted({required this.message});

  @override
  List<Object?> get props => [message];
}

class DefaultPaymentMethodSet extends PaymentState {
  final PaymentMethod paymentMethod;
  final String message;

  DefaultPaymentMethodSet({required this.paymentMethod, required this.message});

  @override
  List<Object?> get props => [paymentMethod, message];
}

class PaymentProcessed extends PaymentState {
  final Payment payment;
  final String message;

  PaymentProcessed({required this.payment, required this.message});

  @override
  List<Object?> get props => [payment, message];
}

class PaymentLoaded extends PaymentState {
  final Payment payment;

  PaymentLoaded({required this.payment});

  @override
  List<Object?> get props => [payment];
}

class PaymentsLoaded extends PaymentState {
  final List<Payment> payments;
  final bool hasMore;
  final int currentPage;

  PaymentsLoaded({
    required this.payments,
    this.hasMore = false,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [payments, hasMore, currentPage];
}

class PaymentRefunded extends PaymentState {
  final Payment payment;
  final String message;

  PaymentRefunded({required this.payment, required this.message});

  @override
  List<Object?> get props => [payment, message];
}

class PaymentSchedulesLoaded extends PaymentState {
  final List<PaymentSchedule> schedules;

  PaymentSchedulesLoaded({required this.schedules});

  @override
  List<Object?> get props => [schedules];
}

class PaymentScheduleCreated extends PaymentState {
  final PaymentSchedule schedule;
  final String message;

  PaymentScheduleCreated({required this.schedule, required this.message});

  @override
  List<Object?> get props => [schedule, message];
}

class PaymentScheduleUpdated extends PaymentState {
  final PaymentSchedule schedule;
  final String message;

  PaymentScheduleUpdated({required this.schedule, required this.message});

  @override
  List<Object?> get props => [schedule, message];
}

class PaymentScheduleDeleted extends PaymentState {
  final String message;

  PaymentScheduleDeleted({required this.message});

  @override
  List<Object?> get props => [message];
}

class PaymentMethodValidated extends PaymentState {
  final bool isValid;
  final String? errorMessage;

  PaymentMethodValidated({required this.isValid, this.errorMessage});

  @override
  List<Object?> get props => [isValid, errorMessage];
}

class PaymentStatisticsLoaded extends PaymentState {
  final Map<String, dynamic> statistics;

  PaymentStatisticsLoaded({required this.statistics});

  @override
  List<Object?> get props => [statistics];
}

class PaymentError extends PaymentState {
  final String message;

  PaymentError({required this.message});

  @override
  List<Object?> get props => [message];
}

class PaymentSuccess extends PaymentState {
  final String message;

  PaymentSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _paymentRepository;

  PaymentBloc({PaymentRepository? paymentRepository})
    : _paymentRepository = paymentRepository ?? sl<PaymentRepository>(),
      super(PaymentInitial()) {
    on<LoadPaymentMethods>(_onLoadPaymentMethods);
    on<AddPaymentMethod>(_onAddPaymentMethod);
    on<UpdatePaymentMethod>(_onUpdatePaymentMethod);
    on<DeletePaymentMethod>(_onDeletePaymentMethod);
    on<SetDefaultPaymentMethod>(_onSetDefaultPaymentMethod);
    on<ProcessPayment>(_onProcessPayment);
    on<LoadPaymentById>(_onLoadPaymentById);
    on<LoadUserPayments>(_onLoadUserPayments);
    on<RefundPayment>(_onRefundPayment);
    on<LoadPaymentSchedules>(_onLoadPaymentSchedules);
    on<CreatePaymentSchedule>(_onCreatePaymentSchedule);
    on<UpdatePaymentSchedule>(_onUpdatePaymentSchedule);
    on<DeletePaymentSchedule>(_onDeletePaymentSchedule);
    on<ValidatePaymentMethod>(_onValidatePaymentMethod);
    on<LoadPaymentStatistics>(_onLoadPaymentStatistics);
  }

  Future<void> _onLoadPaymentMethods(
    LoadPaymentMethods event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(PaymentLoading());
      final response = await _paymentRepository.getPaymentMethods();
      if (response.isSuccess && response.data != null) {
        emit(PaymentMethodsLoaded(paymentMethods: response.data!.data));
      } else {
        emit(
          PaymentError(
            message: response.message ?? 'Failed to load payment methods',
          ),
        );
      }
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> _onAddPaymentMethod(
    AddPaymentMethod event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(PaymentLoading());
      final response = await _paymentRepository.addPaymentMethod(
        type: event.paymentMethod.type,
        provider: 'default',
        details: {
          'name': event.paymentMethod.name,
          'card_number': event.paymentMethod.cardNumber,
          'card_holder_name': event.paymentMethod.cardHolderName,
          'expiry_month': event.paymentMethod.expiryMonth,
          'expiry_year': event.paymentMethod.expiryYear,
          'cvv': event.paymentMethod.cvv,
          'bank_name': event.paymentMethod.bankName,
          'account_number': event.paymentMethod.accountNumber,
          'routing_number': event.paymentMethod.routingNumber,
          'paypal_email': event.paymentMethod.paypalEmail,
        },
        isDefault: event.paymentMethod.isDefault,
      );
      if (response.isSuccess && response.data != null) {
        emit(
          PaymentMethodAdded(
            paymentMethod: response.data!,
            message: 'Payment method added successfully',
          ),
        );
      } else {
        emit(
          PaymentError(
            message: response.message ?? 'Failed to add payment method',
          ),
        );
      }
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> _onUpdatePaymentMethod(
    UpdatePaymentMethod event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(PaymentLoading());
      final response = await _paymentRepository.updatePaymentMethod(
        paymentMethodId: event.paymentMethodId,
        details: {
          'name': event.paymentMethod.name,
          'card_number': event.paymentMethod.cardNumber,
          'card_holder_name': event.paymentMethod.cardHolderName,
          'expiry_month': event.paymentMethod.expiryMonth,
          'expiry_year': event.paymentMethod.expiryYear,
          'cvv': event.paymentMethod.cvv,
          'bank_name': event.paymentMethod.bankName,
          'account_number': event.paymentMethod.accountNumber,
          'routing_number': event.paymentMethod.routingNumber,
          'paypal_email': event.paymentMethod.paypalEmail,
        },
        isDefault: event.paymentMethod.isDefault,
      );
      if (response.isSuccess && response.data != null) {
        emit(
          PaymentMethodUpdated(
            paymentMethod: response.data!,
            message: 'Payment method updated successfully',
          ),
        );
      } else {
        emit(
          PaymentError(
            message: response.message ?? 'Failed to update payment method',
          ),
        );
      }
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> _onDeletePaymentMethod(
    DeletePaymentMethod event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(PaymentLoading());
      final response = await _paymentRepository.deletePaymentMethod(
        event.paymentMethodId,
      );
      if (response.isSuccess) {
        emit(
          PaymentMethodDeleted(message: 'Payment method deleted successfully'),
        );
      } else {
        emit(
          PaymentError(
            message: response.message ?? 'Failed to delete payment method',
          ),
        );
      }
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> _onSetDefaultPaymentMethod(
    SetDefaultPaymentMethod event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(PaymentLoading());
      final response = await _paymentRepository.setDefaultPaymentMethod(
        event.paymentMethodId,
      );
      if (response.isSuccess) {
        emit(
          DefaultPaymentMethodSet(
            paymentMethod: PaymentMethod(
              id: int.parse(event.paymentMethodId),
              userId: 0,
              type: '',
              name: '',
              isDefault: true,
              isActive: true,
            ),
            message: 'Default payment method set successfully',
          ),
        );
      } else {
        emit(
          PaymentError(
            message: response.message ?? 'Failed to set default payment method',
          ),
        );
      }
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> _onProcessPayment(
    ProcessPayment event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(PaymentLoading());
      final response = await _paymentRepository.processPayment(
        orderId: event.payment.orderId.toString(),
        paymentMethodId: event.payment.paymentMethodId?.toString() ?? '',
        amount: event.payment.amount,
        currency: event.payment.currency,
        metadata: {},
      );
      if (response.isSuccess && response.data != null) {
        emit(
          PaymentProcessed(
            payment: response.data!,
            message: 'Payment processed successfully',
          ),
        );
      } else {
        emit(
          PaymentError(
            message: response.message ?? 'Failed to process payment',
          ),
        );
      }
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> _onLoadPaymentById(
    LoadPaymentById event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(PaymentLoading());
      final response = await _paymentRepository.getPaymentById(event.paymentId);
      if (response.isSuccess && response.data != null) {
        emit(PaymentLoaded(payment: response.data!));
      } else {
        emit(
          PaymentError(message: response.message ?? 'Failed to load payment'),
        );
      }
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> _onLoadUserPayments(
    LoadUserPayments event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(PaymentLoading());
      final response = await _paymentRepository.getUserPayments(
        page: event.page,
        limit: event.limit,
        status: event.status,
      );
      if (response.isSuccess && response.data != null) {
        final paginatedData = response.data!;
        emit(
          PaymentsLoaded(
            payments: paginatedData.data,
            hasMore: paginatedData.data.length == event.limit,
            currentPage: event.page,
          ),
        );
      } else {
        emit(
          PaymentError(
            message: response.message ?? 'Failed to load user payments',
          ),
        );
      }
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> _onRefundPayment(
    RefundPayment event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(PaymentLoading());
      final response = await _paymentRepository.refundPayment(
        paymentId: event.paymentId,
        amount: event.amount,
        reason: event.reason,
      );
      if (response.isSuccess && response.data != null) {
        emit(
          PaymentRefunded(
            payment: response.data!,
            message: 'Payment refunded successfully',
          ),
        );
      } else {
        emit(
          PaymentError(message: response.message ?? 'Failed to refund payment'),
        );
      }
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> _onLoadPaymentSchedules(
    LoadPaymentSchedules event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(PaymentLoading());
      final response = await _paymentRepository.getPaymentSchedules();
      if (response.isSuccess && response.data != null) {
        emit(PaymentSchedulesLoaded(schedules: response.data!));
      } else {
        emit(
          PaymentError(
            message: response.message ?? 'Failed to load payment schedules',
          ),
        );
      }
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> _onCreatePaymentSchedule(
    CreatePaymentSchedule event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(PaymentLoading());
      final response = await _paymentRepository.createPaymentSchedule(
        paymentMethodId: event.schedule.orderId.toString(),
        amount: event.schedule.amount,
        frequency: event.schedule.frequency,
        startDate: event.schedule.startDate,
        endDate: event.schedule.endDate,
        description: event.schedule.name,
      );
      if (response.isSuccess && response.data != null) {
        emit(
          PaymentScheduleCreated(
            schedule: response.data!,
            message: 'Payment schedule created successfully',
          ),
        );
      } else {
        emit(
          PaymentError(
            message: response.message ?? 'Failed to create payment schedule',
          ),
        );
      }
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> _onUpdatePaymentSchedule(
    UpdatePaymentSchedule event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(PaymentLoading());
      final response = await _paymentRepository.updatePaymentSchedule(
        scheduleId: event.scheduleId,
        amount: event.schedule.amount,
        frequency: event.schedule.frequency,
        startDate: event.schedule.startDate,
        endDate: event.schedule.endDate,
        description: event.schedule.name,
        isActive: event.schedule.status == 'active',
      );
      if (response.isSuccess && response.data != null) {
        emit(
          PaymentScheduleUpdated(
            schedule: response.data!,
            message: 'Payment schedule updated successfully',
          ),
        );
      } else {
        emit(
          PaymentError(
            message: response.message ?? 'Failed to update payment schedule',
          ),
        );
      }
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> _onDeletePaymentSchedule(
    DeletePaymentSchedule event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(PaymentLoading());
      final response = await _paymentRepository.deletePaymentSchedule(
        event.scheduleId,
      );
      if (response.isSuccess) {
        emit(
          PaymentScheduleDeleted(
            message: 'Payment schedule deleted successfully',
          ),
        );
      } else {
        emit(
          PaymentError(
            message: response.message ?? 'Failed to delete payment schedule',
          ),
        );
      }
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> _onValidatePaymentMethod(
    ValidatePaymentMethod event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(PaymentLoading());
      final response = await _paymentRepository.validatePaymentMethod(
        type: event.paymentMethod.type,
        details: {
          'name': event.paymentMethod.name,
          'card_number': event.paymentMethod.cardNumber,
          'card_holder_name': event.paymentMethod.cardHolderName,
          'expiry_month': event.paymentMethod.expiryMonth,
          'expiry_year': event.paymentMethod.expiryYear,
          'cvv': event.paymentMethod.cvv,
          'bank_name': event.paymentMethod.bankName,
          'account_number': event.paymentMethod.accountNumber,
          'routing_number': event.paymentMethod.routingNumber,
          'paypal_email': event.paymentMethod.paypalEmail,
        },
      );
      if (response.isSuccess && response.data != null) {
        final isValid = response.data!;
        emit(
          PaymentMethodValidated(
            isValid: isValid,
            errorMessage: isValid ? null : 'Invalid payment method',
          ),
        );
      } else {
        emit(
          PaymentMethodValidated(
            isValid: false,
            errorMessage:
                response.message ?? 'Payment method validation failed',
          ),
        );
      }
    } catch (e) {
      emit(PaymentMethodValidated(isValid: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadPaymentStatistics(
    LoadPaymentStatistics event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(PaymentLoading());
      final response = await _paymentRepository.getPaymentStatistics();
      if (response.isSuccess && response.data != null) {
        emit(PaymentStatisticsLoaded(statistics: response.data!));
      } else {
        emit(
          PaymentError(
            message: response.message ?? 'Failed to load payment statistics',
          ),
        );
      }
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }
}
