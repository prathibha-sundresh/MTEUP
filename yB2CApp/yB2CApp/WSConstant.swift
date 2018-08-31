//
//  WSConstant.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 22/11/2017.
//

import UIKit

// BASE URL FORMING FROM ADMIN API
/*
var dic = WSUtility.getBaseUrlDictFromUserDefault() //UserDefaults.standard.dictionary(forKey: "baseURlFeature")
var hybris_base_url = dic["hybris_base_url"]
var hybris_base_url_path = dic["hybris_base_url_path"]
var hybris_token_path = dic["hybris_token_path"]
var hybris_forgot_password = dic["hybris_forgot_password"]
var API_BASE_URL = dic["app_sifu_url"] as! String // SIFU BASE URL
var ADMIN_DEV_BASE_URL = dic["app_admin_panel_url"]  as! String


var BASE_URL_HYBRIS = "\(hybris_base_url ?? "")\(hybris_base_url_path ?? "")BASE_SITE_ID/"
let GET_HYBRIS_TOKEN_URL = "\(hybris_base_url ?? "")\(hybris_token_path ?? "")"
let FORGOT_PASSWORD_API = "\(hybris_base_url ?? "")\(hybris_forgot_password ?? "")"
*/
//**********************************************************************************************

 
//Admin panel headers
let ADMIN_HEADER_COUNTRY_CODE = "App-Country-Code"
let ADMIN_HEADER_LANGUAGE_CODE = "App-Language-Code"
let ADMIN_HEADER_APP_NAME = "App-Name"
let ADMIN_HEADER_APP_PLATFORM = "App-Platform"
let ADMIN_HEADER_APP_VERSION =  "App-Version"
let ADMIN_HEADER_APP_NAME_VALUE = "UFSAPP"
let ADMIN_HEADER_APP_PLATFORM_VALUE = "iOS"


// Keys
let SIFU_AUTHRIZATION_TOKEN_KEY = "SIFU_AUTHRIZATION_TOKEN_KEY"
let LOYALTY_BALANCE_KEY = "currentLoyaltyBalance"
let SIFU_TOKEN_KEY = "SIFU_TOKEN_KEY"
let USER_LOYALTY_GOAL_ID_KEY = "UserLoyaltyGoalIDKey"
let USER_GOAL_DETAIL_KEY = "UserGoalDetailKey"
let IS_USER_HAS_PLACED_FIRST_ORDER = "IsUserHasPlacedFirstOrder"
let Cached_Loyalty_Product = "CachedLoyaltyProduct"
let Cached_TradePartner_Banner = "CachedTradePartnerBanner"
let Cached_Recipe_Like_Status = "CachedRecipeLikeStatus"
let USER_REEDEMED_GIFT_KEY = "UserHasReedemedGift"
let USER_LOGGEDIN_KEY = "USER_LOGGEDIN_KEY"
let TRADE_PARTNER_ID = "tradePartnerID"
let TRADE_PARTNER_NAME = "tradePartnerName"
let USER_ZIP_CODE = "UserZipcode"
let Cached_Double_Loyalty_Product_KEY = "CachedDoubleLoyaltyProduct"
let DTO_OPERATOR = "directOperator"
let HYBRIS_TOKEN = "HYBRIS_TOKEN"
let GET_PRODUCT_QUERY = "GET_PRODUCT_QUERY"
let LAST_AUTHENTICATED_USER_KEY = "LAST_AUTHENTICATED_USER_KEY"
let Cart_Detail_Key = "CartDetail"
let USER_GROUP = "USER_GROUP"
let TAX_NUMBER_KEY = "taxNumber"
let ISPAYMENT_BY_CREDITCARD_KEY = "isPayByCreditCard"
let ISMOQREQUIRED_KEY = "isMOQRequired"

//MARK: Default Value
let Default_ZIP_CODE = "9999"

//Notification Type

