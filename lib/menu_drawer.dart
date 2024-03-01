import "package:flutter/material.dart";

import "page/create_backup_page.dart";
import "page/restore_backup_page.dart";

class MenuDrawer {
  static Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateBackupPage()),
                );
              },
              child: const Text(
                "Criar backup",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const Divider(),
            const SizedBox(height: 18),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RestoreBackupPage()),
                );
              },
              child: const Text(
                "Importar backup",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
