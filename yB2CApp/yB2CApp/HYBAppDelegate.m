//
// HYBAppDelegate.m
// [y] hybris Platform
//
// Copyright (c) 2000-2016 hybris AG
// All rights reserved.
//
// This software is the confidential and proprietary information of hybris
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with hybris.
//

#import "HYBAppDelegate.h"
//#import "MYEnvironmentConfig.h"
#import "UFS-Swift.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GAI.h>
#import <GAIDictionaryBuilder.h>
#import <GoogleAnalytics/GAIFields.h>


#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface HYBAppDelegate () <UNUserNotificationCenterDelegate>
@end
#endif

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif



@implementation HYBAppDelegate {
    
    UIImageView *snapshotSecurityBlocker;
    NSTimer *timer;
    BOOL appIsStarting;
}
NSString *const kGCMMessageIDKey = @"gcm.message_id";
NSString *const LIVE_CHAT_LICENCE_ID = @"8746516";

//app life cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  /*
    NSDictionary* baseUrlDic = [[NSDictionary alloc]init];
    baseUrlDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"baseURlFeature"];
    
    if (baseUrlDic == nil){
        
        NSDictionary* baseUrlDic = @{@"hybris_base_url": @"",@"hybris_base_url_path": @"",@"hybris_token_path": @"",@"hybris_forgot_password": @""};
        [[NSUserDefaults standardUserDefaults] setValue:baseUrlDic forKey:@"baseURlFeature"];
    }
    */
  
    //NSDictionary *dictUrl= [WSUtility getBaseUrlDictFromUserDefault];
  
    
    UFSNetworkReachablityHandler *networkStatus = [UFSNetworkReachablityHandler shared];
    [networkStatus startNetworkReachabilityObserver];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateFCMtoServer:)
                                                 name: @"Update_FCM_token_To_server"
                                               object:nil];
    

     [self liveChatSDKSetUp];
    
  
    // FB Analytics
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
  
  
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
  
    [self makeManualSettings];
    if ([[WSUtility getCountryCode] isEqualToString:@"TR"]) {
        [self adjustTrackingSetup];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currently_shown_cat"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
  
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSplashScreen) name:@"RemoveSplashScreen" object:nil];

     //[self openSplashScreen];
    WSDownloadFilesManager* manager = [[WSDownloadFilesManager alloc] init];
    [manager downloadVideoWithUrlString:@"" PathName:@"" success:^(id response) {
        
    } failure:^(NSString * error) {
        
    }];
    
    
    if([WSUtility isUserLoggedIn]) {
        [UFSGATracker gaIntializer];
        [FireBaseTracker firebaseTrackerConfig];
        [self openHomeScreen];
    } else {
        [self openSplashScreen];
    }
    
    [self.window makeKeyAndVisible];
    
    
#if TARGET_IPHONE_SIMULATOR
    [[NSUserDefaults standardUserDefaults] setObject:@"FAB0CA0FD3BBF7BD01F2EEB73123B041BC9FCAC554E2CCE49D4BECA48D77CAF" forKey:@"DeviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
#endif
    
    //FIRbaseMessaging
    // iOS 8 or later
    // [START register_for_notifications]
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        /*
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
         */
    } else {
        
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
#endif
    }
    
    [application registerForRemoteNotifications];
    // [END register_for_notifications]
    [self registerForRemoteNotifications];

    return YES;
}

//==============================================


// [START receive_message]
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
   
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }

    // Print full message.
    NSLog(@"%@", userInfo);
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    completionHandler(UIBackgroundFetchResultNoData);
  
}

- (void)liveChatSDKSetUp {
  LiveChat.licenseId = LIVE_CHAT_LICENCE_ID;
  LiveChat.groupId = @"12";
 // LiveChat.email = @"Test@test.com";
 // LiveChat.name = @"Test";
  LiveChat.delegate = self;
}

- (void)adjustTrackingSetup {
    NSString *yourAppToken = @"77xw8ed5fc00";
    NSString *environment = @"";
  
  /// Commenting for Turkey relase
  /*
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:@"isForLiveOrStage"];
  
  
    if (value == true) {
        environment = ADJEnvironmentProduction;
    } else {
        environment = ADJEnvironmentSandbox;
    }
    */
  
    environment = ADJEnvironmentSandbox;
  
    self.adjustConfig = [ADJConfig configWithAppToken:yourAppToken
                                                environment:environment];
    [self.adjustConfig setAppSecret:1 info1:619868930 info2:1964931854 info3:1580781099 info4:1500897320];
    
    [Adjust appDidLaunch:self.adjustConfig];
   
}

