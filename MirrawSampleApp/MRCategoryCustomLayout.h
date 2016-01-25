//
//  MRCategoryCustomLayout.h
//  MirrawSampleApp
//
//  Created by Vishal Bhadade on 25/01/16.
//  Copyright (c) 2016 Mirraw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"

@protocol CategoryCustomLayoutDelegate <NSObject>

@optional
- (CategoryModel *)categoryModelForItemAtIndexpath:(NSIndexPath *)indexPath;

@end
@interface MRCategoryCustomLayout : UICollectionViewLayout

@property (nonatomic, readonly) CGFloat horizontalInset;
@property (nonatomic, readonly) CGFloat verticalInset;

@property(nonatomic, weak) id<CategoryCustomLayoutDelegate> cDelegate;

@end
