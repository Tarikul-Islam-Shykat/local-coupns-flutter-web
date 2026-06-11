import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackBar(bool isSuccess, String message) {
  Get.snackbar(
    '',
    '',
    titleText: const SizedBox.shrink(),
    messageText: _SnackbarContent(message: message, isSuccess: isSuccess),
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.transparent,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    padding: EdgeInsets.zero,
    borderRadius: 16,
    duration: const Duration(seconds: 3),
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: const Duration(milliseconds: 600),
    snackStyle: SnackStyle.FLOATING,
  );
}

class _SnackbarContent extends StatefulWidget {
  final String message;
  final bool isSuccess;

  const _SnackbarContent({required this.message, required this.isSuccess});

  @override
  State<_SnackbarContent> createState() => _SnackbarContentState();
}

class _SnackbarContentState extends State<_SnackbarContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSuccess = widget.isSuccess;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSuccess ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSuccess
                    ? Colors.black.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isSuccess
                      ? Colors.black.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color:
                  isSuccess
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
              blurRadius: 30,
              offset: const Offset(0, 4),
              spreadRadius: -5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon bubble
                  _AnimatedIconBubble(isSuccess: isSuccess),

                  const SizedBox(width: 12),

                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              isSuccess ? 'Success' : 'Error',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSuccess ? Colors.black : Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color:
                                    isSuccess
                                        ? Colors.green.shade600
                                        : Colors.red.shade400,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        isSuccess
                                            ? Colors.green.withValues(
                                              alpha: 0.5,
                                            )
                                            : Colors.red.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.message,
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                isSuccess
                                    ? Colors.black.withValues(alpha: 0.7)
                                    : Colors.white.withValues(alpha: 0.8),
                            height: 1.3,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Dismiss button
                  GestureDetector(
                    onTap: () => Get.closeCurrentSnackbar(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color:
                            isSuccess
                                ? Colors.black.withValues(alpha: 0.05)
                                : Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              isSuccess
                                  ? Colors.black.withValues(alpha: 0.08)
                                  : Colors.white.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color:
                              isSuccess
                                  ? Colors.black.withValues(alpha: 0.6)
                                  : Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Progress bar
            AnimatedBuilder(
              animation: _progressController,
              builder: (context, _) {
                return ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: LinearProgressIndicator(
                    value: 1 - _progressController.value,
                    backgroundColor:
                        isSuccess
                            ? Colors.black.withValues(alpha: 0.05)
                            : Colors.white.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation(
                      isSuccess ? Colors.green.shade600 : Colors.red.shade400,
                    ),
                    minHeight: 3,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedIconBubble extends StatefulWidget {
  final bool isSuccess;

  const _AnimatedIconBubble({required this.isSuccess});

  @override
  State<_AnimatedIconBubble> createState() => _AnimatedIconBubbleState();
}

class _AnimatedIconBubbleState extends State<_AnimatedIconBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color:
            widget.isSuccess
                ? Colors.black.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color:
              widget.isSuccess
                  ? Colors.black.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Center(
          child: Icon(
            widget.isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
            color:
                widget.isSuccess ? Colors.green.shade600 : Colors.red.shade400,
            size: 24,
          ),
        ),
      ),
    );
  }
}
