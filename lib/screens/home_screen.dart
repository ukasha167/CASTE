import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../controllers/weather_controller.dart';
import '../widgets/at_glance.dart';
import '../widgets/hourly_data.dart';
import '../widgets/detailed_metrics.dart';
import '../widgets/city_search.dart';
import '../widgets/settings_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherController _controller = WeatherController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Timer? _fadeTimer;
  bool _showDots = true;
  bool _hasBounced = false;

  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isSearching = false;

  @override
  void dispose() {
    _pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _startFadeTimer() {
    _fadeTimer?.cancel();
    setState(() => _showDots = true);
    _fadeTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showDots = false);
    });
  }

  void _triggerBounceHint() {
    if (_hasBounced) return;
    _hasBounced = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 1000));

      if (_pageController.hasClients) {
        await _pageController.animateTo(
          65.0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutQuad,
        );

        await _pageController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutBack,
        );

        _startFadeTimer();
      }
    });
  }

  Widget _buildWeatherPage(double availableHeight, DailyForecast forecast) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            await _controller.refreshWeather();
            if (_currentPage != 0) {
              _pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
              );
            }
          },
          builder:
              (
                context,
                refreshState,
                pulledExtent,
                refreshTriggerPullDistance,
                refreshIndicatorExtent,
              ) {
                final double opacity =
                    (pulledExtent / refreshTriggerPullDistance).clamp(0.0, 1.0);
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 57,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            width: double.infinity,
                            child: AtGlance(
                              forecast: forecast,
                              city: _controller.city,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 43,
                        child: HourlySection(data: forecast.hourlyData),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  bottom: 30,
                  top: 10,
                ),
                child: DetailedMetrics(forecast: forecast),
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
    if (screenHeight <= 0) return const Scaffold();

    final myAppBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 75,
      leading: Padding(
        padding: const EdgeInsets.only(left: 25),
        child: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
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
              weight: 700,
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
      drawerScrimColor: Colors.black.withValues(alpha: 0.4),
      drawer: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) => SettingsDrawer(controller: _controller),
      ),
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
                  setState(() {
                    _isSearching = false;
                    _currentPage = 0;
                  });
                },
              )
            : ListenableBuilder(
                key: const ValueKey('weather_view'),
                listenable: _controller,
                builder: (context, child) {
                  if (_controller.forecasts.isEmpty) {
                    if (_controller.isLoading) {
                      final loadingForecast = DailyForecast(
                        dayString: "Loading...",
                        heroTemp: "--˚",
                        heroLabel: "",
                        tempRange: "--˚ – --˚",
                        msg: "Fetching local weather...",
                        wind: "Wind: -- km/h",
                        windSpeedOnly: "--",
                        windUnitOnly: "",
                        humidity: "Humidity: --%",
                        aqi: "--",
                        aqiLabel: "Loading",
                        uv: "--",
                        uvLabel: "Loading",
                        sunrise: "--:-- AM",
                        sunset: "--:-- PM",
                        daylightProgress: 0.0,
                        pressure: "-- hPa",
                        visibility: "-- km",
                        cloudCover: "--%",
                        hourlyData: [],
                      );
                      return _buildWeatherPage(availableHeight, loadingForecast);

                    } else {
                      return Center(
                        child: Text(
                          "Tap the search icon to\nfind your city",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: Colors.deepOrange[50]!.withValues(alpha: 0.7),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }
                  }

                  _triggerBounceHint();

                  return Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() => _currentPage = index);
                          _startFadeTimer();
                        },
                        itemCount: _controller.forecasts.length,
                        itemBuilder: (context, index) {
                          return _buildWeatherPage(
                            availableHeight,
                            _controller.forecasts[index],
                          );
                        },
                      ),

                      Positioned(
                        top: 10,
                        left: 0,
                        right: 0,
                        child: IgnorePointer(
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: _showDots ? 1.0 : 0.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _controller.forecasts.length,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutCubic,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  width: _currentPage == index ? 12 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: _currentPage == index
                                        ? Colors.deepOrange[50]!.withValues(
                                            alpha: 0.8,
                                          )
                                        : Colors.white.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
