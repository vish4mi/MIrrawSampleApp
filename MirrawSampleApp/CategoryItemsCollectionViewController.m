//
//  CategoryItemsCollectionViewController.m
//  MirrawSampleApp
//
//  Created by Vishal Bhadade on 19/01/16.
//  Copyright (c) 2016 Mirraw. All rights reserved.
//

#import "CategoryItemsCollectionViewController.h"
#import "MirrawService.h"
#import "ItemsCollectionViewCell.h"
#import "CategoryProductsMetadata.h"
#import "CategoryItemModel.h"
#import "MRProductCustomLayout.h"

@interface CategoryItemsCollectionViewController ()
<
  UICollectionViewDataSource,
  UICollectionViewDelegateFlowLayout,
  CustomLayoutDelegate
>

@property (nonatomic, strong) MirrawService *mirrawService;
@property (nonatomic, strong) NSArray *cItemsModelArray;
@property (nonatomic, strong) NSDictionary *pMetadata;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewCellHeightConstraint;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) MRProductCustomLayout *mirrawLayout;

@end

@implementation CategoryItemsCollectionViewController

static NSString * const reuseIdentifier = @"CategoryItemCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchCategoryProductsDetails];
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    [self.collectionView setBackgroundColor:[UIColor darkGrayColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchCategoryProductsDetails
{
    self.mirrawService = [[MirrawService alloc] init];
    self.mirrawLayout = (MRProductCustomLayout *)self.collectionView.collectionViewLayout;
    self.mirrawLayout.aDelegate = self;
    
    [self.mirrawService fetchProductCategoryItemsForModel:self.categoryModel withCompletionBlock:^(NSArray *cItemsArray, id metadata, NSError *error)
     {
         if (error != nil)
         {
         }
         else if (cItemsArray && [cItemsArray count])
         {
             self.cItemsModelArray = cItemsArray;
         }
         
         if (metadata && [metadata isKindOfClass:[CategoryProductsMetadata class]])
         {
             self.pMetadata = (NSDictionary *)metadata;
             
         }
         [self.collectionView reloadData];
     }];

}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(100, 100);
//}
#pragma mark-
#pragma mark- UICollectionViewDelegateFlowLayout methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryItemModel *catModel = [self.cItemsModelArray objectAtIndex:indexPath.row];
    
    CGSize layoutSize;
    layoutSize = catModel.pImage.size.height > 0 ? catModel.pImage.size : CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
    CGFloat fitWidth = (self.view.frame.size.width-50)/2;
    CGSize fitSize = CGSizeMake(fitWidth, fitWidth *4/3);
    NSString *catName = catModel.pTitle;
    
    CGSize size = [catName sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:14.0f]}];
    CGFloat cheight = ceilf(size.height);
    //CGFloat cWidth = ceilf(size.width);
    //fitSize.width += cWidth;
    fitSize.height += cheight;
    return fitSize;
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    return edgeInsets;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat lineSpacing = 20.0;
    
    return lineSpacing;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat interCellSpace = 20.0;
    
    return interCellSpace;
}


#pragma mark-
#pragma mark- UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.cItemsModelArray count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryItemModel *catModel = [self.cItemsModelArray objectAtIndex:indexPath.row];
    
    ItemsCollectionViewCell *pCell;
    pCell = (ItemsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                      forIndexPath:indexPath];
    if (catModel.pImage)
    {
        [pCell.productImage setImage:catModel.pImage];
    }
    
    [pCell.productTitle setText:catModel.pTitle];
    [pCell.productActualPrice setText:catModel.pActualPrice];
    [pCell.productByName setText:[NSString stringWithFormat:@"By %@", catModel.pDesigner]];
    [pCell.priceSymbolOne setText:@"\u20B9"];
    [pCell.priceSymbolTwo setText:@"\u20B9"];
    if ([catModel.pDiscountPercent intValue] != 0)
    {
        NSAttributedString *theAttributedString;
        theAttributedString = [[NSAttributedString alloc] initWithString:catModel.pOriginalPrice
                                                              attributes:@{NSStrikethroughStyleAttributeName:
                                                                               [NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
        
        [pCell.productOriginalPrice setAttributedText:theAttributedString];
        [pCell.productDiscountPercent setText:[NSString stringWithFormat:@"%@ %%", [catModel.pDiscountPercent stringValue]]];
        [pCell.productOriginalPrice setHidden:NO];
        [pCell.productDiscountPercent setHidden:NO];
        [pCell.priceSymbolTwo setHidden:NO];
    }
    else
    {
        [pCell.productOriginalPrice setHidden:YES];
        [pCell.productDiscountPercent setHidden:YES];
        [pCell.priceSymbolTwo setHidden:YES];
        CGRect cellFrame = pCell.frame;
        [pCell setFrame:cellFrame];

    }
    return pCell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CategoryItemModel *)modelForItemAtIndexpath:(NSIndexPath *)indexPath
{
    CategoryItemModel *cItemModel = [self.cItemsModelArray objectAtIndex:indexPath.row];
    return cItemModel;
}

@end
