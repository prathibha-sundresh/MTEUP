//
//  HYBCartController.m
//  yB2CApp
//
//  Created by Ajay Parmar on 4/5/18.
//

#import "HYBCartController.h"
#import "UFSHYBConstants.h"
#import "UFS-Swift.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "stylesheet.h"
#import <SDWebImage/UIImageView+WebCache.h>


#define TAG_ONE_ITEM_DELETION   12239658
#define TAG_MANY_ITEMS_DELETION 12239659
//#define CART_CELL_HEIGHT 155.00


@interface HYBCartController ()
{
    NSString *strTotalPriceForPayment_Tr;
}
@property(nonatomic, strong)  NSArray      *cartItems;
@property(nonatomic, strong)  NSArray      *deletingItems;
@property(nonatomic, strong)  NSArray      *hostName;
@property(nonatomic) NSString *currentlyEditedCartItemPosition;
@property(nonatomic) NSInteger totalLoyaltyPoints;
@property(nonatomic) NSInteger promoLoyaltyPoints;
@property(nonatomic) int totalItemsQunatity;
@property(nonatomic) NSString *validPromoCode;
@property(nonatomic) NSMutableDictionary *validPromoDict;
@property(nonatomic) BOOL IsCouponCodeValidOrNot;

@property (weak, nonatomic) IBOutlet UILabel *supplierText;
@property (weak, nonatomic) IBOutlet UILabel *recommendedPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *loyalityPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *myCart;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *totalItems;
@property (weak, nonatomic) IBOutlet UILabel *rewardPoints;
@property(nonatomic) IBOutlet UITableView    *itemsTable;
@property (weak, nonatomic) IBOutlet UILabel *awayFromGiftLbl;
@property (weak, nonatomic) IBOutlet UILabel *giftName;
@property (weak, nonatomic) IBOutlet UIImageView *giftImage;
@property (weak, nonatomic) IBOutlet UIView *giftView;
@property (weak, nonatomic) IBOutlet WSDesignableButton *orderNowButton;
@property (weak, nonatomic) IBOutlet UIView *emptyCartContianerView;
@property (weak, nonatomic) IBOutlet UIView *PriceContianerView;
@property (weak, nonatomic) IBOutlet UITextField *promoCodeTF;
@property (weak, nonatomic) IBOutlet UILabel *promoCodeErrorTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitPromoCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *addOrChangePromoCodeButton;
@property (weak, nonatomic) IBOutlet UILabel *promoCodeRewardsTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoCodeRewardsPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoCodeNameTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoCodeLoyaltyPointsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promoCodeViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *emptyCartMessageLabel;
@property (weak, nonatomic) IBOutlet WSDesignableButton *startShoppingBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeaderViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *DTOtopHeaderViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *DTOTopView;
@property (weak, nonatomic) IBOutlet UILabel *DTOMinimumOrderTextLabel;

@property(nonatomic) int activeTFTag;
@end

@implementation HYBCartController{
    NSString *totalCartPrice;
    
    BOOL adjustKeyboard;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.IsCouponCodeValidOrNot = false;
    
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
    
    [self UISetUpForPromoTextFieldWithImage:self.promoCodeTF and:false and:false];
    
    [self.promoCodeTF setLeftPaddingPoints:15];
    [self showHidePromoLabels:TRUE];
    WSWebServiceBusinessLayer *serviceBussinessLayer = [[WSWebServiceBusinessLayer alloc] init];
    [serviceBussinessLayer trackingScreensWithScreenName:@"My Cart Screen"];
    [UFSGATracker trackScreenViewsWithScreenName:@"My Cart Screen"];
    [FireBaseTracker ScreenNamingWithScreenName:@"My Cart Screen" ScreenClass:NSStringFromClass(self.class)];
    [FBSDKAppEvents logEvent:@"My Cart Screen"];
    
    [self.view.subviews setValue:@YES forKeyPath:@"hidden"];
    
    self.itemsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    totalCartPrice = 0;
    self.totalLoyaltyPoints = 0;
    
    [self applyDefaultStyle];
    [WSUtility addNavigationBarBackButtonWithController:self];
    [WSUtility addNavigationRightBarButtonToViewController:self];
    
    self.itemsTable.estimatedRowHeight = 120.0;
    self.itemsTable.rowHeight = UITableViewAutomaticDimension;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

-(void) applicationWillEnterForeground{
    [self refreshCartFromServer];
}

-(void) setUI{
    _myCart.text = [WSUtility getlocalizedStringWithKey:@"My Cart" lang:[WSUtility getLanguage] table:@"Localizable"];
    _supplierText.text = NSLocalizedString(@"", nil);
    _supplierText.text = [WSUtility getlocalizedStringWithKey:@"Your supplier determines your delivery and payment conditions." lang:[WSUtility getLanguage] table:@"Localizable"];
  
  
  if ([WSUtility isFeatureEnabledWithFeature:@"12"]){
    _recommendedPriceLabel.hidden = true;
  }else{
    _recommendedPriceLabel.text =[WSUtility getlocalizedStringWithKey:@"Recommended price (excl. VAT)" lang:[WSUtility getLanguage] table:@"Localizable"];
    _recommendedPriceLabel.hidden = false;
  }
  
   
  
  
    _rewardPoints.text = [WSUtility getlocalizedStringWithKey:@"Reward Points" lang:[WSUtility getLanguage] table:@"Localizable"];
    [_orderNowButton setTitle:[WSUtility getlocalizedStringWithKey:@"Order now" lang:[WSUtility getLanguage] table:@"Localizable"] forState:UIControlStateNormal];
    _emptyCartMessageLabel.text = [WSUtility getTranslatedStringForString:@"An empty cart breaks my heart"];
    NSString *startText = [WSUtility getTranslatedStringForString:@"Start shopping"];
    [_startShoppingBtn setTitle:startText forState:UIControlStateNormal];
    self.promoCodeErrorTextLabel.text = [WSUtility getTranslatedStringForString:@"Invalid code. Please try again."];
    [self.addOrChangePromoCodeButton setTitle:[WSUtility getTranslatedStringForString:@"Add promotion code"] forState:UIControlStateNormal];
    self.promoCodeRewardsTextLabel.text = [WSUtility getTranslatedStringForString:@"Reward Points"];
    
}

- (void)rightBarButtonPressed:(UIButton*)sender {
    
}

- (void)applyDefaultStyle{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      @"Environments" ofType:@"plist"];
    // Build the array from the plist
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSDictionary *hostDict = [dict valueForKey:@"Release"];
    self.hostName = [hostDict valueForKey:@"BASE_URL_KEY"];
    
}

