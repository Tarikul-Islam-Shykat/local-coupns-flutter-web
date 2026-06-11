import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'issue_log_service.dart';

class IssueLogPanel extends StatefulWidget {
  const IssueLogPanel({super.key});

  @override
  State<IssueLogPanel> createState() => _IssueLogPanelState();
}

class _IssueLogPanelState extends State<IssueLogPanel> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 720;

    return Obx(() {
      final logs = IssueLogService.instance.logs;

      return Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Material(
            color: Colors.transparent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: _expanded ? (isCompact ? width - 32 : 380) : 172,
              constraints: BoxConstraints(
                maxHeight: _expanded ? (isCompact ? 260 : 340) : 56,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1E293B)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: _expanded
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _PanelHeader(
                            count: logs.length,
                            onToggle: () => setState(() => _expanded = false),
                            onClear: () => IssueLogService.instance.clear(),
                          ),
                          const Divider(height: 1, color: Color(0xFF1E293B)),
                          Flexible(
                            child: logs.isEmpty
                                ? const _EmptyLogState()
                                : ListView.separated(
                                    shrinkWrap: true,
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
                      )
                    : InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => setState(() => _expanded = true),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.bug_report_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Debug Log',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const Spacer(),
                              _LogCountPill(count: logs.length),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({
    required this.count,
    required this.onToggle,
    required this.onClear,
  });

  final int count;
  final VoidCallback onToggle;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
      child: Row(
        children: [
          const Icon(Icons.bug_report_outlined, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            'Debug Log',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 10),
          _LogCountPill(count: count),
          const Spacer(),
          TextButton(onPressed: onClear, child: const Text('Clear')),
          IconButton(
            onPressed: onToggle,
            icon: const Icon(Icons.close_rounded, color: Colors.white70),
            tooltip: 'Collapse log',
          ),
        ],
      ),
    );
  }
}

class _LogCountPill extends StatelessWidget {
  const _LogCountPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
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
    return SizedBox(
      height: 160,
      child: Center(
        child: Text(
          'No issues logged yet.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
      ),
    );
  }
}
