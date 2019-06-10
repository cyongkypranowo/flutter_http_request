import 'package:flutter/material.dart';

//IMPORT PACKAGE UNTUK HTTP REQUEST DAN ASYNCHRONOUS
import 'dart:async';
import 'dart:convert';
// ignore: uri_does_not_exist
import 'package:http/http.dart' as http;

void main() {
  runApp(DigitalQuran());
}

class DigitalQuran extends StatefulWidget {
  State<DigitalQuran> createState() => DigitalQuranState();
}

class DigitalQuranState extends State<DigitalQuran> {
  @override
  void initState() {
    super.initState();
    this.getData(); //panggil fungsi yang telah dibuat sebelumnya
  }

//  Variabel url untuk menampung url end point
  final String url = 'https://api.banghasan.com/quran/format/json/surat';
  List data;

  Future<String> getData() async {
//    Meminta Data Ke Server Dengan Ketentuan yang di Accept JSON
    var res = await http
        .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
    setState(() {
      //Response yang didapatkan dari API di decode
      var content = json.decode(res.body);
      //datanya disimpan dalam variabel data
      //data dari API yang spesifik diambil adalah dari key 'hasil'
      data = content['hasil'];
    });
    return 'success!';
  }

  Widget build(context) {
    return MaterialApp(
      title: 'Digital Quran',
      home: Scaffold(
          appBar: AppBar(
              title: Text('Digital Quran')
          ),
          body: Container(
            margin: EdgeInsets.all(10.0), //Set margin dari container
            child: ListView.builder( //Membuat listview
              itemCount: data == null ? 0:data.length, //Ketika datanya kosong maka diisi dengan 0, namun bila ada maka datanya diisi sesuai jumlah banyaknya data
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min, children: <Widget>[
                        //ListTile mengelompokkan widget menjadi beberapa bagian
                        ListTile(
                          //leading tampil pada sebelah kiri
                          // value dari leading adalah widget text yang berisi nomor surah
                          leading: Text(data[index]['nomor'], style: TextStyle(fontSize: 30.0),),
                          // title tampil ditengan setelah leading
                          // valuenya adalah widget text yang berisi nama surah
                          title: Text(data[index]['nama'], style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
                          //trailing tampil disebelah kanan
                          //valuenya dari image, ketika key type nilainya adalah mekah maka ambil dari mekah, jika madinah maka ambil madinah
                          trailing: Image.asset(data[index]['type'] == 'mekah' ? 'mekah.jpg':'madinah.png', width: 32.0, height: 32.0,),
                          //subtitle tampil tepat dibawah title
                          subtitle: Column(children: <Widget>[ //menggunakan kolom
                            //setiap kolom memiliki row
                            Row(
                              children: <Widget>[
                                //Menampilkan text arti
                                Text('Arti : ', style: TextStyle(fontWeight: FontWeight.bold),),
                                //Menampilkan text dari arti
                                Text(data[index]['arti'], style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15.0),),
                              ],
                            ),
                            //row selanjutnya menampilkan jumlah ayat
                            Row(
                              children: <Widget>[
                                Text('Jumlah Ayat : ', style: TextStyle(fontWeight: FontWeight.bold),),
                                //menampilkan dari index ayat
                                Text(data[index]['ayat'])
                              ],
                            ),
                            //Menampilkan dimana surah tersebut diturunkan dengan type index
                            Row(
                              children: <Widget>[
                                Text('Diturunkan : ', style: TextStyle(fontWeight: FontWeight.bold),),
                                //DENGAN INDEX type
                                Text(data[index]['type'])
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text('Urutan Ayat ke : ', style: TextStyle(fontWeight: FontWeight.bold),),
                                //DENGAN INDEX type
                                Text(data[index]['urut'])
                              ],
                            ),
                          ],),
                        ),
                        //Membuat tombol/button
                        ButtonTheme.bar(
                          child: ButtonBar(
                            children: <Widget>[
                              // Tombol pertama dengan text lihat detail
                              FlatButton(
                                child: const Text('LIHAT DETAIL'),
                                onPressed: () { /* ... */ },
                              ),
                              // Tombol pertama dengan text dengarkan
                              FlatButton(
                                child: const Text('DENGARKAN'),
                                onPressed: () { /* ... */ },
                              ),
                            ],
                          ),
                        ),
                      ],),
                    )
                );
              },
            ),
          )
      ),
    );
  }
}
