import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(41.716667, 44.78333);

  bool _isExpanded = false;
  bool _didFinishAnimating = false;

  MapType _currentMapType = MapType.normal;

  final Set<Marker> _markes = {};

  LatLng _lastMapPosition = const LatLng(41.716667, 44.78333);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _changeMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onCameraMove(CameraPosition cameraPosition) {
    _lastMapPosition = cameraPosition.target;
  }

  void _addMarker() {
    setState(() {
      _markes.add(
        Marker(
          markerId: MarkerId(
            _lastMapPosition.toString(),
          ),
          position: _lastMapPosition,
          infoWindow: const InfoWindow(
              title: 'Marker title',
              snippet: 'Visit this place, testing example'),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps Example'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: _currentMapType,
            onMapCreated: _onMapCreated,
            onCameraMove: _onCameraMove,
            markers: _markes,
            initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedContainer(
              onEnd: () => setState(() {
                _didFinishAnimating = !_didFinishAnimating;
              }),
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              height: _isExpanded ? screenSize.height / 2 : 70,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _isExpanded && _didFinishAnimating
                    ? Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: const Text('Change Map Type'),
                              onPressed: _changeMapType,
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: const Text('Options'),
                              onPressed: () => setState(() {
                                _isExpanded = !_isExpanded;
                              }),
                            ),
                          )
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: const Text('Options'),
                              onPressed: () => setState(() {
                                _isExpanded = !_isExpanded;
                              }),
                            ),
                          )
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMarker,
        child: const Icon(Icons.add),
      ),
    );
  }
}
