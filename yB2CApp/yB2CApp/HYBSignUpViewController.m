//
//  HYBSignUpViewController.m
// [y] hybris Platform
//
// Copyright (c) 2000-2016 hybris AG
// All rights reserved.
//
// This software is the confidential and proprietary information of hybris
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with hybris.

#import "HYBSignUpViewController.h"
#import "UFS-Swift.h"
#import "stylesheet.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "HYBAppDelegate.h"

/*
#if DEV

#define CONFIRM_URL @"http://stage.unileverfoodsolutions.%@/profil-erstellen/registration-completion.html"
#define NEWSLETTER_CONFIRM_URL @"http://stage.unileverfoodsolutions.%@/newsletter-abonnieren/newsletter-abonnieren-completion.html"
#else

#define CONFIRM_URL @"https://www.unileverfoodsolutions.%@/profil-erstellen/registration-completion.html"
#define NEWSLETTER_CONFIRM_URL @"https://www.unileverfoodsolutions.%@/newsletter-abonnieren/newsletter-abonnieren-completion.html"
#endif
*/

#define CONFIRM_URL_ACCOUNT_CH_DE @"de/profil-erstellen/registration-completion.html"
#define CONFIRM_URL_ACCOUNT_CH_FR @"fr/creer-un-compte/registration-completion.html"
#define NEWSLETTER_CONFIRM_URL_ACCOUNT_CH_DE @"de/newsletter-abonnieren/newsletter-abonnieren-completion.html"
#define NEWSLETTER_CONFIRM_URL_ACCOUNT_CH_FR @"fr/newsletter-sabonner/newsletter-sabonner-completion.html"


//#define hybris_red                      UIColor(red: 197.0 / 255.0, green: 0.0 / 255.0, blue: 26.0 / 255.0, alpha: 1)
//#define hybris_gray                     UIColor(red: 183.0 / 255.0, green: 183.0 / 255.0, blue: 183.0 / 255.0, alpha: 1)

@interface HYBSignUpViewController ()


// Constants and var
@property (nonatomic) NSMutableArray *pickerBusinessData;
@property (nonatomic) NSMutableArray *businessTypeNameArray;
@property (nonatomic) NSMutableArray *pickerTradeData;
@property (nonatomic) NSMutableArray *pickerCityData;
//@property (nonatomic) NSMutableArray *pickerTempData;
//@property (nonatomic) NSMutableArray *optionsArray;
@property (nonatomic) NSArray *tradeArr;
//@property (nonatomic) int selectedPicker;
//@property (nonatomic) NSInteger selectUserTitle;
//@property (nonatomic) CGPoint actionCenter;
//@property (nonatomic) UILabel         *cancelPickerLabel;
@property (nonatomic) int pwdSecureFlag;
@property (nonatomic) int checkboxFlag;
@property (nonatomic) int newsLettercheckboxFlag;
@property (nonatomic) int businessOrTradeFlag;
@property (nonatomic) NSString *selectedBusiness;
@property (nonatomic) NSString *selectedCity;
@property (nonatomic) NSString *business_ID;
@property (nonatomic) NSString *selectedTrade;
@property (nonatomic) NSMutableData *dataResponse;
@property (nonatomic) NSString *apiType;
//@property (nonatomic) NSString *hybToken;
@property (nonatomic) NSString *signupResStatus;
@property (nonatomic) NSMutableDictionary *signUpParam;
@property (nonatomic) NSString *accountOptInConfirmationLink;

// Outlets
@property (weak, nonatomic) IBOutlet UILabel *registerLabel;
@property (weak, nonatomic) IBOutlet UILabel *myDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *myBusinessLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerWithFbButton;
@property (weak, nonatomic) IBOutlet UIButton *createAFreeAccountButton;
@property (weak, nonatomic) IBOutlet UILabel *createAPasswordLabel;
@property (nonatomic) IBOutlet FloatLabelTextField         *firstNameTxtField;
@property (nonatomic) IBOutlet FloatLabelTextField         *lastNameTxtField;
@property (nonatomic) IBOutlet FloatLabelTextField         *emailTxtField;
@property (nonatomic) IBOutlet UIImageView                 *firstNameErrorImg;
@property (nonatomic) IBOutlet UIImageView                 *emailerrorImg;
@property (nonatomic) IBOutlet UIImageView                 *lastNameerrorImg;
@property (nonatomic) IBOutlet UILabel         *firstNameErrorLbl;
@property (nonatomic) IBOutlet UILabel         *lastNameErrorLbl;
@property (nonatomic) IBOutlet UILabel         *emailErrorLbl;
@property (nonatomic) IBOutlet UITextField         *businessTypeTxtField;
@property (nonatomic) IBOutlet UILabel         *businessTypeErrorLbl;
@property (nonatomic) IBOutlet UITextField         *tradePartnerTxtField;
@property (nonatomic) IBOutlet UILabel         *tradePartnerErrorLbl;
@property (nonatomic) IBOutlet UITextField         *passwordTxtField;
@property (nonatomic) IBOutlet UIImageView         *passwordErrorImg;
@property (nonatomic) IBOutlet UILabel         *passwordErrorLbl;
@property (nonatomic) IBOutlet UIButton         *pwdSecureBtn;
@property (nonatomic) IBOutlet UIButton         *checkBoxBtn;//need to add
@property (nonatomic) IBOutlet UIButton         *newsLetterCheckBoxBtn;
@property (nonatomic) IBOutlet UILabel          *newsLetterTextLabel;
@property (nonatomic) IBOutlet UILabel          *newsLetterTextSubLabel;
@property (nonatomic) IBOutlet UIButton         *termAndCondBtn;
@property (nonatomic) IBOutlet UIScrollView         *scrollView;
@property (nonatomic) IBOutlet UILabel         *tandCLbl;

@property (weak, nonatomic) IBOutlet UIView *vwBaseCity;
@property (weak, nonatomic) IBOutlet UITextField *tfCity;
@property (weak, nonatomic) IBOutlet UILabel *lblErrorSelectCity;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *htConstantCityVwBase;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalConstraintTradePartnerTF;

@property (weak, nonatomic) IBOutlet UIButton *btnCheckMark1_16YearsOld;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *YearsOldTopX;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckMark1;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckMark2;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckMark3;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckMark4;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckMark5;
@property (weak, nonatomic) IBOutlet UILabel *lblCheckMark1;
@property (weak, nonatomic) IBOutlet UILabel *lblCheckMark2;
@property (weak, nonatomic) IBOutlet UILabel *lblCheckMark3;
@property (weak, nonatomic) IBOutlet UILabel *lblCheckMark4;
@property (weak, nonatomic) IBOutlet UILabel *lblCheckMark5;
@property (weak, nonatomic) IBOutlet UILabel *lblTnC;
@property (weak, nonatomic) IBOutlet UITextView *textViewTnC;


@end

@implementation HYBSignUpViewController

- (IBAction)btnCheckMark1Tapped:(id)sender {
  self.btnCheckMark1.selected = !self.btnCheckMark1.isSelected;
}
- (IBAction)btnCheckMark2Tapped:(id)sender {
  self.btnCheckMark2.selected = !self.btnCheckMark2.isSelected;
  self.btnCheckMark3.selected = self.btnCheckMark2.isSelected;
  self.btnCheckMark4.selected = self.btnCheckMark2.isSelected;
  self.btnCheckMark5.selected = self.btnCheckMark2.isSelected;
}
- (IBAction)btnCheckMark3Tapped:(id)sender {
  self.btnCheckMark3.selected = !self.btnCheckMark3.isSelected;
  [self updateCheckMark2];
}
- (IBAction)btnCheckMark4Tapped:(id)sender {
  self.btnCheckMark4.selected = !self.btnCheckMark4.isSelected;
  [self updateCheckMark2];
}
- (IBAction)btnCheckMark5Tapped:(id)sender {
  self.btnCheckMark5.selected = !self.btnCheckMark5.isSelected;
  [self updateCheckMark2];
}

- (void)updateCheckMark2{
  if (self.btnCheckMark3.isSelected && self.btnCheckMark4.isSelected && self.btnCheckMark5.isSelected) {
    self.btnCheckMark2.selected = true;
  }
  else{
    self.btnCheckMark2.selected = false;
  }
}

