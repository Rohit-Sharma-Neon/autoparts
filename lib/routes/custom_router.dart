import 'package:autoparts/app_ui/screens/auth/change_password/change_password_screen.dart';
import 'package:autoparts/app_ui/screens/auth/forgot_password/forgot_password.dart';
import 'package:autoparts/app_ui/screens/auth/forgot_password/forgot_password_phone.dart';
import 'package:autoparts/app_ui/screens/location/google_map_screen.dart';
import 'package:autoparts/app_ui/screens/location/location_screen.dart';
import "package:autoparts/app_ui/screens/auth/login/login_screen.dart";
import "package:autoparts/app_ui/screens/auth/signup_screen/set_password_screen.dart";
import "package:autoparts/app_ui/screens/auth/signup_screen/sign_up_screen.dart";
import 'package:autoparts/app_ui/screens/auth/signup_screen/signup_select_type.dart';
import "package:autoparts/app_ui/screens/auth/signup_screen/verify_screen_otp.dart";
import "package:autoparts/app_ui/screens/become_dealer/become_seller_screen.dart";
import "package:autoparts/app_ui/screens/business_profile/business_profile_screen.dart";
import 'package:autoparts/app_ui/screens/business_profile/update_business_profile.dart';
import "package:autoparts/app_ui/screens/dashboard/cars_screen/car_detail_screen.dart";
import "package:autoparts/app_ui/screens/dashboard/cars_screen/car_listing_screen.dart";
import 'package:autoparts/app_ui/screens/dashboard/cars_screen/top_category_screen.dart';
import "package:autoparts/app_ui/screens/dashboard/dashboard_screen/dashboard.dart";
import "package:autoparts/app_ui/screens/dashboard/dealers/dealer_detail_screen.dart";
import "package:autoparts/app_ui/screens/dashboard/dealers/dealer_review_screen.dart";
import 'package:autoparts/app_ui/screens/dashboard/dealers/dealers_screen.dart';
import 'package:autoparts/app_ui/screens/dashboard/favorites_screen/favorites_screen.dart';
import 'package:autoparts/app_ui/screens/dashboard/home_screen/home_screen.dart';
import "package:autoparts/app_ui/screens/dashboard/message_box_screen/message_box_screen.dart";
import "package:autoparts/app_ui/screens/dashboard/message_box_screen/message_detail_screen.dart";
import 'package:autoparts/app_ui/screens/dashboard/parts_screens/products_screen.dart';
import "package:autoparts/app_ui/screens/dashboard/parts_screens/product_detail_screen.dart";
import "package:autoparts/app_ui/screens/dashboard/seller_screen/seller_details_screen.dart";
import 'package:autoparts/app_ui/screens/location/marker_map_screen.dart';
import "package:autoparts/app_ui/screens/notifications_screen/notifications_screen.dart";
import "package:autoparts/app_ui/screens/privacy_screen/privacy_screen.dart";
import "package:autoparts/app_ui/screens/privacy_screen/terms_conditions_screen.dart";
import 'package:autoparts/app_ui/screens/reminder/reminder_screen.dart';
import 'package:autoparts/app_ui/screens/select_category/select_category.dart';
import "package:autoparts/app_ui/screens/sell_car/search_car_screen.dart";
import "package:autoparts/app_ui/screens/sell_car/sell_car_screen.dart";
import "package:autoparts/app_ui/screens/sell_car/sell_complete_car_screen.dart";
import 'package:autoparts/app_ui/screens/sell_product/add_new_product_screen.dart';
import "package:autoparts/app_ui/screens/sell_product/sell_existing_product_screen.dart";
import "package:autoparts/app_ui/screens/sell_product/sell_product_screen.dart";
import "package:autoparts/app_ui/screens/tutorial/tutorial_screen.dart";
import "package:autoparts/app_ui/screens/user_profile/complete_profile_screen.dart";
import 'package:autoparts/app_ui/screens/user_profile/update_profile.dart';
import 'package:autoparts/app_ui/screens/user_profile/user_account_screen.dart';
import "package:flutter/material.dart";

import '../app_ui/screens/dashboard/seller_screen/sellers_screen.dart';

