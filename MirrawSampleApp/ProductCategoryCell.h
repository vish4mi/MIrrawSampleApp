//
//  productCategoryCell.h
//  MirrawSampleApp
//
//  Created by Vishal Bhadade on 18/01/16.
//  Copyright (c) 2016 Mirraw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCategoryCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *catImage;
@property (nonatomic, strong) IBOutlet UILabel *catTitle;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *categoryCellHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *categoryTitleHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *categoryImageWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *categoryTitleWidthConstraint;

@end
