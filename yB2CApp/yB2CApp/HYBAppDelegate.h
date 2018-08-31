//
// HYBAppDelegate.h
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

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <LiveChat/LiveChat-Swift.h>
#import <Adjust/Adjust.h>

@import Firebase;


@class HYBB2CService;

@interface HYBAppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate,FIRMessagingDelegate,LiveChatDelegate>

@property(nonatomic) UIWindow *window;
@property(nonatomic, readonly) HYBB2CService* backEndService;
@property(nonatomic) ADJConfig *adjustConfig;

- (void)openHomeScreen;
- (void)openLoginScreen;
- (void)openTutorial;
- (void)openRegularLoginScreen;
- (void)navigateToAllProductScreen;
- (void)navigateToRecipeListScreen;
- (void)navigateToMyRecipeListScreen;
- (void)navigateToMyAccountScreen;
- (void)navigateToChefRewardScreen;
- (void)navigateToChefRewardLoyaltyListScreen;
- (void)navigateToNotificationScreen;
- (void)navigateToOrderHistoryScreen;
- (void)navigateToAppSettingScreen;
- (void)navigateToCartScreen;
- (void)navigateToProductDetailScreen:(NSString *)productCode;
- (void)navigateToRecipeDetailScreen:(NSString *)recipeCode;
- (void)adjustTrackingSetup;

@end
