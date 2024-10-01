part of 'recent_activity_cubit.dart';

class RecentActivityState extends Equatable {
  final List<ActivityModel> recentAcitvities;

  const RecentActivityState({required this.recentAcitvities});

  factory RecentActivityState.initial() {
    return const RecentActivityState(recentAcitvities: []);
  }

  @override
  List<Object> get props => [recentAcitvities];

  @override
  bool get stringify => true;

  RecentActivityState copyWith({
    List<ActivityModel>? recentAcitvities,
  }) {
    return RecentActivityState(
      recentAcitvities: recentAcitvities ?? this.recentAcitvities,
    );
  }
}
