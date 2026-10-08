import 'package:serverpod/serverpod.dart';

import '../util/maintenance.dart';

/// Runs every night at 03:00 UTC (registered in `server.dart` with a cron schedule).
class MaintenanceFutureCall extends FutureCall {
  Future<void> nightly(Session session) async {
    await runMaintenance(session);
  }
}
