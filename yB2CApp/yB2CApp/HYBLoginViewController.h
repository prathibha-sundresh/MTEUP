//
// HYBLoginViewController.h
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
//#import "FloatLabelTextField-Swift.h"

@interface HYBLoginViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *forgotButton;
@property (weak, nonatomic) IBOutlet UILabel *emailErrorMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordErrorMessageLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
   // @property (weak, nonatomic) IBOutlet FloatLabelTextField *emailLabel;
    
    @property (nonatomic) IBOutlet UIImageView   *emailerrorImg;
 
    @property (weak, nonatomic) IBOutlet UILabel *loginLabel;
    @property (nonatomic) IBOutlet UIImageView   *passwordErrorImg;
    @property (nonatomic) IBOutlet UIScrollView *scrollView;

//- (instancetype)initWithBackEndService:(HYBB2CService*)backendService;
- (void)loginWithUser:(NSString *)user pass:(NSString *)pass;
- (IBAction)loginButtonTapped:(UIButton *)sender;

@end
