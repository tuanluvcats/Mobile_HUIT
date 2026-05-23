import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../api_key.dart';
import '../map_utils.dart';

class Bai4App extends StatelessWidget {
  const Bai4App({super.key});

  @override
  Widget build(BuildContext context) {
    return const GeocodingRouteScreen();
  }
}

class GeocodingRouteScreen extends StatefulWidget {
  const GeocodingRouteScreen({super.key});

  @override
  State<GeocodingRouteScreen> createState() => _GeocodingRouteScreenState();
}

class _GeocodingRouteScreenState extends State<GeocodingRouteScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _startCtl = TextEditingController();
  final TextEditingController _endCtl = TextEditingController();

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  String _mode = 'driving';
  String? _distance;
  String? _duration;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(10.7769, 106.7009),
    zoom: 12,
  );

  Future<LatLng?> _geocode(String address) async {
    final url = "https://maps.googleapis.com/maps/api/geocode/json"
        "?address=${Uri.encodeComponent(address)}"
        "&key=$kGoogleApiKey";
    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) return null;
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final results = data['results'] as List?;
    if (results == null || results.isEmpty) return null;
    final loc = results[0]['geometry']['location'];
    return LatLng(loc['lat'] as double, loc['lng'] as double);
  }

  Future<void> _moveCamera(LatLng position) async {
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(position));
  }

  Future<void> _search() async {
    if (_startCtl.text.isEmpty || _endCtl.text.isEmpty) {
      _snack('Vui long nhap ca hai dia chi!');
      return;
    }

    final start = await _geocode(_startCtl.text);
    final end = await _geocode(_endCtl.text);
    if (start == null || end == null) {
      _snack('Khong tim thay dia chi!');
      return;
    }

    final url = "https://maps.googleapis.com/maps/api/directions/json"
        "?origin=${start.latitude},${start.longitude}"
        "&destination=${end.latitude},${end.longitude}"
        "&mode=$_mode"
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
      _markers
        ..clear()
        ..add(Marker(
          markerId: const MarkerId('start'),
          position: start,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: 'Xuat phat', snippet: _startCtl.text),
        ))
        ..add(Marker(
          markerId: const MarkerId('end'),
          position: end,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: 'Dich den', snippet: _endCtl.text),
        ));
      _polylines
        ..clear()
        ..add(Polyline(
          polylineId: const PolylineId('route'),
          points: points,
          color: Colors.blue,
          width: 5,
        ));
    });
    _moveCamera(start);
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
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
        title: const Text('Bai 4: Geocoding + Phuong tien'),
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
                    labelText: 'Dia chi xuat phat',
                    hintText: 'VD: 227 Nguyen Van Cu, Q.5, TP.HCM',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _endCtl,
                  decoration: const InputDecoration(
                    labelText: 'Dia chi dich den',
                    hintText: 'VD: Cho Ben Thanh, TP.HCM',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Phuong tien: '),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _mode,
                      items: const [
                        DropdownMenuItem(value: 'driving', child: Text('Xe hoi')),
                        DropdownMenuItem(value: 'walking', child: Text('Di bo')),
                        DropdownMenuItem(value: 'bicycling', child: Text('Xe dap')),
                        DropdownMenuItem(value: 'transit', child: Text('Cong cong')),
                      ],
                      onChanged: (v) => setState(() => _mode = v ?? 'driving'),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: _search,
                      icon: const Icon(Icons.search),
                      label: const Text('Tim'),
                    ),
                  ],
                ),
                if (_distance != null && _duration != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Khoang cach: $_distance  •  Thoi gian: $_duration',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              markers: _markers,
              polylines: _polylines,
              onMapCreated: (c) => _controller.complete(c),
            ),
          ),
        ],
      ),
    );
  }
}
