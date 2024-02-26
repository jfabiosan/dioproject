import "package:flutter/material.dart";

class MenuDrawer {
  static Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              child: const Text("Criar backup"),
              onTap: () {},
            ),
            const Divider(),
            const SizedBox(height: 18),
            InkWell(
              child: const Text("Importar backup"),
              onTap: () {},
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
