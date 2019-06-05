import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/pages/mapas_pages.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;
import 'direcciones_page.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.borrarScanTODOS,
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: ()=> _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),

    );
  }

  _scanQR(BuildContext context) async{
    //https://www.youtube.com/watch?v=Ws7K6eNcu-8
    // geo:40.717988192775195,-73.98946180781252

     String futureString;
    try {
        futureString =  await   new QRCodeReader().scan();
      } catch (error) {
        futureString = error.toString();
      }
  

    if(futureString !=null){

        final scan = ScanModel(valor: futureString);
        scansBloc.agregarScan(scan);

        if(Platform.isIOS){
          Future. delayed(Duration(milliseconds: 750), (){
                    utils.abrirScan(context, scan);
          });
        }else{
            utils.abrirScan(context, scan);
        }
    }

  }

  Widget  _callPage(int paginaActual){
    switch( paginaActual ){
      case 0: return MapasPages();
      case 1: return DireccionesPages();
      
      default: 
        return MapasPages();
    }
  }

  Widget  _crearBottomNavigationBar(){
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index){
        setState(() {
            currentIndex = index;
        });
      } ,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapa')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones')
        )
      ],
    );
  }
}