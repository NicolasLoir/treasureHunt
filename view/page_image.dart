import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tp6_carte_aux_tresors/modeles/endroit.dart';
import 'package:tp6_carte_aux_tresors/utilitaires/gestion_bdd.dart';
import 'package:tp6_carte_aux_tresors/view/page_principale.dart';

class PageImage extends StatefulWidget {
  final String nomFichierImage;
  final Endroit lieu;
  const PageImage(this.nomFichierImage, this.lieu, {Key? key})
      : super(key: key);

  @override
  _PageImageState createState() => _PageImageState();
}

class _PageImageState extends State<PageImage> {
  @override
  Widget build(BuildContext context) {
    print("abcdef page_image " + widget.nomFichierImage);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sauvegarder la photo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              widget.lieu.image = widget.nomFichierImage;
              GestionBdD.insererEndroit(widget.lieu);
              MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) => const PagePrincipale());
              Navigator.push(context, route);
            },
          ),
        ],
      ),
      body: Image.file(File(widget.nomFichierImage)),
    );
  }
}
