import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../api_key.dart';
import '../map_utils.dart';

class Bai5App extends StatelessWidget {
  const Bai5App({super.key});

  @override
  Widget build(BuildContext context) {
    return const FavoriteRoutesScreen();
  }
}

class FavoriteRoute {
  final int? id;
  final String startAddr;
  final String endAddr;
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;
  final String mode;
  final String polyline;
  final String distance;
  final String duration;
  final int createdAt;

  FavoriteRoute({
    this.id,
    required this.startAddr,
    required this.endAddr,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
    required this.mode,
    required this.polyline,
    required this.distance,
    required this.duration,
    required this.createdAt,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'start_addr': startAddr,
        'end_addr': endAddr,
        'start_lat': startLat,
        'start_lng': startLng,
        'end_lat': endLat,
        'end_lng': endLng,
        'mode': mode,
        'polyline': polyline,
        'distance': distance,
        'duration': duration,
        'created_at': createdAt,
      };

  factory FavoriteRoute.fromMap(Map<String, Object?> m) => FavoriteRoute(
        id: m['id'] as int?,
        startAddr: m['start_addr'] as String,
        endAddr: m['end_addr'] as String,
        startLat: m['start_lat'] as double,
        startLng: m['start_lng'] as double,
        endLat: m['end_lat'] as double,
        endLng: m['end_lng'] as double,
        mode: m['mode'] as String,
        polyline: m['polyline'] as String,
        distance: m['distance'] as String,
        duration: m['duration'] as String,
        createdAt: m['created_at'] as int,
      );
}

class FavoriteDb {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    final dir = await getDatabasesPath();
    final path = p.join(dir, 'favorite_routes.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, v) async {
        await db.execute('''
          CREATE TABLE favorite_routes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            start_addr TEXT NOT NULL,
            end_addr TEXT NOT NULL,
            start_lat REAL NOT NULL,
            start_lng REAL NOT NULL,
            end_lat REAL NOT NULL,
            end_lng REAL NOT NULL,
            mode TEXT NOT NULL,
            polyline TEXT NOT NULL,
            distance TEXT NOT NULL,
            duration TEXT NOT NULL,
            created_at INTEGER NOT NULL
          )
        ''');
      },
    );
    return _db!;
  }

  static Future<int> insert(FavoriteRoute r) async {
    final d = await db;
    return d.insert('favorite_routes', r.toMap()..remove('id'));
  }

  static Future<List<FavoriteRoute>> list() async {
    final d = await db;
    final rows =
        await d.query('favorite_routes', orderBy: 'created_at DESC');
    return rows.map(FavoriteRoute.fromMap).toList();
  }

  static Future<int> delete(int id) async {
    final d = await db;
    return d.delete('favorite_routes', where: 'id = ?', whereArgs: [id]);
  }
}

class FavoriteRoutesScreen extends StatefulWidget {
  const FavoriteRoutesScreen({super.key});

  @override
  State<FavoriteRoutesScreen> createState() => _FavoriteRoutesScreenState();
}

class _FavoriteRoutesScreenState extends State<FavoriteRoutesScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _startCtl = TextEditingController();
  final TextEditingController _endCtl = TextEditingController();

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  String _mode = 'driving';
  String? _distance;
  String? _duration;

  LatLng? _startLatLng;
  LatLng? _endLatLng;
  String _lastPolyline = '';

  List<FavoriteRoute> _favorites = [];

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(10.7769, 106.7009),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _refreshFavorites();
  }

  Future<void> _refreshFavorites() async {
    final list = await FavoriteDb.list();
    if (!mounted) return;
    setState(() => _favorites = list);
  }

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

    _startLatLng = start;
    _endLatLng = end;
    _lastPolyline = encoded;

    _renderRoute(
      start: start,
      end: end,
      encoded: encoded,
      distance: leg['distance']['text'] as String? ?? '',
      duration: leg['duration']['text'] as String? ?? '',
    );
  }

  void _renderRoute({
    required LatLng start,
    required LatLng end,
    required String encoded,
    required String distance,
    required String duration,
  }) {
    final points = decodePolyline(encoded);
    setState(() {
      _distance = distance;
      _duration = duration;
      _markers
        ..clear()
        ..add(Marker(
          markerId: const MarkerId('start'),
          position: start,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: 'Xuat phat'),
        ))
        ..add(Marker(
          markerId: const MarkerId('end'),
          position: end,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Dich den'),
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

  Future<void> _saveCurrent() async {
    if (_startLatLng == null || _endLatLng == null || _lastPolyline.isEmpty) {
      _snack('Chua co tuyen duong de luu!');
      return;
    }
    final route = FavoriteRoute(
      startAddr: _startCtl.text,
      endAddr: _endCtl.text,
      startLat: _startLatLng!.latitude,
      startLng: _startLatLng!.longitude,
      endLat: _endLatLng!.latitude,
      endLng: _endLatLng!.longitude,
      mode: _mode,
      polyline: _lastPolyline,
      distance: _distance ?? '',
      duration: _duration ?? '',
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    await FavoriteDb.insert(route);
    await _refreshFavorites();
    _snack('Da luu tuyen duong yeu thich!');
  }

  Future<void> _loadFavorite(FavoriteRoute r) async {
    _startCtl.text = r.startAddr;
    _endCtl.text = r.endAddr;
    _mode = r.mode;
    _startLatLng = LatLng(r.startLat, r.startLng);
    _endLatLng = LatLng(r.endLat, r.endLng);
    _lastPolyline = r.polyline;
    _renderRoute(
      start: _startLatLng!,
      end: _endLatLng!,
      encoded: r.polyline,
      distance: r.distance,
      duration: r.duration,
    );
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _deleteFavorite(FavoriteRoute r) async {
    if (r.id == null) return;
    await FavoriteDb.delete(r.id!);
    await _refreshFavorites();
  }

  void _openFavorites() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        builder: (ctx, ctrl) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Tuyen duong yeu thich',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: _favorites.isEmpty
                    ? const Center(child: Text('Chua co tuyen duong nao'))
                    : ListView.separated(
                        controller: ctrl,
                        itemCount: _favorites.length,
                        separatorBuilder: (ctx, i) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final r = _favorites[i];
                          return ListTile(
                            leading: const Icon(Icons.star, color: Colors.amber),
                            title: Text('${r.startAddr}  →  ${r.endAddr}'),
                            subtitle: Text(
                                '${r.mode} • ${r.distance} • ${r.duration}'),
                            onTap: () => _loadFavorite(r),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () => _deleteFavorite(r),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
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
        title: const Text('Bai 5: Tuyen duong yeu thich'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Danh sach yeu thich',
            onPressed: _openFavorites,
            icon: const Icon(Icons.star),
          ),
        ],
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
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _endCtl,
                  decoration: const InputDecoration(
                    labelText: 'Dia chi dich den',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Phuong tien: '),
                    const SizedBox(width: 4),
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
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _search,
                        icon: const Icon(Icons.search),
                        label: const Text('Tim'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _saveCurrent,
                        icon: const Icon(Icons.bookmark_add),
                        label: const Text('Luu yeu thich'),
                      ),
                    ),
                  ],
                ),
                if (_distance != null && _duration != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
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
