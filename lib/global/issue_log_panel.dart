import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'issue_log_service.dart';

class IssueLogPanel extends StatelessWidget {
  const IssueLogPanel({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final logs = IssueLogService.instance.logs;

      return Container(
        width: compact ? double.infinity : 360,
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(compact ? 18 : 0),
          border: Border(
            left: compact
                ? BorderSide.none
                : const BorderSide(color: Color(0xFF1E293B)),
            top: compact
                ? const BorderSide(color: Color(0xFF1E293B))
                : BorderSide.none,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PanelHeader(
              count: logs.length,
              onClear: () => IssueLogService.instance.clear(),
            ),
            const Divider(height: 1, color: Color(0xFF1E293B)),
            Expanded(
              child: logs.isEmpty
                  ? const _EmptyLogState()
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: logs.length,
                      separatorBuilder: (context, _) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final entry = logs[index];
                        return _LogTile(entry: entry);
                      },
                    ),
            ),
          ],
        ),
      );
    });
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.count, required this.onClear});

  final int count;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
      decoration: const BoxDecoration(color: Color(0xFF111C31)),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Color(0xFFFF4000),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Debug / Issue Log',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '$count item(s) stored',
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: Colors.white60),
                ),
              ],
            ),
          ),
          TextButton(onPressed: onClear, child: const Text('Clear')),
        ],
      ),
    );
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({required this.entry});

  final IssueLogEntry entry;

  @override
  Widget build(BuildContext context) {
    final color = switch (entry.level.toLowerCase()) {
      'error' => const Color(0xFFFF6B6B),
      'warning' => const Color(0xFFFFC857),
      _ => const Color(0xFF7DD3FC),
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111C31),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  entry.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                _timeLabel(entry.timestamp),
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: Colors.white54),
              ),
            ],
          ),
          if (entry.details != null && entry.details!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              entry.details!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white70,
                height: 1.35,
              ),
            ),
          ],
          if (entry.imageUrl != null && entry.imageUrl!.isNotEmpty) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  entry.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF0B1220),
                      alignment: Alignment.center,
                      child: Text(
                        'Image failed to load',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.white54),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _timeLabel(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final second = timestamp.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }
}

class _EmptyLogState extends StatelessWidget {
  const _EmptyLogState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No issues logged yet.',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
      ),
    );
  }
}
