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


#define PRODUCT_CATEGORY_SERVICE_URL @"https://api.mirraw.com/api/v1/frontpage"
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

@property (nonatomic, strong) NSNumber *contentId;
@property (nonatomic, strong) NSNumber *contentGrade;
@property (nonatomic, strong) NSString *contentKey;
@property (nonatomic, strong) NSString *contentLink;
@property (nonatomic, strong) NSString *contentName;

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
                    NSString *catURLString = [NSString stringWithFormat:@"http://%@", catMainURL];
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
@end
