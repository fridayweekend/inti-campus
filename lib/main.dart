import 'package:flutter/material.dart';

void main() => runApp(const IntiCampusApp());
const red = Color(0xFFD71920);
const ink = Color(0xFF202A35);

class IntiCampusApp extends StatelessWidget {
  const IntiCampusApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'INTI Campus',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: red, primary: red),
      scaffoldBackgroundColor: const Color(0xFFF5F5F7),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: ink,
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: ink,
        ),
        titleLarge: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w700,
          color: ink,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: ink,
        ),
        bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: ink),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ink,
      ),
    ),
    home: const CampusShell(),
  );
}

class Activity {
  Activity(
    this.title,
    this.category,
    this.date,
    this.location,
    this.description,
    this.icon,
  );
  final String title, category, date, location, description;
  final IconData icon;
  bool joined = false, saved = false;
}

class CampusShell extends StatefulWidget {
  const CampusShell({super.key});
  @override
  State<CampusShell> createState() => _CampusShellState();
}

class _CampusShellState extends State<CampusShell> {
  int currentIndex = 0;
  String studentName = 'Alex Tan',
      studentId = 'DEMO-2026001',
      programme = 'Bachelor of Computer Science',
      email = 'alex.tan@example.com';
  String query = '';
  bool savedOnly = false;
  final reminders = <String>[];
  final activities = <Activity>[
    Activity(
      'Build with Flutter',
      'TECHNOLOGY',
      '12 Oct 2026 · 2:00 PM',
      'Computing lab · sample venue',
      'Create your first mobile interface with fellow student developers. Bring your laptop and curiosity.',
      Icons.code_rounded,
    ),
    Activity(
      'Campus sports afternoon',
      'SPORT & WELLBEING',
      '16 Oct 2026 · 4:00 PM',
      'Sports court · sample venue',
      'Meet new teammates for a friendly afternoon of basketball and campus games.',
      Icons.sports_basketball_rounded,
    ),
    Activity(
      'Culture & community night',
      'COMMUNITY',
      '23 Oct 2026 · 6:00 PM',
      'Student hall · sample venue',
      'Share music, food stories and traditions with the INTI student community.',
      Icons.diversity_3_rounded,
    ),
  ];

