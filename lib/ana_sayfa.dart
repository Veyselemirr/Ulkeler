import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:untitled/favoriler.dart';
import 'package:untitled/ortak_liste.dart';
import 'package:untitled/ulke.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/ulke_detay_sayfasi.dart';


class  AnaSayfa extends StatefulWidget {
  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}
  class _AnaSayfaState extends State<AnaSayfa>{
  final String _apiUrl ="https://restcountries.com/v3.1/all?fields=name,flags,cca2,capital,region,languages,population";
  List<Ulke> _butunUlkeler = [];

  List<String> _favoriUlkeKodlari=[];

  @override
  void initState() {
        super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _favorileriCihazHafizasindanCek().then((value){
        _ulkeleriInternettenCek();
      });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: _buildBody(),
    );
  }
  AppBar buildAppBar(BuildContext context){
    return AppBar(
      backgroundColor: Colors.blue,
      title: Text("Tüm Ülkeler"),
      centerTitle: true,
      actions: [
        IconButton(
             icon: Icon(
             Icons.favorite,
             color: Colors.red,
             ),
          onPressed: (){
               _favorilerSayfasiniAc(context);
          },
        ),
      ],
    );
  }

  Widget _buildBody(){
    return _butunUlkeler.isEmpty
        ? Center(child: CircularProgressIndicator())
        : OrtakListe(_butunUlkeler, _favoriUlkeKodlari);
  }

  
  void _ulkeleriInternettenCek() async{
    Uri uri=Uri.parse(_apiUrl);
    http.Response response = await http.get(uri);
      
    List<dynamic> parsedResponse = jsonDecode(response.body);
    for(int i=0;i<parsedResponse.length;i++){
      Map<String,dynamic> ulkeMap=parsedResponse[i];
      Ulke ulke= Ulke.fromMap(ulkeMap);
      _butunUlkeler.add(ulke);
    }
    setState(() {});

  }




  Future<void> _favorileriCihazHafizasindanCek() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();

    List<String> ?favoriler = prefs.getStringList("favoriler");

    if(favoriler!=null){
      for(String ulkeKodu in favoriler){
        _favoriUlkeKodlari.add(ulkeKodu);
      }


    }
  }

  void _favorilerSayfasiniAc(BuildContext context) {
    MaterialPageRoute sayfaYolu=MaterialPageRoute(
      builder: (context) {
        return Favoriler(_butunUlkeler,_favoriUlkeKodlari);
      },
    );
    Navigator.push(context, sayfaYolu);
  }
}