- (IBAction)emailTFEndEditing:(id)sender {
  if([self validateEmailWithString:self.emailTxtField.text]){
    self.emailErrorLbl.hidden = true;
    self.emailerrorImg.hidden = false;
    self.emailerrorImg.image = [UIImage imageNamed: @"right_icon"];
    self.emailTxtField.layer.borderColor = hybris_gray;
    
  }else {
    self.emailErrorLbl.hidden = false;
    self.emailerrorImg.hidden = false;
    self.emailerrorImg.image = [UIImage imageNamed: @"error_icon"];
    self.emailTxtField.layer.borderColor = hybris_red ;
  }
}
- (void)viewDidLoad {
  [super viewDidLoad];
    self.signUpParam = [[NSMutableDictionary alloc] init];
  [self applyDefaultStyle];
  [self varInit];
  
  //HYBAppDelegate *delegate = (HYBAppDelegate*)[self getDelegate];
  //self.backendService =  delegate.backEndService;
  
  [self setTextToCheckMarkLabels];
  [self setTextToTnCTextView];
  
  _lblErrorSelectCity.text = [WSUtility getlocalizedStringWithKey:@"Password" lang:[WSUtility getLanguage] table:@"Localizable"];
  self.passwordTxtField.placeholder = [WSUtility getlocalizedStringWithKey:@"Password" lang:[WSUtility getLanguage] table:@"Localizable"];
  self.firstNameTxtField.placeholder = [WSUtility getlocalizedStringWithKey:@"First Name" lang:[WSUtility getLanguage] table:@"Localizable"];
  self.lastNameTxtField.placeholder = [WSUtility getlocalizedStringWithKey:@"Last Name" lang:[WSUtility getLanguage] table:@"Localizable"];
  self.emailTxtField.placeholder = [WSUtility getlocalizedStringWithKey:@"Email" lang:[WSUtility getLanguage] table:@"Localizable"];
  self.businessTypeTxtField.placeholder = [WSUtility getlocalizedStringWithKey:@"Business type" lang:[WSUtility getLanguage] table:@"Localizable"];
  self.tradePartnerTxtField.placeholder = [WSUtility getlocalizedStringWithKey:@"Trade partner" lang:[WSUtility getLanguage] table:@"Localizable"];
  self.tfCity.placeholder = [WSUtility getlocalizedStringWithKey:@"City" lang:[WSUtility getLanguage] table:@"Localizable"];
  _firstNameErrorLbl.text=[WSUtility getlocalizedStringWithKey:@"Please enter your first name" lang:[WSUtility getLanguage] table:@"Localizable"];
  _lastNameErrorLbl.text = [WSUtility getlocalizedStringWithKey:@"Please enter your last name" lang:[WSUtility getLanguage] table:@"Localizable"];
  _emailErrorLbl.text = [WSUtility getlocalizedStringWithKey:@"Please enter a correct email address" lang:[WSUtility getLanguage] table:@"Localizable"];
  _businessTypeErrorLbl.text = [WSUtility getlocalizedStringWithKey:@"Please enter what type of business you are working in" lang:[WSUtility getLanguage] table:@"Localizable"];
  _tradePartnerErrorLbl.text = [WSUtility getlocalizedStringWithKey:@"Please select your tradepartner name" lang:[WSUtility getLanguage] table:@"Localizable"];
  _passwordErrorLbl.text = [WSUtility getlocalizedStringWithKey:@"Your password needs to be minimum 8 characters long one and contain at least one of each: upper case, lowercase, number special character [eg. !. %. +]" lang:[WSUtility getLanguage] table:@"Localizable"];
  _tandCLbl.text = [WSUtility getlocalizedStringWithKey:@"I have read and accepted the terms and conditions" lang:[WSUtility getLanguage] table:@"Localizable"];
  _registerLabel.text = [WSUtility getlocalizedStringWithKey:@"Register" lang:[WSUtility getLanguage] table:@"Localizable"];
  
  _myDetailsLabel.text = [WSUtility getlocalizedStringWithKey:@"My details" lang:[WSUtility getLanguage] table:@"Localizable"];
  
  
  _myBusinessLabel.text = [WSUtility getlocalizedStringWithKey:@"My business" lang:[WSUtility getLanguage] table:@"Localizable"];
  
  
  NSString *tcText = [WSUtility getlocalizedStringWithKey:@"terms and conditions" lang:[WSUtility getLanguage] table:@"Localizable"];
  NSMutableAttributedString *tcAttriString = [[NSMutableAttributedString alloc] initWithString:tcText];
  [tcAttriString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [tcText length])];
  [tcAttriString addAttribute:NSForegroundColorAttributeName value:UIColor.orangeColor range:NSMakeRange(0, [tcText length])];
  [_termAndCondBtn setAttributedTitle:tcAttriString forState:UIControlStateNormal];
  [_termAndCondBtn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
  
  [_createAFreeAccountButton setTitle:[WSUtility getlocalizedStringWithKey:@"Create a FREE account - Register Page" lang:[WSUtility getLanguage] table:@"Localizable"] forState:UIControlStateNormal];
  [_registerWithFbButton setTitle:[WSUtility getlocalizedStringWithKey:@"Register with Facebook" lang:[WSUtility getLanguage] table:@"Localizable"] forState:UIControlStateNormal];
  _createAPasswordLabel.text = [WSUtility getlocalizedStringWithKey:@"Create a Password" lang:[WSUtility getLanguage] table:@"Localizable"];
  
  [WSUtility addNavigationBarBackButtonWithController:self];
  
  if (![WSUtility isLoginWithTurkey]){
    self.htConstantCityVwBase.constant = 0.0;
    self.verticalConstraintTradePartnerTF.constant = 30.0;
    [self.vwBaseCity setHidden:true];
  }
  else{
    self.htConstantCityVwBase.constant = 79.0;
    self.verticalConstraintTradePartnerTF.constant = 5.0;
    [self.vwBaseCity setHidden:false];
  }
  
}

