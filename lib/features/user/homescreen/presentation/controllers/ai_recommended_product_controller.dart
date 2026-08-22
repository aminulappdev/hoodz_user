import 'package:hoodz/features/user/homescreen/presentation/controllers/all_product_controller.dart';
import 'package:hoodz/urls.dart';

class AiRecommendedProductController extends AllTrendingProductController {
  @override
  String get apiPath => Urls.aiRecommendedProductUrl;
}
