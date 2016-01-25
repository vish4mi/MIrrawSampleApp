//
//  ItemsCollectionViewCell.h
//  MirrawSampleApp
//
//  Created by Vishal Bhadade on 19/01/16.
//  Copyright (c) 2016 Mirraw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *productImage;
@property (nonatomic, strong) IBOutlet UILabel *productTitle;
@property (strong, nonatomic) IBOutlet UILabel *productByName;
@property (strong, nonatomic) IBOutlet UILabel *priceCurrencySymbol;
@property (strong, nonatomic) IBOutlet UILabel *productActualPrice;
@property (strong, nonatomic) IBOutlet UILabel *productOriginalPrice;
@property (strong, nonatomic) IBOutlet UILabel *productDiscountPercent;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *priceSymbolOne;
@property (strong, nonatomic) IBOutlet UILabel *priceSymbolTwo;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *productDiscountLabelHeightConstraint;

@end