- (void)setTextToTnCTextView{
  NSString *strTnC = [WSUtility getlocalizedStringWithKey:@"TnC Signup" lang:[WSUtility getLanguage] table:@"Localizable"];
  
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strTnC];
  NSRange rng = [strTnC rangeOfString:[WSUtility getlocalizedStringWithKey:strTnC lang:[WSUtility getLanguage] table:@"Localizable"]];
  NSRange foundRange = [strTnC rangeOfString:[WSUtility getlocalizedStringWithKey:@"privacy policy" lang:[WSUtility getLanguage] table:@"Localizable"]];
  
  [attributedString addAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"DINPro-Regular" size:14.0],  NSForegroundColorAttributeName : [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0] } range:rng];
    NSString *strURL = @"http://www.unileverprivacypolicy.com/de_at/policy.aspx";
    NSString *str = [WSUtility getCountryCode];
    if ([str isEqualToString:@"AT"]) {
        strURL = @"http://www.unileverprivacypolicy.com/de_at/policy.aspx";
    }
    else if ([str isEqualToString:@"DE"]){
        strURL = @"http://www.unileverprivacypolicy.com/de_DE/Policy.aspx";
    }
    else if ([str isEqualToString:@"TR"]){
        strURL = @"http://www.unileverprivacypolicy.com/turkish/policy.aspx";
    }
    else if ([str isEqualToString:@"CH"]){
        NSString *strLang = [WSUtility getLanguageCode];
        if ([strLang isEqualToString:@"fr"]){
            strURL = @"http://www.unileverprivacypolicy.com/fr_ch/Policy.aspx";
        }
        else if ([strLang isEqualToString:@"de"]){
            strURL = @"http://www.unileverprivacypolicy.com/de_ch/Policy.aspx";
        }
    }
    [attributedString addAttributes:@{NSLinkAttributeName:strURL, NSFontAttributeName:[UIFont fontWithName:@"DINPro-Regular" size:14.0] } range:foundRange];
  
  NSRange fndRange = [strTnC rangeOfString:[WSUtility getlocalizedStringWithKey:@"Legal Terms" lang:[WSUtility getLanguage] table:@"Localizable"]];
  [attributedString addAttributes:@{NSLinkAttributeName:@"legalTerms", NSFontAttributeName:[UIFont fontWithName:@"DINPro-Regular" size:14.0] } range:fndRange];
  
  self.textViewTnC.linkTextAttributes = @{
                                          NSForegroundColorAttributeName: [UIColor orangeColor],
                                          NSUnderlineStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                          };
  
  self.textViewTnC.attributedText = attributedString;
  
}
- (void)setTextToCheckMarkLabels{
  self.lblCheckMark1.text = [WSUtility getlocalizedStringWithKey:@"Yes - I confirm that I am over 16 years old" lang:[WSUtility getLanguage] table:@"Localizable"];
  self.lblCheckMark2.text = [WSUtility getlocalizedStringWithKey:@"Yes - I consent to my personal data being processed for all the below marketing purposes" lang:[WSUtility getLanguage] table:@"Localizable"];
  self.lblCheckMark3.text = [WSUtility getlocalizedStringWithKey:@"Yes - I want to receive personalized newsletters from Unilever Food Solutions on new products, recipes ideas and inspirations" lang:[WSUtility getLanguage] table:@"Localizable"];
  self.lblCheckMark4.text = [WSUtility getlocalizedStringWithKey:@"Yes - I want to participate to marketing campaigns and to receive discount, promotional, loyalty offers and competition invites" lang:[WSUtility getLanguage] table:@"Localizable"];
  self.lblCheckMark5.text = [WSUtility getlocalizedStringWithKey:@"Yes - I want to receive personalized communication about event training and surveys invites" lang:[WSUtility getLanguage] table:@"Localizable"];
  self.lblCheckMark1.text = [WSUtility getlocalizedStringWithKey:@"Yes - I confirm that I am over 16 years old" lang:[WSUtility getLanguage] table:@"Localizable"];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (![WSUtility isLoginWithTurkey]){
    [self trade_request];
  }
  else{
    [self getVendorListAndCities];
      self.btnCheckMark1.hidden = YES;
      self.lblCheckMark1.hidden = YES;
      self.btnCheckMark1_16YearsOld.hidden = YES;
      self.YearsOldTopX.constant = 0;
  }
  // [self getBusinessTypesFromAdmin];
  [self getBusinessTypesFromHybris];
  [self getTrustedClientStatus];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)applyDefaultStyle{
  
  [self.firstNameTxtField setLeftPaddingPoints:10];
  [self.lastNameTxtField setLeftPaddingPoints:10];
  [self.emailTxtField setLeftPaddingPoints:10];
  [self.businessTypeTxtField setLeftPaddingPoints:5];
  [self.tradePartnerTxtField setLeftPaddingPoints:5];
  [self.passwordTxtField setLeftPaddingPoints:5];
  
  self.firstNameTxtField.layer.cornerRadius = 5;
  self.firstNameTxtField.layer.borderColor = hybris_gray ;
  self.firstNameTxtField.layer.borderWidth = 1;
  self.lastNameTxtField.layer.cornerRadius = 5;
  self.lastNameTxtField.layer.borderColor = hybris_gray ;
  self.lastNameTxtField.layer.borderWidth = 1;
  self.emailTxtField.layer.cornerRadius = 5;
  self.emailTxtField.layer.borderColor = hybris_gray ;
  self.emailTxtField.layer.borderWidth = 1;
  
  [self AttributedTextInUILabelWithGreenText:@"Your password needs to be minimum 8 characters long and contain at least one of each: " boldText:@"Upper Case, Lower Case, Number, Special character (eg. !,%,+)"];
  
  
  self.newsLetterTextSubLabel.text = [WSUtility getTranslatedStringForString:@"You may unsubsribe at any time."];
  
  NSString *text = [WSUtility getTranslatedStringForString:@"Yes, I have read the conditions and would like to subscribe to the newsletter."];
  NSMutableAttributedString *attributedText =
  [[NSMutableAttributedString alloc] initWithString:text
                                         attributes:nil];
  
  // gray text attributes
  UIColor *orangeColor = [UIColor colorWithRed:1.00 green:0.35 blue:0.00 alpha:1.0];;
  
  NSRange orangeTextRange = [text rangeOfString:[WSUtility getTranslatedStringForString:@"news_letter_Link"]];
  [attributedText setAttributes:@{NSForegroundColorAttributeName:orangeColor,
                                  NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}
                          range:orangeTextRange];
  self.newsLetterTextLabel.attributedText = attributedText;
  
}

- (void)varInit{
  self.pwdSecureFlag = 0;
  self.checkboxFlag = 0;
  self.newsLettercheckboxFlag = 0;
  
  self.businessOrTradeFlag = 0;
  self.selectedBusiness = @"";
  self.selectedTrade = @"";
  self.selectedBusiness = @"";
  self.selectedTrade = @"";
  
  self.dataResponse=[NSMutableData data];
  self.pickerTradeData = [[NSMutableArray alloc] init];
  
  [self.firstNameTxtField addTarget:self action:@selector(fnameTextFieldDidChange:)
                   forControlEvents:UIControlEventEditingChanged];
  [self.lastNameTxtField addTarget:self action:@selector(lnameTextFieldDidChange:)
                  forControlEvents:UIControlEventEditingChanged];
  [self.emailTxtField addTarget:self action:@selector(emailTextFieldDidChange:)
               forControlEvents:UIControlEventEditingChanged];
  [self.passwordTxtField addTarget:self action:@selector(passwordTFDidEndEditing:)
                  forControlEvents:UIControlEventEditingDidEnd];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(dismissKeyboard)];
  tap.cancelsTouchesInView = false;
  [self.view addGestureRecognizer:tap];
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

- (IBAction)backClicked:(id)sender {
  [self back];
}

- (void)backAction:(UIButton*)sender {
  [self.navigationController popViewControllerAnimated:true];
}
- (void)back {
  [self dismissViewControllerAnimated:YES completion:^{
    
  }];
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

- (NSString *)getNewsLetterConfirmURL {
  NSString *confirmUrl = @"";
  
  NSDictionary *dict = [WSUtility getBaseUrlDictFromUserDefault];
  int status = [dict[@"app_is_live"] intValue];
  if (status == 1){ //Live {
    confirmUrl = @"https://www.unileverfoodsolutions.%@/newsletter-abonnieren/newsletter-abonnieren-completion.html";
  }else{
    confirmUrl = @"http://stage.unileverfoodsolutions.%@/newsletter-abonnieren/newsletter-abonnieren-completion.html";
  }
  
  return confirmUrl;
  
}

#pragma mark alert

- (void)saveProblemAlert:(NSString*)message {
  //   if(error.L)
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"account_warning", nil)
                                                      message:NSLocalizedString(message, nil)
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"ok", nil)
                                            otherButtonTitles:nil];
  
  [alertView show];
}

