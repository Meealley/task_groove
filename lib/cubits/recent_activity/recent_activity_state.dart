// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:equatable/equatable.dart';

part of 'recent_activity_cubit.dart';

class RecentActivityState extends Equatable {
  final List<ActivityModel> recentAcitvities;
  final RecentActivityStatus recentActivityStatus;

  const RecentActivityState(
      {required this.recentAcitvities, required this.recentActivityStatus});

  factory RecentActivityState.initial() {
    return const RecentActivityState(
      recentAcitvities: [],
      recentActivityStatus: RecentActivityStatus.initial,
    );
  }

  @override
  List<Object> get props => [recentAcitvities, recentActivityStatus];

  @override
  bool get stringify => true;

  RecentActivityState copyWith({
    List<ActivityModel>? recentAcitvities,
    RecentActivityStatus? recentActivityStatus,
  }) {
    return RecentActivityState(
      recentAcitvities: recentAcitvities ?? this.recentAcitvities,
      recentActivityStatus: recentActivityStatus ?? this.recentActivityStatus,
    );
  }
}