// [START refresh_token]
- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    
}

// To enable direct data messages, you can set [Messaging messaging].shouldEstablishDirectChannel to YES.
- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    NSLog(@"Received data message: %@", remoteMessage.appData);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    //good for her
    
    appIsStarting = NO;
}

- (UIImageView *)createLogoView {
    UIImageView *imageHolder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo.png"]];
    imageHolder.contentMode = UIViewContentModeScaleAspectFit;
    return imageHolder;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    appIsStarting = NO;
  
}


-(void)targetMethod {
    
    //NSString *emailID = [[self.backEndService userStorage] objectForKey:LAST_AUTHENTICATED_USER_KEY];
    NSString *emailID = [[NSUserDefaults standardUserDefaults] objectForKey: @"LAST_AUTHENTICATED_USER_KEY"];
    WSWebServiceBusinessLayer *serviceBussinessLayer = [[WSWebServiceBusinessLayer alloc] init];
    [serviceBussinessLayer triggerLeavingAppWithoutBuyingNotificationWithAction:@"abandoned_cart" email:emailID productNames:@"Knorr1" productCodes:@"12345"];
}

-(void)applicationWillEnterForeground:(UIApplication *)application{
    [timer invalidate];
  
    appIsStarting = YES;
}
- (void)applicationDidBecomeActive:(UIApplication *)application{
    
    [self makeManualSettings];
    
    appIsStarting = NO;
  
  [self enableDisableFeature];
  
 
    if([WSUtility isUserLoggedIn]) {
        
        [self getLoyaltyPoint];
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
//        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
//        UIViewController *selectedVC = tabBarController.selectedViewController.childViewControllers.lastObject;
        WSAddToCartBussinessLogic *addToCartBussinessHandler = [[WSAddToCartBussinessLogic alloc] init];
        [addToCartBussinessHandler getCartDetailForController:self.window.rootViewController];
    }
}

- (void)getLoyaltyPoint  {
  WSWebServiceBusinessLayer *serviceBussinessLayer =  [[WSWebServiceBusinessLayer alloc] init];
  [serviceBussinessLayer makeLoyaltyPointsRequestWithMethodName:@"ecom/loyalty/balance" successResponse:^(id response) {
    
  } faliureResponse:^(NSString * errorMessage) {
    
    if ([errorMessage isEqualToString:@"Session_Token_Expire" ]) {
      NSLog(@"session token expired in homescreen");
     // self.getSifuAccessToken()
    }
    
  }];
  
}
- (void) makeManualSettings {
    /* 2 lines for get static urls
     Start*/
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isManualSettings"];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isForLiveOrStage"];
    
 
    //End
}
- (void) getSifuAccessToken  {
  WSWebServiceBusinessLayer *serviceBussinessLayer =  [[WSWebServiceBusinessLayer alloc] init];
  NSString *emailID = [[NSUserDefaults standardUserDefaults] objectForKey: @"LAST_AUTHENTICATED_USER_KEY"];
    NSString *password =  [[NSUserDefaults standardUserDefaults] objectForKey: @"USER_PASSWORD_KEY"];//[[self.backEndService userStorage] objectForKey:USER_PASSWORD_KEY];
  NSDictionary *dictParameter = @{@"EmailId":emailID, @"Password":password};
  
  [serviceBussinessLayer makeLoginRequestWithParameter:dictParameter methodName:@"auth/authenticate" successResponse:^(id response) {
    [self getLoyaltyPoint];
  } faliureResponse:^(NSString * errorMessage) {
    
  }];
}

- (void)removeSplashScreen{
  
  if([WSUtility isUserLoggedIn]) {
    [self openHomeScreen];
  } else {
    [self openLoginScreen];
  }
}

