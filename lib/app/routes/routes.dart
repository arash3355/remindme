import 'package:go_router/go_router.dart';

import 'package:remindme/features/reminder/domain/entities/reminder.dart';
import 'package:remindme/features/reminder/presentation/screens/calendar_screen.dart';
import 'package:remindme/features/reminder/presentation/screens/home_shell_screen.dart';
import 'package:remindme/features/reminder/presentation/screens/reminder_form_screen.dart';
import 'package:remindme/features/reminder/presentation/screens/reminder_list_screen.dart';
import 'package:remindme/features/reminder/presentation/screens/splash_screen.dart';

import '../../features/auth/presentation/screens/forgot_password_email_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/new_password_screen.dart';
import '../../features/auth/presentation/screens/notification_sound_screen.dart';
import '../../features/auth/presentation/screens/profile_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/verification_code_screen.dart';

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

    // AUTH
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(
      path: '/forgot-email',
      builder: (context, state) => const ForgetPasswordEmailScreen(),
    ),
    GoRoute(
      path: '/verify-code',
      builder: (context, state) => const VerificationCodeScreen(),
    ),
    GoRoute(
      path: '/new-password',
      builder: (context, state) => const NewPasswordScreen(),
    ),

    // PROFILE/SETTINGS
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/notification-sound',
      builder: (context, state) => const NotificationSoundScreen(),
    ),
  ],
);