- (void)hideAndShowFirstIncentiveView{
    self.addOrChangePromoCodeButton.hidden = false;
    self.promoCodeViewHeightConstraint.constant = 200;
    
    // For DTO
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"directOperator"] || ([WSUtility isLoginWithTurkey] && [[NSUserDefaults standardUserDefaults] boolForKey:@"isMOQRequired"])){
        self.DTOtopHeaderViewHeightConstraint.constant = 55;
        self.DTOTopView.hidden = NO;
    }
    else{
        self.DTOtopHeaderViewHeightConstraint.constant = 0;
        self.DTOTopView.hidden = YES;
    }
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"IsUserHasPlacedFirstOrder"] || [WSUtility isUserPlacedFirstOrder] == true) {
        self.giftView.hidden = true;
        self.topHeaderViewHeightConstraint.constant = 0;
    } else {
        if (![WSUtility isFeatureEnabledWithFeature:@"1"]) {
            self.giftView.hidden = true;
            self.topHeaderViewHeightConstraint.constant = 0;
        } else {
            self.giftView.hidden = false;
            [self getGiftCoupon];
            [self getAppliedPromoCodeIfOrderNotPlaced];
        }
    }
    
}

-(void)backButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 90, 35);
    UIImage *backBtnImage = [UIImage imageNamed:@"signup_back"]  ;
    [backBtn setImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0);
    [backBtn setTitle:[WSUtility getlocalizedStringWithKey:@"Back" lang:[WSUtility getLanguage] table:@"Localizable"] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor colorWithRed:1.00 green:0.35 blue:0.01 alpha:1.0] forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:[UIFont fontWithName:@"DINPro-Regular" size:12]];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)backAction:(UIButton*)sender {
    [self.view endEditing:true];
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark vc life
- (void)viewDidAppear:(BOOL)animated {
    
    if (![WSUtility isTaxNumberAvailableWithVCview:self.view]){
        [WSUtility addTaxNumberViewWithViewController:self];
    }else if ([self.view viewWithTag:9006] != nil ){
      UIView *taxView = [self.view viewWithTag:9006] ;
      [taxView removeFromSuperview];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isFromSummary"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userDeliveryDetails"];
    
    [super viewDidAppear:animated];
    [self refreshCartFromServer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [WSUtility setCartBadgeCountWithViewController:self];
    [self backButton];
    [self setUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)btnTaxTappedWithSender:(UIButton *)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"EnterTaxNumberStoryboard" bundle:nil];
    WSEnterTaxNumberViewController * vc = [storyBoard instantiateViewControllerWithIdentifier:@"WSEnterTaxNumberViewController"];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.callBack = ^{
        WSTaxNumberFooterView *taxNumberFooterView =  (WSTaxNumberFooterView *)[self.view viewWithTag:9006];
        if ([self.view.subviews containsObject: taxNumberFooterView]){
            [taxNumberFooterView removeFromSuperview];
        }
    };
    [self presentViewController:vc animated:false completion:nil];
}

#pragma mark batch deletion loop
- (void)checkForBatchDeleteEnd {
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.deletingItems];
    [tempArray removeLastObject];
    if([tempArray count] > 0) {
        //continue delete loop
        [self setDeletingItems:[NSArray arrayWithArray:tempArray]];
        //[self deleteNextItem];
    } else {
        //no more item to delete, end loop
        [self setDeletingItems:[NSArray array]];
        [self batchDeleteDidEnd];
    }
}

- (void)batchDeleteDidEnd {
    //[HYBActivityIndicator hide];
    
    //[self showNotifyMessage:NSLocalizedString(@"cart_item_removal_items_removed", @"Items Removed!")];
    [self refreshCartFromServer];
    
    self.isBatchDeleting = NO;
}

- (void)getGiftCoupon{
    WSWebServiceBusinessLayer *businesslayer = [[WSWebServiceBusinessLayer alloc] init];
    [businesslayer getCartCouponWithSuccessResponse:^(id response) {
        NSLog(@"%@", response);
     
        NSDictionary *dataDict = [response objectForKey:@"data"];
        if ([[response objectForKey:@"data"] count] != 0 ) {
            [[NSUserDefaults standardUserDefaults] setObject:dataDict forKey:@"First_Order_Incentive_Data"];
            [[NSUserDefaults standardUserDefaults] setValue:[dataDict objectForKey:@"minimum_order_amount"] forKey:@"First_Order_Incentive_amount"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *imageURL = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"image_url"]];
            [self.giftImage sd_setImageWithURL:[NSURL URLWithString:imageURL]
                              placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageAllowInvalidSSLCertificates];
            
            
            self.giftName.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"product_name"]];
        }
        
    } faliureResponse:^(NSString * errorMessage) {
        [UFSProgressView stopWaitingDialog];
    }];
}

-(void)revalidatePromoCode:(NSString *)promoCodeStr{
    [UFSProgressView showWaitingDialog:@""];
    WSWebServiceBusinessLayer *serviceBussinessLayer = [[WSWebServiceBusinessLayer alloc] init];
    [serviceBussinessLayer validatePromoCodeRequestWithPromoCode:promoCodeStr successResponse:^(id response) {
        [UFSProgressView stopWaitingDialog];
        BOOL responseSuccuess = [response objectForKey:@"error"];
        NSString *responseCodeStr = [NSString stringWithFormat:@"%@",[response objectForKey:@"http_status"]];
        
        if (responseSuccuess && [responseCodeStr isEqualToString:@"200"]){
            [self proceedToPlaceOrder];
        }
        else{
            [self showHidePromoLabels:true];
            self.validPromoCode = @"";
            
            self.validPromoDict = nil;
            NSString *myString = [NSString stringWithFormat:@"%ld %@",(long)self.totalLoyaltyPoints,[WSUtility getlocalizedStringWithKey:@"Loyalty Points" lang:[WSUtility getLanguage] table:@"Localizable"]];
            self.promoLoyaltyPoints =  0;
            [self makeAttribute:myString and:[NSString stringWithFormat:@"%ld",(long)self.totalLoyaltyPoints] and:self.loyalityPointsLabel];
            self.IsCouponCodeValidOrNot = false;
            //[WSUtility UISetUpForTextFieldWithImageWithTextField:self.promoCodeTF boolValue:true];
            [self UISetUpForPromoTextFieldWithImage:self.promoCodeTF and:true and:false];
            self.promoCodeTF.hidden = self.IsCouponCodeValidOrNot;
            self.submitPromoCodeButton.hidden = self.IsCouponCodeValidOrNot;
            self.promoCodeErrorTextLabel.hidden = self.IsCouponCodeValidOrNot;
            self.promoCodeViewHeightConstraint.constant = 200;
            
        }
        
    } faliureResponse:^(NSString * errorMessage) {
        [UFSProgressView stopWaitingDialog];
    }];
}