- (void)openLoginScreen {
  UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CountrySelection" bundle:nil];
  UIViewController *selectCountry = [sb instantiateViewControllerWithIdentifier:@"SelectCountryVC"];
  self.window.rootViewController = selectCountry ;
  [self.window makeKeyAndVisible];
}
- (void)openRegularLoginScreen {
   
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SignInBaseView" bundle:nil];
    //UIViewController *loginVC = [sb instantiateViewControllerWithIdentifier:@"SignInVCID"];
  UINavigationController *navigationVC = [sb instantiateViewControllerWithIdentifier:@"SignInBaseNavigationController"];
    self.window.rootViewController = navigationVC ;
    
    //Clear all the remote notification when successfully logged out
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllDeliveredNotifications];

    [self.window makeKeyAndVisible];
}
- (void)openHomeScreen {
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  UITabBarController *mainTabBarVC =  [mainStoryboard instantiateViewControllerWithIdentifier:@"MainTabBarVC"];
  //mainTabBarVC.tabBar.tintColor = [UIColor colorWithRed:1.00 green:0.35 blue:0.00 alpha:1.0];
  
  for (UITabBarItem *tabBarItem in mainTabBarVC.tabBar.items) {
    tabBarItem.title = nil ;
    tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0) ;
  }
  
  self.window.rootViewController = mainTabBarVC ;
}

- (void)openTutorial{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
    
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"firstInstallation"];
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isFirstTimeLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    int value = [version intValue];
    [UFSGATracker trackEventWithCategory:@"install app" action:@"button click" label:@"app installed," value:[NSNumber numberWithInt:value]];
    [FBSDKAppEvents logEvent:@"Installs"];
    [FBSDKAppEvents logEvent:FBSDKAppEventNameCompletedTutorial];
    UIViewController *tutorialVC =  [storyboard instantiateViewControllerWithIdentifier:@"WSTutorialViewControllerID"];
    self.window.rootViewController = tutorialVC ;
}

- (void)openSplashScreen {
    UIStoryboard *splashStoryboard = [UIStoryboard storyboardWithName:@"Splash" bundle:nil];
    UIViewController *splashVC =  [splashStoryboard instantiateViewControllerWithIdentifier:@"SplashVC"];
    self.window.rootViewController = splashVC;
    [self.window makeKeyAndVisible];
}
- (void)registerForRemoteNotifications {
    
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    // do work here
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
            }
        }];
    }
    else {
        // Code for old versions
    }
}
// Mark:- pushNotification Delegates methods

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
 // NSLog( @"Handle push from foreground" );
  // custom code to handle push while app is in the foreground
  NSLog(@"%@", notification.request.content.userInfo);
  
    NSDictionary *dictInfo = notification.request.content.userInfo;
    
    
    if([WSUtility isUserLoggedIn]) {
        
        NSString *action = dictInfo[@"action"];
        if([action isEqualToString:@"chat"]) //chat notofication
        {
            NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"msgcame" object:self userInfo:nil];
            
        }else{
            completionHandler(UNNotificationPresentationOptionAlert);
        }
    }
    else{
        completionHandler(UNNotificationPresentationOptionAlert);
    }
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
  //NSLog( @"Handle push from background or closed" );
  // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
    NSLog(@"userInfo######## %@", response.notification.request.content.userInfo);
    
  if([WSUtility isUserLoggedIn]) {
      
    NSDictionary *dictInfo = response.notification.request.content.userInfo;
    NSString *action = dictInfo[@"action"];
      
    if([action isEqualToString:@"chat"]) //chat notofication
    {
       [self navigateToChatScreen:(NSString *)[dictInfo objectForKey:@"seg_id"]];
        
    }else{
         [self navigationFromPushNotification:dictInfo[@"aps"]];
    }
  }
  
}


