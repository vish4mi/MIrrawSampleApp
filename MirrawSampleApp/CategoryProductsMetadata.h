//
//  CategoryProductsMetadata.h
//  MirrawSampleApp
//
//  Created by Vishal Bhadade on 21/01/16.
//  Copyright (c) 2016 Mirraw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryProductsMetadata : NSObject

@property (nonatomic, strong) NSNumber *productCount;
@property (nonatomic, strong) NSNumber *totalPages;
@property (nonatomic, strong) NSNumber *previousPage;
@property (nonatomic, strong) NSNumber *nextPage;
@property (nonatomic, strong) NSString *hexSymbol;
@property (nonatomic, strong) NSString *priceSymbol;

@end
