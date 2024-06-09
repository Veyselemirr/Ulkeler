import 'dart:ffi';

class Ulke{
String ulkeKodu;
String isim;
String baskent;
String bolge;
int nufus;
String bayrak;
String dil;

Ulke.fromMap(Map<String,dynamic>ulkeMap)
: ulkeKodu=ulkeMap["cca2"]??"",
 isim=ulkeMap["name"]?["common"]??"",
 baskent=(ulkeMap["capital"] as List<dynamic>).isNotEmpty ? ulkeMap["capital"][0] : "",
 bolge=ulkeMap["region"],
 nufus=ulkeMap["population"],
 bayrak=ulkeMap["flags"]?["png"]??"",
 dil=(ulkeMap["languages"] as Map<String,dynamic>).isNotEmpty ?
 (ulkeMap["languages"] as Map<String,dynamic>)
    .entries
    .toList()[0]
    .value :" ";
}

