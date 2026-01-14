import 'package:go_router/go_router.dart';

import 'package:remindme/features/reminder/domain/entities/reminder.dart';
import 'package:remindme/features/reminder/presentation/screens/calendar_screen.dart';
import 'package:remindme/features/reminder/presentation/screens/home_shell_screen.dart';
import 'package:remindme/features/reminder/presentation/screens/reminder_form_screen.dart';
import 'package:remindme/features/reminder/presentation/screens/reminder_list_screen.dart';
import 'package:remindme/features/reminder/presentation/screens/splash_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) =>
          SplashScreen(onGetStarted: () => context.go('/tasks')),
    ),

    ShellRoute(
      builder: (context, state, child) => HomeShellScreen(child: child),
      routes: [
        GoRoute(
          path: '/tasks',
          builder: (context, state) => ReminderListScreen(
            onCreate: () => context.push('/create'),
            onOpenDetail: (reminder) => context.push('/edit', extra: reminder),
          ),
        ),
        GoRoute(
          path: '/calendar',
          builder: (context, state) => const CalendarScreen(),
        ),
      ],
    ),

    GoRoute(
      path: '/create',
      builder: (context, state) => const ReminderFormScreen(),
    ),

    GoRoute(
      path: '/edit',
      builder: (context, state) =>
          ReminderFormScreen(editingReminder: state.extra as Reminder),
    ),
  ],
);