class CustomRouter {
  static Route<dynamic> generateRoute(RouteSettings? settings) {
    switch (settings!.name) {
      // case Splash.routeName:
      //   return MaterialPageRoute(
      //     builder: (_) {
      //       return const Splash();
      //     },
      //   );
      case TutorialScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const TutorialScreen();
          },
        );
      case ForgotPasswordScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const ForgotPasswordScreen();
          },
        );
      case ForgotPasswordPhone.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const ForgotPasswordPhone();
          },
        );
      case UserAccountScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const UserAccountScreen();
          },
        );
      case LoginScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const LoginScreen();
          },
        );
      case SignUpScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const SignUpScreen();
          },
        );
      case DashboardScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            int index = settings.arguments as int;
            return DashboardScreen(bottomIndex: index);
          },
        );
      case VerifyOtpScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            List<dynamic> args = settings.arguments as List;
            return VerifyOtpScreen(
              phone: args[0],
              countryCode: args[1],
              otp: args[2],
            );
          },
        );
      case CompleteProfileScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const CompleteProfileScreen();
          },
        );
      case LocationScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const LocationScreen();
          },
        );
      case NotificationsScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const NotificationsScreen();
          },
        );
      case BusinessProfileScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const BusinessProfileScreen();
          },
        );
      case BecomeSellerScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const BecomeSellerScreen();
          },
        );
      case SellProductScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const SellProductScreen();
          },
        );
      case AddNewProductScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const AddNewProductScreen();
          },
        );
      case SearchCarScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const SearchCarScreen();
          },
        );
      case SellCarScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const SellCarScreen();
          },
        );
      case SellCompleteCarScreen.routeName:
        return MaterialPageRoute(builder: (_) {
          return const SellCompleteCarScreen();
        });
      case StaticPage.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const StaticPage();
          },
        );
      case PrivacyScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const PrivacyScreen();
          },
        );
      case DealerDetailScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            List<dynamic> args = settings.arguments as List;
            return DealerDetailScreen(dealerId: args[0]);
          },
        );
      case DealerReviewScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const DealerReviewScreen();
          },
        );
      case MessageBoxScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const MessageBoxScreen();
          },
        );
      // case MessageDetailScreen.routeName:
      //   return MaterialPageRoute(
      //     builder: (_) {
      //       return const MessageDetailScreen();
      //     },
      //   );
      case ProductDetailScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            List<dynamic> args = settings.arguments as List;
            return  ProductDetailScreen(detailsId: args[0]);
          },
        );
      case SellerDetailsScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            List<dynamic> args = settings.arguments as List;
            return SellerDetailsScreen(sellerId: args[0]);
          },
        );
      case CarListingScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            List<dynamic> args = settings.arguments as List;
            return  CarListingScreen(detailsId: args[0],);
          },
        );
      case CarDetailScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            List<dynamic> args = settings.arguments as List;
            return  CarDetailScreen(detailsId: args[0],);
          },
        );
      case SignupSelectType.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const SignupSelectType();
          },
        );
      case HomeScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const HomeScreen();
          },
        );
      case DealersScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const DealersScreen();
          },
        );
      case SellersScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const SellersScreen();
          },
        );
      case ProductsScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const ProductsScreen();
          },
        );
      case FavoritesScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const FavoritesScreen();
          },
        );
      case TopCategoriesScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const TopCategoriesScreen();
          },
        );
      case ReminderScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const ReminderScreen();
          },
        );
      case CarsCategoryScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const CarsCategoryScreen();
          },
        );
      case UpdateBusinessProfile.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const UpdateBusinessProfile();
          },
        );
      case UpdateProfileScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const UpdateProfileScreen();
          },
        );
      case ChangePasswordScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const ChangePasswordScreen();
          },
        );
      case MarkerMapScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const MarkerMapScreen();
          },
        );
      case GoogleMapScreen.routeName:
        return MaterialPageRoute(
          builder: (_) {
            return const GoogleMapScreen();
          },
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text("No route defined for ${settings.name}"),
            ),
          ),
        );
    }
  }
}
