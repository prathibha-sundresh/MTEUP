//
//  HYBCartController.h
//  yB2CApp
//
//  Created by Ajay Parmar on 4/5/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HYBCartController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic) BOOL isBatchDeleting;
@property (nonatomic) BOOL validAmount;


@property (nonatomic) NSString *firstResponderOriginalValue;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView;

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
