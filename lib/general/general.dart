import 'package:flutter/material.dart';


class GeneralPage extends StatefulWidget {
  const GeneralPage({super.key});

  @override
  State<GeneralPage> createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage> {
  bool _isSaving = false;

  Widget _actionRectangle({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback? onTap,
    bool isPrimary = false,
  }) {
    final Color background = isPrimary
        ? Colors.blueGrey.shade700
        : Colors.white;
    final Color textColor = isPrimary ? Colors.white : Colors.blueGrey.shade900;
    final Color subTextColor = isPrimary
        ? Colors.white70
        : Colors.blueGrey.shade600;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          height: 88,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.blueGrey.shade100),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Icon(icon, color: textColor, size: 26),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: subTextColor, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: textColor),
            ],
          ),
        ),
      ),
    );
  }

  String _employeeNameFromArgs(BuildContext context) {
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.trim().isNotEmpty) {
      return args.trim();
    }
    return 'Employe';
  }

  Future<void> _pointerMaintenant(String employeeName) async {
    setState(() {
      _isSaving = true;
    });

    try {
      final PointageEntry entry = await PointageRepository.enregistrerPointage(
        employeeName,
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pointage enregistre pour ${entry.employeeName} le ${entry.date} a ${entry.heure}.',
          ),
        ),
      );
    } on PointageDuplicateException catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Echec de l\'enregistrement du pointage.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String employeeName = _employeeNameFromArgs(context);

    return Scaffold(
      appBar: AppBar(title: const Text('General')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Bienvenue, $employeeName',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Selectionnez une action :'),
              const SizedBox(height: 24),
              _actionRectangle(
                title: _isSaving ? 'Pointage en cours...' : 'Se pointer',
                subtitle: 'Enregistrer l\'heure d\'arrivee maintenant',
                icon: _isSaving ? Icons.hourglass_top : Icons.access_time,
                onTap: _isSaving
                    ? null
                    : () => _pointerMaintenant(employeeName),
                isPrimary: true,
              ),
              const SizedBox(height: 12),
              _actionRectangle(
                title: 'Voir l\'historique',
                subtitle: 'Consulter la liste des pointages enregistres',
                icon: Icons.history,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/historique',
                    arguments: employeeName,
                  );
                },
              ),
              const SizedBox(height: 12),
              _actionRectangle(
                title: 'Page pointage detail',
                subtitle: 'Acceder a l\'ecran de pointage complet',
                icon: Icons.fingerprint,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/pointage',
                    arguments: employeeName,
                  );
                },
              ),
              const Spacer(),
              _actionRectangle(
                title: 'Se deconnecter',
                subtitle: 'Retourner a l\'ecran d\'accueil',
                icon: Icons.logout,
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/accueil',
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
