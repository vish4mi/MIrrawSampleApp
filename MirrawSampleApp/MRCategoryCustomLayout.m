//
//  MRCategoryCustomLayout.m
//  MirrawSampleApp
//
//  Created by Vishal Bhadade on 25/01/16.
//  Copyright (c) 2016 Mirraw. All rights reserved.
//

#import "MRCategoryCustomLayout.h"
#import "ProductCategoryCell.h"

@interface MRCategoryCustomLayout()
{
    NSMutableDictionary *_layoutAttributes;
    CGSize _contentSize;
}

@end

@implementation MRCategoryCustomLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    _layoutAttributes = [NSMutableDictionary dictionary]; // 1
    
    NSUInteger numberOfSections = [self.collectionView numberOfSections]; // 3
    
    CGFloat y1Offset = self.verticalInset;
    CGFloat y2Offset = self.verticalInset;
    CGFloat yOffset = 0.0;
    for (int section = 0; section < numberOfSections; section++)
    {
        NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:section]; // 3
        
        CGFloat xOffset = self.horizontalInset;
        
        for (int item = 0; item < numberOfItems; item++)
        {
            if ((item + 1)%2 == 0)
            {
                yOffset = y2Offset;
            }
            else
            {
                yOffset = y1Offset;
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath]; // 4
            
            CategoryModel *cItem;
            cItem = [self.cDelegate categoryModelForItemAtIndexpath:indexPath];
            CGSize itemSize = cItem.categoryMainImage.size;

            if (itemSize.height == 0)
            {
                itemSize.height = 150.0f;
            }

            itemSize.width = (self.collectionView.frame.size.width - self.horizontalInset - self.horizontalInset - self.horizontalInset)/2;
            
            CGSize size = [cItem.categoryName sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:14.0f]}];
            if (size.width > itemSize.width-10)
            {
                itemSize.height += 40;
            }
            else
            {
                itemSize.height += 20;
            }
            //itemSize.height += size.height;
            
            attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));
            NSString *key = [self layoutKeyForIndexPath:indexPath];
            _layoutAttributes[key] = attributes; // 7
            
            xOffset += itemSize.width;
            xOffset += self.horizontalInset; // 8
            yOffset += itemSize.height;
            yOffset += self.verticalInset;
            
            if ((item + 1)%2 == 0)
            {
                y2Offset = yOffset;
                xOffset = self.horizontalInset;
            }
            else
            {
                y1Offset = yOffset;
            }
            
        }
    }
    
    if (y1Offset > y2Offset)
    {
        y1Offset += self.verticalInset; // 10
        y2Offset = y1Offset;
    }
    else
    {
        y2Offset += self.verticalInset;
        y1Offset = y2Offset;
    }
    
    _contentSize = CGSizeMake(self.collectionView.frame.size.width, yOffset + self.verticalInset); // 11
}


- (NSString *)layoutKeyForIndexPath:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"%ld_%ld", (long)indexPath.section, (long)indexPath.row];
}

- (NSString *)layoutKeyForHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"s_%ld_%ld", (long)indexPath.section, (long)indexPath.row];
}


- (CGSize)collectionViewContentSize
{
    return _contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *headerKey = [self layoutKeyForHeaderAtIndexPath:indexPath];
    return _layoutAttributes[headerKey];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self layoutKeyForIndexPath:indexPath];
    return _layoutAttributes[key];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
        UICollectionViewLayoutAttributes *layoutAttribute = _layoutAttributes[evaluatedObject];
        return CGRectIntersectsRect(rect, [layoutAttribute frame]);
    }];
    
    NSArray *matchingKeys = [[_layoutAttributes allKeys] filteredArrayUsingPredicate:predicate];
    return [_layoutAttributes objectsForKeys:matchingKeys notFoundMarker:[NSNull null]];
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return !(CGSizeEqualToSize(newBounds.size, self.collectionView.frame.size));
}
@end

