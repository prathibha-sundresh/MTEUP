//
//  UFSHYBConstants.h
//  UFSDev
//
//  Created by Ajay Parmar on 3/29/18.
//

#import <Foundation/Foundation.h>

/**
 * Class to save all static constans that are used more than by one single class definition.
 */



#define defaultAnimationDuration 0.3
#define defaultTopMargin 80.f
#define FORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]
#define SIMPLE_CART_ITEM_CELL_ID    @"HYBEntryViewCellID"
#define HYBOCCErrorDomain           @"HYBOCCErrorDomain"
#define HYB2B_ERROR_CODE_TECHNICAL  -57

// BACKEND SERVICE

#define CURRENT_SETTINGS    @"CURRENT_SETTINGS"
#define USESSL              @"useSSL"
#define OCCVERSION          @"OCCVersion"
#define STOREID             @"storeId"
#define CATALOGID           @"catalogId"
#define CATALOGVERSIONID    @"catalogVersionId"
#define ROOTCATEGORYID      @"rootCategoryId"
#define GROUPID             @"groupId"
#define USERID              @"userId"
#define BACKENDHOST         @"backEndHost"
#define BACKENDPORT         @"backEndPort"
#define DID_CHANGE_SERVER   @"DID_CHANGE_SERVER"

