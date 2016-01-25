//
//  CategoryModel.h
//  MirrawSampleApp
//
//  Created by Vishal Bhadade on 18/01/16.
//  Copyright (c) 2016 Mirraw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CategoryModel : NSObject

@property (nonatomic, strong) UIImage *categoryMainImage;
@property (nonatomic, strong) UIImage *categoryOriginalImage;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *categoryKey;
@property (nonatomic, strong) NSString *categoryValue;

@end