- (void)navigationFromPushNotification:(NSDictionary *)userInfo {

  NSDictionary *dictInfo = userInfo[@"alert"];
  NSString *actionType = dictInfo[@"click_action"];
  NSArray *notificationArray = [actionType componentsSeparatedByString:@"#"];
  
   
    [UFSGATracker trackScreenViewsWithScreenName:@"Push Notification"];//added to match the android GA tracking.
    [UFSGATracker trackScreenViewsWithScreenName:@"Home Screen"];//added to match the android GA tracking.
    [UFSGATracker trackScreenViewsWithScreenName:@"Dashboard Screen"];//added to match the android GA tracking.
  
  [self openHomeScreen];

  UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
  
/*
  if (self.window.subviews.count > 1){
    UIView *menuView = self.window.subviews.lastObject;
    [menuView removeFromSuperview];
  }
*/
  if (notificationArray.count > 0){
    

    NSString *notificationActionKey = notificationArray[0];
      NSLog(@"notificationActionKey######## %@", notificationActionKey);

    
    if ([notificationActionKey isEqualToString:@"home_screen"]){
      tabBarController.selectedIndex = 0;
      
    }else if ([notificationActionKey isEqualToString:@"shopping_list_screen"]){
      tabBarController.selectedIndex = 1;
      
    }else if ([notificationActionKey isEqualToString:@"product_category_screen"]){
       tabBarController.selectedIndex = 2;
      
    }else if ([notificationActionKey isEqualToString:@"search_screen"]){
        tabBarController.selectedIndex = 4;
    }else if ([notificationActionKey isEqualToString:@"search_recipe_screen"]){
        tabBarController.selectedIndex = 3;
    }else if ([notificationActionKey isEqualToString:@"product_listing_screen"]){
      [self navigateToAllProductScreen];
    }else if ([notificationActionKey isEqualToString:@"product_detail_screen"]){
      if (notificationArray.count > 1){
        NSString *code = notificationArray[2];
          [UFSGATracker trackScreenViewsWithScreenName:@"Home Screen"];//added to match the android GA tracking.
          [UFSGATracker trackScreenViewsWithScreenName:@"Dashboard Screen"];//added to match the android GA tracking.
      [self navigateToProductDetailScreen:code];
      }
    }else if ([notificationActionKey isEqualToString:@"recipe_listing_screen"]){
      [self navigateToRecipeListScreen];
    }else if ([notificationActionKey isEqualToString:@"recipe_detail_screen"]){
        if (notificationArray.count > 1){
            NSString *code = notificationArray[2];
            [self navigateToRecipeDetailScreen:code];
        }
    }else if ([notificationActionKey isEqualToString:@"recipe_favorites_screen"]){
       [self navigateToMyRecipeListScreen];
      
    }else if ([notificationActionKey isEqualToString:@"my_accounts_screen"]){
      [self navigateToMyAccountScreen];
      
    }else if ([notificationActionKey isEqualToString:@"chef_rewards_screen"]){
      [self navigateToChefRewardScreen];
      
    }else if ([notificationActionKey isEqualToString:@"loyalty_listing_screen"]){
      [self navigateToChefRewardLoyaltyListScreen];
      
    }else if ([notificationActionKey isEqualToString:@"notifications_screen"]){
      [self navigateToNotificationScreen];
      
    }else if ([notificationActionKey isEqualToString:@"order_listing_screen"]){
      
      [self navigateToOrderHistoryScreen];
    }else if ([notificationActionKey isEqualToString:@"order_detail_screen"]){
      [self navigateToOrderHistoryScreen];
    }else if ([notificationActionKey isEqualToString:@"app_settings_screen"]){
      [self navigateToAppSettingScreen];
    }else if ([notificationActionKey isEqualToString:@"my_cart_screen"]){
      [self navigateToCartScreen];
    }
  }
}

- (void)navigateToAllProductScreen {
  UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
  UIViewController *selectedVC = tabBarController.selectedViewController.childViewControllers.lastObject;
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ProductCatalogue" bundle:nil];
  AllProductsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ProductListScreenID"];
  vc.productListScreenOpenedBy = ProductListOpenedForALL_PRODUCT;
  
  [selectedVC.navigationController pushViewController:vc animated:YES];
  
}

- (void)navigateToRecipeListScreen {
  UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
  UIViewController *selectedVC = tabBarController.selectedViewController.childViewControllers.lastObject;
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Recipe" bundle:nil];
  WSRecipeListViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"RecipeStoryboard"];
  //vc.productListScreenOpenedBy = ProductListOpenedForALL_PRODUCT;
  
  [selectedVC.navigationController pushViewController:vc animated:YES];
  
}
- (void)navigateToMyRecipeListScreen {
  UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
  UIViewController *selectedVC = tabBarController.selectedViewController.childViewControllers.lastObject;
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Recipe" bundle:nil];
  WSMyRecipeViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MyRecipeStoryboardID"];
  
  [selectedVC.navigationController pushViewController:vc animated:YES];
  
}