#pragma mark textfield delegate
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
  
  //Do something with the URL
  if ([URL.absoluteString isEqualToString:@"legalTerms"]) {
    [self performSegueWithIdentifier:@"TermAndConditonSegue" sender:self];
    return NO;
  }
  else{
    return YES;
  }
}
- (void)openNewsLetterOptInTermAndCondition {
  [self performSegueWithIdentifier:@"TermAndConditonSegue" sender:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if(textField ==  self.firstNameTxtField){
    [self.lastNameTxtField becomeFirstResponder];
  } else if(textField ==  self.lastNameTxtField) {
    [self.emailTxtField becomeFirstResponder];
  }else if(textField ==  self.emailTxtField){
    [self.emailTxtField resignFirstResponder];
    //self.view.endEditing(true)
    return false;
  }else if(textField ==  self.passwordTxtField){
    [self.passwordTxtField resignFirstResponder];
    //self.view.endEditing(true)
    return false;
  }
  return NO;
}

//-(void)textFieldDidBeginEditing:(UITextField *)textField {
//    CGFloat dHeight = [UIScreen mainScreen].bounds.size.height;
//    if (textField == self.passwordTxtField) {
//        [self.scrollView setContentOffset:CGPointMake(0.0, dHeight/2) animated:YES];
//    }
//}
//-(void)textFieldDidEndEditing:(UITextField *)textField {
//    CGFloat dHeight = [UIScreen mainScreen].bounds.size.height;
//    if (textField == self.passwordTxtField) {
//        [self.scrollView setContentOffset:CGPointMake(0.0, -dHeight/20) animated:YES];
//    }
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  UIViewController * destinationController = segue.destinationViewController ;
  if ([destinationController isKindOfClass:[WSEmailVerifictionViewController class]]) {
    WSEmailVerifictionViewController *vc = (WSEmailVerifictionViewController *) segue.destinationViewController;
    vc.emailId = self.emailTxtField.text;
    vc.password = self.passwordTxtField.text;
   // NSString *strCountryCode = [WSUtility getCountryCode];
    vc.confirmUrl = self.accountOptInConfirmationLink ; //[NSString stringWithFormat:CONFIRM_URL,strCountryCode.lowercaseString];
    vc.isComeFromSignUpScreen = YES;
  } else if ([destinationController isKindOfClass:[UFSPopUpViewController class]]) {
    UFSPopUpViewController *popUpVC = (UFSPopUpViewController *) segue.destinationViewController;
    
    if (self.businessOrTradeFlag == 2) {
      popUpVC.titleString =  @"Select a city";
      popUpVC.arrayItems = self.pickerCityData;
      popUpVC.selectedItem = self.selectedCity;
    }
    else{
      popUpVC.titleString = (self.businessOrTradeFlag == 0) ? @"Select a business type" : @"Select tradepartner";
      popUpVC.arrayItems = (self.businessOrTradeFlag == 0) ?  self.businessTypeNameArray : self.pickerTradeData;
      popUpVC.selectedItem = (self.businessOrTradeFlag == 0)  ? self.selectedBusiness : self.selectedTrade;
    }
    popUpVC.isSearchBarHidden = YES;
    
    popUpVC.callBack = ^(NSString * selectedItemValue) {
      if(self.businessOrTradeFlag == 0){
          
        self.selectedBusiness = selectedItemValue;
        self.businessTypeTxtField.text = self.selectedBusiness;
        NSUInteger index = [self.businessTypeNameArray indexOfObject:self.selectedBusiness];
        NSDictionary *dict = self.pickerBusinessData[index];
        // self.business_ID = [dict objectForKey:@"bt_id"];
        self.business_ID = [dict objectForKey:@"businessCode"];
        self.businessTypeErrorLbl.hidden = true;
      }else if(self.businessOrTradeFlag == 1){
        self.selectedTrade = selectedItemValue;
        self.tradePartnerTxtField.text = self.selectedTrade;
        self.tradePartnerErrorLbl.hidden = true;
      }
      else
      {
        self.selectedCity = selectedItemValue;
        self.tfCity.text = self.selectedCity;
        self.lblErrorSelectCity.hidden = true;
        
        self.selectedTrade = @"";
        self.tradePartnerTxtField.text = @"";
        
        NSMutableArray *vendorListArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in self.tradeArr){
          NSArray *array  = [dict objectForKey:@"vendorAddress"];
          if (array.count >0){
            NSArray *tmpArray = [[array valueForKeyPath:@"town"] valueForKeyPath:@"uppercaseString"];
            if ([tmpArray containsObject:selectedItemValue]){
              [vendorListArray addObject:dict];
            }
          }
        }
        self.pickerTradeData = [vendorListArray valueForKeyPath:@"name"];
      }
    };
    
  }
  else if([segue.identifier isEqualToString: @"newsLetter"]){
    WSTermsAndConditionsViewController *termsAndCondtionsVC = (WSTermsAndConditionsViewController *) segue.destinationViewController;
    termsAndCondtionsVC.isFromNewsLetter = true;
    
  }
}

- (IBAction)businessTypeClicked:(id)sender {
  [self dismissKeyboard];
  if (self.pickerBusinessData.count > 0) {
    //self.picker.hidden = false;
    //self.pickerTool.hidden = false;
    // self.pickerTempData = self.pickerBusinessData;
    // [self.picker reloadAllComponents];
    self.businessOrTradeFlag = 0;
    [self dismissKeyboard];
    [self performSegueWithIdentifier:@"CustomPopUpSegue" sender:self];
  }
  
}
- (IBAction)tradePartnerNameClicked:(id)sender {
  [self dismissKeyboard];
  if (self.pickerTradeData.count > 0) {
    //self.picker.hidden = false;
    //self.pickerTool.hidden = false;
    //self.pickerTempData = self.pickerTradeData;
    //[self.picker reloadAllComponents];
    self.businessOrTradeFlag = 1;
    [self performSegueWithIdentifier:@"CustomPopUpSegue" sender:self];
  }
  
}
- (IBAction)btnCityTapped:(id)sender {
  [self dismissKeyboard];
  if (self.pickerCityData.count > 0) {
    self.businessOrTradeFlag = 2;
    [self performSegueWithIdentifier:@"CustomPopUpSegue" sender:self];
  }
  
}

- (IBAction)pwdSecureClicked:(id)sender {
  if(self.pwdSecureFlag == 0){
    UIImage *img = [UIImage imageNamed:@"show_pwd.png"];
    [self.pwdSecureBtn setImage:img forState:UIControlStateNormal];
    self.passwordTxtField.secureTextEntry = false;
    self.pwdSecureFlag = 1;
  }else{
    UIImage *img = [UIImage imageNamed:@"hide_pwd_logo.png"];
    [self.pwdSecureBtn setImage:img forState:UIControlStateNormal];
    self.passwordTxtField.secureTextEntry = true;
    self.pwdSecureFlag = 0;
  }
}

