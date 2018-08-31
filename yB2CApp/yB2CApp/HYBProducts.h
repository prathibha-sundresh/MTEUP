//
//  HYBProducts.h
//  UFSDev
//
//  Created by Ajay Parmar on 4/4/18.
//

#import <Foundation/Foundation.h>

@class HYBStock;


@interface HYBProducts : NSObject

@property (nonatomic) BOOL availableForPickup;
@property (nonatomic) BOOL volumePricesFlag;
@property (nonatomic) BOOL purchasable;
@property (nonatomic) NSString *code;
@property (nonatomic) NSNumber *numberOfReviews;
@property (nonatomic) NSArray *variantMatrix;
@property (nonatomic) NSString *descriptor;
@property (nonatomic) NSString *manufacturer;
@property (nonatomic) NSString *variantType;
@property (nonatomic) NSArray *reviews;
@property (nonatomic) NSArray *variantOptions;
//@property (nonatomic) HYBPrice *price;
@property (nonatomic) NSNumber *averageRating;
@property (nonatomic) NSString *firstVariantImage;
@property (nonatomic) NSArray *categories;
//@property (nonatomic) NSArray *potentialPromotions;
@property (nonatomic) HYBStock *stock;
@property (nonatomic) NSString *summary;
@property (nonatomic) NSArray *images;
@property (nonatomic) NSString *baseProduct;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *firstVariantCode;
@property (nonatomic) NSArray *futureStocks;
@property (nonatomic) NSArray *classifications;
@property (nonatomic) NSArray *productReferences;
@property (nonatomic) NSString *name;
@property (nonatomic) NSArray *volumePrices;
@property (nonatomic) NSString *thumbnailUrl;
//@property (nonatomic) HYBPriceRange *priceRange;
@property (nonatomic) BOOL multidimensional;
@property (nonatomic) NSArray *baseOptions;



@end


