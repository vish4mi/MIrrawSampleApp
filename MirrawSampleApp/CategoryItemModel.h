//
//  CategoryItemModel.h
//  MirrawSampleApp
//
//  Created by Vishal Bhadade on 19/01/16.
//  Copyright (c) 2016 Mirraw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CategoryItemModel : NSObject

@property (nonatomic, strong) UIImage * pImage;
@property (nonatomic, strong) NSString * pByName;
@property (nonatomic, strong) NSString * pActualPrice;
@property (nonatomic, strong) NSNumber * pId;
@property (nonatomic, strong) NSString * pTitle;
@property (nonatomic, strong) NSString * pCategoryName;
@property (nonatomic, strong) NSString * pDesignPath;
@property (nonatomic, strong) NSString * pHexSymbol;
@property (nonatomic, strong) NSString * pOriginalPrice;
@property (nonatomic, strong) NSNumber * pDiscountPercent;
@property (nonatomic, strong) NSString * pDesigner;
@property (nonatomic, strong) NSString * pCachedSlug;
@property (nonatomic, strong) NSNumber * pGrade;
@property (nonatomic, strong) NSString * pStockState;
@property (nonatomic, strong) NSString * pBrand;

@end
