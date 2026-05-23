import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../api_key.dart';
import '../map_utils.dart';

class Bai2App extends StatelessWidget {
  const Bai2App({super.key});

  @override
  Widget build(BuildContext context) {
    return const RouteFinderScreen();
  }
}

class RouteFinderScreen extends StatefulWidget {
  const RouteFinderScreen({super.key});

  @override
  State<RouteFinderScreen> createState() => _RouteFinderScreenState();
}

class _RouteFinderScreenState extends State<RouteFinderScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final TextEditingController _startCtl = TextEditingController();
  final TextEditingController _endCtl = TextEditingController();

  LatLng? _startLatLng;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(10.7769, 106.7009),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _fillCurrentAsStart();
  }

  Future<void> _fillCurrentAsStart() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _startLatLng = LatLng(position.latitude, position.longitude);
      _startCtl.text = "${position.latitude}, ${position.longitude}";
      _markers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: _startLatLng!,
          infoWindow: const InfoWindow(title: 'Xuat phat'),
        ),
      );
    });
    _moveCamera(_startLatLng!);
  }

  LatLng? _parse(String s) {
    final parts = s.split(',');
    if (parts.length != 2) return null;
    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());
    if (lat == null || lng == null) return null;
    return LatLng(lat, lng);
  }

  Future<void> _moveCamera(LatLng position) async {
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(position));
  }

  Future<void> _findRoute() async {
    if (_startCtl.text.isEmpty || _endCtl.text.isEmpty) {
      _snack('Vui long nhap ca hai diem!');
      return;
    }
    final s = _parse(_startCtl.text);
    final e = _parse(_endCtl.text);
    if (s == null || e == null) {
      _snack('Toa do khong hop le. Dinh dang: lat, lng');
      return;
    }
    _startLatLng = s;

    final url =
        "https://maps.googleapis.com/maps/api/directions/json"
        "?origin=${s.latitude},${s.longitude}"
        "&destination=${e.latitude},${e.longitude}"
        "&key=$kGoogleDirectionsApiKey";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      _snack('Loi khi goi API: ${response.statusCode}');
      return;
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final apiStatus = data['status'] as String?;
    final errMsg = data['error_message'] as String?;
    final routes = data['routes'] as List?;
    if (apiStatus != 'OK' || routes == null || routes.isEmpty) {
      _snack('Directions API: $apiStatus${errMsg != null ? " - $errMsg" : ""}');
      // Debug full body in console:
      // ignore: avoid_print
      print('Directions response: ${response.body}');
      return;
    }
    final encoded = routes[0]['overview_polyline']['points'] as String;
    final points = decodePolyline(encoded);

    setState(() {
      _markers
        ..clear()
        ..add(
          Marker(
            markerId: const MarkerId('start'),
            position: s,
            infoWindow: const InfoWindow(title: 'Xuat phat'),
          ),
        )
        ..add(
          Marker(
            markerId: const MarkerId('end'),
            position: e,
            infoWindow: const InfoWindow(title: 'Dich den'),
          ),
        );
      _polylines
        ..clear()
        ..add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: points,
            color: Colors.blue,
            width: 5,
          ),
        );
    });
    _moveCamera(s);
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _startCtl.dispose();
    _endCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bai 2: Route Finder'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(
                  controller: _startCtl,
                  decoration: const InputDecoration(
                    labelText: 'Diem xuat phat (lat, lng)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _endCtl,
                  decoration: const InputDecoration(
                    labelText: 'Diem dich (lat, lng)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _findRoute,
                  icon: const Icon(Icons.directions),
                  label: const Text('Tim duong di'),
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
              onMapCreated: (c) => _controller.complete(c),
            ),
          ),
        ],
      ),
    );
  }
}
