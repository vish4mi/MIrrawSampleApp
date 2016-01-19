//
//  MirrawService.h
//  MirrawSampleApp
//
//  Created by Vishal Bhadade on 18/01/16.
//  Copyright (c) 2016 Mirraw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CategoryModel.h"

typedef void (^categoryServiceCompletionBlock)(NSArray *categoryArray, NSError *error);

@protocol MirrawServicesDelegate <NSObject>

@optional
- (void)updateCollectionViewCellwithModel:(CategoryModel *)cModel;

@end

@interface MirrawService : NSObject

@property (nonatomic, weak) id<MirrawServicesDelegate> sDelegate;

- (void)fetchProductCategoryDetails:(categoryServiceCompletionBlock)completionBlock;

@end
