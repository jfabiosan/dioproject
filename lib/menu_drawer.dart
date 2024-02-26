import "package:flutter/material.dart";

import "page/create_backup_page.dart";

class MenuDrawer {
  static Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              child: const Text(
                "Criar backup",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateBackupPage()),
                );
              },
            ),
            const Divider(),
            const SizedBox(height: 18),
            InkWell(
              child: const Text(
                "Importar backup",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {},
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
