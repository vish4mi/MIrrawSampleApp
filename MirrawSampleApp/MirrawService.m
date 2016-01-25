//
//  MirrawService.m
//  MirrawSampleApp
//
//  Created by Vishal Bhadade on 18/01/16.
//  Copyright (c) 2016 Mirraw. All rights reserved.
//

#import "MirrawService.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "CategoryProductsMetadata.h"
#import "CategoryItemModel.h"

#define PRODUCT_CATEGORY_SERVICE_URL @"https://api.mirraw.com/api/v1/frontpage"
#define PRODUCT_CATEGORY_ITEMS_SERVICE_URL @"https://api.mirraw.com/api/v1/search?%@=%@&page=1"

#define MODEL_KEY_BLOCK @"blocks"

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
#define CATEGORY_SIZES              @"sizes"

@interface MirrawService ()
<
   NSURLConnectionDataDelegate
>

@property (nonatomic, strong) NSNumber *contentId;
@property (nonatomic, strong) NSNumber *contentGrade;
@property (nonatomic, strong) NSString *contentKey;
@property (nonatomic, strong) NSString *contentLink;
@property (nonatomic, strong) NSString *contentName;
@property (nonatomic, strong) NSMutableData *cItemsData;
@property (nonatomic, strong) NSDictionary *categoryCollections;
@property (nonatomic, copy) cItemsServiceCompletionBlock aCompletionBlock;

@end
@implementation MirrawService

- (void)fetchProductCategoryDetails:(categoryServiceCompletionBlock)completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        NSError *error = nil;
        NSString *searchResultString = [NSString stringWithContentsOfURL:[NSURL URLWithString:PRODUCT_CATEGORY_SERVICE_URL]
                                                                encoding:NSUTF8StringEncoding
                                                                   error:&error];
        if (error != nil)
        {
            completionBlock(nil, error);
        }
        else
        {
            // Parse the JSON Response
            NSData *jsonData = [searchResultString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *searchResultsDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                              options:kNilOptions
                                                                                error:&error];
            if(error != nil)
            {
                completionBlock(nil,error);
            }
            else
            {
                NSArray *catArray = [searchResultsDict valueForKey:MODEL_KEY_BLOCK];
                NSMutableArray *catModelArray = [[NSMutableArray alloc] init];
                
                NSNumber *catId = [NSNumber numberWithInt:-1];
                NSNumber *catGrade = [NSNumber numberWithInt:-1];
                NSString *catKey = @"";
                NSString *catLink = @"";
                NSString *catName = @"";
                NSString *catMainURL = @"";
                NSString *catOriginalURL = @"";
                NSString *catValue = @"";
                
                NSURLSessionConfiguration *defConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
                NSURLSession *defSession = [NSURLSession sessionWithConfiguration:defConfig
                                                                         delegate:nil
                                                                    delegateQueue:[NSOperationQueue mainQueue]];
                for (NSDictionary *catDict in catArray)
                {
                    catId = [catDict valueForKey:CATEGORY_ID];
                    catGrade = [catDict valueForKey:CATEGORY_GRADE];
                    catKey = [catDict valueForKey:CATEGORY_KEY];
                    catLink = [catDict valueForKey:CATEGORY_LINK];
                    catName = [catDict valueForKey:CATEGORY_NAME];
                    catValue = [catDict valueForKey:CATEGORY_VALUE];
                    
                    NSDictionary *pSizeDict = [catDict valueForKey:CATEGORY_PHOTO];
                    NSDictionary *photoDict = [pSizeDict valueForKey:CATEGORY_SIZES];
                    if (photoDict && [photoDict count])
                    {
                        catMainURL = [photoDict valueForKey:CATEGORY_MAIN_IMAGE_URL];
                        catOriginalURL = [photoDict valueForKey:CATEGORY_ORIGINAL_IMAGE_URL];
                    }
                    
                    CategoryModel *catModel = [[CategoryModel alloc] init];
                    [catModel setCategoryName:catName];
                    [catModel setCategoryKey:catKey];
                    [catModel setCategoryValue:catValue];
                    
                    NSString *catURLString = [NSString stringWithFormat:@"http://%@", catOriginalURL];
                    NSURL *mainImageURL = [NSURL URLWithString:catURLString];
                    
                    __block CategoryModel *ctModel = catModel;
                    NSURLSessionDataTask *dTask = [defSession dataTaskWithURL:mainImageURL
                                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                                   {
                                                       if (error != nil)
                                                       {
                                                           
                                                       }
                                                       else
                                                       {
                                                           [ctModel setCategoryMainImage:[UIImage imageWithData:data]];
                                                           completionBlock(catModelArray, nil);
                                                       }
                                                   }];
                    
                    [dTask resume];
                    [catModelArray addObject:catModel];
                }

                completionBlock(catModelArray, nil);
            }
        }
    });
}

