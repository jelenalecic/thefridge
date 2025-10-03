import 'package:thefridge/features/fridge/domain/models/expiry_status.dart';

extension ExpiryDateX on DateTime? {
  ExpiryStatus get expiryStatus {
    final bestBefore = this;
    if (bestBefore == null) return ExpiryStatus.none;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final hours = bestBefore.difference(today).inHours;

    if (hours < 0) return ExpiryStatus.expired;
    if (hours <= 72) return ExpiryStatus.soon;
    return ExpiryStatus.fresh;
  }

  bool get isExpired => expiryStatus == ExpiryStatus.expired;

  bool get isSoon => expiryStatus == ExpiryStatus.soon;
}