- (IBAction)ordrrNowClicked:(id)sender {
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"IsUserHasPlacedFirstOrder"] || ![WSUtility isUserPlacedFirstOrder]) {
        if ([self.validPromoCode isEqualToString:@""] || self.validPromoCode == nil){
            [self proceedToPlaceOrder];
        }
        else{
            [self revalidatePromoCode:self.validPromoCode];
        }
    }
    else{
        [self proceedToPlaceOrder];
    }
}

-(void)proceedToPlaceOrder{
    
    [self textDidChange:self.promoCodeTF];
    self.promoCodeTF.text = self.validPromoCode;
    //FB Analytics
    [FBSDKAppEvents logEvent:FBSDKAppEventNameInitiatedCheckout];
    [FBSDKAppEvents logPurchase:[totalCartPrice doubleValue] currency:@"£"];
    
    NSMutableDictionary *tempTableDict = [[NSMutableDictionary alloc] init];
    NSMutableArray *cartArr = [[NSMutableArray alloc] init];
    for(int i = 0; i<_cartItems.count; i++){
        tempTableDict = [_cartItems objectAtIndex:i];
        NSMutableDictionary *tempProdDict = [tempTableDict objectForKey:@"product"];
        if ([tempProdDict objectForKey:@"name"] != nil) {
            cartArr[i] = [tempProdDict objectForKey:@"name"];
        }
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Checkout" bundle:nil];
    MyDetailViewController      *_myDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"CheckoutFOne"];
    _myDetailViewController.cartArr = cartArr;
    _myDetailViewController.totalPrice = self.totalPrice.text;
    
    _myDetailViewController.earnedLoyaltyPoints = [NSString stringWithFormat:@"%ld",(long)(self.totalLoyaltyPoints + self.promoLoyaltyPoints)];
    _myDetailViewController.promoCode = self.validPromoCode;
    _myDetailViewController.validPromoDict = self.validPromoDict;
    _myDetailViewController.totalItemsQunatity = self.totalItemsQunatity;
    _myDetailViewController.totalPriceForPayment_TR = strTotalPriceForPayment_Tr;
    
    [self.navigationController pushViewController:_myDetailViewController animated:YES];
}

- (void)refreshCartFromServer {
    [UFSProgressView showWaitingDialog:@""];
  
    WSWebServiceBusinessLayer *serviceBussinessLayer = [[WSWebServiceBusinessLayer alloc] init];
    [serviceBussinessLayer getCartsForUserIdWithUserId:@"" params:@{@"":@""} successResponse:^(id response) {
        [UFSProgressView stopWaitingDialog];
        [self loadCurrentCart:response];
       [UFSProgressView stopWaitingDialog];
    } faliureResponse:^(NSString * errorMessage) {
        [UFSProgressView stopWaitingDialog];
        NSLog(@"%@",errorMessage);
    }];
}

