//
//  HYBProducts.m
//  UFSDev
//
//  Created by Ajay Parmar on 4/4/18.
//

#import "HYBProducts.h"

@implementation HYBProducts

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"availableForPickup" : @"availableForPickup",
             @"volumePricesFlag" : @"volumePricesFlag",
             @"purchasable" : @"purchasable",
             @"code" : @"code",
             @"numberOfReviews" : @"numberOfReviews",
             @"variantMatrix" : @"variantMatrix",
             @"descriptor" : @"description",
             @"manufacturer" : @"manufacturer",
             @"variantType" : @"variantType",
             @"reviews" : @"reviews",
             @"variantOptions" : @"variantOptions",
             @"price" : @"price",
             @"averageRating" : @"averageRating",
             @"firstVariantImage" : @"firstVariantImage",
             @"categories" : @"categories",
             @"potentialPromotions" : @"potentialPromotions",
             @"stock" : @"stock",
             @"summary" : @"summary",
             @"images" : @"images",
             @"baseProduct" : @"baseProduct",
             @"url" : @"url",
             @"firstVariantCode" : @"firstVariantCode",
             @"futureStocks" : @"futureStocks",
             @"classifications" : @"classifications",
             @"productReferences" : @"productReferences",
             @"name" : @"name",
             @"volumePrices" : @"volumePrices",
             @"priceRange" : @"priceRange",
             @"multidimensional" : @"multidimensional",
             @"baseOptions" : @"baseOptions",
             @"thumbnailUrl" : @"thumbnailUrl"
             };
}



- (NSString*)firstVariantCode {
    
    if (_firstVariantCode) {
        return _firstVariantCode;
    }
    
    return _code;
}
@end