- (void)navigateToMyAccountScreen {
  UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
  UIViewController *selectedVC = tabBarController.selectedViewController.childViewControllers.lastObject;
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyAccount" bundle:nil];
  WSMyAccountViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"WSMyAccountViewControllerID"];
  
  [selectedVC.navigationController pushViewController:vc animated:YES];
  
}

- (void)navigateToChefRewardScreen {
  UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
  UIViewController *selectedVC = tabBarController.selectedViewController.childViewControllers.lastObject;
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ChefReward" bundle:nil];
  WSChefRewardScreenViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ChefRewardLandingID"];
  
  [selectedVC.navigationController pushViewController:vc animated:YES];
  
}

- (void)navigateToChefRewardLoyaltyListScreen {
    
  UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
  UIViewController *selectedVC = tabBarController.selectedViewController.childViewControllers.lastObject;
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ChefReward" bundle:nil];
  WSLoyaltyListerViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"LoyaltyListStoryBoardId"];
  vc.selectedCategoryName = @"All rewards";
  vc.selectedCategoryCode = @"*";
  
  [selectedVC.navigationController pushViewController:vc animated:YES];
  
}

- (void)navigateToChatScreen:(NSString *)segId {
/*
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    tabBarController.selectedIndex = 0;
    UIViewController *selectedVC = tabBarController.selectedViewController.childViewControllers.lastObject;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    ChatHistoryViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ChatHistoryViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.segId = segId;
    [selectedVC.navigationController pushViewController:vc animated:YES];
*/
}

- (void)navigateToNotificationScreen {
  UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
  UIViewController *selectedVC = tabBarController.selectedViewController.childViewControllers.lastObject;
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyNotification" bundle:nil];
  MyNotificationViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MyNotificationViewControllerID"];
  
  [selectedVC.navigationController pushViewController:vc animated:YES];
  
}

- (void)navigateToOrderHistoryScreen {
  UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
  UIViewController *selectedVC = tabBarController.selectedViewController.childViewControllers.lastObject;
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyOrderHistory" bundle:nil];
  MyNotificationViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MyOrderHistoryViewControllerID"];
  
  [selectedVC.navigationController pushViewController:vc animated:YES];
  
}


- (void)navigateToAppSettingScreen {
  UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
  UIViewController *selectedVC = tabBarController.selectedViewController.childViewControllers.lastObject;
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AppSettings" bundle:nil];
  AppSettingsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AppSettingsViewControllerID"];
    vc.isFromMenu = true;
  [selectedVC.navigationController pushViewController:vc animated:YES];
  
}
- (void)navigateToCartScreen {
  UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
  UIViewController *selectedVC = tabBarController.selectedViewController.childViewControllers.lastObject;
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Cart" bundle:nil];
  AppSettingsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CartViewC"];
  
  [selectedVC.navigationController pushViewController:vc animated:YES];
  
}

- (void)navigateToProductDetailScreen:(NSString *)productCode {
    
  UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
  UIViewController *selectedVC = tabBarController.selectedViewController.childViewControllers.lastObject;
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ProductDetail" bundle:nil];
  WSProductDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ProductDetailVc"];
  vc.productCode = productCode;
  vc.originalProductCode = productCode;
  [selectedVC.navigationController pushViewController:vc animated:YES];
  
}
- (void)navigateToRecipeDetailScreen:(NSString *)recipeCode {
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UIViewController *selectedVC = tabBarController.selectedViewController.childViewControllers.lastObject;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RecipeDetail" bundle:nil];
    UFSRecipeDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"RecipeDetailVCID"];
    vc.recipeNumber = recipeCode;
    [selectedVC.navigationController pushViewController:vc animated:YES];
    
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
 
    //Store FCM token To admin
    NSString *fcmToken = [[FIRInstanceID instanceID] token];
   // NSLog(@"FCM registration token: %@", fcmToken);
    
    if([WSUtility isUserLoggedIn]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Update_FCM_token_To_server" object:nil];
    }
    
   // NSLog(@"deviceToken: %@", deviceToken);
    
    // for adjust tracking of installation
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"FirstInstallation"];
    AdjustTracking.deviceToken = deviceToken;
    
    NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
    //Format token as you need:
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"DeviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"PushNotificationSentForFirstInstallation"]){
        WSWebServiceBusinessLayer *serviceBussinessLayer = [[WSWebServiceBusinessLayer alloc] init];
        [serviceBussinessLayer triggerAppInstalledPushNotificationWithAction:@"app_installed"];
    }
  
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