- (void)loadCurrentCart:(NSDictionary*)cartDict {
    
    [WSUtility setCartBadgeCountWithViewController:self];
    
    [self.view.subviews setValue:@NO forKeyPath:@"hidden"];
    [self hideAndShowFirstIncentiveView];
    
    if (cartDict) {
        _cartItems = [cartDict objectForKey:@"entries"];
        [self.itemsTable reloadData];
        if ([_cartItems count] <= 0) {
            NSDictionary *errorDict = [cartDict objectForKey:@"error"];
            if ([[errorDict objectForKey:@"errorCode"] intValue] == 404){
                [self.view.subviews setValue:@YES forKeyPath:@"hidden"];
                [self getSifuAccessToken];
            }
            else{
                self.emptyCartContianerView.hidden = NO;
                self.PriceContianerView.hidden = YES;
            }
            
        } else {
            
            self.totalItemsQunatity = [[cartDict objectForKey:@"totalUnitCount"] intValue];
            self.emptyCartContianerView.hidden = YES;
            self.PriceContianerView.hidden = NO;
            
            NSString * cartString;
            cartString =  [WSUtility getlocalizedStringWithKey:@"My Cart" lang:[WSUtility getLanguage] table:@"Localizable"];
            NSDictionary *tempTotalPrice = [cartDict objectForKey:@"totalPrice"];
            self.myCart.text = [NSString stringWithFormat:[WSUtility getlocalizedStringWithKey:@"My Cart[value]" lang:[WSUtility getLanguage] table:@"Localizable"],[cartDict objectForKey:@"totalUnitCount"]];
            self.totalItems.text = [NSString stringWithFormat:[WSUtility getlocalizedStringWithKey:@"Total items [value]" lang:[WSUtility getLanguage] table:@"Localizable"],[cartDict objectForKey:@"totalUnitCount"]];
            //float priceFloat = [[tempTotalPrice objectForKey:@"value"] floatValue];
    
            
//            NSString *str = [[NSString stringWithFormat:@"%@",[tempTotalPrice objectForKey:@"formattedValue"]] stringByReplacingOccurrencesOfString:@"," withString:@""];
//            self.totalPrice.text = [str stringByReplacingOccurrencesOfString:@"." withString:@","];
            
            NSString *strPrice = @"";
           // NSString *str = [WSUtility getCountryCode];
           strPrice = [tempTotalPrice objectForKey:@"formattedValue"];
          /*
            if ([str isEqualToString:@"CH"]){
                double value = [[tempTotalPrice objectForKey:@"value"]doubleValue];
                strPrice = [NSString stringWithFormat:@"CHF %.02f", value];
            }
            else{
               // strPrice = [[tempTotalPrice objectForKey:@"formattedValue"] stringByReplacingOccurrencesOfString:@"." withString:@""] ;
               strPrice = [tempTotalPrice objectForKey:@"formattedValue"];
            }
           */
          
            double value = [[tempTotalPrice objectForKey:@"value"]doubleValue];
            strTotalPriceForPayment_Tr = [NSString stringWithFormat:@"%.02f", value];
          self.totalPrice.text = strPrice; //[strPrice stringByReplacingOccurrencesOfString:@"." withString:@","];

//            totalCartPrice = [[tempTotalPrice objectForKey:@"formattedValue"] stringByReplacingOccurrencesOfString:@"." withString:@","];//[item.quantity stringValue]
            totalCartPrice = [tempTotalPrice objectForKey:@"formattedValue"];
            
            
            self.totalLoyaltyPoints = 0;
            if ([WSUtility isLoginWithTurkey]){
                self.totalLoyaltyPoints = [[cartDict objectForKey:@"totalLoyaltyPointsForOrder"] intValue];
            }
            else{
                for(int i = 0; i<_cartItems.count; i++){
                    NSDictionary *productsDict = _cartItems[i];
                    NSDictionary *products = [productsDict objectForKey:@"product"];
                    NSArray *baseOptionsArr = [products objectForKey:@"baseOptions"];
                    NSDictionary *baseOptionsDict = baseOptionsArr[0];
                    NSDictionary *selectedDict = [baseOptionsDict objectForKey:@"selected"];
                    NSString *loyalty = [selectedDict objectForKey:@"loyalty"];
                    //self.totalLoyaltyPoints = self.totalLoyaltyPoints + (int)[loyalty integerValue];
                    int loyaltyPointOfCurrentProduct = ((int)[productsDict[@"quantity"] integerValue] * (int)[loyalty integerValue]);
                    self.totalLoyaltyPoints = loyaltyPointOfCurrentProduct + self.totalLoyaltyPoints;
                    
                    
                }
            }
            
            NSString *myString = [NSString stringWithFormat:@"%ld %@",(long)self.totalLoyaltyPoints,[WSUtility getlocalizedStringWithKey:@"Loyalty Points" lang:[WSUtility getLanguage] table:@"Localizable"]];
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
            NSRange range = [myString rangeOfString:[NSString stringWithFormat:@"%ld",(long)self.totalLoyaltyPoints]];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:252.0/255.0 green:91.0/255.0 blue:31.0/255.0 alpha:1] range:range];
            self.loyalityPointsLabel.attributedText = attString;
            
            float tmpMinValue = ([[NSUserDefaults standardUserDefaults] boolForKey:@"directOperator"] || ([WSUtility isLoginWithTurkey] && [[NSUserDefaults standardUserDefaults] boolForKey:@"isMOQRequired"]))? [[[NSUserDefaults standardUserDefaults] valueForKey:@"minOrderValue"] floatValue]: [[[NSUserDefaults standardUserDefaults] valueForKey:@"First_Order_Incentive_amount"] floatValue];
            
            NSString *cartItemPrice = [tempTotalPrice objectForKey:@"value"];
            if(cartItemPrice.floatValue< tmpMinValue){
                self.giftView.backgroundColor = [UIColor colorWithRed:238/255.0f green:250/255.0f blue:255/255.0f alpha:1.0f];
                
                float priceRemaining = (tmpMinValue - (cartItemPrice.floatValue));
                NSString *strRemianingPrice = [NSString stringWithFormat:@"%0.2f",priceRemaining];
                
                NSDictionary *firstOrderIncentiveDict = [[NSUserDefaults standardUserDefaults] valueForKey:@"First_Order_Incentive_Data"];
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"First_Order_Incentive_Data"] count] != 0) {
                    NSString *str = [firstOrderIncentiveDict objectForKey:@"product_name"];
                    NSRange range1;
                    if ([[WSUtility getCountryCode] isEqualToString:@"CH"] && [[WSUtility getLanguageCode] isEqualToString:@"de"]){
                        self.awayFromGiftLbl.text = [[NSString stringWithFormat:[WSUtility getTranslatedStringForString:@"You're £65 away from getting a gift name"],strRemianingPrice,str] stringByReplacingOccurrencesOfString:@"€" withString:@"CHF"];
                        range1 = [self.awayFromGiftLbl.text rangeOfString:[NSString stringWithFormat:@"%@CHF",strRemianingPrice]];
                    }
                    else{
                        self.awayFromGiftLbl.text = [NSString stringWithFormat:[WSUtility getTranslatedStringForString:@"You're £65 away from getting a gift name"],strRemianingPrice,str];
                        if ([[WSUtility getCountryCode] isEqualToString:@"CH"]){
                            range1 = [self.awayFromGiftLbl.text rangeOfString:[NSString stringWithFormat:@"%@CHF",strRemianingPrice]];
                        }
                        else if([WSUtility isLoginWithTurkey]){
                            range1 = [self.awayFromGiftLbl.text rangeOfString:[NSString stringWithFormat:@"%@",strRemianingPrice]];
                        }
                        else{
                            range1 = [self.awayFromGiftLbl.text rangeOfString:[NSString stringWithFormat:@"%@€",strRemianingPrice]];
                        }
                    }
                    
                    NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc] initWithString:self.awayFromGiftLbl.text];
                    [attString1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINPro-Bold" size:13.0] range:range1];
                    self.awayFromGiftLbl.attributedText = attString1;
                }
                
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"directOperator"]||([WSUtility isLoginWithTurkey] && [[NSUserDefaults standardUserDefaults] boolForKey:@"isMOQRequired"])){
                    
                    NSString *localized = [NSString stringWithFormat:@"Minimun order value is 300. You are 120 away from reaching this."];
                    NSString *totalStr = @"";
                    NSString *str = [WSUtility getCountryCode];
                    if ([str isEqualToString:@"CH"] && [[WSUtility getLanguageCode] isEqualToString:@"de"]) {
                        
                        totalStr = [[NSString stringWithFormat:[WSUtility getlocalizedStringWithKey:localized lang:[WSUtility getLanguage] table:@"Localizable"],[NSString stringWithFormat:@"%0.2f",tmpMinValue],[NSString stringWithFormat:@"%@",strRemianingPrice]] stringByReplacingOccurrencesOfString:@"€" withString:@"CHF"];
                        
                    }
                    else{
                        totalStr = [NSString stringWithFormat:[WSUtility getlocalizedStringWithKey:localized lang:[WSUtility getLanguage] table:@"Localizable"],[NSString stringWithFormat:@"%0.2f",tmpMinValue],[NSString stringWithFormat:@"%@",strRemianingPrice]];
                    }

                    
                    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:totalStr];
                    
                    NSString *subLocalized1 = [NSString stringWithFormat:@"Minimun order value is 300."];
                    if ([str isEqualToString:@"CH"] && [[WSUtility getLanguageCode] isEqualToString:@"de"]) {
                        
                        NSRange range = [totalStr rangeOfString:[[NSString stringWithFormat:[WSUtility getlocalizedStringWithKey:subLocalized1 lang:[WSUtility getLanguage] table:@"Localizable"],[NSString stringWithFormat:@"%0.2f",tmpMinValue]] stringByReplacingOccurrencesOfString:@"€" withString:@"CHF"]];
                        
                        [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINPro-Bold" size:13.0] range:range];
                    }
                    else{
                        NSRange range = [totalStr rangeOfString:[NSString stringWithFormat:[WSUtility getlocalizedStringWithKey:subLocalized1 lang:[WSUtility getLanguage] table:@"Localizable"],[NSString stringWithFormat:@"%0.2f",tmpMinValue]]];
                        
                        [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINPro-Bold" size:13.0] range:range];
                    }

                    
                    self.DTOMinimumOrderTextLabel.attributedText = attString;
                    self.orderNowButton.enabled = NO;
                    self.orderNowButton.alpha = 0.5;
                }
                
            }else{
                NSDictionary *firstOrderIncentiveDict = [[NSUserDefaults standardUserDefaults] valueForKey:@"First_Order_Incentive_Data"];
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"First_Order_Incentive_Data"] count] != 0) {
                    NSString *str = [firstOrderIncentiveDict objectForKey:@"product_name"];
                    if (str != nil) {
                        self.awayFromGiftLbl.text =  [[WSUtility getTranslatedStringForString:@"Congrats, you now have enough items to get a gift name"] stringByReplacingOccurrencesOfString:@"%@" withString:str];
                    }
                    self.giftView.backgroundColor = [UIColor colorWithRed:242/255.0f green:255/255.0f blue:242/255.0f alpha:1.0f];
                }
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"directOperator"] || ([WSUtility isLoginWithTurkey] && [[NSUserDefaults standardUserDefaults] boolForKey:@"isMOQRequired"])){//
                    self.DTOtopHeaderViewHeightConstraint.constant = 0;
                    self.DTOTopView.hidden = YES;
                    self.orderNowButton.enabled = YES;
                    self.orderNowButton.alpha = 1.0;
                }

            }
            
            
        }
    } else {
       // DDLogDebug(@"No cart is present in the user cache, a cart should have been created at the login.");
    }
}

