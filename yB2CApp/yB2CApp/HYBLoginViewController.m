//
// HYBLoginViewController.m
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


#import "HYBLoginViewController.h"
#import "HYBAppDelegate.h"
#import "HYBSignUpViewController.h"
#import "UFS-Swift.h"
#import <AVFoundation/AVFoundation.h>
#import "stylesheet.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Adjust/Adjust.h>


/*
#if DEV
#define CONFIRM_URL @"http://stage.unileverfoodsolutions.%@/profil-erstellen/registration-completion.html"
#else
#define CONFIRM_URL @"https://www.unileverfoodsolutions.%@/profil-erstellen/registration-completion.html"
#endif
*/

#define CONFIRM_URL_ACCOUNT_CH_DE @"de/profil-erstellen/registration-completion.html"
#define CONFIRM_URL_ACCOUNT_CH_FR @"fr/creer-un-compte/registration-completion.html"

@interface HYBLoginViewController ()

@property(nonatomic) WSloginView *mainView;
- (IBAction)emailTFEndEditing:(id)sender;

@end

@implementation HYBLoginViewController{
  
  NSMutableData *dataResponse;
  NSString *countryCode;
}

//- (instancetype)initWithBackEndService:(HYBB2CService*)backendService {
//    if (self = [super init]) {
//        NSAssert(backendService != nil, @"Service must be present.");
//        _backendService = backendService;
//    }
//    return self;
//}

- (void)dismiss {
  [self dismissViewControllerAnimated:YES
                           completion:nil];
}
- (id)backEndService {
  return [[self getDelegate] backEndService];
}

- (HYBAppDelegate *)getDelegate {
  return (HYBAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
  
  
  
  
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnLoginView:)];
  [self.view addGestureRecognizer:tapGesture];
  
  //_backendService = [self backEndService];
  
  [WSUtility UISetUpForTextFieldWithTextField:self.usernameField withBorderColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1].CGColor];
  [WSUtility UISetUpForTextFieldWithTextField:self.passwordField withBorderColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1].CGColor];
  
  [self.usernameField setLeftPaddingPoints:10];
  [self.passwordField setLeftPaddingPoints:10];
  
  
  [self.loginButton setTitle:[WSUtility getlocalizedStringWithKey:@"Log in" lang:[WSUtility getLanguage] table:@"Localizable"] forState:UIControlStateNormal];
  self.loginLabel.text = [WSUtility getlocalizedStringWithKey:@"Log in" lang:[WSUtility getLanguage] table:@"Localizable"];
  self.usernameField.placeholder = [WSUtility getlocalizedStringWithKey:@"Email" lang:[WSUtility getLanguage] table:@"Localizable"];
  self.passwordField.placeholder = [WSUtility getlocalizedStringWithKey:@"Password" lang:[WSUtility getLanguage] table:@"Localizable"];
  self.emailErrorMessageLabel.text = [WSUtility getlocalizedStringWithKey:@"Please enter a correct email address" lang:[WSUtility getLanguage] table:@"Localizable"];
  self.passwordErrorMessageLabel.text = [WSUtility getlocalizedStringWithKey:@"Please enter a correct password" lang:[WSUtility getLanguage] table:@"Localizable"];
  
  NSString *forgotPasswordText = [WSUtility getlocalizedStringWithKey:@"Forgot Password" lang:[WSUtility getLanguage] table:@"Localizable"];
  NSMutableAttributedString *forgotPasswordString = [[NSMutableAttributedString alloc] initWithString:forgotPasswordText];
  [forgotPasswordString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [forgotPasswordText length])];
  [forgotPasswordString addAttribute:NSForegroundColorAttributeName value:UIColor.orangeColor range:NSMakeRange(0, [forgotPasswordText length])];
  [self.forgotButton setAttributedTitle:forgotPasswordString forState:UIControlStateNormal];
  
  
  dataResponse=[NSMutableData data];
  countryCode = [[NSUserDefaults standardUserDefaults] stringForKey:@"CountryCode"];
  [WSUtility addNavigationBarBackButtonWithController:self];
  [FBSDKAppEvents logEvent:@"Login In"];
  //[FBSDKAppEvents loggingOverrideAppID:@""];
}