//FB Analytics
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSString * strURL = url.absoluteString;
    if ([strURL containsString:@"ufsapp://"]) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        tracker.allowIDFACollection = YES;

        GAIDictionaryBuilder *hitParams = [[GAIDictionaryBuilder alloc] init];
        [hitParams setCampaignParametersFromUrl:strURL];

        if(![hitParams get:kGAICampaignSource] && [url host].length !=0) {
            // Set campaign data on the map, not the tracker.
            [hitParams set:@"Google-referrer" forKey:kGAICampaignMedium];
            [hitParams set:[url host] forKey:kGAICampaignSource];
        }
        
        NSDictionary *hitParamsDict = [hitParams build];
        
        // A screen name is required for a screen view.
        [tracker set:kGAIScreenName value:@"Appdelegate"];
        [tracker send:[[[GAIDictionaryBuilder createScreenView] setAll:hitParamsDict] build]];

        [self removeSplashScreen];
    }
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    // Add any custom logic here.
    return handled;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {
    if ([[userActivity activityType] isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *url = [userActivity webpageURL];
        //NSLog(@"adjustURL----%@",url);
        NSString * strURL = url.absoluteString;
        if ([strURL containsString:@"ufsapp-adjust"]) {
             if ([[WSUtility getCountryCode] isEqualToString:@"TR"] && _adjustConfig != nil) {
                  [Adjust appWillOpenUrl:url];
             }
              return YES;
         }
    }
  
    return NO;
}

- (BOOL)adjustDeeplinkResponse:(NSURL *)deeplink {
    // deeplink object contains information about deferred deep link content
      NSLog(@"adjustURL---adjustDeeplinkResponse-%@",deeplink);
    return YES;
}

- (void)getTokenForAuth {
  
    WSWebServiceBusinessLayer *serviceBussinessLayer = [[WSWebServiceBusinessLayer alloc] init];
    [serviceBussinessLayer makeGuestTrustedClientAndExecuteWithSuccessResponse:^(id response) {
        //[UFSProgressView stopWaitingDialog];
        NSLog(@"%@",response);
        
    } faliureResponse:^(NSString * errorMessage) {
       // [UFSProgressView stopWaitingDialog];
        NSLog(@"%@",errorMessage);
    }];
  
}
- (void)enableDisableFeature {
    WSWebServiceBusinessLayer* webservice = [[WSWebServiceBusinessLayer alloc] init];
    [webservice featureEnableDisableForcountriesWithSuccess:^(NSDictionary *response) {
        [self getTokenForAuth];
    } failure:^(NSString *error) {
    }];
}

-(void)updateFCMtoServer:(NSNotification *)notification {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
        
        NSString *deviceToken = [[NSUserDefaults standardUserDefaults]
                                 stringForKey:@"DeviceToken"];
        
        if (deviceToken == nil){
            deviceToken = @"";
        }

        NSString *fcmToken = [[FIRInstanceID instanceID] token];
        
        if (fcmToken == nil){
            fcmToken = @"";
        }
        
        NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
        [tmpDict setValue:fcmToken forKey:@"fcm_token"];
        [tmpDict setValue:deviceToken forKey:@"deviceToken"];
        
        WSWebServiceBusinessLayer *businesslayer = [[WSWebServiceBusinessLayer alloc] init];
        [businesslayer addUserToAdminPanelWithParams:tmpDict actionType:@"updateFcm" successResponse:^(id response) {
            
           // NSLog(@"Successfully updated FCM to server");
            

        } faliureResponse:^(NSString * errorMessage) {
            
            NSLog(@"Failed to update FCM to server");
            
        }];
        
    });
}

#pragma mark - LIVECHAT SDK
- (void)receivedWithMessage:(LiveChatMessage *)message{
  
}

- (void)chatDismissed{
  
}
@end