  void notify(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void selectPage(int index) => setState(() => currentIndex = index);
  void info(String title, String message) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Got it'),
        ),
      ],
    ),
  );

  Future<void> addReminder() async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (_) => const EditDialog(
        title: 'New reminder',
        labels: ['What do you need to do?'],
        values: [''],
        saveLabel: 'Add reminder',
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      reminders.add(result[0]);
      currentIndex = 0;
    });
    notify('Reminder created');
  }

  Future<void> editProfile() async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (_) => EditDialog(
        title: 'Edit student profile',
        labels: const ['Student name', 'Student ID', 'Programme', 'Email'],
        values: [studentName, studentId, programme, email],
        saveLabel: 'Save profile',
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      studentName = result[0];
      studentId = result[1];
      programme = result[2];
      email = result[3];
    });
    notify('Student profile updated');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Row(
        children: [
          Image.asset('assets/logo.jpg', width: 65, semanticLabel: 'INTI logo'),
          const SizedBox(width: 12),
          const Flexible(
            child: Text(
              'Campus',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Announcements',
          onPressed: () => info(
            'Campus noticeboard',
            'Welcome to your INTI campus companion. Explore activities and create a reminder for your next task.\n\nThis is a student project. Events, venues, notices and student details are demonstration data, not official university information.',
          ),
          icon: const Icon(Icons.notifications_outlined),
        ),
        const SizedBox(width: 8),
      ],
    ),
    drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: red),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.school_rounded, color: red),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    studentName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'INTI International University',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    studentId,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          for (final item in [
            (0, Icons.dashboard_outlined, 'Home'),
            (1, Icons.event_outlined, 'Campus activities'),
            (2, Icons.person_outline, 'My profile'),
          ])
            ListTile(
              selected: currentIndex == item.$1,
              leading: Icon(item.$2),
              title: Text(item.$3),
              onTap: () {
                Navigator.pop(context);
                selectPage(item.$1);
              },
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help centre'),
            onTap: () {
              Navigator.pop(context);
              info(
                'How to use INTI Campus',
                'Use the bottom navigation to explore. Save or join a demo activity, edit your profile, or tap New reminder. Tap the circle beside a reminder to complete it.\n\nChanges reset when the app restarts or the browser refreshes.',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About this project'),
            onTap: () {
              Navigator.pop(context);
              info(
                'INTI Campus',
                'A Flutter Scaffold student project for INTI International University.\n\nBuilt with AppBar, Drawer, BottomNavigationBar, FloatingActionButton, SnackBar and setState().\n\nAn unofficial educational prototype.',
              );
            },
          ),
        ],
      ),
    ),
    body: SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: IndexedStack(
            index: currentIndex,
            children: [home(), activityPage(), profile()],
          ),
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: addReminder,
      tooltip: 'Create a student reminder',
      backgroundColor: red,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add),
      label: const Text('New reminder'),
    ),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: selectPage,
      selectedItemColor: red,
      unselectedItemColor: const Color(0xFF637080),
      backgroundColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_outlined),
          activeIcon: Icon(Icons.event),
          label: 'Activities',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    ),
  );

  Widget heading(String title, String subtitle) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        Text(subtitle, style: const TextStyle(color: Color(0xFF637080))),
      ],
    ),
  );
  Widget home() => ListView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
    children: [
      const Text(
        'YOUR CAMPUS. YOUR COMMUNITY.',
        style: TextStyle(
          color: red,
          fontSize: 11,
          letterSpacing: 1.8,
          fontWeight: FontWeight.w800,
        ),
      ),
      heading('Welcome, $studentName', 'Make the most of your day at INTI.'),
      ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Image.asset(
              'assets/academic_block.jpg',
              height: 230,
              width: double.infinity,
              fit: BoxFit.cover,
              semanticLabel: 'Aerial view of the INTI academic block',
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.85),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'A place to grow.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'INTI International University',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          Chip(
            avatar: const Icon(Icons.event_available, size: 18),
            label: Text('${activities.where((a) => a.joined).length} joined'),
          ),
          Chip(
            avatar: const Icon(Icons.bookmark_outline, size: 18),
            label: Text('${activities.where((a) => a.saved).length} saved'),
          ),
          Chip(
            avatar: const Icon(Icons.check_circle_outline, size: 18),
            label: Text('${reminders.length} reminders'),
          ),
        ],
      ),
      const SizedBox(height: 20),
      Text('Campus essentials', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 12),
      LayoutBuilder(
        builder: (context, constraints) => Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            service(
              'Library',
              'Plan your next study session',
              Icons.local_library_outlined,
              constraints.maxWidth,
              () => info(
                'Library',
                'Use the library for reading, research and focused study. Check official university channels for current opening hours and borrowing rules.',
              ),
            ),
            service(
              'Student support',
              'Find a little guidance',
              Icons.support_agent,
              constraints.maxWidth,
              () => info(
                'Student support',
                'Contact university student services through your official student portal for academic, wellbeing or campus enquiries. This demo does not submit support requests.',
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      Row(
        children: [
          Expanded(
            child: Text(
              'Get involved',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          TextButton(
            onPressed: () => selectPage(1),
            child: const Text('View activities'),
          ),
        ],
      ),
      Card(
        color: Colors.white,
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: const CircleAvatar(
            backgroundColor: Color(0xFFFFE7E8),
            child: Icon(Icons.code, color: red),
          ),
          title: const Text('Build with Flutter'),
          subtitle: const Text('12 Oct · Sample campus activity'),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () => selectPage(1),
        ),
      ),
      const SizedBox(height: 24),
      Text('My reminders', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      if (reminders.isEmpty)
        const Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'A clear start. Tap New reminder to plan your next campus task.',
            ),
          ),
        ),
      for (int i = 0; i < reminders.length; i++)
        Card(
          color: Colors.white,
          child: ListTile(
            leading: IconButton(
              tooltip: 'Complete reminder',
              icon: const Icon(Icons.radio_button_unchecked),
              onPressed: () {
                setState(() => reminders.removeAt(i));
                notify('Reminder completed');
              },
            ),
            title: Text(reminders[i]),
          ),
        ),
      const SizedBox(height: 18),
      const Text(
        'Student project · Sample events and profile · Session-only changes',
        style: TextStyle(fontSize: 12, color: Color(0xFF637080)),
      ),
    ],
  );

  Widget service(
    String title,
    String subtitle,
    IconData icon,
    double width,
    VoidCallback action,
  ) => SizedBox(
    width: width < 520 ? width : (width - 12) / 2,
    child: Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: action,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, color: red, size: 30),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    Text(subtitle),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    ),
  );

  Widget activityPage() {
    final visible = activities
        .where(
          (a) =>
              (!savedOnly || a.saved) &&
              '${a.title} ${a.category} ${a.description}'
                  .toLowerCase()
                  .contains(query.toLowerCase()),
        )
        .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      children: [
        heading(
          'Find your next thing.',
          'Discover, save and join campus activities.',
        ),
        const Text(
          'Sample events for this student project. Joining is a local demo action.',
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            hintText: 'Search activities',
            prefixIcon: Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (value) => setState(() => query = value),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: FilterChip(
            label: const Text('Saved only'),
            avatar: const Icon(Icons.bookmark_outline, size: 18),
            selected: savedOnly,
            onSelected: (value) => setState(() => savedOnly = value),
          ),
        ),
        const SizedBox(height: 10),
        if (visible.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'No activities match. Try another search or turn off Saved only.',
            ),
          ),
        for (final a in visible)
          Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFFFE7E8),
                        child: Icon(a.icon, color: red),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          a.category,
                          style: const TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.1,
                            color: red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: a.saved
                            ? 'Unsave ${a.title}'
                            : 'Save ${a.title}',
                        icon: Icon(
                          a.saved ? Icons.bookmark : Icons.bookmark_border,
                        ),
                        color: red,
                        onPressed: () {
                          setState(() => a.saved = !a.saved);
                          notify(
                            a.saved
                                ? 'Activity saved'
                                : 'Activity removed from saved',
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(a.title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(a.description),
                  const SizedBox(height: 16),
                  detail(Icons.schedule, a.date),
                  detail(Icons.location_on_outlined, a.location),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () {
                      setState(() => a.joined = !a.joined);
                      notify(
                        a.joined
                            ? 'Joined ${a.title} (demo)'
                            : 'Registration cancelled (demo)',
                      );
                    },
                    icon: Icon(a.joined ? Icons.check : Icons.add),
                    label: Text(
                      a.joined ? 'Joined · Tap to cancel' : 'Join activity',
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget detail(IconData icon, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 19, color: const Color(0xFF637080)),
        const SizedBox(width: 10),
        Expanded(child: Text(value)),
      ],
    ),
  );
  Widget profile() => ListView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
    children: [
      heading(
        'Your student space.',
        'A little about you. A lot of possibility.',
      ),
      Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 34,
                backgroundColor: Color(0xFFFFE7E8),
                child: Icon(Icons.person_rounded, color: red, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                studentName,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Text('INTI International University'),
              const SizedBox(height: 24),
              detail(Icons.badge_outlined, 'Student ID: $studentId'),
              detail(Icons.school_outlined, programme),
              detail(Icons.email_outlined, email),
              detail(
                Icons.calendar_month_outlined,
                'Semester 1 · Sample profile',
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: editProfile,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit profile'),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),
      Text(
        'Your campus involvement',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 10),
      for (final a in activities.where((a) => a.joined))
        Card(
          color: Colors.white,
          child: ListTile(
            leading: Icon(a.icon, color: red),
            title: Text(a.title),
            subtitle: Text(a.date),
          ),
        ),
      if (!activities.any((a) => a.joined))
        const Text('Your joined activities will appear here.'),
      const SizedBox(height: 24),
      const Text(
        'This profile starts with fictional details. Edits, saved activities, registrations and reminders are kept only while the app is running.',
        style: TextStyle(color: Color(0xFF637080)),
      ),
    ],
  );
}

// The dialog owns and disposes its controllers after the closing animation.
class EditDialog extends StatefulWidget {
  const EditDialog({
    super.key,
    required this.title,
    required this.labels,
    required this.values,
    required this.saveLabel,
  });
  final String title, saveLabel;
  final List<String> labels, values;
  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  final form = GlobalKey<FormState>();
  late final controllers = widget.values
      .map((v) => TextEditingController(text: v))
      .toList();
  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void save() {
    if (form.currentState!.validate()) {
      Navigator.pop(context, controllers.map((c) => c.text.trim()).toList());
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: SizedBox(
      width: 420,
      child: SingleChildScrollView(
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < controllers.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextFormField(
                    controller: controllers[i],
                    autofocus: i == 0,
                    maxLength: 100,
                    decoration: InputDecoration(labelText: widget.labels[i]),
                    keyboardType: widget.labels[i] == 'Email'
                        ? TextInputType.emailAddress
                        : TextInputType.text,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is required.';
                      }
                      if (widget.labels[i] == 'Email' &&
                          !RegExp(
                            r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                          ).hasMatch(value.trim())) {
                        return 'Enter a valid email address.';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => save(),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(onPressed: save, child: Text(widget.saveLabel)),
    ],
  );
}
