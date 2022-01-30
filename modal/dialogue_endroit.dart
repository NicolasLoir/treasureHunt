import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tp6_carte_aux_tresors/modeles/endroit.dart';
import 'package:tp6_carte_aux_tresors/utilitaires/gestion_bdd.dart';
import 'package:tp6_carte_aux_tresors/view/page_camera.dart';

class DialogueEndroit {
  final bool estNouveau;
  final Endroit endroit;

  final txtDes = TextEditingController();
  final txtLat = TextEditingController();
  final txtLon = TextEditingController();
  final txtInd = TextEditingController();

  DialogueEndroit(this.endroit, this.estNouveau);

  Widget construireDialogue(BuildContext context) {
    txtDes.text = endroit.designation;
    txtLat.text = endroit.lat.toString();
    txtLon.text = endroit.lon.toString();
    txtInd.text = endroit.indication;

    return AlertDialog(
      title: Text('Endroit ' + endroit.id.toString()),
      content: SingleChildScrollView(
        child: Column(
          children: [
            (txtDes.text == "")
                ? Container()
                : TextField(
                    enabled: false,
                    controller: txtDes,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Désignation',
                    ),
                  ),
            // TextField(
            //   controller: txtLat,
            //   decoration: const InputDecoration(
            //     hintText: 'Latitude',
            //   ),
            // ),
            // TextField(
            //   controller: txtLon,
            //   decoration: const InputDecoration(
            //     hintText: 'Longitude',
            //   ),
            // ),
            TextField(
              enabled: false,
              controller: txtInd,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Indication',
              ),
            ),
            afficherImage(),
            // IconButton(
            //   icon: const Icon(Icons.camera_front),
            //   onPressed: () {
            //     if (estNouveau) {
            //       GestionBdD.insererEndroit(endroit).then((donnees) {
            //         endroit.id = donnees;
            //         MaterialPageRoute route = MaterialPageRoute(
            //             builder: (context) => PageCamera(endroit));
            //         Navigator.push(context, route);
            //       });
            //     } else {
            //       MaterialPageRoute route = MaterialPageRoute(
            //           builder: (context) => PageCamera(endroit));
            //       Navigator.push(context, route);
            //     }
            //   },
            // ),
            ElevatedButton(
                onPressed: () {
                  endroit.designation = txtDes.text;
                  endroit.lat = double.tryParse(txtLat.text)!;
                  endroit.lon = double.tryParse(txtLon.text)!;
                  endroit.indication = txtInd.text;
                  GestionBdD.insererEndroit(endroit);
                  Navigator.pop(context);
                },
                child: const Text('OK'))
          ],
        ),
      ),
    );
  }

  Widget afficherImage() {
    var retour;
    if (endroit.id == 1) {
      retour = Image.asset('images/photo1.png');
    } else if (endroit.id == 2) {
      retour = Image.asset('images/photo2.png');
    }
    // else if (endroit.id == 3) {
    //   retour = Image.asset('images/photoGaletBleu.png');
    // } else if (endroit.id == 4) {
    //   retour = Image.asset('images/photo4.png');
    // } else if (endroit.id == 5) {
    //   retour = Image.asset('images/photo5.png');
    // } else if (endroit.id == 6) {
    //   retour = Image.asset('images/photo6.png');
    // }
    else {
      retour = Container();
      // retour = (endroit.image != '')
      //     ? Image.file(File(endroit.image))
      //     :
    }
    return retour;
  }
}