let Home = "home_screen"
let Shopping_List = "shopping_list_screen"
let product_category_screen = "product_category_screen"
let product_listing_screen = "product_listing_screen"
let product_detail_screen = "product_detail_screen"
let recipe_listing_screen = "recipe_listing_screen"
let recipe_favorites_screen = "recipe_favorites_screen"
let my_accounts_screen = "my_accounts_screen"
let chef_rewards_screen = "chef_rewards_screen"
let loyalty_listing_screen = "loyalty_listing_screen"
let notifications_screen = "notifications_screen"
let order_listing_screen = "order_listing_screen"
let order_detail_screen = "order_detail_screen"
let app_settings_screen = "app_settings_screen"
let my_cart_screen = "my_cart_screen"
let first_screen = "first_screen"
let UPDATE_FCM_TO_SERVER = "Update_FCM_token_To_server"




// API Name

let Registration_API_Method = "auth/register"
let Get_Loyalty_API_Method = "ecom/loyalty/balance"
let Slide_API_Method = "auth/slide"
let Login_API_Method = "auth/authenticate"
let Check_User_Email_Verification = "auth/profile/confirm/check"
let Add_Loyalty_API_Method = "ecom/loyalty/add"
let Reset_Password_API = "auth/request/resetPassword"
let CHANGE_PASSWORD_API = "auth/changePassword"
let Recipe_List_API = "recipes/%@/%@/0/5"
let Recipe_Search_API = "recipes/%@/%@/keywords/search?skip=%@&take=%@&q=%@"
let Favourites_List_API = "ecom/favorites"
let Delete_Favourite_Item = "ecom/favorites"
let ADD_Favourite_Item = "ecom/favorites/add"

struct LOYALTY_PRODUCT_BASE_URL {
  let LOYALTY_PRODUCT_CATLOG_DACH_API = "products/pnir/COUNTRY_CODE/LANGUAGE_CODE/search?q=CATEGORY_NAME&type=LOYALTY_REWARD&skip=SKIP&take=TAKE"
  //let LOYALTY_PRODUCT_CATLOG_Turkey_API = "products/%@/%@/search?q=%@&type=LOYALTY_REWARD&skip=%@&take=%@"
  let LOYALTY_PRODUCT_CATLOG_Turkey_API = "products/COUNTRY_CODE/LANGUAGE_CODE/keywords/filter?filterOptions= &take=TAKE&skip=SKIP&type=LOYALTY_REWARD&f=[slugified_category_name_facet~CATEGORY_NAME]"
  
 // https://stage-api.ufs.com/products/TR/tr/keywords/filter?filterOptions= &take=10&skip=0&type=LOYALTY_REWARD&f=[slugified_category_name_facet~oeduel-programi]
  
}

struct LOYALTY_REWARDS_BASE_URL {
  let LOYALTY_REWARDS_DACH_API = "products/pnir/%@/%@/keywords/search?q=*&skip=%@&take=%@&returnAllChildren=false&type=LOYALTY_REWARD"
  
  let LOYALTY_REWARDS_OtherCountry_API = "products/%@/%@/keywords/search?q=*&skip=%@&take=%@&returnAllChildren=false&type=LOYALTY_REWARD"
}

struct GET_RECOMMENDED_RECIPE_BASE_URL {
  //  let GET_RECOMMENDED_RECIPE_DACH = "products/pnir/%@/%@/search?q=*&type=RECIPE&skip=%@&take=%@"
  //  let GET_RECOMMENDED_RECIPE_OtherCountry = "products/%@/%@/search?q=*&type=RECIPE&skip=%@&take=%@"
  let GET_RECOMMENDED_RECIPES = "recipes/%@/%@/search?q=*&type=RECIPES&skip=%@&take=%@"
}

struct GOAL_PRODUCT_DETAIL_BASE_URL {
  let Goal_Product_Detail_DACH = "products/pnir/%@/%@/ean/%@"
  let Goal_Product_Detail_OTHERCOUNTRY = "products/%@/%@/ean/%@"
}

/*
 struct GET_RECOMMENDED_PRODUCT_SIFU_BASE_URL {
 let GET_RECOMMENDED_PRODUCT_DACH_SIFU = "products/pnir/%@/%@/search?q=%@&type=PRODUCT&skip=%@&take=%@"
 let GET_RECOMMENDED_PRODUCT_OtherCountry_SIFU = "products/%@/%@/search?q=%@&type=PRODUCT&skip=%@&take=%@"
 }
 */


struct StockStatus {
  let IN_STOCK = "inStock"
  let OUT_OF_STOCK = "outOfStock"
}

