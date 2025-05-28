import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:imtihon4/screens/chat_screen.dart';
import 'dart:convert';
import 'package:location/location.dart';

class MapWithSearchScreen extends StatefulWidget {
  const MapWithSearchScreen({super.key});

  @override
  _MapWithSearchScreenState createState() => _MapWithSearchScreenState();
}

class _MapWithSearchScreenState extends State<MapWithSearchScreen> {
  GoogleMapController? mapController;
  TextEditingController destinationController = TextEditingController();
  String? currentAddress = "Manzil aniqlanmoqda...";
  LatLng? currentLatLng;
  Set<Marker> markers = {};
  List<Prediction> searchResults = [];
  Set<Polyline> polylines = {};
  bool isSearching = false;

  final String googleApiKey = "AIzaSyBbYLPuhexAOd4QO8e3UI_s2qdoZJQEIdY";
  final LatLng initialPosition = LatLng(41.2995, 69.2401);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: currentLatLng ?? initialPosition,
              zoom: 12.0,
            ),
            polylines: polylines,
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          Positioned(
            top: 50,
            left: 15,
            right: 15,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                child: Column(
                  children: [
                    // Current location (Manzilim)
                    Row(
                      children: [
                        Icon(Icons.my_location, color: Color(0xFF4ECDC4)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            currentAddress ?? "Manzil aniqlanmoqda...",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    // Destination input (Qayerga boramiz?)
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                            controller: destinationController,
                            decoration: InputDecoration(
                              hintText: 'Qayerga boramiz?',
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                _searchPlaces(value);
                              } else {
                                setState(() {
                                  searchResults.clear();
                                  isSearching = false;
                                });
                              }
                            },
                          ),
                        ),
                        if (destinationController.text.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              destinationController.clear();
                              setState(() {
                                searchResults.clear();
                                isSearching = false;
                              });
                            },
                          ),
                      ],
                    ),
                    // Suggestions
                    if (isSearching && searchResults.isNotEmpty)
                      Container(
                        constraints: BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final prediction = searchResults[index];
                            return ListTile(
                              leading: Icon(
                                Icons.location_on,
                                color: Colors.red,
                              ),
                              title: Text(
                                prediction.description ?? '',
                                style: TextStyle(fontSize: 14),
                              ),
                              onTap: () {
                                _selectPlace(prediction);
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: 15,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: _goToCurrentLocation,
              child: Icon(Icons.my_location, color: Color(0xFF4ECDC4)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }
    LocationData locationData = await location.getLocation();
    currentLatLng = LatLng(locationData.latitude!, locationData.longitude!);

    // Reverse geocode
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${currentLatLng!.latitude},${currentLatLng!.longitude}&key=$googleApiKey&language=uz';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        setState(() {
          currentAddress = data['results'][0]['formatted_address'];
        });
      }
    }
    setState(() {});
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(currentLatLng!, 16.0),
      );
    }
  }

  Future<void> _searchPlaces(String query) async {
    setState(() {
      isSearching = true;
    });
    try {
      final String url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
          'input=$query&key=$googleApiKey&language=uz';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          List<Prediction> predictions = [];
          for (var item in data['predictions']) {
            predictions.add(
              Prediction(
                description: item['description'],
                placeId: item['place_id'],
              ),
            );
          }
          setState(() {
            searchResults = predictions;
          });
        }
      }
    } catch (e) {
      print('Qidiruv xatoligi: $e');
    }
  }

  Future<void> _selectPlace(Prediction prediction) async {
    setState(() {
      isSearching = false;
      searchResults.clear();
      destinationController.text = prediction.description ?? '';
    });
    try {
      final String url =
          'https://maps.googleapis.com/maps/api/place/details/json?'
          'place_id=${prediction.placeId}&key=$googleApiKey&fields=geometry';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final location = data['result']['geometry']['location'];
          final LatLng coordinates = LatLng(location['lat'], location['lng']);
          setState(() {
            markers.clear();
            markers.add(
              Marker(
                markerId: MarkerId('destination'),
                position: coordinates,
                infoWindow: InfoWindow(title: prediction.description),
              ),
            );
          });
          if (mapController != null) {
            mapController!.animateCamera(
              CameraUpdate.newLatLngZoom(coordinates, 16.0),
            );
          }
          // Polyline chizish uchun directions chaqiramiz:
          if (currentLatLng != null) {
            await _getDirections(currentLatLng!, coordinates);
          }
        }
      }
    } catch (e) {
      print('Joy tafsilotlarini olishda xatolik: $e');
    }
  }

  void _goToCurrentLocation() async {
    await _getCurrentLocation();
    if (currentLatLng != null && mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(currentLatLng!, 16.0),
      );
    }
  }

  //A manzildan B manzilgacha bo’lgan Polyline larni olib kelib beruvchi funksia

  Future<void> _getDirections(LatLng origin, LatLng destination) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleApiKey',
    );

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    if (data['routes'].isNotEmpty) {
      final points = data['routes'][0]['overview_polyline']['points'];
      final polylinePoints = _decodePolyline(points);

      // Masofa va vaqtni olish (km va minut)
      final legs = data['routes'][0]['legs'];
      String? distanceText;
      String? durationText;
      if (legs != null && legs.isNotEmpty) {
        distanceText = legs[0]['distance']['text'];
        durationText = legs[0]['duration']['text'];
        // distanceText masalan: "5.3 km", durationText: "12 mins"
        debugPrint('Distance: $distanceText, Duration: $durationText');
      }

      setState(() {
        polylines.clear();
        polylines.add(
          Polyline(
            polylineId: const PolylineId("route"),
            points: polylinePoints,
            color: Colors.blue,
            width: 4,
          ),
        );
        showDynamicBottomSheet(context);
      });
    }
  }
  //Get qilingan PolyLine larni map o’qiy oladigan shakilga keltirib beruvchi algoritmik funksia

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  void showDynamicBottomSheet(BuildContext context) {
    bool isExpanded = false;

    showModalBottomSheet(
      isDismissible: false,
      context: context,
      isScrollControlled: true, // To'liq ekran qismini egallash uchun
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Yopiq holatdagi ko'rinish (default)
                  if (!isExpanded) ...[
                    ListTile(
                      title: Text("Transport turini tanlang"),
                      trailing: Icon(Icons.arrow_upward),
                      onTap: () => setState(() => isExpanded = true),
                    ),
                    ListTile(
                      title: Text("\$25.00 • 2 min"),
                      subtitle: Text("Yaquinizda"),
                      onTap: () {
                        Navigator.pop(context);
                        // Tanlovni amalga oshirish
                      },
                    ),
                  ],

                  // Ochilgan holatdagi ko'rinish (full view)
                  if (isExpanded) ...[
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_downward),
                          onPressed: () => setState(() => isExpanded = false),
                        ),
                        Text(
                          "Transport turini tanlang",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 1.5,
                        children: [
                          _buildVehicleOption("Limousine", "\$80.00", "5 min"),
                          _buildVehicleOption("Luxury", "\$50.00", "3 min"),
                          _buildVehicleOption(
                            "Elektromobil",
                            "\$25.00",
                            "2 min",
                          ),
                          _buildVehicleOption("Velosiped", "\$15.00", "3 min"),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => ChatScreen(
                                    rideId: "ride123",
                                    userId: 'user1',
                                    driverId: 'driver7')));
                      },
                      child: Text("bowlash"),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVehicleOption(String name, String price, String time) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text("$price • $time"),
          ],
        ),
      ),
    );
  }
}

class Prediction {
  final String? description;
  final String? placeId;

  Prediction({this.description, this.placeId});
}
