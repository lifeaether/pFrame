//
//  PixivScrapper.h
//  pFrame
//
//  Created by lifeaether on 2014/10/25.
//  Copyright (c) 2014年 lifeaether. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * const kDefinitionKeyBookmarkURL;
extern NSString * const kDefinitionKeyBookmarkPageURL;
extern NSString * const kDefinitionKeyIllustURL;
extern NSString * const kDefinitionKeyImageURL;

extern NSString * const kDefinitionKeyBookmarkCountXPath;
extern NSString * const kDefinitionKeyBookmarkIdentifiersXPath;
extern NSString * const kDefinitionKeyImageXPath;

@interface PixivScrapper : NSObject

- (instancetype)init;
- (instancetype)initWithScrapingDifinition:(NSDictionary *)definition;

- (NSURLSessionTask *)loadTaskForCountOfBookmark:(void (^)(NSInteger count, NSError *error))completionHandler;
- (NSURLSessionTask *)loadTaskForIdentifiersOnBookmarkAtPageIndex:(NSInteger)index completionHandler:(void (^)(NSArray *identifiers, NSError *error))completionHandler;
- (NSURLSessionTask *)loadTaskForImageURLWithIdentifier:(NSString *)identifier completionHandler:(void (^)(NSURL *imageURL, NSError *error))completionHandler;
- (NSURLSessionTask *)loadTaskForImageWithIdentifer:(NSString *)identifier imageURL:(NSURL *)imageURL completionHandler:(void (^)(NSBitmapImageRep *image, NSError *error))completionHandler;


- (NSInteger)countPerPage;

@end