- (void)fetchProductCategoryItemsForModel:(CategoryModel *)cModel withCompletionBlock:(cItemsServiceCompletionBlock)completionBlock
{
    self.aCompletionBlock = completionBlock;
    __block CategoryModel *catModel = cModel;
    __block MirrawService *aSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        NSString *itemURLString = [NSString stringWithFormat:PRODUCT_CATEGORY_ITEMS_SERVICE_URL, catModel.categoryKey, catModel.categoryValue];
        itemURLString = [itemURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *pURL = [NSURL URLWithString:itemURLString];
        NSMutableURLRequest *pRequest = [NSMutableURLRequest requestWithURL:pURL];
        [pRequest setHTTPMethod:@"GET"];
        [pRequest setValue:@"a2487f5de1a4c4e5d99e459f7b8a4bc577238ff11792499235bfa86e71443a43" forHTTPHeaderField:@"token"];
        UIDevice *device = [UIDevice currentDevice];
        NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
        [pRequest setValue:currentDeviceId forHTTPHeaderField:@"Device-ID"];
        [pRequest setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
        NSURLConnection *pConnection = [[NSURLConnection alloc] initWithRequest:pRequest delegate:aSelf];
        [pConnection start];

    });
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.cItemsData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.cItemsData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    self.categoryCollections = [NSJSONSerialization JSONObjectWithData:self.cItemsData
                                                                      options:kNilOptions
                                                                        error:&error];
    
   
    NSURLSessionConfiguration *defConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defSession = [NSURLSession sessionWithConfiguration:defConfig
                                                             delegate:nil
                                                        delegateQueue:[NSOperationQueue mainQueue]];
    
    if (error != nil)
    {
    }
    else
    {
        NSMutableArray *pItemsArray = [[NSMutableArray alloc] init];
        if (self.categoryCollections && [self.categoryCollections count])
        {
            NSDictionary *responseDict = [self.categoryCollections valueForKey:@"search"];
            if (responseDict && [responseDict count])
            {
                CategoryProductsMetadata *pMetadata = [[CategoryProductsMetadata alloc] init];
                [pMetadata setProductCount:[responseDict valueForKey:@"results"]];
                [pMetadata setHexSymbol:[responseDict valueForKey:@"hex_symbol"]];
                [pMetadata setPriceSymbol:[responseDict valueForKey:@"symbol"]];
                [pMetadata setNextPage:[responseDict valueForKey:@"next_page"]];
                [pMetadata setPreviousPage:[responseDict valueForKey:@"previous_page"]];
                [pMetadata setTotalPages:[responseDict valueForKey:@"total_pages"]];
                
                
                NSArray *responseArray = [responseDict valueForKey:@"designs"];
                for (NSDictionary *dict in responseArray)
                {
                    CategoryItemModel *cItemModel = [[CategoryItemModel alloc] init];
                    [cItemModel setPId:[dict valueForKey:@"id"]];
                    [cItemModel setPTitle:[dict valueForKey:@"title"]];
                    [cItemModel setPCategoryName:[dict valueForKey:@"category_name"]];
                    [cItemModel setPDesignPath:[dict valueForKey:@"design_path"]];
                    [cItemModel setPHexSymbol:[dict valueForKey:@"hex_symbol"]];
    
                    
                    [cItemModel setPActualPrice:[[dict valueForKey:@"discount_price"] stringValue]];
                    [cItemModel setPOriginalPrice:[[dict valueForKey:@"price"] stringValue]];
                    
                    [cItemModel setPDiscountPercent:[dict valueForKey:@"discount_percent"]];
                    [cItemModel setPDesigner:[dict valueForKey:@"designer"]];
                    [cItemModel setPBrand:[dict valueForKey:@"brand"]];
                    [cItemModel setPCachedSlug:[dict valueForKey:@"cached_slug"]];
                    [cItemModel setPGrade:[dict valueForKey:@"grade"]];
                    [cItemModel setPStockState:[dict valueForKey:@"state"]];
                    [cItemModel setPImage:[dict valueForKey:@""]];
                                      
                    NSDictionary *imageURLs = [dict valueForKey:@"sizes"];
                    NSString *pImageURLString = nil;
                    if (imageURLs  && [imageURLs count])
                    {
                        pImageURLString = [imageURLs valueForKey:@"large"];
                    }
                    
                    NSString *pURLString = [NSString stringWithFormat:@"http://%@", pImageURLString];
                    NSURL *pImageURL = [NSURL URLWithString:pURLString];
                    
                    __block CategoryProductsMetadata *cProMetadata = pMetadata;
                    __block CategoryItemModel *itemModel = cItemModel;
                    __weak MirrawService *weakSelf = self;
                    NSURLSessionDataTask *dTask = [defSession dataTaskWithURL:pImageURL
                                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                                   {
                                                       if (error != nil)
                                                       {
                                                           
                                                       }
                                                       else
                                                       {
                                                           [itemModel setPImage:[UIImage imageWithData:data]];
                                                           weakSelf.aCompletionBlock(pItemsArray, cProMetadata, error);
                                                       }
                                                   }];
                    
                    [dTask resume];
                    [pItemsArray addObject:cItemModel];
                    
                }
                self.aCompletionBlock(pItemsArray, pMetadata, error);
            }
            
            
        }
    }
}

@end
