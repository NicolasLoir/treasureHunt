import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tp6_carte_aux_tresors/modal/dialogue_endroit.dart';
import 'package:tp6_carte_aux_tresors/modeles/endroit.dart';
import 'package:tp6_carte_aux_tresors/utilitaires/gestion_bdd.dart';
import 'package:tp6_carte_aux_tresors/view/gerer_endroit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PagePrincipale extends StatefulWidget {
  const PagePrincipale({Key? key}) : super(key: key);

  @override
  _PagePrincipaleState createState() => _PagePrincipaleState();
}

class _PagePrincipaleState extends State<PagePrincipale> {
  List<Marker> _marqueurs = [];

  static const CameraPosition position = CameraPosition(
    target: LatLng(43.6989, 7.2771),
    zoom: 17,
  );

  @override
  void initState() {
    GestionBdD.chargerEndroits().then((rien) {
      _updateMapState();
    }).catchError((erreur) => print(erreur.toString()));
    super.initState();
  }

  void _updateMapState() {
    _marqueurs.clear();
    _lirePositionActuelle().then((pos) {
      _ajouterMarqueur(pos, 'positionCourante', 'Vous êtes içi');
    }).catchError((erreur) => print(erreur.toString()));
    _lireDonnees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('La carte aux trésors'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) => const GererEndroits());
              Navigator.push(context, route).then((value) {
                _updateMapState();
              });
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: position,
        markers: Set<Marker>.of(_marqueurs),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            left: 25,
            bottom: 0,
            child: FloatingActionButton(
              child: const Icon(Icons.verified),
              onPressed: () async {
                final pref = await SharedPreferences.getInstance();
                final nbMarker = pref.getInt('nombreMarker');
                await pref.setInt('nombreMarker', nbMarker!.toInt() + 1);
                _updateMapState();
                var _endroits = await GestionBdD.lireEndroits();
                DialogueEndroit dialogue =
                    DialogueEndroit(_endroits[nbMarker], false);
                showDialog(
                  context: context,
                  builder: (context) => dialogue.construireDialogue(context),
                ).then((_) {
                  setState(() {});
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<LatLng> _lirePositionActuelle() async {
    // return position.target;
    Location localisation = Location();
    bool _serviceActif;
    PermissionStatus _autorisationAccordee;
    LocationData _donneesLocalisation;

    _serviceActif = await localisation.serviceEnabled();
    if (!_serviceActif) {
      _serviceActif = await localisation.requestService();
      if (!_serviceActif) {
        // return position.target;
      }
    }

    _autorisationAccordee = await localisation.hasPermission();
    if (_autorisationAccordee == PermissionStatus.denied) {
      // return position.target;
      _autorisationAccordee = await localisation.requestPermission();
      print("BUG SUR IOS SIMULATEUR localisation.requestPermission()");
      if (_autorisationAccordee != PermissionStatus.granted) {
        return position.target;
      }
    }

    _donneesLocalisation = await localisation.getLocation();

    return (LatLng(
        _donneesLocalisation.latitude!, _donneesLocalisation.longitude!));
  }

  void _ajouterMarqueur(
      LatLng pos, String marqueurID, String marqueurTitre) async {
    final pref = await SharedPreferences.getInstance();
    final nbMarker = pref.getInt('nombreMarker');
    final marqueur = Marker(
        markerId: MarkerId(marqueurID),
        position: LatLng(pos.latitude, pos.longitude),
        infoWindow: InfoWindow(
          title: marqueurTitre,
        ),
        icon: (marqueurID == 'positionCourante')
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
            : ((nbMarker!.toInt() - 1).toString() == marqueurID)
                ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen)
                : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueOrange));
    _marqueurs.add(marqueur);
    setState(() {
      _marqueurs = _marqueurs;
    });
  }

  Future _lireDonnees() async {
    await GestionBdD.ouvrirBdD();
    List<Endroit> _endroits = await GestionBdD.lireEndroitsMap();
    for (Endroit endroit in _endroits) {
      _ajouterMarqueur(LatLng(endroit.lat, endroit.lon), endroit.id.toString(),
          endroit.designation);
    }
    setState(() {
      _marqueurs = _marqueurs;
    });
  }
}
