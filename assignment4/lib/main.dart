import 'package:flutter/material.dart';

void main() => runApp(const PulseApp());

class PulseApp extends StatelessWidget {
  const PulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF1F4D3A);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Pulse',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          primary: seed,
          secondary: const Color(0xFFE07A5F),
          surface: const Color(0xFFF7F3EC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F3EC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F4D3A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFFE8E0D4)),
          ),
        ),
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isPhone = width < 600;
    final isTablet = width >= 600 && width < 1024;
    final pad = isPhone ? 16.0 : 24.0;
    final statsCols = isPhone ? 2 : isTablet ? 4 : 4;
    final courseCols = isPhone ? 1 : isTablet ? 2 : 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Pulse', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Color(0xFFE07A5F),
              child: Text('S', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(pad, 20, pad, 32),
        children: [
          _WelcomeBanner(wide: !isPhone),
          const SizedBox(height: 22),
          const _SectionTitle('Today at a glance'),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: statsCols,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: isPhone ? 1.35 : 1.7,
            children: const [
              _StatCard(icon: Icons.menu_book_outlined, label: 'Classes', value: '4', tint: Color(0xFF1F4D3A)),
              _StatCard(icon: Icons.assignment_outlined, label: 'Due today', value: '2', tint: Color(0xFFE07A5F)),
              _StatCard(icon: Icons.stars_outlined, label: 'GPA', value: '8.6', tint: Color(0xFF3D6B58)),
              _StatCard(icon: Icons.schedule_outlined, label: 'Hours left', value: '5', tint: Color(0xFFC26E56)),
            ],
          ),
          const SizedBox(height: 24),
          if (width >= 900)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(flex: 3, child: _ScheduleCard()),
                const SizedBox(width: 16),
                Flexible(flex: 2, child: _ShortcutsCard(wide: true)),
              ],
            )
          else ...[
            const _ScheduleCard(),
            const SizedBox(height: 16),
            const _ShortcutsCard(wide: false),
          ],
          const SizedBox(height: 24),
          const _SectionTitle('Your courses'),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _courses.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: courseCols,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: isPhone ? 2.4 : 1.55,
            ),
            itemBuilder: (context, i) => _CourseCard(course: _courses[i]),
          ),
          const SizedBox(height: 24),
          const _SectionTitle('Announcements'),
          const SizedBox(height: 12),
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _notes.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final note = _notes[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: note.$3.withValues(alpha: 0.15),
                    child: Icon(note.$2, color: note.$3, size: 20),
                  ),
                  title: Text(note.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(note.$4),
                  trailing: const Icon(Icons.chevron_right, size: 18),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner({required this.wide});
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(wide ? 22 : 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF1F4D3A), Color(0xFF3D6B58)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Good evening, arham khan',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text('Flutter lab is next. 2 tasks are waiting.',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.85))),
                if (wide) ...[
                  const SizedBox(height: 14),
                  FilledButton.tonal(
                    onPressed: () {},
                    style: FilledButton.styleFrom(foregroundColor: const Color(0xFF1F4D3A)),
                    child: const Text('Open timetable'),
                  ),
                ],
              ],
            ),
          ),
          if (wide)
            const Flexible(
              child: Icon(Icons.school_outlined, size: 72, color: Colors.white70),
            ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1F4D3A)));
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.label, required this.value, required this.tint});
  final IconData icon;
  final String label;
  final String value;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: tint.withValues(alpha: 0.12), child: Icon(icon, color: tint)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: Color(0xFF7A7167), fontSize: 13)),
                  Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: tint)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: _SectionTitle('Today’s timetable'),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _slots.length,
              itemBuilder: (context, i) {
                final slot = _slots[i];
                return ListTile(
                  leading: Container(
                    width: 54,
                    alignment: Alignment.center,
                    child: Text(slot.$1, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1F4D3A))),
                  ),
                  title: Text(slot.$2, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(slot.$3),
                  trailing: Icon(slot.$4, color: const Color(0xFFE07A5F)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ShortcutsCard extends StatelessWidget {
  const _ShortcutsCard({required this.wide});
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.cloud_upload_outlined, 'Submit lab'),
      (Icons.groups_outlined, 'Join meetup'),
      (Icons.library_books_outlined, 'Library seat'),
      (Icons.mail_outline, 'Faculty mail'),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('Quick actions'),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: wide ? 2 : 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: wide ? 1.6 : 2.2,
              children: [
                for (final a in actions)
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {},
                    child: Ink(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F3EC),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(a.$1, color: const Color(0xFF1F4D3A)),
                          const SizedBox(height: 6),
                          Text(a.$2, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.course});
  final (String, String, double, Color) course;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course.$1, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            Text(course.$2, style: const TextStyle(color: Color(0xFF7A7167))),
            const Spacer(),
            LinearProgressIndicator(
              value: course.$3,
              color: course.$4,
              backgroundColor: const Color(0xFFEFE8DC),
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 6),
            Text('${(course.$3 * 100).round()}% complete', style: const TextStyle(fontSize: 12, color: Color(0xFF7A7167))),
          ],
        ),
      ),
    );
  }
}

const _courses = <(String, String, double, Color)>[
  ('Flutter Studio', 'Prof. Mehta  •  Lab 2', 0.72, Color(0xFF1F4D3A)),
  ('UI Systems', 'Prof. Rao  •  A-204', 0.45, Color(0xFFE07A5F)),
  ('DSA Practice', 'Self paced', 0.88, Color(0xFF3D6B58)),
];

const _slots = <(String, String, String, IconData)>[
  ('09:30', 'UI Systems lecture', 'Room A-204', Icons.desktop_windows_outlined),
  ('11:15', 'Flutter Studio lab', 'Lab 2', Icons.phone_iphone),
  ('14:00', 'Mentor hour', 'Online', Icons.videocam_outlined),
];

const _notes = <(String, IconData, Color, String)>[
  ('Lab submission window closes 8 PM', Icons.timer_outlined, Color(0xFFE07A5F), '2 hours left'),
  ('Guest talk: Product design Friday', Icons.campaign_outlined, Color(0xFF1F4D3A), 'Campus auditorium'),
  ('Library seats open for booking', Icons.event_available_outlined, Color(0xFF3D6B58), 'Starts tomorrow 9 AM'),
];