- (void)keyboardWillShow: (NSNotification *) aNotification{
  // Do something here
  
  NSDictionary *info = [aNotification userInfo];
  
  CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
  
  self.scrollView.contentInset = contentInsets;
  self.scrollView.scrollIndicatorInsets = contentInsets;
  
  // If active text field is hidden by keyboard, scroll it so it's visible
  // Your app might not need or want this behavior.
  CGRect aRect = self.view.frame;
  aRect.size.height -= kbSize.height;
}

- (void)keyboardWillHide: (NSNotification *) aNotification{
  // Do something here
  self.scrollView.contentInset = UIEdgeInsetsZero;
  self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self getTokenForAuth];
}

- (void)tapOnLoginView:(UITapGestureRecognizer *)sender{
  [self.usernameField resignFirstResponder];
  [self.passwordField resignFirstResponder];
}
- (IBAction)emailTFEndEditing:(id)sender {
    
    if([self isValidEmail:self.usernameField.text]){
        self.emailErrorMessageLabel.hidden = true;
        self.emailerrorImg.hidden = false;
        self.emailerrorImg.image = [UIImage imageNamed: @"right_icon"];
        self.usernameField.layer.borderColor = hybris_gray ;
    }else {
        self.emailErrorMessageLabel.hidden = false;
        self.emailerrorImg.hidden = false;
        self.emailerrorImg.image = [UIImage imageNamed: @"error_icon"];
        self.usernameField.layer.borderColor = hybris_red ;
    }
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
}

- (void)backAction:(UIButton*)sender {
  [self.navigationController popViewControllerAnimated:true];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  UIViewController * destinationController = segue.destinationViewController ;
  if ([destinationController isKindOfClass:[WSEmailVerifictionViewController class]]) {
    WSEmailVerifictionViewController *vc = (WSEmailVerifictionViewController *) segue.destinationViewController;
    vc.emailId = self.usernameField.text;
    vc.password = self.passwordField.text;
    vc.confirmUrl = [self getAccountOptInConfirmationUrl];
  }
}

- (NSString *)getConfirmURL {
  NSString *confirmUrl = @"";
  
  NSDictionary *dict = [WSUtility getBaseUrlDictFromUserDefault];
  int status = [dict[@"app_is_live"] intValue];
  if (status == 1){ //Live {
    confirmUrl = @"https://www.unileverfoodsolutions.%@/profil-erstellen/registration-completion.html";
  }else{
    confirmUrl = @"http://stage.unileverfoodsolutions.%@/profil-erstellen/registration-completion.html";
  }

  return confirmUrl;
  
}

- (NSString *)getAccountOptInConfirmationUrl {
  NSString *strCountryCode = [WSUtility getCountryCode];
  NSString *confirmURLStr = [NSString stringWithFormat:[self getConfirmURL],strCountryCode.lowercaseString];
  if ([strCountryCode isEqualToString:@"CH"]) {
    if ([[WSUtility getLanguageCode] isEqualToString:@"de"]) {
      confirmURLStr =  [confirmURLStr stringByReplacingOccurrencesOfString:@"profil-erstellen/registration-completion.html" withString:CONFIRM_URL_ACCOUNT_CH_DE];
      
    } else if ([[WSUtility getLanguageCode] isEqualToString:@"fr"]) {
      confirmURLStr =  [confirmURLStr stringByReplacingOccurrencesOfString:@"profil-erstellen/registration-completion.html" withString:CONFIRM_URL_ACCOUNT_CH_FR];
      
    }
  }
  
  return confirmURLStr;
}

