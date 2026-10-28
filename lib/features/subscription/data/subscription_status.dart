import 'package:equatable/equatable.dart';
import 'package:frantend/core/error/failures.dart';

/// `GET /subscription/status`.
class SubscriptionStatus extends Equatable {
  const SubscriptionStatus({
    required this.status,
    this.planName,
    this.trialEndsAt,
    this.subscriptionEndsAt,
    this.daysLeft,
    this.inGrace = false,
    this.contact = SubscriptionContact.empty,
  });

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) {
    final days = json['days_left'];
    return SubscriptionStatus(
      status: (json['status'] as String? ?? '').toLowerCase().trim(),
      planName: json['plan_name'] as String?,
      trialEndsAt: DateTime.tryParse('${json['trial_ends_at'] ?? ''}'),
      subscriptionEndsAt:
          DateTime.tryParse('${json['subscription_ends_at'] ?? ''}'),
      daysLeft: days is num ? days.toInt() : int.tryParse('$days'),
      inGrace: json['in_grace'] == true,
      contact: SubscriptionContact.fromJson(json['contact']),
    );
  }

  final String status;
  final String? planName;
  final DateTime? trialEndsAt;
  final DateTime? subscriptionEndsAt;
  final int? daysLeft;
  final bool inGrace;
  final SubscriptionContact contact;

  static const _hardBlocked = {'expired', 'suspended', 'cancelled', 'canceled'};

  /// Past the end date but still readable.
  bool get isGrace => inGrace || status == 'grace';

  /// Nothing may be used: expired (outside grace), suspended or cancelled.
  bool get isHardBlocked => !isGrace && _hardBlocked.contains(status);

  /// The date that matters to the customer: when it ends (or ended).
  DateTime? get endsAt => status == 'trial' || status == 'trialing'
      ? (trialEndsAt ?? subscriptionEndsAt)
      : (subscriptionEndsAt ?? trialEndsAt);

  @override
  List<Object?> get props => [
        status,
        planName,
        trialEndsAt,
        subscriptionEndsAt,
        daysLeft,
        inGrace,
        contact,
      ];
}
