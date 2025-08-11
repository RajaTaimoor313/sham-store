class ApiConstants {
  static const String baseUrl = 'http://ecom.addisanalytics.com';

  // Authentication endpoints
  static const String login = '/api/login';
  static const String logout = '/api/logout';
  static const String forgotPassword = '/api/forgot-password';
  static const String sendResetPasswordPin = '/api/send_reset_password_pin';
  static const String resetPassword = '/api/reset_password';
  static const String verifyEmail = '/api/verify-email';
  static const String verifyEmailOtp = '/api/verify_email';
  static const String resendOtp = '/api/resend_otp';
  static const String resendVerification =
      '/api/email/verification-notification';
  static const String changePassword = '/api/change_password';

  // Product endpoints
  static const String product = '/api/product';
  static const String allProducts = '/api/all_products';
  static const String searchProduct = '/api/search_product';
  static const String productWithShipping = '/product_with_shipping';
  static const String productsByCategory = '/api/products/category';
  static const String categoryProducts = '/api/category/{categoryId}/products';

  // Product Category endpoints
  static const String productCategory = '/api/productcategor';
  static const String allProductCategories = '/api/all_productcategors';
  static const String searchProductCategory = '/api/search_productcategor';
  static const String publicProductCategories = '/public/productcat';
  static const String productCategoryWithSub = '/product_catagory';

  // Product Gallery endpoints
  static const String productGallery = '/api/productgaller';
  static const String allProductGalleries = '/api/all_productgallers';
  static const String searchProductGallery = '/api/search_productgaller';

  // Product Attributes endpoints
  static const String productAttribute = '/api/productattribute';
  static const String allProductAttributes = '/api/all_productattributes';
  static const String searchProductAttribute = '/api/search_productattribute';

  // Product Pricing Tier endpoints
  static const String productPricingTier = '/api/productpricingtier';
  static const String allProductPricingTiers = '/api/all_productpricingtiers';
  static const String searchProductPricingTier = '/api/search_productpricingtier';

  // Product Shipping endpoints
  static const String productShipping = '/api/productshipping';
  static const String allProductShippings = '/api/all_productshippings';
  static const String searchProductShipping = '/api/search_productshipping';

  // Order endpoints
  static const String orders = '/order';
  static const String createOrder = '/order';
  static const String allOrders = '/api/all_orders';
  static const String searchOrders = '/search_order';
  static const String myOrders = '/orders';
  static const String myOrdersApi = '/api/my_orders';
  static const String userOrders = '/user/orders';
  static const String getOrder = '/order';
  static const String updateOrder = '/order';
  static const String cancelOrder = '/order/cancel';
  static const String trackOrder = '/track_order';
  static const String deliveredOrders = '/orders/delivered';
  static const String orderStatistics = '/order/statistics';
  static const String sellerOrders = '/seller/orders';
  static const String driverOrders = '/driver/orders';
  static const String markDelivered = '/order/mark-delivered';

  // Order Item endpoints
  static const String orderItems = '/orderitem';
  static const String allOrderItems = '/all_orderitems';
  static const String searchOrderItems = '/search_orderitem';

  // Payment endpoints
  static const String payments = '/payment';
  static const String processPayment = '/payment/process';
  static const String refundPayment = '/payment/refund';
  static const String paymentStatistics = '/payment/statistics';
  static const String myPayments = '/my_payment';
  static const String searchPayments = '/search_payment';
  static const String getPayment = '/payment';
  static const String userPayments = '/user/payments';

  // Payment Method endpoints
  static const String paymentMethods = '/paymentmethod';
  static const String addPaymentMethod = '/paymentmethod';
  static const String updatePaymentMethod = '/paymentmethod';
  static const String deletePaymentMethod = '/paymentmethod';
  static const String allPaymentMethods = '/all_paymentmethods';
  static const String myPaymentMethods = '/my_payment_methode';
  static const String validatePaymentMethod = '/payment-method/validate';
  static const String setDefaultPaymentMethod = '/payment-method/default';
  static const String searchPaymentMethods = '/search_paymentmethod';

  // Payment Schedule endpoints
  static const String paymentSchedules = '/payment-schedule';
  static const String createPaymentSchedule = '/payment-schedule';
  static const String updatePaymentSchedule = '/payment-schedule';
  static const String deletePaymentSchedule = '/payment-schedule';

  // User account endpoints
  static const String register = '/api/register';
  static const String user = '/api/user';
  static const String profile = '/api/profile';
  static const String updateProfile = '/api/profile';
  static const String updateMyAccount = '/api/update_myaccount';
  static const String deleteAccount = '/api/delete-account';

  // Wishlist endpoints
  static const String wishlist = '/api/wishlist';
  static const String getWishlist = '/api/wishlist';
  static const String searchWishlist = '/api/search_wishlist';
  static const String allWishlists = '/api/all_wishlists';
  static const String myWatchList = '/api/all_wishlists';

  // Follow endpoints
  static const String myFollow = '/api/my_follow';

  // Support Ticket endpoints
  static const String supportTickets = '/supportticket';
  static const String mySupportTickets = '/my_support_ticket';
  static const String searchSupportTickets = '/search_supportticket';

  // Inquiry endpoints
  static const String myInquiry = '/my_inquery';

  // Blog endpoints
  static const String blogs = '/blog';
  static const String allBlogs = '/all_blogs';
  static const String searchBlogs = '/search_blog';

  // Gallery endpoints
  static const String gallery = '/gallery';
  static const String allGalleries = '/all_gallerys';
  static const String searchGalleries = '/search_gallery';

  // Notification endpoints
  static const String notifications = '/api/notifications';
  static const String notificationSettings = '/api/notificationsetting';
  static const String allNotificationSettings = '/api/all_notificationsettings';
  static const String searchNotificationSettings =
      '/api/search_notificationsetting';
  static const String markNotificationsAsRead = '/api/notifications/mark-as-read';

  // Business Settings endpoints
  static const String businessSettings = '/businesssetting';
  static const String searchBusinessSettings = '/search_businesssetting';

  // File operations
  static const String uploadFileByChunk = '/upload-file-by-chunk';
  static const String retrieveFile = '/retrieve-File';

  // Seller endpoints
  static const String sellerProducts = '/seller_product';
  static const String sellerDashboardOrders = '/seller_dashbord_order';

  // Delivery endpoints
  static const String driverRegister = '/drivers/register';
  static const String driverDocumentUpdate = '/driver/document/update';
  static const String driverProfileUpdate = '/driver/profile/update';
  static const String performanceStats = '/performance_stats';
  static const String registerVehicle = '/register_vechile';
  static const String getVehicle = '/get_vechile';
  static const String searchVehicle = '/search_vechle';
  static const String availableOrders = '/delivery/available-orders';
  static const String deliveryOrders = '/delivery/orders';

  // Admin endpoints
  static const String allUsers = '/all_user';
  static const String assignDriver = '/admin/driver/orders';
  static const String driverOrderDetail = '/admin/driver/order';
  static const String deliveredOrderDetail =
      '/admin/driver/delivered_orderdetail';
  static const String deliveredOrder = '/admin/driver/delivered_order';

  // Feedback endpoints
  static const String feedbacks = '/feedbacks';
  static const String searchFeedbacks = '/feedbacks/search';

  // Broadcasting
  static const String broadcastingAuth = '/broadcasting/auth';

  // Cart endpoints
  static const String carts = '/api/carts';  // POST, GET
  static const String allCarts = '/api/carts/all';  // GET
  static const String cartById = '/api/carts';  // GET /api/carts/{id}
  static const String updateCart = '/api/carts';  // PUT /api/carts/{id}
  static const String deleteCart = '/api/carts';  // DELETE /api/carts/{id}
  static const String searchCarts = '/api/carts/search';  // GET /api/carts/search/{query}
  
  // Legacy cart endpoints (keeping for backward compatibility)
  static const String cart = '/api/carts/all';
  static const String addToCart = '/api/carts';
  static const String updateCartItem = '/api/cart/update';
  static const String removeFromCart = '/api/cart/remove';
  static const String clearCart = '/api/cart/clear';
  static const String addToWishlist = '/api/wishlist';
  static const String removeFromWishlist = '/api/wishlist/remove';

  // Review endpoints
  static const String reviews = '/api/reviews';
  static const String allReviews = '/api/all_reviews';
  static const String reviewStatistics = '/api/reviews/';
  static const String productReviews = '/api/reviews/:id';
  static const String addReview = '/api/reviews';
  static const String updateReview = '/api/reviews/:id';
  static const String deleteReview = '/api/reviews/:id';
}