- (void)getSifuAccessToken {
    
    WSWebServiceBusinessLayer *serviceBussinessLayer =  [[WSWebServiceBusinessLayer alloc] init];
    NSString *emailID = [[NSUserDefaults standardUserDefaults] objectForKey: @"LAST_AUTHENTICATED_USER_KEY"];
    NSString *password =  [[NSUserDefaults standardUserDefaults] objectForKey: @"USER_PASSWORD_KEY"];//[[self.backEndService userStorage] objectForKey:USER_PASSWORD_KEY];
    NSDictionary *dictParameter = @{@"EmailId":emailID, @"Password":password};
    
    [serviceBussinessLayer makeLoginRequestWithParameter:dictParameter methodName:@"auth/authenticate" successResponse:^(id response) {
        [self refreshCartFromServer];
    } faliureResponse:^(NSString * errorMessage) {
        
    }];
}

#pragma mark Cart Items Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    return self.cartItems.count;
}

#pragma mark --> cellForRowAtIndexPath

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CartTableViewCell *cell = (CartTableViewCell *) [table dequeueReusableCellWithIdentifier:@"CustomCellCart"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CartCell" owner:self options:nil] objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableDictionary *tempTableDict = [[NSMutableDictionary alloc] init];
    tempTableDict = [_cartItems objectAtIndex:indexPath.row];
    NSMutableDictionary *tempProdDict = [tempTableDict objectForKey:@"product"];
    NSMutableDictionary *tempPriceDict = [tempTableDict objectForKey:@"totalPrice"];
    NSArray *baseOptionsArr = [tempProdDict objectForKey:@"baseOptions"];
    NSDictionary *tempImagesDict = [baseOptionsArr objectAtIndex:0];
    NSDictionary *selectedImagesDict = [tempImagesDict objectForKey:@"selected"];
    cell.pName.text = [tempProdDict objectForKey:@"name"];
    cell.unit.text = [selectedImagesDict objectForKey:@"packaging"];
    
    NSNumber *pQty = [tempTableDict objectForKey:@"quantity"];
    if(pQty){
        cell.tfQty.text = pQty.stringValue;
    }
    float prPrice = [[tempPriceDict objectForKey:@"value"] floatValue];
    if (prPrice == 0){
        cell.QuantityBox.hidden = true;
        cell.deleteBtn.hidden = true;
        cell.price.hidden = true;
    }
    NSString *pri = @"";
  /*
    NSString *str = [WSUtility getCountryCode];
  
    if ([str isEqualToString:@"CH"]) {
        pri = [NSString stringWithFormat:@"CHF %.02f",prPrice];
    }else{
      pri = [tempPriceDict objectForKey:@"formattedValue"];
    }
   */
  
    pri = [tempPriceDict objectForKey:@"formattedValue"];
  
  /*
    else if ([str isEqualToString:@"TR"]) {
        pri = [NSString stringWithFormat:@"%.02f ₺",prPrice];
    }
    else{
        pri = [NSString stringWithFormat:@"€ %.02f",prPrice];
    }
   */
  
  
  
  
  cell.price.text = pri; //[pri stringByReplacingOccurrencesOfString:@"." withString:@","];
    NSString *imageURL = [NSString stringWithFormat:@"%@",[selectedImagesDict objectForKey:@"thumbnailUrl"]];
    [cell.pImage sd_setImageWithURL:[NSURL URLWithString:imageURL]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageAllowInvalidSSLCertificates];
    
    cell.minusBtn.tag = indexPath.row;
    cell.plusBtn.tag = indexPath.row;
    cell.deleteBtn.tag = indexPath.row;
    [cell.minusBtn addTarget:self action:@selector(minusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.plusBtn addTarget:self action:@selector(plusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.tfQty.tag = indexPath.row;
    cell.tfQty.delegate = self;
    [cell.tfQty addDoneButtonToKeyboardWithMyAction:@selector(resignKeyboardInScanViewController)];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isBatchDeleting) return NO;
    return YES;
}

/*
 -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 return CART_CELL_HEIGHT;
 }
 */


-(void)minusButtonClicked:(UIButton*)sender {
    [self.view endEditing:true];
    [UFSProgressView showWaitingDialog:@""];
    NSLog(@"%@", [NSString stringWithFormat:@"%ld",(long)sender.tag]);
    NSInteger taggedRow = sender.tag;
    CartTableViewCell *cell =  (CartTableViewCell *)[self.itemsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:taggedRow inSection:0]];
  
    
    NSMutableDictionary *tempTableDict = [[NSMutableDictionary alloc] init];
    tempTableDict = [_cartItems objectAtIndex:sender.tag];
  
    self.currentlyEditedCartItemPosition = [tempTableDict objectForKey:@"entryNumber"];
    if([cell.tfQty.text integerValue] > 1){
        int qtyVal = (int)[cell.tfQty.text integerValue];
        qtyVal = qtyVal - 1;
        NSNumber *amount = [NSNumber numberWithInt:qtyVal];
        if (amount.intValue == 0) {
            // starting the dialog for deletion, take a look at the UIAlertViewDelegate methods
            [self showAlertViewForItemDeletion:(int)sender.tag];
            [UFSProgressView stopWaitingDialog];
        } else {
            if (amount) {
              
              NSString *cartId = [UFSHybrisUtility uniqueCartId];
              WSWebServiceBusinessLayer *serviceBussinessLayer = [[WSWebServiceBusinessLayer alloc] init];
              [serviceBussinessLayer replaceCartEntryForUserIdWithCartId:cartId entryNumber:self.currentlyEditedCartItemPosition cartQuantity:[NSString stringWithFormat:@"%d",qtyVal] successResponse:^(id response) {
                
                //[UFSProgressView stopWaitingDialog];
                [self refreshCartFromServer];
                
              } faliureResponse:^(NSString * errorMessage) {
                [UFSProgressView stopWaitingDialog];
              }];
               
              
              
              
               
            } else{
                [UFSProgressView stopWaitingDialog];
            }
        }
    }else{
        [UFSProgressView stopWaitingDialog];
    }
    
}

-(void)plusButtonClicked:(UIButton*)sender {
    [self.view endEditing:true];
    CartTableViewCell *cell =  (CartTableViewCell *)[self.itemsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];

    NSInteger num = [cell.tfQty.text integerValue];
    if (num+1 <= 1000) {
        [self updateQuantity:(int)sender.tag isTextField:false];
    }
}

-(void)updateQuantity:(int)tag isTextField:(BOOL)isTF {

    [UFSProgressView showWaitingDialog:@""];
    NSLog(@"%@", [NSString stringWithFormat:@"%ld",(long)tag]);
    NSInteger taggedRow = tag;
    CartTableViewCell *cell =  (CartTableViewCell *)[self.itemsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:taggedRow inSection:0]];
 
    
    NSMutableDictionary *tempTableDict = [[NSMutableDictionary alloc] init];
    tempTableDict = [_cartItems objectAtIndex:tag];
    //NSMutableDictionary *tempProdDict = [tempTableDict objectForKey:@"product"];
    self.currentlyEditedCartItemPosition = [tempTableDict objectForKey:@"entryNumber"];
    
    int qtyVal = (int)[cell.tfQty.text integerValue];
    if (!isTF) {
        qtyVal = qtyVal + 1;
    }
    NSNumber *amount = [NSNumber numberWithInt:qtyVal];
    if (amount.intValue == 0) {
        // starting the dialog for deletion, take a look at the UIAlertViewDelegate methods
        [self showAlertViewForItemDeletion:tag];
        [UFSProgressView stopWaitingDialog];
    } else {
        if (amount) {
          
            NSString *cartId = [UFSHybrisUtility uniqueCartId];
          
            WSWebServiceBusinessLayer *serviceBussinessLayer = [[WSWebServiceBusinessLayer alloc] init];
        
            [serviceBussinessLayer replaceCartEntryForUserIdWithCartId:cartId entryNumber:self.currentlyEditedCartItemPosition cartQuantity:[NSString stringWithFormat:@"%d",qtyVal] successResponse:^(id response) {
             
                [self refreshCartFromServer];
                
            } faliureResponse:^(NSString * errorMessage) {
                [UFSProgressView stopWaitingDialog];
            }];
           
          
          
      
          
          
        }  else{
            [UFSProgressView stopWaitingDialog];
        }
    }
}
-(void)deleteButtonClicked:(UIButton*)sender
{
    [self deleteCurrentlyEditedItem:(int)sender.tag];
}