let Products_Search_API = "users/Email_Id/search" //"products/search"



let GET_RECIPE_DETAILS = "recipes/full/code/"
var GET_RECIPE_CODE = "recipes/%@/%@/full/number/%@"
let GET_FILTER_KEYWORDS_FOR_RECIPES = "recipes/%@/%@/keywords/tree"
let FILTER_RECIPES_LIST = "filter-recipes-subkey"
let GET_SAMPLE_ORDER = "adobecampaign/products/samples?country=%@"
let RESEND_VERIFICATION_MAIL = "auth/profile/confirm/send"
let Double_Loyalty_Product_Sifu = "productloyaltypoints/list?siteCode=%@"
let GET_PRODUCT_BY_CODE_TR = "products/codes?codes=%@"

struct Product_Detail_BY_Number_BASE_URL {
  let Product_Detail_BY_Number_DACH_API = "products/pnir/%@/%@/number/%@"
  let Product_Detail_BY_Number_OtherCountry_API = "products/%@/%@/number/%@"
  
}

struct GET_RECOMMENDED_PRODUCT_FROM_EAN_CODES_BASE_URL  {
  let GET_RECOMMENDED_PRODUCT_FROM_EAN_CODES_DACH = "products/pnir/%@/%@/eans?eans=%@"
  let GET_RECOMMENDED_PRODUCT_FROM_EAN_CODES_OTHERCOUNTRY = "products/%@/%@/eans?eans=%@"
  
}
let LoginUser_API = "login"
let Forgot_API = "forgottenpasswordtokens?email=email_id"
let GET_BUSINESS_TYPES_FROM_HYBRIS = "businessTypes?lang=%@"

//HYBRIS APIs
let SIGN_UP = "users"
let HYB_PROUCT_DETAIL = "users/%@/%@?fields=FULL&lang=%@"
let HYB_SCAN_PROUCT_DETAIL = "users/%@/barcode/%@?fields=FULL"
let HYB_DTO_UPDATE_PROFILE = "users/%@/update/DTO/profile"
let HYB_TermsAndCondtions = "getCMSComponent/%@?fields=FULL"

// Admin panel api for my account
let UPLOAD_PROFILE_IMAGE = "add-profile-picture"
let GET_USER_INFO = "get-user-info"
let UPDATE_USER_INFO = "update-user"
let REMOVE_USER_PIC = "remove-profile-picture"
let GET_BUSINESS_TYPES = "business-types"
let UPDATELOGIN_OR_LOGGEDOUT_TO_ADMIN = "track-users-status"

let ORDER_HISTORY_API = "ecom/order"
let ORDER_HISTORY_API_HYBRIS_FOR_TR = "users/%@/orders?pageSize=20&fields=DEFAULT"
let ORDER_HISTORY_DETAIL_API_HYBRIS_FOR_TR = "users/%@/orders/%@?fields=DEFAULT"



// Member To Member API
let VALIDATE_PROMOCODE = "validate_promo_code"
let AFTER_PROMOCODE_ORDER_PLACED_SUCCESSFULLY = "after_order_placed_successfully"
let UPDATE_LOYALTYPOINTS_TO_ADMIN = "admin_flag_status_after_order_placed"
let GET_PENDING_LOYALTYPOINTS_FROM_ADMIN = "get-pending-loyalty-points"
let UPDATE_ADMIN_FLAG_STATUS_AFTER_SIFU = "update_admin_flag_status_after_sifu"
let GET_APPLIED_PROMOCODE_BEFORE_ORDERPLACED = "get-applied-promo-before-orderplaced"
let SET_APPLIED_PROMOCODE_BEFORE_ORDERPLACED = "set-applied-promo-before-orderplaced"
let UNSET_APPLIED_PROMOCODE_BEFORE_ORDERPLACED = "unset-applied-promo-before-orderplaced"
let SEND_PUSH_NOTIFICATION_AFTER_ORDER_PLACED = "trigger_push_notification"
let GET_FEATURE_ENABLE_DISABLE = "get-app-feature-status"
let GET_COUNTRY_LANGUAGE = "get-all-country-language"
let GET_COUNTRY_LOYALTY_POINTS = "get-country-loyalty-points"


//base URL for hybris