#pragma mark TextField delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField {
  [self updateButtonState];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == _mainView.usernameField) {
    [_mainView.passwordField becomeFirstResponder];
  } else if (textField == _mainView.passwordField) {
    [self loginButtonPressed];
  }
  
  return NO;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField {
  textField.text = @"";
  [self updateButtonState];
  return NO;
}

-(void)updateButtonState {
  if ([self canUseLoginButton]) {
    _mainView.loginButton.enabled = YES;
  } else {
    _mainView.loginButton.enabled = NO;
  }
}

#pragma mark Login Actions

- (void)loginButtonPressed {
  [self tapOnLoginView:nil];
  
  [FBSDKAppEvents logEvent:@"login Button clicked"];
  if([self canUseLoginButton]){
    
    NSString *strCountryCode = [WSUtility getCountryCode];
    if ([strCountryCode isEqualToString:@"TR"]){ // Turkey is Single OPT In country, no need to check the email confirmation
      NSString *username =  self.usernameField.text;
      NSString *pass =  self.passwordField.text;
      [UFSProgressView showWaitingDialog:@""];
      [self loginWithUser:username pass:pass];
    }else{
      [self checkUserEmailConfirmationStatus];
    }
    
  }
}

- (BOOL)canUseLoginButton {
  NSString *username  =  self.usernameField.text;
  NSString *password  = self.passwordField.text;
  
  if ([username isEqualToString:@""]) {
    self.emailErrorMessageLabel.hidden = NO;
  }
  else {
    self.emailErrorMessageLabel.hidden = YES;
  }
  if ([password isEqualToString:@""]) {
    self.passwordErrorMessageLabel.hidden = NO;
  }
  else{
    self.passwordErrorMessageLabel.hidden = YES;
  }
  [self emailTextFieldDidChange: self.usernameField];
  [self passwordTextFieldDidChange: self.passwordField];
  if(username && (username.length > 0 || ![username isEqualToString:@""]) &&
     password && (password.length > 0 || ![password isEqualToString:@""])) {
    return YES;
  }
  
  return NO;
}


- (void)forgotButtonPressed {
  //DDLogDebug(@"Forgot button pressed ...");
  
  UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  UFSForgotPasswordViewController  *controller = [storyBoard instantiateViewControllerWithIdentifier:@"ForgotPasswordStoryboardID"];
  [self presentViewController:controller animated:true completion:nil];
  
}

- (BOOL)canUseForgotButton {
  NSString *username  = _mainView.usernameField.text;
  
  if(username && (username.length > 0 || ![username isEqualToString:@""])) {
    return YES;
  }
  
  return NO;
}

- (void)checkUserEmailConfirmationStatus {
  
  [UFSProgressView showWaitingDialog:@""];
  WSWebServiceBusinessLayer *businesslayer = [[WSWebServiceBusinessLayer alloc] init];
  [businesslayer checkUserHasConfirmedVerificationMailWithEmailID:self.usernameField.text successResponse:^(NSDictionary *response) {
    
    if ([(NSNumber *)response[@"successful"] boolValue] == YES) {
      NSString *username =  self.usernameField.text;
      NSString *pass =  self.passwordField.text;
      
      [self loginWithUser:username pass:pass];
    }else{
      
      [self performSegueWithIdentifier:@"EmailVerificationSegue" sender:self];
      
    }
    
    
  } faliureResponse:^(NSString * errorMessage) {
    
    [UFSProgressView stopWaitingDialog];
    [WSUtility showAlertWithMessage:@"" title:[WSUtility getTranslatedStringForString:@"Please provide valid login credentials"] forController:self];
    
    
  }];
  
}

