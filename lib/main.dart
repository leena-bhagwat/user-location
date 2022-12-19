 import 'dart:math';
import 'dart:typed_data';
 import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 import 'package:google_maps_flutter/google_maps_flutter.dart';
 import 'package:location/location.dart';
import 'visitedLocations.dart';
void main() {//MaterialApp(home: LocationApp());
   runApp(MyApp());
 }
 class MyApp extends StatelessWidget {
   // This widget is the root of your application.
   @override
   Widget build(BuildContext context) {

     return MaterialApp(

       home: LocationApp(),
     );

   }
}

class LocationApp extends StatefulWidget {
  const LocationApp({Key? key}) : super(key: key);

  @override
  State<LocationApp> createState() => _MyAppState();


}

class _MyAppState extends State<LocationApp> {
  late GoogleMapController mapController; 
  Location currentLocation = Location();
  Set<Marker> _markers = Set(); //markers for google map
   LatLng _center = const LatLng(45.521563, -122.677433);

  @override
  void initState(){
    super.initState();
    user=new Userlocations();
   // setState(() {
    //  addMarkers();
      getLocation();

    //});
  }

  late BitmapDescriptor markerbitmap;
  addMarkers() async {
     markerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/user.png",
    );
  }

  void getLocation() async{
    var location = await currentLocation.getLocation();

    currentLocation.onLocationChanged.listen((LocationData loc){


      print(loc.latitude);
      print(loc.longitude);
      setState(() {
        _center=LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0);

      });
    });
  }
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onRandomLocation()
  {
    Random random = new Random();
    double newLat = random.nextInt(170)-85;
    double newLon = random.nextInt(360)-180;
    print('New lat lon '+newLat.toString()+' '+newLon.toString());

    setState((){
      newloc=LatLng(	newLat, newLon);
    });
      user.addLocation('Lat: '+newLat.toString()+', Long: '+newLon.toString());
    print('locations random'+user.getPreLocations().length.toString());
      mapController?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(

        target:newloc ,

      zoom: 7.0,
    )));
    //  _showPreLocations();
      // target: const LatLng(	60.621607, 16.775918),
    _markers.add(Marker(markerId: MarkerId(newloc.toString()),
        icon: markerbitmap,
        position: newloc
    ));
    // });
    setState(() {
      //refresh UI
    });
  }
  late LatLng newloc;
  late Userlocations user;
   _showPreLocations() async
  { List<String> _userLocations= user.getPreLocations();
    showDialog(
        context: context,
        builder: (_) => new Dialog(

          backgroundColor:Color(0x83c4c4c4), // Colors.transparent,
          child: new Container(
              alignment: FractionalOffset.center,
              height: 80.0,
             // padding: const EdgeInsets.all(20.0),
              child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Current Location',style:TextStyle(color: Colors.white)),
                    Container(padding:EdgeInsets.all(8) , alignment: Alignment.center,

                        child:Text('Latitude: '+newloc.latitude.toString(),style:TextStyle(color: Colors.white))),
                    Text('Longituuude: '+newloc.longitude.toString(),style:TextStyle(color: Colors.white)),
                    Container(padding:EdgeInsets.all(8) , alignment: Alignment.center,

                        child: Text('Previous',style:TextStyle(color: Colors.white))),
              for(int i=0;i<_userLocations.length-1;i++)

                Container(padding:EdgeInsets.all(8) , alignment: Alignment.topLeft,

                child:SingleChildScrollView(scrollDirection: Axis.horizontal,

                child:Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                        Text(_userLocations[i],style: TextStyle(color: Colors.white)),
                    ] )))
                  ]),
          ),
        ));
  }
  void _onCurrentLocation()
  {

    mapController?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
      target: _center,

      zoom: 12.0,
    )));
    _markers.add(Marker(markerId: MarkerId(_center.toString()),
        icon: markerbitmap,
        position: _center
    ));
    // });
    setState(() {
      //refresh UI
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Maps Sample App'),
        //   backgroundColor: Colors.green[700],
        // ),
        body:Center(child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[GoogleMap(
            zoomGesturesEnabled: true,
          //  markers: _markers,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(

            target: _center,
            zoom: 11.0,
          ),
        ),
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Column( mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center ,
            children: <Widget>[ ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 25.0,fixedSize: Size(155, 45)),
                onPressed: () => _onRandomLocation(),
                child: new Text("Teleport me to someware random",style:TextStyle(color: Colors.white,fontSize: 11),textAlign: TextAlign.center,)),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 25.0,fixedSize: Size(155, 45)),
                  onPressed: () => _onCurrentLocation(),
                  child: new Text("Bring me back home",style:TextStyle(color: Colors.white,fontSize: 11),textAlign: TextAlign.center,)),



            ])
        ),]
      ),
    )));
  }
}