#pragma mark alert for item deletion and its delegate


- (void)showAlertViewForItemDeletion:(int)tag {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[WSUtility getTranslatedStringForString:@"Item Removal"]
                                                    message:[WSUtility getTranslatedStringForString:@"Are you sure you would like to remove this item from the cart?"]
                                                   delegate:self
                                          cancelButtonTitle:[WSUtility getTranslatedStringForString:@"No"]
                                          otherButtonTitles:[WSUtility getTranslatedStringForString:@"Yes, I am sure"], nil];
    self.activeTFTag = tag;
    [alert setTag:100];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if ([alertView tag] == 100) {
        if (buttonIndex == 1) {
//            DDLogDebug(@"Item Deletion Cancelled");
//            HYBOrderEntry *item = [self.cartItems objectAtIndex:self.currentlyEditedCartItemPosition];
//            NSIndexPath *path = [NSIndexPath indexPathForRow:self.currentlyEditedCartItemPosition inSection:0];
//            HYBCartItemCellView *cell = (HYBCartItemCellView *) [self.itemsTable cellForRowAtIndexPath:path];
//            [cell.itemsInputTextfield setText:[item.quantity stringValue]];
            [self deleteCurrentlyEditedItem:self.activeTFTag];
        } else {
            //DDLogDebug(@"Item Deletion Confirmed");
            //[self deleteCurrentlyEditedItem:];
        }
//    } else if ([alertView tag] == TAG_MANY_ITEMS_DELETION) {
//        if (buttonIndex != [alertView cancelButtonIndex]) {
//            //[self doBatchDelete];
//        }
    }
}

