//
//  ViewController.m
//  MirrawSampleApp
//
//  Created by Vishal Bhadade on 18/01/16.
//  Copyright (c) 2016 Mirraw. All rights reserved.
//

#import "CategoryViewController.h"
#import "ProductCategoryCell.h"
#import "MirrawService.h"
#import "CategoryModel.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "CategoryItemsCollectionViewController.h"
#import "MRCategoryCustomLayout.h"

#define CATEGORY_CELL_IDENTIFIER @"mrCategoryCell"

#define CATEGORY_ID                 @"id"
#define CATEGORY_GRADE              @"grade"
#define CATEGORY_KEY                @"key"
#define CATEGORY_LINK               @"link"
#define CATEGORY_NAME               @"name"
#define CATEGORY_PHOTO              @"photo"
#define CATEGORY_SIZES              @"sizes"
#define CATEGORY_MAIN_IMAGE_URL     @"main"
#define CATEGORY_ORIGINAL_IMAGE_URL @"original"
#define CATEGORY_VALUE              @"value"

#define SHOW_CATEGORY_PRODUCTS_VC @"showCategoryProductsVC"

@interface CategoryViewController ()
<
  UICollectionViewDataSource,
  UICollectionViewDelegateFlowLayout,
  CategoryCustomLayoutDelegate
>

@property (nonatomic, strong) MirrawService *mirrawService;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *categoryModelArray;
@property (nonatomic, strong) MRCategoryCustomLayout *catLayout;
@end

@implementation CategoryViewController

- (void)loadView
{
    [super loadView];
    self.mirrawService = [[MirrawService alloc] init];
    self.catLayout = (MRCategoryCustomLayout *)[self.collectionView collectionViewLayout];
    self.catLayout.cDelegate = self;

    [self.mirrawService fetchProductCategoryDetails:^(NSArray *catArray, NSError *error)
    {
        if (error != nil)
        {
            
        }
        else if (catArray && [catArray count])
        {
            self.categoryModelArray = catArray;
            [self.collectionView reloadData];
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    [self.collectionView setBackgroundColor:[UIColor darkGrayColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark- UICollectionViewDelegateFlowLayout methods

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CategoryModel *catModel = [self.categoryModelArray objectAtIndex:indexPath.row];
//    
//    CGSize layoutSize;
//    layoutSize = catModel.categoryMainImage.size.height > 0 ? catModel.categoryMainImage.size : CGSizeMake(self.view.frame.size.width, 150);
//    //layoutSize.height += 10;
//    //layoutSize.width += 10;
//    CGSize fitSize = CGSizeMake((self.view.frame.size.width-50)/2, layoutSize.height);
//    NSString *catName = catModel.categoryName;
//
//    CGSize size = [catName sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:14.0f]}];
//    CGFloat cheight = ceilf(size.height);
//    CGFloat cWidth = ceilf(size.width);
//    //fitSize.width += cWidth;
//    fitSize.height += cheight;
//    return fitSize;
//    
//}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
//    return edgeInsets;
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    CGFloat lineSpacing = 20.0;
//    
//    return lineSpacing;
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    CGFloat interCellSpace = 20.0;
//    
//    return interCellSpace;
//}
//

#pragma mark-
#pragma mark- UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.categoryModelArray count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryModel *catModel = [self.categoryModelArray objectAtIndex:indexPath.row];
    
    ProductCategoryCell *pCell;
    pCell = [collectionView dequeueReusableCellWithReuseIdentifier:CATEGORY_CELL_IDENTIFIER
                                                      forIndexPath:indexPath];
    if (catModel.categoryMainImage)
    {
        [pCell.catImage setImage:catModel.categoryMainImage];
    }
    
    pCell.categoryCellHeightConstraint.constant = pCell.catImage.frame.size.height;
    pCell.categoryTitleHeightConstraint.constant = pCell.catTitle.frame.size.height;
    pCell.categoryImageWidthConstraint.constant = pCell.catImage.frame.size.width;
    pCell.categoryTitleWidthConstraint.constant = pCell.catTitle.frame.size.width;
    [pCell.catTitle setText:catModel.categoryName];
    return pCell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark-
#pragma mark- UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryModel *cModel = [self.categoryModelArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:SHOW_CATEGORY_PRODUCTS_VC sender:cModel];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)catModel
{
    if ([segue.identifier isEqualToString:SHOW_CATEGORY_PRODUCTS_VC])
    {
        CategoryItemsCollectionViewController *cItemsVC = (CategoryItemsCollectionViewController *)segue.destinationViewController;
        cItemsVC.categoryModel = (CategoryModel *)catModel;
    }
}

- (CategoryModel *)categoryModelForItemAtIndexpath:(NSIndexPath *)indexPath
{
    CategoryModel *cModel = [self.categoryModelArray objectAtIndex:indexPath.row];
    return cModel;
}
@end
