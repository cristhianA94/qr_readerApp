import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:qr_reader/src/providers/scan_list_provider.dart';
import 'package:qr_reader/src/utils/utils.dart';

class ScanTiles extends StatelessWidget {
  final String tipo;

  const ScanTiles({@required this.tipo});

  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.scans;

    return ListView.builder(
      itemCount: scans.length,
      // ** Accion al Deslizar
      itemBuilder: (_, i) => Dismissible(
        key: UniqueKey(),
        // Efecto del contenido al deslizar
        crossAxisEndOffset: 1.5,
        // Direccion a deslizar
        direction: DismissDirection.startToEnd,
        // Duracion de cuando se selecciona y se suelta
        movementDuration: Duration(seconds: 1),
        resizeDuration: Duration(milliseconds: 200),
        onDismissed: (DismissDirection direction) {
          // Borra el scan seleccionado
          Provider.of<ScanListProvider>(context, listen: false)
              .borrarScanByID(scans[i].id);
        },
        background: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          color: Colors.red,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.delete, size: 40.0),
            ],
          ),
        ),

        // **Lista Scans
        child: ListTile(
          leading: Icon(
              this.tipo == 'http' ? Icons.home_outlined : Icons.map_outlined,
              color: Theme.of(context).primaryColor),
          title: Text(scans[i].valor),
          subtitle: Text(scans[i].id.toString()),
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
          onTap: () => launchURL(context, scans[i]),
        ),
      ),
    );
  }
}
