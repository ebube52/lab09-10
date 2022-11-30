import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class Geolocation {
  final String name;
  final String address;
  final LatLng location;


  Geolocation({required this.name, required this.address, required this.location});}

  final Geolocators = [
    Geolocation (

        name: 'Trent University',
        address: '55 Thornton Rd S, Oshawa ON L1J5Y1',
        location: LatLng(44.35819, -78.29147)
    ),

    Geolocation (

      name: 'NEBsFun World',
      address: '1300 Wilson Rd N, Oshawa ON L1K 2B8',
      location: LatLng(43.9354, 78.8599),
    ),

    Geolocation (

      name: 'Niagara Falls',
      address: 'Canada',
      location: LatLng(44.9456, 79.8968),
    ),

    Geolocation (

      name: 'Canadas Wonderland',
      address: '1 Canadas Wonderland Dr, Vaughan ON L6A 1S6',
      location: LatLng(43.84167, -79.54306),
    ),

    Geolocation (
      name: 'Ontario Place',
      address: '955 Lake Shore Blvd W, Toronto ON M6K 3B9 ',
      location: LatLng(43.629, -79.417),
    ),


  ];