- (IBAction)checkBoxClicked:(id)sender{
  //[self tradeSubmit];
  if(self.checkboxFlag == 0){
    UIImage *img = [[UIImage imageNamed:@"checkbox_checked.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.checkBoxBtn setImage:img forState:UIControlStateNormal];
    self.checkboxFlag = 1;
  }else{
    UIImage *img = [[UIImage imageNamed:@"checkbox_unchecked.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.checkBoxBtn setImage:img forState:UIControlStateNormal];
    self.checkboxFlag = 0;
  }
}
- (IBAction)newsLetterCheckBoxClicked:(id)sender{
  
  if(self.newsLettercheckboxFlag == 0){
    UIImage *img = [[UIImage imageNamed:@"checkbox_checked.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.newsLetterCheckBoxBtn setImage:img forState:UIControlStateNormal];
    self.newsLettercheckboxFlag = 1;
  }else{
    UIImage *img = [[UIImage imageNamed:@"checkbox_unchecked.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.newsLetterCheckBoxBtn setImage:img forState:UIControlStateNormal];
    self.newsLettercheckboxFlag = 0;
  }
}
- (IBAction)createAccountClicked:(id)sender{
  Boolean firstNameValid= true;
  Boolean lastNameValid = true;
  Boolean emailValid = true;
  Boolean businessValid = true;
  Boolean tradeValid  = true;
  Boolean cityValid  = true;
  Boolean passwordValid = true;
  
  if(![self checkFirstNameValidations]){
    firstNameValid = false;
  }
  if(![self checkLastNameValidation]){
    lastNameValid = false;
  }
  if(![self checkEmailValidation]){
    emailValid = false;
  }
  if(![self checkBusinessValidation]){
    businessValid = false;
  }
  if(![self checkTradeValidation]){
    tradeValid = false;
  }
  if(![self checkPasswordValidation] || ![self isValidPassword:self.passwordTxtField.text]){
    passwordValid = false;
  }
    if (![WSUtility isLoginWithTurkey]){
        if (!_btnCheckMark1.isSelected) {
            [_btnCheckMark1 setImage:[UIImage imageNamed:@"checkbox_unchecked_red"] forState:UIControlStateNormal];
            return;
        }
    }
  NSString *strCountryCode = [WSUtility getCountryCode];
  if ([strCountryCode isEqualToString:@"TR"]){
    if(![self checkCityValidation]){
      cityValid = false;
    }
    
    if(firstNameValid && lastNameValid && emailValid && businessValid && tradeValid && passwordValid &&  cityValid){
      //API call
      [self processForm];
    }
  }
  else{
    if(firstNameValid && lastNameValid && emailValid && businessValid && tradeValid && passwordValid){
      //API call
      [self processForm];
    }
  }
  
}
- (IBAction)pickerDoneClicked:(id)sender {
  //self.picker.hidden = true;
  //self.pickerTool.hidden = true;
  if(self.businessOrTradeFlag == 0){
    self.businessTypeTxtField.text = self.selectedBusiness;
    self.businessTypeErrorLbl.hidden = true;
  }else if(self.businessOrTradeFlag == 1){
    self.tradePartnerTxtField.text = self.selectedTrade;
    self.tradePartnerErrorLbl.hidden = true;
  }
  else{
    self.tfCity.text = self.selectedCity;
    self.lblErrorSelectCity.hidden = true;
  }
}

-(Boolean)checkFirstNameValidations{
  if([self.firstNameTxtField.text isEqualToString:@""]){
    self.firstNameErrorImg.hidden = false;
    self.firstNameErrorLbl.hidden = false;
    self.firstNameErrorImg.image = [UIImage imageNamed: @"error_icon"];
    self.firstNameTxtField.layer.borderColor = hybris_red;
    return false;
  }else{
    return true;
  }
}

-(Boolean) checkLastNameValidation{
  if([self.lastNameTxtField.text isEqualToString:@""]){
    self.lastNameerrorImg.hidden = false;
    self.lastNameErrorLbl.hidden = false;
    self.lastNameerrorImg.image = [UIImage imageNamed: @"error_icon"];
    self.lastNameTxtField.layer.borderColor = hybris_red;
    
    return false;
  }else{
    return true;
  }
}

-(Boolean) checkEmailValidation{
  if([self validateEmailWithString:self.emailTxtField.text]){
    return true;
  }else{
    self.emailerrorImg.hidden = false;
    self.emailErrorLbl.hidden = false;
    self.emailerrorImg.image = [UIImage imageNamed: @"error_icon"];
    self.emailTxtField.layer.borderColor = hybris_red ;
    return false;
  }
}

-(Boolean) checkBusinessValidation{
  if([self.businessTypeTxtField.text isEqualToString:@""]){
    self.businessTypeErrorLbl.hidden = false;
    return false;
  }else{
    return true;
  }
}

-(Boolean) checkTradeValidation{
  if([self.tradePartnerTxtField.text isEqualToString:@""]){
    self.tradePartnerErrorLbl.hidden = false;
    return false;
  }else{
    return true;
  }
}
-(Boolean) checkCityValidation{
  if([self.tfCity.text isEqualToString:@""]){
    self.lblErrorSelectCity.hidden = false;
    return false;
  }else{
    return true;
  }
}

-(Boolean) checkPasswordValidation{
  if([self.passwordTxtField.text isEqualToString:@""]){
    self.passwordErrorImg.hidden = false;
    self.passwordErrorLbl.textColor = [UIColor colorWithRed:197.0f/255.0f
                                                      green:0.0f/255.0f
                                                       blue:26.0f/255.0f
                                                      alpha:1.0f];
    
    return false;
  }
  return true;
}

-(Boolean) checkTermAndConditionValidation{
  if(self.checkboxFlag == 0){
    UIImage *img = [[UIImage imageNamed:@"checkbox_unchecked_red.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.checkBoxBtn setImage:img forState:UIControlStateNormal];
    return false;
  }else{
    return true;
  }
}


-(void)fnameTextFieldDidChange :(UITextField *) textField{
  
  if([textField.text length] == 1){
    self.firstNameErrorLbl.hidden = true;
    self.firstNameErrorImg.hidden = false;
    self.firstNameErrorImg.image = [UIImage imageNamed: @"right_icon"];
    self.firstNameTxtField.layer.borderColor = hybris_gray;
  }else if([textField.text isEqualToString:@""]){
    self.firstNameErrorLbl.hidden = false;
    self.firstNameErrorImg.hidden = false;
    self.firstNameErrorImg.image = [UIImage imageNamed: @"error_icon"];
    self.firstNameTxtField.layer.borderColor = hybris_red ;
  }
}

-(void)lnameTextFieldDidChange :(UITextField *) textField{
  
  if([textField.text length] == 1){
    self.lastNameErrorLbl.hidden = true;
    self.lastNameerrorImg.hidden = false;
    self.lastNameerrorImg.image = [UIImage imageNamed: @"right_icon"];
    self.lastNameTxtField.layer.borderColor = hybris_gray ;
  }else if([textField.text isEqualToString:@""]){
    self.lastNameErrorLbl.hidden = false;
    self.lastNameerrorImg.hidden = false;
    self.lastNameerrorImg.image = [UIImage imageNamed: @"error_icon"];
    self.lastNameTxtField.layer.borderColor = hybris_red;
  }
}

-(void)emailTextFieldDidChange :(UITextField *) textField{
  
  //    if([self validateEmailWithString:self.emailTxtField.text]){
  //        self.emailErrorLbl.hidden = true;
  //        self.emailerrorImg.hidden = false;
  //        self.emailerrorImg.image = [UIImage imageNamed: @"right_icon"];
  //        self.emailTxtField.layer.borderColor =[hybris_gray CGColor];
  //    }else {
  //        self.emailErrorLbl.hidden = false;
  //        self.emailerrorImg.hidden = false;
  //        self.emailerrorImg.image = [UIImage imageNamed: @"error_icon"];
  //        self.emailTxtField.layer.borderColor =[hybris_red CGColor];
  //    }
}

-(void)passwordTFDidEndEditing :(UITextField *) textField {
  
  if([self isValidPassword:self.passwordTxtField.text]){
    self.passwordErrorLbl.textColor = [UIColor blackColor];
    self.passwordErrorImg.hidden = false;
    self.passwordErrorImg.image = [UIImage imageNamed: @"right_icon"];
    self.passwordTxtField.layer.borderColor = hybris_gray ;
  }else {
    self.passwordErrorLbl.hidden = false;
    self.passwordErrorLbl.textColor = [UIColor redColor];
    self.passwordErrorImg.hidden = false;
    self.passwordErrorImg.image = [UIImage imageNamed: @"error_icon"];
    self.passwordTxtField.layer.borderColor = hybris_red ;
  }
}

-(void)dismissKeyboard {
  [self.firstNameTxtField resignFirstResponder];
  [self.lastNameTxtField  resignFirstResponder];
  [self.emailTxtField  resignFirstResponder];
  [self.passwordTxtField  resignFirstResponder];
}

- (void)processForm {
  
  NSString *tradeID = @"";
  for(int i=0; i<self.tradeArr.count; i++){
    NSDictionary *tmpDict = self.tradeArr[i];
    NSString *tName = [tmpDict objectForKey:@"name"];
    if([self.selectedTrade isEqualToString:tName]){
        if (![WSUtility isLoginWithTurkey]){
            tradeID = [tmpDict objectForKey:@"id"];
        }
        else{
            tradeID = [tmpDict objectForKey:@"code"];
        }
      break;
    }
  }
  _newsLettercheckboxFlag = self.btnCheckMark3.selected == true ? 1 : 0;
  NSString *newsLetterOptInVal = self.btnCheckMark3.selected == true ? @"true" : @"false"; //_newsLettercheckboxFlag == 0 ? @"false" : @"true" ;
  
  NSString *currentDate = [WSUtility fetchurrentWithFormat];
  NSString *strConfirmedOptIn = @"false";
  NSString *strCountryCode = [WSUtility getCountryCode];
  NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
  
  NSString *confirmURLStr = [NSString stringWithFormat:[self getConfirmURL],strCountryCode.lowercaseString];
  NSString *newsLetterConfirmURL = _newsLettercheckboxFlag == 0 ? @"" : [NSString stringWithFormat:[self getNewsLetterConfirmURL],strCountryCode.lowercaseString] ;
  
  if ([strCountryCode isEqualToString:@"TR"]){
    strConfirmedOptIn = @"true";
    confirmURLStr = @"";
    newsLetterConfirmURL = @"";
    
    
  } else if ([strCountryCode isEqualToString:@"CH"]) {
    if ([[WSUtility getLanguageCode] isEqualToString:@"de"]) {
      confirmURLStr =  [confirmURLStr stringByReplacingOccurrencesOfString:@"profil-erstellen/registration-completion.html" withString:CONFIRM_URL_ACCOUNT_CH_DE];
      newsLetterConfirmURL = [newsLetterConfirmURL stringByReplacingOccurrencesOfString:@"newsletter-abonnieren/newsletter-abonnieren-completion.html" withString:NEWSLETTER_CONFIRM_URL_ACCOUNT_CH_DE];
    } else if ([[WSUtility getLanguageCode] isEqualToString:@"fr"]) {
      confirmURLStr =  [confirmURLStr stringByReplacingOccurrencesOfString:@"profil-erstellen/registration-completion.html" withString:CONFIRM_URL_ACCOUNT_CH_FR];
      newsLetterConfirmURL = [newsLetterConfirmURL stringByReplacingOccurrencesOfString:@"newsletter-abonnieren/newsletter-abonnieren-completion.html" withString:NEWSLETTER_CONFIRM_URL_ACCOUNT_CH_FR];
    }
  }
  
  
  params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            [[NSUserDefaults standardUserDefaults] valueForKey:@"Site"],@"site",
            [WSUtility getLanguageCode],@"languageCode",
            [WSUtility getCountryCode],@"countryCode",
            self.passwordTxtField.text,@"password",
            self.passwordTxtField.text,@"confirmPassword",
            @"mr",@"titleCode",
            self.emailTxtField.text,@"uid",
            self.firstNameTxtField.text,@"firstName",
            self.lastNameTxtField.text, @"lastName",
            self.selectedBusiness,@"typeOfBusiness",
            confirmURLStr,@"confirmUrl",
            tradeID,@"tradePartnerID",
            strConfirmedOptIn,@"confirmedOptIn",
            newsLetterConfirmURL,@"newsletterConfirmUrl",
            newsLetterOptInVal,@"newsletterOptIn",
            currentDate,@"confirmedOptInDate",
            @"false",@"accountOptIn",
            currentDate,@"optInDate",
            nil];
  
  if ([strCountryCode isEqualToString:@"TR"]){
    
    NSMutableDictionary *vendorDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *cityDict = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dict in self.tradeArr){
      NSArray *array  = [dict objectForKey:@"vendorAddress"];
      if (array.count >0){
        NSMutableArray *tmpArray = [[array valueForKeyPath:@"town"] valueForKeyPath:@"uppercaseString"];
        if ([tmpArray containsObject:self.selectedCity] && [tradeID isEqualToString:[dict objectForKey:@"code"]]){
          NSInteger index = [tmpArray indexOfObject:self.selectedCity];
          cityDict = [array objectAtIndex:index];
          NSString *code = (NSString *)[dict objectForKey:@"code"];
          [vendorDict setObject:code forKey:@"code"];
          break;
        }
      }
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableDictionary *LocationTmpDict = [[NSMutableDictionary alloc] init];
    [LocationTmpDict setObject:[cityDict objectForKey:@"locationId"] forKey:@"locationId"];
    [LocationTmpDict setObject:[cityDict objectForKey:@"town"] forKey:@"city"];
    [LocationTmpDict setObject:[cityDict objectForKey:@"locationName"] forKey:@"locationName"];
    [array addObject:LocationTmpDict];
    [vendorDict setObject:array forKey:@"vendorAddress"];
    [params setObject:vendorDict forKey:@"vendor"];
    [params setObject:self.business_ID forKey:@"businessCode"];
    [params setObject:self.emailTxtField.text forKey:@"email"];
    [params setObject:@"true" forKey:@"confirmedNewsletterOptIn"];
    
  }
  else{
    //[params setObject:self.business_ID forKey:@"businessCode"];
      [params setObject:self.businessTypeTxtField.text forKey:@"businessCode"];
  }
  
  self.accountOptInConfirmationLink = confirmURLStr ;
  [self registerUserWithParams:params];
  
}

- (void)registerUserWithParams:(NSDictionary *)params {
  
  [self registerUser:(NSDictionary *)params];
  
}

- (void)getTrustedClientStatus {
  
  WSWebServiceBusinessLayer *serviceBussinessLayer = [[WSWebServiceBusinessLayer alloc] init];
  [serviceBussinessLayer makeGuestTrustedClientAndExecuteWithSuccessResponse:^(id response) {
    //[UFSProgressView stopWaitingDialog];
    // self.hybToken = [response objectForKey:@"access_token"];
    NSString *hybrisToken = [response objectForKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] setValue:hybrisToken forKey:@"HYBRIS_TOKEN_KEY"];
  } faliureResponse:^(NSString * errorMessage) {
    //[UFSProgressView stopWaitingDialog];
    NSLog(@"%@", errorMessage);
  }];
}


#pragma mark Post Data
- (void)registerUser:(NSDictionary *)params{
  
  [self.signUpParam setDictionary: params];
  [UFSProgressView showWaitingDialog:@""];
  
  WSWebServiceBusinessLayer *businesslayer = [[WSWebServiceBusinessLayer alloc] init];
  [businesslayer makeSignUpRequestWithParameter:(params) successResponse:^(NSDictionary *response) {
    
  //  NSDictionary *successDict = response[""]
    
    if ([response[@"StatusCode"] intValue] == 201){
        //"LAST_AUTHENTICATED_USER_KEY"
      [[NSUserDefaults standardUserDefaults] setObject:self.firstNameTxtField.text forKey:@"FirstName"];
      [[NSUserDefaults standardUserDefaults] setObject:self.lastNameTxtField.text forKey:@"LastName"];
      [[NSUserDefaults standardUserDefaults] setObject:self.emailTxtField.text forKey:@"UserEmailId"];
      [[NSUserDefaults standardUserDefaults] setObject:self.emailTxtField.text forKey:@"LAST_AUTHENTICATED_USER_KEY"];
      [[NSUserDefaults standardUserDefaults] setObject:self.passwordTxtField.text forKey:@"USER_PASSWORD_KEY"];
      [[NSUserDefaults standardUserDefaults] setObject:[self.signUpParam objectForKey:@"tradePartnerID"] forKey:@"TradePartnerID"];
      [[NSUserDefaults standardUserDefaults] setObject:self.selectedTrade forKey:@"tradePartnerName"];
      [[NSUserDefaults standardUserDefaults] synchronize];
      
      [self addUserToAdmin];
      NSString *strCountryCode = [WSUtility getCountryCode];
      if ([strCountryCode isEqualToString:@"TR"]){
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"USER_LOGGEDIN_KEY"];
           [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self addVendorToUser:self.signUpParam];
            [AdjustTracking EventTrackingWithToken:@"u1e93o"];
      }
      
      [FBSDKAppEvents logEvent:FBSDKAppEventNameCompletedRegistration];
    }else{
      [UFSProgressView stopWaitingDialog];
      NSDictionary *dictResponse = response[@"MessageType"];
      NSDictionary *dictError = dictResponse[@"error"];
      if ([dictError[@"errorCode"] intValue] == 409){
        [WSUtility showAlertWithMessage:[WSUtility getlocalizedStringWithKey:@"Email already registered" lang:[WSUtility getLanguageCode] table:@"Localizable"] title:@"" forController:self];
      }else{
        [WSUtility showAlertWithMessage:@"Error in SignUp" title:@"" forController:self];
      }
      
      /*
      NSDictionary *dictError = response[@"MessageType"];
      NSArray *errArr = [dictError objectForKey:@"errors"];
      NSDictionary *errDict = errArr[0];
      NSString *msg = [errDict objectForKey:@"message"];
      NSString *type = [errDict objectForKey:@"type"];
      if([type isEqualToString:@"DuplicateUidError"])
      {
        
        [WSUtility showAlertWithMessage:[WSUtility getlocalizedStringWithKey:@"Email already registered" lang:[WSUtility getLanguageCode] table:@"Localizable"] title:@"" forController:self];
        
      }
      else if ([type isEqualToString:@"Error"]){
        if ([msg containsString:@"Trade partner"]){
          [WSUtility showAlertWithMessage:[WSUtility getlocalizedStringWithKey:@"Trade partner is not available" lang:[WSUtility getLanguageCode] table:@"Localizable"] title:@"" forController:self];
        }
        else{
          if (msg != nil){
            [WSUtility showAlertWithMessage:msg title:type forController:self];
          }
        }
      }
      else{
        if (msg != nil){
          [WSUtility showAlertWithMessage:msg title:type forController:self];
        }
      }
      
      */
    }
    
    
  } faliureResponse:^(NSString * errorMessage) {
    [UFSProgressView stopWaitingDialog];
  }];
  
  
}

-(void)addVendorToUser:(NSDictionary *)requestDict{
    NSDictionary *dict = [self.signUpParam objectForKey:@"vendor"];
    NSArray *array = [dict objectForKey:@"vendorAddress"];
    NSString *locID = @"";
    if ([array count] >0){
        locID = [[array objectAtIndex:0] objectForKey:@"locationId"];
    }
    NSDictionary *dictParameter = [NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"code"], @"parentTpId", locID, @"tplocationID",@"",@"accountNumber",@"true",@"makeDefalut",[requestDict objectForKey:@"email"],@"email", nil];
    
    WSWebServiceBusinessLayer *businesslayer = [[WSWebServiceBusinessLayer alloc] init];
    [businesslayer addVendorToUserWithParams:(dictParameter) successResponse:^(NSDictionary *response) {
        
    } failureResponse:^(NSString * errorMessage) {
        
    }];
}

-(void) getSifuAccessTokenForTurkey  {
  [UFSProgressView showWaitingDialog:@""];
  WSWebServiceBusinessLayer *businesslayer = [[WSWebServiceBusinessLayer alloc] init];
  
  NSDictionary *dictParameter = [NSDictionary dictionaryWithObjectsAndKeys:self.emailTxtField.text, @"EmailId", self.passwordTxtField.text, @"Password", nil];
  [businesslayer makeLoginRequestWithParameter:dictParameter methodName:@"auth/authenticate" successResponse:^(id response) {
    [[NSUserDefaults standardUserDefaults] setObject:self.emailTxtField.text forKey:@"LAST_AUTHENTICATED_USER_KEY"];
   [UFSProgressView stopWaitingDialog];
    [self getPendingLoyaltyPointsForTurkey];
    
  } faliureResponse:^(NSString * errorMessage) {
    [UFSProgressView stopWaitingDialog];
    [self moveToTutorialorHomeScreen];
  }];
}

//-(void) createUserForEcom:(NSString *)userID{
//    BOOL firstTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"callFirstTime"];
//
//    if (firstTime) {
//        WSWebServiceBusinessLayer *businesslayer = [[WSWebServiceBusinessLayer alloc] init];
//        [businesslayer CreateEcomProfileWithUserID:<#(NSString * _Nonnull)#> successResponse:^(id response) {
//            [[NSUserDefaults standardUserDefaults] setObject:YES forKey:@"callFirstTime"];
//            [UFSProgressView stopWaitingDialog];
//
//        } faliureResponse:^(NSString * errorMessage) {
//            [UFSProgressView stopWaitingDialog];
//        }];
//    }
//}

-(void) getPendingLoyaltyPointsForTurkey {
  WSWebServiceBusinessLayer *businesslayer = [[WSWebServiceBusinessLayer alloc] init];
  [businesslayer getPendingLoyaltyPointsRequestWithSuccessResponse:^(id response) {
    NSDictionary *loyaltyPointsDic = response[@"country_loyalty_points"];
    NSNumber *num = loyaltyPointsDic[@"points"];
    //        NSUInteger loyaltyPoints = num.integerValue;
    [self addLoyaltyPointsForTurkey:num];
  } faliureResponse:^(NSString * errorMessage) {
    [UFSProgressView stopWaitingDialog];
    [self moveToTutorialorHomeScreen];
  }];
}

-(void) addLoyaltyPointsForTurkey:(NSNumber*)Points {
  
  NSDictionary *loyaltyDict = [NSDictionary dictionaryWithObjectsAndKeys:Points, @"points", @"Initiated", @"description", nil];
  
  WSWebServiceBusinessLayer *businesslayer = [[WSWebServiceBusinessLayer alloc] init];
  [businesslayer addLoyaltyPointsRequestWithParameter:loyaltyDict successResponse:^(id response) {
    [self moveToTutorialorHomeScreen];
    [UFSProgressView stopWaitingDialog];
  } faliureResponse:^(NSString * errorMessage) {
    [UFSProgressView stopWaitingDialog];
    [self moveToTutorialorHomeScreen];
  }];
}

-(void)moveToTutorialorHomeScreen{
    HYBAppDelegate *delegate = [self getDelegate];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstInstallation"]) {
        [delegate openTutorial];
    }
    else{
        [delegate openHomeScreen];
    }
}

- (HYBAppDelegate *)getDelegate {
  return (HYBAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)trade_request{
  
  
  [UFSProgressView showWaitingDialog:@""];
  WSWebServiceBusinessLayer *businesslayer = [[WSWebServiceBusinessLayer alloc] init];
  [businesslayer getTradePartenersListWithSuccessResponse:^(id response) {
    [UFSProgressView stopWaitingDialog];
    
      if ([self.pickerTradeData count] >0){
          [self.pickerTradeData removeAllObjects];
      }
    
    //self.tradeArr = [NSJSONSerialization JSONObjectWithData:self.dataResponse options:0 error:nil];
    self.tradeArr = response;
    for(int i=0; i<self.tradeArr.count; i++){
      NSDictionary *tmpDict = self.tradeArr[i];
      NSString *tName = [tmpDict objectForKey:@"name"];
      [self.pickerTradeData addObject:tName];
    }
    // [self.picker reloadAllComponents];
    
  } faliureResponse:^(NSString * errorMessage) {
    [UFSProgressView stopWaitingDialog];
  }];
  
}

// to get VendorList and Cities for Turkey

- (void)getVendorListAndCities{
  
  [UFSProgressView showWaitingDialog:@""];
  WSWebServiceBusinessLayer *businesslayer = [[WSWebServiceBusinessLayer alloc] init];
  [businesslayer getVendorsListWithSuccessResponse:^(id response) {
    [UFSProgressView stopWaitingDialog];

      NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
      NSArray *tmpArray = [response objectForKey:@"vendorList"];
 
      for (NSDictionary *dict in tmpArray) {
          NSArray *tmpArray = [dict objectForKey:@"vendorAddress"];
          if (tmpArray.count > 0){
              [filteredArray addObject:dict];
          }
      }
      
    self.tradeArr = filteredArray;
    NSMutableArray *cityListArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.tradeArr){
      NSArray *array  = [dict objectForKey:@"vendorAddress"];
      if (array.count >0){
        NSArray *tmpArray = [[array valueForKeyPath:@"town"] valueForKeyPath:@"uppercaseString"];
        [cityListArray addObjectsFromArray:tmpArray];
      }
    }
    [cityListArray removeObjectIdenticalTo:[NSNull null]];
    
    self.pickerCityData = (NSMutableArray *)[[cityListArray valueForKeyPath:@"@distinctUnionOfObjects.self"] sortedArrayUsingSelector:@selector(compare:)];
    
  } failureResponse:^(NSString * errorMessage) {
    [UFSProgressView stopWaitingDialog];
  }];
}

#pragma mark Connection Delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
  NSLog(@"didReceiveResponse %s##### response  %@",__FUNCTION__,response);
  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
  if ([httpResponse statusCode] == 201) {
    self.signupResStatus = @"pass";
    
  }else{
    self.signupResStatus = @"failed";
  }
  [self.dataResponse setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
  [self.dataResponse appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
  @try {
    NSLog(@"didFailWithError %s   --- %@ ",__FUNCTION__,[error description]);
    //[loadingView removeView];
    //[UFSProgressView stopWaitingDialog];
    [UFSProgressView stopWaitingDialog];
    
  }
  @catch (NSException *exception) {
    NSLog(@"didFailWithError %s   --- %@ ",__FUNCTION__,exception);
    //[loadingView removeView];
    //[HYBActivityIndicator hide];
    [UFSProgressView stopWaitingDialog];
  }
  @finally {
  }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  
  NSLog(@"connectionDidFinishLoading %@",[[NSString alloc]initWithData:self.dataResponse encoding:4]);
  [UFSProgressView stopWaitingDialog];
  if([self.apiType isEqualToString:@"Register"]) {
    [[NSUserDefaults standardUserDefaults] setObject:self.firstNameTxtField.text forKey:@"FirstName"];
    [[NSUserDefaults standardUserDefaults] setObject:self.lastNameTxtField.text forKey:@"LastName"];
    [[NSUserDefaults standardUserDefaults] setObject:self.emailTxtField.text forKey:@"UserEmailId"];
    [[NSUserDefaults standardUserDefaults] setObject:[self.signUpParam objectForKey:@"tradePartnerID"] forKey:@"TradePartnerID"];
    [[NSUserDefaults standardUserDefaults] setObject:self.selectedTrade forKey:@"tradePartnerName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //WSWebServiceBusinessLayer *serviceBussinessLayer = [[WSWebServiceBusinessLayer alloc] init];
    //[serviceBussinessLayer trackingScreensWithScreenName:@"Product Scan Screen"];
    
    if([self.signupResStatus isEqualToString:@"pass"]){
      [UFSProgressView stopWaitingDialog];
      [self addUserToAdmin];
      [self performSegueWithIdentifier:@"EmailVerificationSegue" sender:self];
      [FBSDKAppEvents logEvent:FBSDKAppEventNameCompletedRegistration];
      
    }else{
      [UFSProgressView stopWaitingDialog];
      
      NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:self.dataResponse options:0 error:nil];
      NSArray *errArr = [dict objectForKey:@"errors"];
      NSDictionary *errDict = errArr[0];
      NSString *msg = [errDict objectForKey:@"message"];
      NSString *type = [errDict objectForKey:@"type"];
      if([type isEqualToString:@"DuplicateUidError"])
      {
        
        [WSUtility showAlertWithMessage:[WSUtility getlocalizedStringWithKey:@"Email already registered" lang:[WSUtility getLanguageCode] table:@"Localizable"] title:@"" forController:self];
        
      }
      else if ([type isEqualToString:@"Error"]){
        if ([msg containsString:@"Trade partner"]){
          [WSUtility showAlertWithMessage:[WSUtility getlocalizedStringWithKey:@"Trade partner is not available" lang:[WSUtility getLanguageCode] table:@"Localizable"] title:@"" forController:self];
        }
        else{
          [WSUtility showAlertWithMessage:msg title:type forController:self];
        }
      }
      else{
        [WSUtility showAlertWithMessage:msg title:type forController:self];
      }
      
    }
  }
}



- (BOOL)validateEmailWithString:(NSString*)checkString
{
  BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
  NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
  NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
  NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  return [emailTest evaluateWithObject:checkString];
}

-(BOOL)isValidPassword:(NSString *)passwordString
{
  
  //NSString *regex = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#^()+-._])[A-Za-zäöüÄÖÜß\\d$@$!%*?&#^()+-._]{8,}";
  
  //list of reguar expression taken from Wiki
  // NSString *regex = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!#$%&'()*+,-./:;<=>?@^_`{|}~])[A-Za-zäöüÄÖÜß\\d!#$%&'()*+,-./:;<=>?@^_`{|}~]{8,}";
  
  //list of reguar expression supported by Hybris
  NSString *regex = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[#%!$@^*()_.])[A-Za-z\\d#%!$@^*()_.]{8,}";
  
  
  NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
  
  BOOL isValid = [passwordTest evaluateWithObject:passwordString];
  
  return isValid;
}


-(void)addUserToAdmin{
  NSString *age_verification = self.btnCheckMark1.selected == true ? @"1" : @"0";
  NSString *news_letter_opt_in = self.btnCheckMark3.selected == true ? @"1" : @"0";
  NSString *promotion_opt_in = self.btnCheckMark4.selected == true ? @"1" : @"0";
  NSString *event_opt_in = self.btnCheckMark5.selected == true ? @"1" : @"0";
  
  NSString *deviceToken = [[NSUserDefaults standardUserDefaults]
                           stringForKey:@"DeviceToken"];
  NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
  [tmpDict setValue:deviceToken forKey:@"deviceToken"];
  [tmpDict setValue:self.businessTypeTxtField.text forKey:@"business_name"];
  [tmpDict setValue:self.business_ID forKey:@"businessCode"];
  [tmpDict setValue:age_verification forKey:@"age_verification"];
  [tmpDict setValue:news_letter_opt_in forKey:@"news_letter_opt_in"];
  [tmpDict setValue:promotion_opt_in forKey:@"promotion_opt_in"];
  [tmpDict setValue:event_opt_in forKey:@"event_opt_in"];
  
  WSWebServiceBusinessLayer *businesslayer = [[WSWebServiceBusinessLayer alloc] init];
  [businesslayer addUserToAdminPanelWithParams:tmpDict actionType:@"create" successResponse:^(id response) {
    [WSUtility triggerPushnotificationWithAction:@"registration_completed" email:_emailTxtField.text ];
    
    NSString *strCountryCode = [WSUtility getCountryCode];
     if ([strCountryCode isEqualToString:@"TR"]){
      [self getSifuAccessTokenForTurkey];
    }else{
      [self moveToEmailconformation];
    }
  } faliureResponse:^(NSString * errorMessage) {
    
    [self moveToEmailconformation];
  }];
}

- (void)moveToEmailconformation{
  [UFSProgressView stopWaitingDialog];
  NSString *strCountryCode = [WSUtility getCountryCode];
  if (![strCountryCode isEqualToString:@"TR"]){
    [self performSegueWithIdentifier:@"EmailVerificationSegue" sender:self];
  }
}

-(void)getBusinessTypesFromAdmin{
  
  // [HYBActivityIndicator show];
  WSWebServiceBusinessLayer *businesslayer = [[WSWebServiceBusinessLayer alloc] init];
  [businesslayer getBusinessTypesFromAdminWithSuccessResponse:^(id response) {
    
    self.pickerBusinessData = response[@"data"];
    self.businessTypeNameArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in self.pickerBusinessData) {
      [self.businessTypeNameArray addObject:[dict objectForKey:@"bt_name"]];
    }
    // [HYBActivityIndicator hide];
  } failureResponse:^(NSString * errorMessage) {
    // [HYBActivityIndicator hide];
  }];
}

-(void)getBusinessTypesFromHybris{
  
  // [HYBActivityIndicator show];
  WSWebServiceBusinessLayer *businesslayer = [[WSWebServiceBusinessLayer alloc] init];
  [businesslayer getBusinessTypesFromHybrisWithSuccessResponse:^(id response) {
    
    self.pickerBusinessData = response[@"businessList"];
    self.businessTypeNameArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in self.pickerBusinessData) {
      [self.businessTypeNameArray addObject:[dict objectForKey:@"businessName"]];
    }
    
  } faliureResponse:^(NSString * errorMessage) {
    
  }];
  
}

-(void)AttributedTextInUILabelWithGreenText:(NSString *)grayText boldText:(NSString *)boldText {
  NSString *text = [NSString stringWithFormat:@"%@ %@",
                    grayText,
                    boldText];
  
  //Check If attributed text is unsupported (below iOS6+)
  if (![self.passwordErrorLbl respondsToSelector:@selector(setAttributedText:)]) {
    self.passwordErrorLbl.text = text;
  }
  // If attributed text is available
  else {
    // Define general attributes like color and fonts for the entire text
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName: self.passwordErrorLbl.textColor,
                              NSFontAttributeName: self.passwordErrorLbl.font
                              };
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:text
                                           attributes:attribs];
    
    // gray text attributes
    UIColor *grayColor = [UIColor darkGrayColor];
    UIFont *grayFont = [UIFont fontWithName: @"DINPro-Regular" size: self.passwordErrorLbl.font.pointSize];
    NSRange greenTextRange = [text rangeOfString:grayText];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:grayColor,
                                    NSFontAttributeName:grayFont}
                            range:greenTextRange];
    
    UIColor *blueColor = [UIColor darkGrayColor];
    UIFont *boldFont = [UIFont fontWithName: @"DINPro-Medium" size: self.passwordErrorLbl.font.pointSize];
    NSRange blueBoldTextRange = [text rangeOfString:boldText];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:blueColor,
                                    NSFontAttributeName:boldFont}
                            range:blueBoldTextRange];
    self.passwordErrorLbl.attributedText = attributedText;
    //[self.passwordErrorLbl setFont:[UIFont fontWithName: @"Avenir" size: self.passwordErrorLbl.font.pointSize]];
    
  }
  
}

@end
