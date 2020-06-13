class Api {

  //static const String BASE_URL = "http://192.168.43.177/api_ci/index.php/";
  static const String BASE_URL = "http://192.168.43.177/api-minipos/index.php/";
  //static const String BASE_URL = "http://192.168.13.10/api_ci/index.php/";
  static const String PRODUCTS_IMAGES_URL = "http://192.168.43.177/api-minipos/uploads/products/";
  static const String LOGIN_URL = BASE_URL + "loginuser";
  static const String REGISTER_URL = BASE_URL + "RegisterUser";
  static const String CREATE_SHOP_URL = BASE_URL + "CreateShop";
  static const String GET_SHOP_LIST = BASE_URL + "getShopList";
  static const String GET_PRODUCTS_DETAIL = BASE_URL + "getproductdetail";
  static const String GET_CART_LIST = BASE_URL + "getCartList";
  static const String INSERT_CART_URL = BASE_URL + "insertCart";
  static const String GET_TOTAL_CART = BASE_URL + "JumlahTotalCart";
  static const String GET_LABEL_COUNT = BASE_URL + "LabelCartCount";
  static const String DELETE_CART = BASE_URL + "DeleteCart";
  static const String GET_PRODUCT_LIST = BASE_URL + "getproductlist";
}