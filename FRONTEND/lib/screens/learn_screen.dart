import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/design_system.dart';
import '../models/course.dart';
import '../providers/course_providers.dart';
import 'course_progress_screen.dart';

class LearnScreen extends ConsumerWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(courseListProvider);
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: AppDesignSystem.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Your Course',
              style: AppDesignSystem.heading(textTheme),
            ),
            const SizedBox(height: AppDesignSystem.spacing24),
            Expanded(
              child: coursesAsync.when(
                data: (courses) => ListView.separated(
                  itemCount: courses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppDesignSystem.spacing16),
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return _CourseTile(course: course);
                  },
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (err, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load courses',
                        style: AppDesignSystem.subheading(textTheme),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please check your connection',
                        style: AppDesignSystem.body(textTheme, Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile({required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppDesignSystem.radiusXLarge),
      onTap: () {
        Navigator.of(context).pushNamed(
          CourseProgressScreen.routeName,
          arguments: course.id,
        );
      },
      child: Ink(
        padding: const EdgeInsets.all(AppDesignSystem.spacing20),
        decoration: AppDesignSystem.cardDecoration(colorScheme),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDesignSystem.radiusLarge),
                    gradient: course.artwork.toGradient(),
                  ),
                  child: Icon(
                    course.artwork.icon,
                    size: 44,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: AppDesignSystem.spacing20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: AppDesignSystem.subheading(textTheme),
                      ),
                      const SizedBox(height: AppDesignSystem.spacing8),
                      Text(
                        course.displayVerseCount,
                        style: AppDesignSystem.body(textTheme, colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDesignSystem.spacing16),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: LinearProgressIndicator(
                value: course.percentComplete,
                minHeight: 10,
                backgroundColor: colorScheme.outlineVariant.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(AppDesignSystem.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
