import 'package:flutter/material.dart';

class GeneralPage extends StatelessWidget {
  const GeneralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('General')),
      body: Column(
        children: [
          const Text(
            'Bienvenue sur la page générale !',
            style: TextStyle(fontSize: 18),
          ),
          topnavbar(context),
        ],
      ),
    );
  }
}   


Widget topnavbar(BuildContext context) => SizedBox(
  height: 330,
  child: SingleChildScrollView(
    scrollDirection: Axis.vertical,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _blocNavigation(
          label: 'MonApp',
          icon: Icons.apps,
          onTap: () {},
          isPrimary: true,
        ),
        const SizedBox(height: 10),
        _blocNavigation(
          label: 'Pointage',
          icon: Icons.calendar_month,
          onTap: () {
            Navigator.pushNamed(context, '/pointage');
          },
        ),
        const SizedBox(height: 10),
        _blocNavigation(
          label: 'Historique',
          icon: Icons.history,
          onTap: () {
            Navigator.pushNamed(context, '/historique');
          },
        ),
        const SizedBox(height: 10),
        _blocNavigation(
          label: 'Se deconnecter',
          icon: Icons.logout,
          onTap: () {
            Navigator.of(context).pushNamedAndRemoveUntil('/', (Route route) => false);
          },
        ),
      ],
    ),
  ),
);

Widget _blocNavigation({
  required String label,
  required IconData icon,
  required VoidCallback onTap,
  bool isPrimary = false,
}) {
  final Color fond = isPrimary ? Colors.blueGrey.shade700 : Colors.white;
  final Color texte = isPrimary ? Colors.white : Colors.blueGrey.shade900;

  return InkWell(
    borderRadius: BorderRadius.circular(14),
    onTap: onTap,
    child: Ink(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: fond,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blueGrey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: texte),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: texte,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

