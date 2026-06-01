import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../controllers/weather_controller.dart';
import '../widgets/at_glance.dart';
import '../widgets/hourly_data.dart';
import '../widgets/detailed_metrics.dart';
import '../widgets/city_search.dart';
import '../widgets/settings_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;

  final WeatherController _controller = WeatherController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildWeatherView(double availableHeight) {
    return CustomScrollView(
      key: const ValueKey('weather_view'),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            await _controller.refreshWeather();
          },
          builder: (context, refreshState, pulledExtent, refreshTriggerPullDistance, refreshIndicatorExtent) {
            final double opacity = (pulledExtent / refreshTriggerPullDistance).clamp(0.0, 1.0);
            return Center(
              child: Opacity(
                opacity: opacity,
                child: CupertinoActivityIndicator(
                  color: Colors.deepOrange[50],
                  radius: 15,
                ),
              ),
            );
          },
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: availableHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: ListenableBuilder(
                    listenable: _controller,
                    builder: (context, child) {
                      return Column(
                        children: [
                          Expanded(
                            flex: 57,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                width: double.infinity,
                                child: AtGlance(
                                  city: _controller.city,
                                  day: _controller.day,
                                  temp: _controller.temp,
                                  msg: _controller.msg,
                                  tempRange: _controller.tempRange,
                                  wind: _controller.wind,
                                  humidity: _controller.humidity,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 43,
                            child: HourlySection(
                              data: _controller.hourlyData,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30, right: 30, bottom: 30, top: 10),
                child: DetailedMetrics(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight <= 0) {
      return const Scaffold();
    }

    final myAppBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 75,
      leading: Padding(
        padding: const EdgeInsets.only(left: 25),
        child: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu, size: 26, weight: 700),
          color: Colors.deepOrange[50],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 30),
          child: IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
            icon: Icon(
              _isSearching ? CupertinoIcons.clear : Icons.search,
              size: 26,
              weight: 700
            ),
            color: Colors.deepOrange[50],
          ),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: Divider(indent: 30, endIndent: 30),
      ),
    );

    final statusBarHeight = MediaQuery.of(context).padding.top;
    final availableHeight = (screenHeight - myAppBar.preferredSize.height - statusBarHeight) - 145.0;

    return Scaffold(
      key: _scaffoldKey,
      appBar: myAppBar,
      drawer: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) => SettingsDrawer(controller: _controller),
      ),
      drawerScrimColor: Colors.black.withValues(alpha: 0.5),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.05),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: _isSearching
            ? CitySearch(
                key: const ValueKey('search_view'),
                controller: _controller,
                onCitySelected: () {
                  setState(() => _isSearching = false);
                },
              )
            : _buildWeatherView(availableHeight),
      ),
    );
  }
}