- (void)deleteCurrentlyEditedItem:(int)tag {
    NSDictionary *params = @{@"qty" : @"0"};
    [UFSProgressView showWaitingDialog:@""];
    NSString *cartId = [UFSHybrisUtility uniqueCartId];
    WSWebServiceBusinessLayer *serviceBussinessLayer = [[WSWebServiceBusinessLayer alloc] init];
    [serviceBussinessLayer deleteCartEntryForUserIdWithUserId:@"" cartId:cartId entryNumber:[NSString stringWithFormat:@"%d", tag] params:params successResponse:^(id response) {
        //[UFSProgressView stopWaitingDialog];
        [self refreshCartFromServer];
    } faliureResponse:^(NSString * errorMessage) {
        [UFSProgressView stopWaitingDialog];
        NSLog(@"%@",errorMessage);
    }];
    
}


-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)startShoppingAction:(UIButton *)sender {
    
    self.tabBarController.selectedIndex = 2;
    [self.navigationController popViewControllerAnimated:false];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [self.promoCodeTF resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _promoCodeTF) {
        adjustKeyboard = true;
    }
    else{
        adjustKeyboard = false;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (!adjustKeyboard) {
        if ([textField.text isEqual:@""]) {
            textField.text = @"1";
        }
    [self updateQuantity:(int)textField.tag isTextField:true];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]){
        return true;
    }
    NSMutableString *str = [[NSMutableString alloc]init];
    [str appendString:textField.text];
    [str appendString:string];
    NSInteger num = [str integerValue];
    if (textField.text.length == 0 || [textField.text isEqualToString:@""]){
        if ([string  isEqual: @""] || [string  isEqual: @"0"]){
            textField.text = @"1";
            return false;
        }
    }
    else if (num > 1000) {
         return false;
    }
    return true;
}
-(IBAction)textDidChange:(id)sender{
    
    [self UISetUpForPromoTextFieldWithImage:self.promoCodeTF and:false and:false];
    self.promoCodeErrorTextLabel.hidden = true;
}

-(void)dismissKeyboard {
    [self.promoCodeTF resignFirstResponder];
}

- (void)keyboardWillShow: (NSNotification *) aNotification{
    // Do something here
    if (!adjustKeyboard) {
        return;
    }
    NSDictionary *info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.origin.y -= kbSize.height ;
    self.view.frame = aRect;
}

- (void)keyboardWillHide: (NSNotification *) aNotification{
    // Do something here
    if (!adjustKeyboard) {
        return;
    }

    CGRect aRect = self.view.frame;
    if (aRect.origin.y > -195){
        int height = 0;
        if (self.topHeaderViewHeightConstraint.constant == 0) {
            height = 55;
        }
        else{
            height = self.topHeaderViewHeightConstraint.constant;
        }
        aRect.origin.y = height + 10;
    }
    else{
        aRect.origin.y = 0;
    }
    self.view.frame = aRect;
}

// promoCode

-(IBAction)addOrChangePromoCodeButton_Click:(id)sender{
    
    self.promoCodeTF.hidden = FALSE;
    self.submitPromoCodeButton.hidden = FALSE;
}
-(IBAction)submitPromoCodeButton_Click:(id)sender{
    
    if ([self.promoCodeTF.text isEqualToString:@""]){
        [self UISetUpForPromoTextFieldWithImage:self.promoCodeTF and:true and:false];
        self.promoCodeErrorTextLabel.hidden = false;
    }
    else{
        [UFSProgressView showWaitingDialog:@""];
        WSWebServiceBusinessLayer *serviceBussinessLayer = [[WSWebServiceBusinessLayer alloc] init];
        [serviceBussinessLayer validatePromoCodeRequestWithPromoCode:self.promoCodeTF.text successResponse:^(id response) {
            [UFSProgressView stopWaitingDialog];
            self.validPromoDict = response;
            BOOL responseSuccuess = [response objectForKey:@"error"];
            NSString *responseCodeStr = [NSString stringWithFormat:@"%@",[response objectForKey:@"http_status"]];
            
            if (responseSuccuess && [responseCodeStr isEqualToString:@"200"]){
                
                [self updatePromoCodeUI:response and:@"FromValidApi"];
                
            }
            else{
                self.IsCouponCodeValidOrNot = false;
                [self UISetUpForPromoTextFieldWithImage:self.promoCodeTF and:true and:false];
                self.promoCodeErrorTextLabel.hidden = false;
            }
            
        } faliureResponse:^(NSString * errorMessage) {
            [UFSProgressView stopWaitingDialog];
        }];
        
    }
}