- (void)loginWithUser:(NSString *)user pass:(NSString *)pass {
  
  WSWebServiceBusinessLayer *serviceBussinessLayer = [[WSWebServiceBusinessLayer alloc] init];
  [serviceBussinessLayer retrieveLoginTokenForUsernameWithUsername:user password:pass successResponse:^(id response) {
    //[UFSProgressView stopWaitingDialog];
    NSLog(@"%@",response);
    [self addUserToAdmin];
    
    //NSString *token = [(NSDictionary*)response objectForKey:ACCESS_TOKEN_KEY];
    NSString *sifuToken = [(NSDictionary*)response objectForKey:@"sifuToken"];
    //[HYBStorage storeObject:sifuToken forKey:@"SIFU_TOKEN_KEY"];
    
    [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"LAST_AUTHENTICATED_USER_KEY"];
    [[NSUserDefaults standardUserDefaults] setObject:pass forKey:@"USER_PASSWORD_KEY"];
    [[NSUserDefaults standardUserDefaults] setObject:sifuToken forKey:@"SIFU_TOKEN_KEY"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //store session
    // [self storeSession:responseObject forUsername:[username lowercaseString]];
    
  } faliureResponse:^(NSString * errorMessage) {
    [UFSProgressView stopWaitingDialog];
    NSLog(@"%@",errorMessage);
    
      [WSUtility showAlertWithMessage:@"" title:[WSUtility getTranslatedStringForString:@"Please provide valid login credentials"] forController:self];
      
    }];

}



- (void)addUserToAdmin{
  NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
  int value = [version intValue];
  [UFSGATracker trackEventWithCategory:@"UFS Login" action:@"Login Button Clicked" label:@"Login" value:[NSNumber numberWithInt:value]];
    if([[WSUtility getCountryCode] isEqualToString:@"TR"]){
        [AdjustTracking EventTrackingWithToken:@"geouy3"];
        [AdjustTracking setTokenToAdjust];
    }else {
         [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"FirstInstallation"];
    }
    
  //Clear all the remote notification when successfully logged in
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
  UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
  [center removeAllDeliveredNotifications];
  //    [center removeAllPendingNotificationRequests];
  
  [[NSUserDefaults standardUserDefaults] setObject:self.usernameField.text forKey:@"UserEmailId"];
  NSString *deviceToken = [[NSUserDefaults standardUserDefaults]
                           stringForKey:@"DeviceToken"];
  
  if (deviceToken == nil){
    deviceToken = @"";
  }
  
  NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
  [tmpDict setValue:deviceToken forKey:@"deviceToken"];
  
  NSString *fcmToken = [[FIRInstanceID instanceID] token];
  
  if (fcmToken == nil){
    fcmToken = @"";
  }
  
  [tmpDict setValue:fcmToken forKey:@"fcm_token"];
  
  WSWebServiceBusinessLayer *businesslayer = [[WSWebServiceBusinessLayer alloc] init];
  [businesslayer addUserToAdminPanelWithParams:tmpDict actionType:@"login" successResponse:^(id response) {
    
    NSArray *arrayResponse = response[@"data"];
    NSDictionary *dict = arrayResponse[0];
    
    NSString *tradePartnerId = [NSString stringWithFormat:@"%@",dict[@"tp_id"]];
    NSString *tradePartnerName = [NSString stringWithFormat:@"%@",dict[@"tp_name"]];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"adminUserResponse"];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"USER_LOGGEDIN_KEY"];
    [[NSUserDefaults standardUserDefaults]setValue:tradePartnerId forKey:@"tradePartnerID"];
    [[NSUserDefaults standardUserDefaults]setValue:tradePartnerName forKey:@"tradePartnerName"];
    //[[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isExistedUserLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [self updateLoginOrLogoutToAdmin];
    
    //
   [self enableDisableFeature];

    
  } faliureResponse:^(NSString * errorMessage) {
    
    [self moveToHomeScreen];
  }];
}

- (void)updateLoginOrLogoutToAdmin {
  
  WSWebServiceBusinessLayer *businesslayer = [[WSWebServiceBusinessLayer alloc] init];
  [businesslayer updateUserLoggedInOrLogoutToAdminPanelWithStatusValue:1 successResponse:^(id response) {
    
  } faliureResponse:^(NSString * errorMessage) {
    
  }];
}
- (void)enableDisableFeature {
    WSWebServiceBusinessLayer* webservice = [[WSWebServiceBusinessLayer alloc] init];
    [webservice featureEnableDisableForcountriesWithSuccess:^(NSDictionary *response) {
       [self getLoyaltyPoints];
     } failure:^(NSString *error) {
         [self moveToHomeScreen];
     }];
}

