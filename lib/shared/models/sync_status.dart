enum SyncStatus {
  pending,
  syncing,
  synced,
  failed;

  String get label {
    switch (this) {
      case SyncStatus.pending:
        return 'Pending';
      case SyncStatus.syncing:
        return 'Syncing';
      case SyncStatus.synced:
        return 'Synced';
      case SyncStatus.failed:
        return 'Failed';
    }
  }
}