-(void)updatePromoCodeUI:(NSDictionary *)response and:(NSString *)from{
    
    [self UISetUpForPromoTextFieldWithImage:self.promoCodeTF and:true and:true];
    self.IsCouponCodeValidOrNot = true;
    [self showHidePromoLabels:FALSE];
    
    self.promoCodeTF.hidden = self.IsCouponCodeValidOrNot;
    self.submitPromoCodeButton.hidden = self.IsCouponCodeValidOrNot;
    self.promoCodeErrorTextLabel.hidden = self.IsCouponCodeValidOrNot;
    self.promoCodeViewHeightConstraint.constant = 270;
    
    self.promoCodeTF.text = [response objectForKey:@"promocode"];
    
    self.promoCodeNameTextLabel.text = [NSString stringWithFormat:@"%@: %@:",[WSUtility getTranslatedStringForString:@"Promo"],[response objectForKey:@"promoname"]];
    
    self.promoCodeLoyaltyPointsLabel.text = [NSString stringWithFormat:@"+%@ %@",[response objectForKey:@"points"],[WSUtility getlocalizedStringWithKey:@"Loyalty Points" lang:[WSUtility getLanguage] table:@"Localizable"]];
    
    self.promoCodeRewardsPointsLabel.text = [NSString stringWithFormat:@"%ld %@",(long)self.totalLoyaltyPoints,[WSUtility getlocalizedStringWithKey:@"Loyalty Points" lang:[WSUtility getLanguage] table:@"Localizable"]];
    
    [self makeAttribute:self.promoCodeLoyaltyPointsLabel.text and:[NSString stringWithFormat:@"+%@",[response objectForKey:@"points"]] and:self.promoCodeLoyaltyPointsLabel];
    
    [self makeAttribute:self.promoCodeRewardsPointsLabel.text and:[NSString stringWithFormat:@"%ld",(long)self.totalLoyaltyPoints] and:self.promoCodeRewardsPointsLabel];
    
    NSString *loyalty = [response objectForKey:@"points"];
    NSInteger totalPoints = self.totalLoyaltyPoints + (int)[loyalty integerValue];
    
    // promoLoyaltyPoints
    self.promoLoyaltyPoints = (int)[loyalty integerValue];
    NSString *myString = [NSString stringWithFormat:@"%ld %@",(long)totalPoints,[WSUtility getlocalizedStringWithKey:@"Loyalty Points" lang:[WSUtility getLanguage] table:@"Localizable"]];
    
    [self makeAttribute:myString and:[NSString stringWithFormat:@"%ld",(long)totalPoints] and:self.loyalityPointsLabel];
    
    if ([self.addOrChangePromoCodeButton.titleLabel.text isEqualToString:[WSUtility getlocalizedStringWithKey:@"Change promotion code" lang:[WSUtility getLanguage] table:@"Localizable"]]){
        
        if ([from isEqualToString:@"FromValidApi"]){
            [self unSetPromoCodeToAdmin:self.validPromoCode];
            [self setPromoCodeToAdmin:[response objectForKey:@"promocode"]];
        }
    }
    else{
        if ([from isEqualToString:@"FromValidApi"]){
            [self setPromoCodeToAdmin:[response objectForKey:@"promocode"]];
        }
        
        [self.addOrChangePromoCodeButton setTitle:[WSUtility getlocalizedStringWithKey:@"Change promotion code" lang:[WSUtility getLanguage] table:@"Localizable"] forState:UIControlStateNormal];
    }
    if ([from isEqualToString:@"FromValidApi"]){
        //[self showNotifyMessage:[WSUtility getlocalizedStringWithKey:@"Promotion code added" lang:[WSUtility getLanguage] table:@"Localizable"]];
    }
    self.validPromoCode = [response objectForKey:@"promocode"];
    
}

-(void)UISetUpForPromoTextFieldWithImage:(UITextField *)textField and:(BOOL)boolValue and:(BOOL)validationBool {
    
    textField.rightViewMode = UITextFieldViewModeNever;
    if (boolValue == true) {
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 50)];
        UIImageView *checkedImage = [[UIImageView alloc] initWithFrame:CGRectMake(-50, 17.5, 15, 15)];
        checkedImage.contentMode = UIViewContentModeScaleAspectFit;
        
        if (validationBool == true) {
            //checkedImage.image = [UIImage imageNamed:@"checked_Icon"];
            textField.layer.borderColor =
            textField.layer.borderColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.0].CGColor;
        }
        else{
            //checkedImage.image = [UIImage imageNamed:@"error_icon"];
            textField.layer.borderColor = [UIColor colorWithRed:0.82 green:0.00 blue:0.11 alpha:1.0].CGColor;
        }
        //[rightView addSubview:checkedImage];
        textField.rightView = rightView;
        textField.rightViewMode = UITextFieldViewModeAlways;
        
    }
    else{
        textField.layer.borderWidth = 1.5;
        textField.layer.borderColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.0].CGColor;
        textField.layer.cornerRadius = 6;
    }
    
}

-(void)makeAttribute:(NSString *)totalStr and:(NSString *)subStr and:(UILabel *)label{
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:totalStr];
    NSRange range = [totalStr rangeOfString:[NSString stringWithFormat:@"%@",subStr]];
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINPro-Bold" size:12.0] range:range];
    if (label == self.loyalityPointsLabel){
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:252.0/255.0 green:91.0/255.0 blue:31.0/255.0 alpha:1] range:range];
    }
    label.attributedText = attString;
}

-(void)setPromoCodeToAdmin:(NSString *)promoCode{
    WSWebServiceBusinessLayer *serviceBussinessLayer = [[WSWebServiceBusinessLayer alloc] init];
    [serviceBussinessLayer setAppliedPromoCodeBeforeOrderPlacedWithPromoCode:promoCode successResponse:^(id response) {
        
    } faliureResponse:^(NSString * errorMessage) {
        
    }];
}

-(void)unSetPromoCodeToAdmin:(NSString *)promoCode{
    WSWebServiceBusinessLayer *serviceBussinessLayer = [[WSWebServiceBusinessLayer alloc] init];
    [serviceBussinessLayer unSetAppliedPromoCodeBeforeOrderPlacedWithPromoCode:promoCode successResponse:^(id response) {
        
    } faliureResponse:^(NSString * errorMessage) {
        
    }];
}

-(void)getAppliedPromoCodeIfOrderNotPlaced{
    WSWebServiceBusinessLayer *serviceBussinessLayer = [[WSWebServiceBusinessLayer alloc] init];
    [serviceBussinessLayer getAppliedPromoCodeWhileOrderIsNotPlacedWithSuccessResponse:^(id response) {
        
        BOOL responseSuccuess = [response objectForKey:@"error"];
        NSString *responseCodeStr = [NSString stringWithFormat:@"%@",[response objectForKey:@"http_status"]];
        if (responseSuccuess && [responseCodeStr isEqualToString:@"200"]){
            if (![[response objectForKey:@"promocode"] isEqualToString:@""]){
                self.validPromoDict = response;
                self.validPromoCode = [response objectForKey:@"promocode"];
                [self updatePromoCodeUI:response and:@"AppliedPromoApi"];
            }
        }
        else{
            
        }
        
    } faliureResponse:^(NSString * errorMessage) {
        
    }];
}

-(void)showHidePromoLabels:(BOOL)isShow{
    
    self.promoCodeTF.hidden = isShow;
    self.submitPromoCodeButton.hidden = isShow;
    self.promoCodeErrorTextLabel.hidden = isShow;
    self.promoCodeRewardsTextLabel.hidden = isShow;
    self.promoCodeRewardsPointsLabel.hidden = isShow;
    self.promoCodeNameTextLabel.hidden = isShow;
    self.promoCodeLoyaltyPointsLabel.hidden = isShow;
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
@end