let HYBRIS_TOKEN_KEY = "HYBRIS_TOKEN_KEY"
let MAIN_CATEGORIES_API = "catalogs/ufs%@ProductCatalog/Online/categories/1?lang=%@"
let PRODUCTLIST_FOR_SUB_CATEGORY = "users/%@/search?query=%@&fields=FULL&currentPage=%@&pageSize=10&lang=%@"
let GET_PRODUCTLIST_HYBRIS = "users/%@/search?query=%@&fields=FULL&currentPage=%@&pageSize=10&lang=%@"
let GET_DOUBLE_PRODUCTLIST_HYBRIS = "products/search?query=%@&fields=FULL"
//traderPartner

let GET_TRADEPARTNERS_LIST = "ecom/tradepartners"
let CREATE_UPDATE_MAKE_DEFALUT_TRADEPARTNER_API = "ecom/userprofile/tradepartner"
let GET_PROFILE_API = "ecom/userprofile"
let GET_PROFILE_API_HYBRIS_TR = "users/email_id?fields=DEFAULT"
let UPDATE_PROFILE_API = "ecom/userprofile"
let GET_BASIC_PROFILE_API = "auth/profile"
let UPDATE_USER_DETAILS_TO_SIFU = "auth/update/profile"
let GET_USER_TRADEPARTNERS = "ecom/userprofile/full"
let GET_TRADEPARTNERS = "ecom/tradepartners"
let GET_TRADEPARTNERS_LOCATIONS = "ecom/tradepartners/%@/children"
let CREATE_USER_FOR_ECOM = "ecom/userprofile/create"


let GET_RECOMMENDED_PRODUCT_ADMIN = "getrecommendendproducts"
let GET_TRADEPARTNER_BANNER_ADMIN = "get-tradepartner-banner"
let RECIPE_SWIPE_API = "get-recipe-swipe"
let Recipe_FAVORITE_API = "make-as-favorite-recipe"
let Recipe_UNFAVORITE_API = "make-as-unfavorite-recipe"
let MY_RECIPES_API = "get-all-saved-favorite-recipe"
let GET_RECIPE_API = "get-all-recipes-with-favorites"
let GET_RECOMMENDE_RECIPE = "get-recommended-recipes"
let SEND_TRACKING_EVENT_API = "save-track-event-info"

let GET_RECOMMENDED_EANCODES = "recommendation/?type=PRODUCT"

let GET_NOTIFICATION_LIST = "get-notifications-list"
let SEND_NOTIFICATION_STATUS = "track-notifications-opened"
//call Sales rep
let GET_SALES_REP_ADMIN = "get-salesrep-byzip"

//check out
let ADD_ADDRESS_TO_CART = "users/email_id/addresses"
let ADD_DELIVERY_DETAILS = "users/%@/carts/%@/deliverydetails?deliveryNotes=%@&deliveryDate=%@"
let SET_DELIVERY_MODE = "users/email_id/carts/cart_id/deliverymode?deliveryModeId=delivery_Mode"
let ADD_PAYMENT_DETAILS = "users/%@/carts/%@/paymentdetails"
let GET_CART_ID = "users/email_id/carts"
let ADD_TO_CART = "users/email_id/carts/cart_id/entries?fields=statusCode,quantity,entry(FULL)&sifuToken=SIFU_TOKEN_ID"
let REORDER_TO_CART = "users/email_id/carts/cart_id/multiEntries?&fields=DEFAULT&sifuToken=SIFU_TOKEN_ID"
let ADD_PRODUCT_WITHQTY_TO_CART = "users/email_id/carts/cart_id/entries?fields=statusCode,quantity,entry(BASIC)&sifuToken=token"
let CHECKOUT_SAMPLEORDER = "checkoutSampleOrder"
let GET_GIFT = "getGift"
let PLACE_ORDER = "placeOrder"

//vendorList for turkey
let GET_VENDORSLIST_FOR_TR = "vendors/list"
let GET_SAVED_PAYMENT_CARDS_FOR_TR = "users/%@/paymentdetails?saved=%@&vendorId=%@&fields=DEFAULT"
let DELETE_SAVED_PAYMENT_CARDS_FOR_TR = "users/%@/paymentdetails/%@"


