class AdminDashboardModel {
  final DashboardCards cards;
  final List<RevenueByMonth> monthlyRevenue;
  final List<SignupByMonth> monthlySignups;
  final UsageSummary usageSummary;

  const AdminDashboardModel({
    required this.cards,
    required this.monthlyRevenue,
    required this.monthlySignups,
    required this.usageSummary,
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json['data']);
    return AdminDashboardModel(
      cards: DashboardCards.fromJson(_asMap(data['cards'])),
      monthlyRevenue: _asList(
        data['monthlyRevenue'],
      ).map((e) => RevenueByMonth.fromJson(_asMap(e))).toList(),
      monthlySignups: _asList(
        data['monthlySignups'],
      ).map((e) => SignupByMonth.fromJson(_asMap(e))).toList(),
      usageSummary: UsageSummary.fromJson(_asMap(data['usageSummary'])),
    );
  }
}

class DashboardCards {
  final MetricCard totalRevenue;
  final MetricCard totalMerchants;
  final MetricCard totalConsumers;
  final MetricCard totalRedemptions;
  final ActiveSubscriptionsCard activeSubscriptions;
  final MetricCard issues;

  const DashboardCards({
    required this.totalRevenue,
    required this.totalMerchants,
    required this.totalConsumers,
    required this.totalRedemptions,
    required this.activeSubscriptions,
    required this.issues,
  });

  factory DashboardCards.fromJson(Map<String, dynamic> json) {
    return DashboardCards(
      totalRevenue: MetricCard.fromJson(_asMap(json['totalRevenue'])),
      totalMerchants: MetricCard.fromJson(_asMap(json['totalMerchants'])),
      totalConsumers: MetricCard.fromJson(_asMap(json['totalConsumers'])),
      totalRedemptions: MetricCard.fromJson(_asMap(json['totalRedemptions'])),
      activeSubscriptions: ActiveSubscriptionsCard.fromJson(
        _asMap(json['activeSubscriptions']),
      ),
      issues: MetricCard.fromJson(_asMap(json['issues'])),
    );
  }
}

class MetricCard {
  final num value;
  final num growthFromLastMonth;

  const MetricCard({required this.value, required this.growthFromLastMonth});

  factory MetricCard.fromJson(Map<String, dynamic> json) {
    return MetricCard(
      value: _asNum(json['value']),
      growthFromLastMonth: _asNum(json['growthFromLastMonth']),
    );
  }
}

class ActiveSubscriptionsCard extends MetricCard {
  final num totalCores;
  final num totalSpotlight;

  const ActiveSubscriptionsCard({
    required super.value,
    required super.growthFromLastMonth,
    required this.totalCores,
    required this.totalSpotlight,
  });

  factory ActiveSubscriptionsCard.fromJson(Map<String, dynamic> json) {
    return ActiveSubscriptionsCard(
      value: _asNum(json['value']),
      growthFromLastMonth: _asNum(json['growthFromLastMonth']),
      totalCores: _asNum(json['totalCores']),
      totalSpotlight: _asNum(json['totalSpotlight']),
    );
  }
}

class RevenueByMonth {
  final String month;
  final num corePlan;
  final num spotlightPlan;

  const RevenueByMonth({
    required this.month,
    required this.corePlan,
    required this.spotlightPlan,
  });

  factory RevenueByMonth.fromJson(Map<String, dynamic> json) {
    return RevenueByMonth(
      month: json['month']?.toString() ?? '',
      corePlan: _asNum(json['corePlan']),
      spotlightPlan: _asNum(json['spotlightPlan']),
    );
  }
}

class SignupByMonth {
  final String month;
  final num merchants;
  final num consumers;

  const SignupByMonth({
    required this.month,
    required this.merchants,
    required this.consumers,
  });

  factory SignupByMonth.fromJson(Map<String, dynamic> json) {
    return SignupByMonth(
      month: json['month']?.toString() ?? '',
      merchants: _asNum(json['merchants']),
      consumers: _asNum(json['consumers']),
    );
  }
}

class UsageSummary {
  final num totalOffers;
  final num views;
  final num saves;
  final num shares;
  final num activations;
  final num redemptions;
  final num calls;
  final num directions;

  const UsageSummary({
    required this.totalOffers,
    required this.views,
    required this.saves,
    required this.shares,
    required this.activations,
    required this.redemptions,
    required this.calls,
    required this.directions,
  });

  factory UsageSummary.fromJson(Map<String, dynamic> json) {
    return UsageSummary(
      totalOffers: _asNum(json['totalOffers']),
      views: _asNum(json['views']),
      saves: _asNum(json['saves']),
      shares: _asNum(json['shares']),
      activations: _asNum(json['activations']),
      redemptions: _asNum(json['redemptions']),
      calls: _asNum(json['calls']),
      directions: _asNum(json['directions']),
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  return <String, dynamic>{};
}

List<dynamic> _asList(dynamic value) {
  if (value is List) return value;
  return <dynamic>[];
}

num _asNum(dynamic value) {
  if (value is num) return value;
  return num.tryParse(value?.toString() ?? '') ?? 0;
}
