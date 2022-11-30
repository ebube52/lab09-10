
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'MapMaker.dart';
import 'MapMarker.dart';
import 'package:latlong2/latlong.dart';
// import 'geolocator/geolocator.dart';
import 'constant.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Map Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  var _positionMessage = '';
  var _descriptionMessage = '';
  List<Marker> markers1=[];

  setMarkers(){
    new Marker(
        width: 45,
        height:45,
        point: new LatLng(51.5382123, -0.1882464),
        builder: (context)=> new Container(
            child: IconButton(
              icon: Icon(Icons.location_on),
              color: Colors.black,
              onPressed: (){print('Marker tapped');
              },
            )

        )
    );
    return markers1;

  }

  var points1 = <LatLng>[
    new LatLng(44.35819, -78.29147),
    new LatLng(43.9354, 78.8599),
    new LatLng(44.9456, 79.8968),
    new LatLng(43.84167, -79.54306),
    new LatLng(43.629, -79.417),
  ];

  int selectedIndex = 0;
  final pageController = PageController();
  var currentLocation = AppConstants.myLocation;

  late MapController mapController;

  @override

  void initState(){
    super.initState();
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    Geolocator.isLocationServiceEnabled().then((value) => null);
    Geolocator.requestPermission().then((value) => null);
    Geolocator.checkPermission().then(
            (LocationPermission permission)
        {
          print("Check Location Permission: $permission");
        }
    );
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
          accuracy: LocationAccuracy.best
      ),
    ).listen(_updateLocationStream);

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
        actions: [
          IconButton(onPressed: (){mapController;}, icon: Icon(Icons.zoom_in)),
          IconButton(onPressed: (){mapController;}, icon: Icon(Icons.zoom_out)),


        ],
      ),
      body: Stack(
        children: [
          Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_positionMessage,
                style: TextStyle(fontSize: 30),
              ),
              Text(
                _descriptionMessage,
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
          FlutterMap(


            mapController: mapController,
            options: MapOptions(



                onTap: (position, latLng) {
                  print('working $latLng');
                  // add marker at latLng.latitude and latLng.longitude
                }
            ),
            layers: [

              TileLayerOptions(
                urlTemplate: AppConstants.mapBoxStyleId,
              ),

              MarkerLayerOptions(
                // markers: markers1,


                markers: [


                  for (int i = 0; i < mapMarkers.length; i++)
                    Marker(
                        height: 80,
                        width: 80,
                        point: mapMarkers[i].location ?? AppConstants.myLocation,
                        builder: (context){

                          return Container(
                            child: IconButton(
                              onPressed: (){
                                setState(() {
                                  pageController.animateToPage(
                                      i,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut
                                  );
                                  selectedIndex = i;
                                  currentLocation = mapMarkers[i].location;
                                  _animatedMapMove(currentLocation, 11.5);
                                });
                              },
                              icon: Icon(Icons.location_on,
                                  color: selectedIndex == i ?
                                  Colors.blue : Colors.black),
                              iconSize: 45,
                            ),
                          );
                        }
                    ),

                ],
              ),
              PolylineLayerOptions(
                  polylines:[
                    new Polyline(points: points1,
                        strokeWidth: 5.0,
                        color: Colors.black)

                  ]

              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 2,
            height: MediaQuery.of(context).size.height*0.3,
            child: PageView.builder(
                controller: pageController,
                itemCount: mapMarkers.length,
                onPageChanged: (value){
                  setState(() {
                    selectedIndex = value;
                    currentLocation = mapMarkers[value].location;
                    _animatedMapMove(currentLocation, 11.5);
                  });
                },
                itemBuilder: (context, index){
                  var item = mapMarkers[index];
                  return Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: const Color.fromARGB(255, 30, 29, 29),
                      child: Row(
                        children: [
                          const SizedBox(width:10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Expanded( //Put in gold stars for restaurant
                                //   child: ListView.builder(
                                //     padding: EdgeInsets.zero,
                                //     scrollDirection: Axis.horizontal,
                                //     itemCount: item.name,
                                //     itemBuilder: (context, index){
                                //       return Icon(Icons.star, color: Colors.yellow,);
                                //     },
                                //   ),
                                // ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name ?? '',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                // child: Image.network(mapMarkers[index].image),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
            ),
          ),
        ],

      ),

      floatingActionButton: FloatingActionButton(
        onPressed: geocode,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  _updateLocationStream(Position userLocation) async{

    _positionMessage = userLocation.latitude.toString() + ','
        + userLocation.longitude.toString();
    final List<Placemark> places = await placemarkFromCoordinates(
        userLocation.latitude,
        userLocation.longitude
    );
    setState(() {
      _descriptionMessage = '${[places[0]]}';
    });
  }

  geocode() async{
    String address = '301 Front St W, Toronto, ON';
    final List<Location> locations = await locationFromAddress(address);
    setState(() {
      _positionMessage = locations[0].latitude.toString() + ','
          + locations[0].longitude.toString();
    });
  }

  _updateCurrentLocation() async{
    Position userLocation = await Geolocator.getCurrentPosition();
    _positionMessage = userLocation.latitude.toString() + ','
        + userLocation.longitude.toString();

    final List<Placemark> places = await placemarkFromCoordinates(
        userLocation.latitude,
        userLocation.longitude
    );
    setState(() {
      _descriptionMessage = '${[places[0]]}';
    });
  }


  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
    CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

}