import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../api_key.dart';
import '../map_utils.dart';

class Bai3App extends StatelessWidget {
  const Bai3App({super.key});

  @override
  Widget build(BuildContext context) {
    return const TapPickRouteScreen();
  }
}

class TapPickRouteScreen extends StatefulWidget {
  const TapPickRouteScreen({super.key});

  @override
  State<TapPickRouteScreen> createState() => _TapPickRouteScreenState();
}

class _TapPickRouteScreenState extends State<TapPickRouteScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  LatLng? _startLatLng;
  LatLng? _endLatLng;
  String? _distance;
  String? _duration;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(10.7769, 106.7009),
    zoom: 13,
  );

  @override
  void initState() {
    super.initState();
    _initCurrentAsStart();
  }

  Future<void> _initCurrentAsStart() async {
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
      _setStartMarker(_startLatLng!);
    });
    _moveCamera(_startLatLng!);
  }

  void _setStartMarker(LatLng p) {
    _markers.removeWhere((m) => m.markerId.value == 'start');
    _markers.add(Marker(
      markerId: const MarkerId('start'),
      position: p,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: const InfoWindow(title: 'Xuat phat'),
    ));
  }

  void _setEndMarker(LatLng p) {
    _markers.removeWhere((m) => m.markerId.value == 'end');
    _markers.add(Marker(
      markerId: const MarkerId('end'),
      position: p,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: const InfoWindow(title: 'Dich den'),
    ));
  }

  Future<void> _moveCamera(LatLng position) async {
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(position));
  }

  Future<void> _useCurrentAsDestination() async {
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _endLatLng = LatLng(position.latitude, position.longitude);
      _setEndMarker(_endLatLng!);
    });
    _moveCamera(_endLatLng!);
    if (_startLatLng != null) _findRoute();
  }

  void _onMapTap(LatLng p) {
    setState(() {
      if (_startLatLng == null) {
        _startLatLng = p;
        _setStartMarker(p);
      } else {
        _endLatLng = p;
        _setEndMarker(p);
      }
    });
    if (_startLatLng != null && _endLatLng != null) _findRoute();
  }

  Future<void> _findRoute() async {
    if (_startLatLng == null || _endLatLng == null) return;
    final url = "https://maps.googleapis.com/maps/api/directions/json"
        "?origin=${_startLatLng!.latitude},${_startLatLng!.longitude}"
        "&destination=${_endLatLng!.latitude},${_endLatLng!.longitude}"
        "&key=$kGoogleApiKey";
    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) {
      _snack('Loi API: ${res.statusCode}');
      return;
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final apiStatus = data['status'] as String?;
    final errMsg = data['error_message'] as String?;
    final routes = data['routes'] as List?;
    if (apiStatus != 'OK' || routes == null || routes.isEmpty) {
      _snack('Directions API: $apiStatus${errMsg != null ? " - $errMsg" : ""}');
      // ignore: avoid_print
      print('Directions response: ${res.body}');
      return;
    }
    final route = routes[0];
    final leg = (route['legs'] as List).first;
    final encoded = route['overview_polyline']['points'] as String;
    final points = decodePolyline(encoded);
    setState(() {
      _distance = leg['distance']['text'] as String?;
      _duration = leg['duration']['text'] as String?;
      _polylines
        ..clear()
        ..add(Polyline(
          polylineId: const PolylineId('route'),
          points: points,
          color: Colors.blue,
          width: 5,
        ));
    });
  }

  void _reset() {
    setState(() {
      _startLatLng = null;
      _endLatLng = null;
      _distance = null;
      _duration = null;
      _markers.clear();
      _polylines.clear();
    });
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bai 3: Tap pick + Distance/Time'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Reset',
            onPressed: _reset,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.blue.shade50,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nhan vao ban do de chon diem (lan 1 = xuat phat, lan 2 = dich den).',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 6),
                Text('Xuat phat: '
                    '${_startLatLng == null ? "-" : "${_startLatLng!.latitude.toStringAsFixed(5)}, ${_startLatLng!.longitude.toStringAsFixed(5)}"}'),
                Text('Dich den:  '
                    '${_endLatLng == null ? "-" : "${_endLatLng!.latitude.toStringAsFixed(5)}, ${_endLatLng!.longitude.toStringAsFixed(5)}"}'),
                if (_distance != null && _duration != null) ...[
                  const SizedBox(height: 6),
                  Text('Khoang cach: $_distance',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Thoi gian:   $_duration',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _useCurrentAsDestination,
                      icon: const Icon(Icons.my_location),
                      label: const Text('Vi tri hien tai lam dich'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _findRoute,
                      icon: const Icon(Icons.directions),
                      label: const Text('Tim duong'),
                    ),
                  ],
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
              myLocationButtonEnabled: true,
              onMapCreated: (c) => _controller.complete(c),
              onTap: _onMapTap,
            ),
          ),
        ],
      ),
    );
  }
}