// Color
let ApplicationOrangeColor = UIColor(red: 250.0 / 255.0, green: 90.0 / 255.0, blue: 0.0 / 255.0, alpha: 1)
let Search_UnitBox_UnSelectedColor = UIColor(red: 228.0 / 255.0, green: 229.0 / 255.0, blue: 236.0 / 255.0, alpha: 1)
let CartBadgeColor = UIColor(red: 255.0 / 255.0, green: 90.0 / 255.0, blue: 0.0 / 255.0, alpha: 1)
let ApplicationBlackColor = UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1)

let unselectedTextFieldBorderColor = UIColor(red: 230.0 / 255.0, green: 230.0 / 255.0, blue: 230.0 / 255.0, alpha: 1).cgColor

let selectedTextFieldBorderColor = UIColor(red: 208.0 / 255.0, green: 1.0 / 255.0, blue: 27.0 / 255.0, alpha: 1).cgColor

let USER_PROFILE_IMAGE_URL = "ProfileImageURL"
let USER_PROFILE_IMAGE_NAME = "MyProfile"

//notification
let SEND_LAST_VISITED_RECIPE_STATUS = "store-last-visited-recipe"
let TRIGGER_PUSH_NOTIFICATION = "trigger_push_notification"
let TRACK_SAVE_INFO = "save-track-screen-info"

let  GET_SALES_REPRESENTATIVES = "get-sales-representatives"

let  GET_INCENTIVE_PRODUCTS = "get-incentive-product"

//FireBase
let CATEGORIES = "Category"
let ACTION = "Action"
let LABEL = "Label"
let EVENTS = "Events"
let ANALYTICS_DATA = "analytic_data"
let FIREBASE_USERID = "Country"

//Navigation conditions
var SHOW_ALL_RECIPES_FROM_SAMPLE_ORDER_SUCCESS = false


//Calender API constants
let GET_CALENDER_INFO_TO_ENABLE_AVAILABLE_DATES = "get-available-delivery-dates"


//Cart
let CREATE_CART = "users/email_id/carts?sifuToken=SIFU_TOKEN_ID"
let GET_CART_URL = "users/email_id/carts/current?fields=FULL&sifuToken=SIFU_TOKEN_ID&lang=language_Code"
let REPLACE_CART_ENTRY = "users/email_id/carts/cart_id/entries/entry_no?qty=REP_QTY&sifuToken=SIFU_TOKEN_ID"
let DELETE_CART_ENTRY = "users/email_id/carts/cart_id/entries/entry_no?sifuToken=SIFU_TOKEN_ID"
let GET_CART = "getCart"

//Chat
let START_CHAT = "get-opr-sr-id"
let SEND_MESSAGE = "save-operator-chat"
let SET_ONLINE_OFFLINE_STATUS = "track-users-status"
let CHAT_HISTORY = "get-opr-chat-history"

//Hyb Constants
let USER_PASSWORD_KEY = "USER_PASSWORD_KEY"

//For country loyalty Points
let COUNTRY_LOYALTY_POINTS = "CountryLoyaltyPoints"

enum featureId : String {
  case First_order_incentive = "1"
  case Trade_partner_promotion_banners = "2"
  case Sales_rep_chat_feature = "3"
  case Cook_and_save_scan_functionality = "4"
  case Payment_integration = "5"
  case Availability_of_city_in_Registration_form = "6"
  case Live_Chat_Chef = "8"
  case Loyalty_Promotion_Banner = "10"
  case Recommended_Product = "11"
  case Personalized_Pricing = "12"
  case Sales_Rep_Call = "9"
}

let ChefRewards_Vedio = "https://techstage.nl/ufsapp_global/download_video"
let chefRewards_Path_Name = "chefrewards_Video.mp4"

//add,update,get vendor details
let CREATE_VENDOR = "users/%@/addVendorToUserProfile?customerEmailId=%@&parentVendor=%@&vendorAddress=%@&customerNumber=%@&isDefault=%@"
let GET_USER_PROFILE_VENDORS_LIST = "users/%@/getUserProfileVendors?fields=DEFAULT"
let UPDATE_USER_VENDOR_PROFILE = "users/%@/updateUserProfileVendor?myProfileVendorCode=%@&customerNumber=%@&isDefault=%@&fields=DEFAULT"
