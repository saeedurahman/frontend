import 'package:equatable/equatable.dart';
import 'package:frantend/features/restaurant/domain/entities/business_feature_flags.dart';

class BusinessSessionState extends Equatable {
  const BusinessSessionState({
    this.flags = BusinessFeatureFlags.disabled,
    this.isLoaded = false,
  });

  final BusinessFeatureFlags flags;
  final bool isLoaded;

  BusinessSessionState copyWith({
    BusinessFeatureFlags? flags,
    bool? isLoaded,
  }) {
    return BusinessSessionState(
      flags: flags ?? this.flags,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }

  @override
  List<Object?> get props => [flags, isLoaded];
}
