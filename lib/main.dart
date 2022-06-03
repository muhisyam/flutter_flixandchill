// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_flixandchill/api/endpoints.dart';
import 'package:flutter_flixandchill/helper/shared_preference.dart';
import 'package:flutter_flixandchill/model_class/function.dart';
import 'package:flutter_flixandchill/model_class/genres.dart';
import 'package:flutter_flixandchill/model_class/movie.dart';
import 'package:flutter_flixandchill/model_class/user_model.dart';
import 'package:flutter_flixandchill/screens/movie_detail.dart';
import 'package:flutter_flixandchill/screens/search_view.dart';
import 'package:flutter_flixandchill/screens/settings.dart';
import 'package:flutter_flixandchill/screens/widgets.dart';
import 'package:flutter_flixandchill/theme/theme_state.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initiateLocalDB();
  SharedPreference().getLoginStatus().then((status) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeState>(
      create: (_) => ThemeState(),
      child: MaterialApp(
        title: 'Flix & Chill',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue, canvasColor: Colors.transparent),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Genres> _genres = [];
  @override
  void initState() {
    super.initState();
    fetchGenres().then((value) {
      _genres = value.genres ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ThemeState>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: state.themeData.textTheme.headline5!.color,
            size: 26,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        centerTitle: true,
        title: Text('FLIX & CHILL', style: state.themeData.textTheme.headline5),
        backgroundColor: state.themeData.primaryColor,
        actions: <Widget>[
          IconButton(
            color: state.themeData.textTheme.headline5!.color,
            icon: Icon(
              Icons.search,
              size: 26,
            ),
            onPressed: () async {
              final Movie? result = await showSearch<Movie?>(
                  context: context,
                  delegate:
                      MovieSearch(themeData: state.themeData, genres: _genres));
              if (result != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MovieDetailPage(
                            movie: result,
                            themeData: state.themeData,
                            genres: _genres,
                            heroId: '${result.id}search')));
              }
            },
          )
        ],
      ),
      drawer: Drawer(
        child: SettingsPage(),
      ),
      body: Stack(
        children: [
          Container(
            color: state.themeData.primaryColor,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: DiscoverMovies(
                    themeData: state.themeData,
                    genres: _genres,
                  ),
                ),
                ScrollingMovies(
                  themeData: state.themeData,
                  title: 'Top Rated',
                  api: Endpoints.topRatedUrl(1),
                  genres: _genres,
                ),
                ScrollingMovies(
                  themeData: state.themeData,
                  title: 'Now Playing',
                  api: Endpoints.nowPlayingMoviesUrl(1),
                  genres: _genres,
                ),
                ScrollingMovies(
                  themeData: state.themeData,
                  title: 'Popular',
                  api: Endpoints.popularMoviesUrl(2),
                  genres: _genres,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void initiateLocalDB() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>("data");
}