-(void)getLoyaltyPoints {
  WSWebServiceBusinessLayer *webservice = [[WSWebServiceBusinessLayer alloc] init];
  [webservice makeLoyaltyPointsRequestWithMethodName:@"ecom/loyalty/balance" successResponse:^(NSDictionary *response) {
    NSString *loyalty_points = response[@"absoluteLoyaltyBalance"];
    NSString *countryLoyaltyPoints = [[NSUserDefaults standardUserDefaults] valueForKey:@"CountryLoyaltyPoints"];
    if (loyalty_points != nil) {
      if (loyalty_points.integerValue <= countryLoyaltyPoints.integerValue) {
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isFirstTimeLogin"];
      } else {
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isFirstTimeLogin"];
      }
      [[NSUserDefaults standardUserDefaults] synchronize];
      [self moveToHomeScreen];
    }
    
  } faliureResponse:^(NSString *error) {
    [self moveToHomeScreen];
  }];
}

- (void)moveToHomeScreen {
  
  [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isFromLoginForDTO"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  dispatch_async(dispatch_get_main_queue(), ^{
    NSLog(@"inside dispatch async block main thread from main thread");
    HYBAppDelegate *delegate = [self getDelegate];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstInstallation"]) {
      [delegate openTutorial];
    }
    else{
      [delegate openHomeScreen];
    }
  });
}

- (IBAction)backButtonTapped:(UIButton *)sender {
  [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)loginButtonTapped:(UIButton *)sender {
  [self loginButtonPressed];
}

- (void)getTokenForAuth {
  
  [UFSProgressView showWaitingDialog:@""];
  
  WSWebServiceBusinessLayer *serviceBussinessLayer = [[WSWebServiceBusinessLayer alloc] init];
  [serviceBussinessLayer makeGuestTrustedClientAndExecuteWithSuccessResponse:^(id response) {
    [UFSProgressView stopWaitingDialog];
    NSLog(@"%@",response);
    
  } faliureResponse:^(NSString * errorMessage) {
    [UFSProgressView stopWaitingDialog];
    NSLog(@"%@",errorMessage);
  }];
  
}

- (UIInterfaceOrientation)orientation {
  return [UIApplication sharedApplication].statusBarOrientation;
}

#pragma mark keyboard management

-(IBAction)emailTextFieldDidChange :(UITextField *) textField{
  
  if([self isValidEmail:self.usernameField.text]){
    self.emailErrorMessageLabel.hidden = true;
    self.emailerrorImg.hidden = false;
    self.emailerrorImg.image = [UIImage imageNamed: @"right_icon"];
    self.usernameField.layer.borderColor = hybris_gray;
  }else {
    //self.emailErrorMessageLabel.hidden = false;
    self.emailerrorImg.hidden = false;
    self.emailerrorImg.image = [UIImage imageNamed: @"error_icon"];
    self.usernameField.layer.borderColor = hybris_red;
  }
}
- (IBAction)passwordTextFieldDidChange:(id)sender {
    
    if(![self.passwordField.text isEqualToString:@""]){
        self.passwordErrorMessageLabel.hidden = true;
        self.passwordErrorImg.hidden = false;
        self.passwordErrorImg.image = [UIImage imageNamed: @"right_icon"];
        self.passwordField.layer.borderColor = hybris_gray ;
    }else {
        self.passwordErrorMessageLabel.hidden = false;
        self.passwordErrorImg.hidden = false;
        self.passwordErrorImg.image = [UIImage imageNamed: @"error_icon"];
        self.passwordField.layer.borderColor = hybris_red ;
    }
}

#pragma mark utilities

- (BOOL)isValidEmail:(NSString *)email {
  NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  return [emailTest evaluateWithObject:email];
}



@end

