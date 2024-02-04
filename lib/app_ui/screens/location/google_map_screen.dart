import 'package:autoparts/constant/app_colors.dart';
import 'package:autoparts/constant/app_text_style.dart';
import 'package:autoparts/provider/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GoogleMapScreen extends StatefulWidget {
  static const routeName = '/google-map-screen';
   const GoogleMapScreen({Key? key}) : super(key: key);

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Provider.of<LocationProvider>(context, listen: false).initialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50.0), child: _buildAppBar()),
        body: _buildBody());
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.whiteColor,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        "Live Map",
        style: AppTextStyles.boldStyle(AppFontSize.font_18,AppColors.blackBottomColor),
      ),
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<LocationProvider>(
      builder: (ctx, model, child) {
        if (model.locationPosition != null) {
          return Column(
            children: [
              Expanded(
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition:
                    CameraPosition(target: model.locationPosition!, zoom: 18),
                    onMapCreated: (GoogleMapController controller) {},
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ))
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
