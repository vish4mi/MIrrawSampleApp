//
//  MirrawCustomLayout.h
//  MirrawSampleApp
//
//  Created by Vishal Bhadade on 23/01/16.
//  Copyright (c) 2016 Mirraw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryItemModel.h"

@protocol CustomLayoutDelegate <NSObject>

@optional
- (CategoryItemModel *)modelForItemAtIndexpath:(NSIndexPath *)indexPath;

@end
@interface MRProductCustomLayout : UICollectionViewLayout

@property (nonatomic, readonly) CGFloat horizontalInset;
@property (nonatomic, readonly) CGFloat verticalInset;

@property (nonatomic, readonly) CGFloat minimumItemHeight;
@property (nonatomic, readonly) CGFloat maximumItemHeight;
@property (nonatomic, readonly) CGFloat itemHeight;

@property (nonatomic, weak) id<CustomLayoutDelegate> aDelegate;

@end
