import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Bai1App extends StatelessWidget {
  const Bai1App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MapScreen();
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(10.7769, 106.7009),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui long bat dich vu vi tri!')),
      );
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final pos = LatLng(position.latitude, position.longitude);
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('me'),
          position: pos,
          infoWindow: const InfoWindow(title: 'Vi tri cua ban'),
        ),
      );
    });
    _moveCamera(pos);
  }

  Future<void> _moveCamera(LatLng position) async {
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bai 1: Map + Vi tri hien tai'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (c) => _controller.complete(c),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}
