//
//  PixivScrapper.m
//  pFrame
//
//  Created by lifeaether on 2014/10/25.
//  Copyright (c) 2014年 lifeaether. All rights reserved.
//

#import "PixivScrapper.h"

NSString * const kDefinitionKeyBookmarkURL      = @"pixiv.url.bookmark";
NSString * const kDefinitionKeyBookmarkPageURL  = @"pixiv.url.bookmarkpage";
NSString * const kDefinitionKeyIllustURL        = @"pixiv.url.illust.medium";
NSString * const kDefinitionKeyImageURL         = @"pixiv.url.illust.big";

NSString * const kDefinitionKeyBookmarkCountXPath       = @"pixiv.bookmark.count";
NSString * const kDefinitionKeyBookmarkIdentifiersXPath = @"pixiv.bookmark.identifiers";
NSString * const kDefinitionKeyImageXPath               = @"pixiv.illust.big.image";

@interface PixivScrapper ()

@property (copy) NSDictionary *definition;

- (NSURL *)urlForKeyPath:(NSString *)keypath;
- (NSString *)xpathForKeyPath:(NSString *)keypath;

@end

@implementation PixivScrapper

- (instancetype)init
{
    return [self initWithScrapingDifinition:@{
                             @"pixiv":@{
                                     @"url":@{
                                             @"bookmark":@"http://www.pixiv.net/bookmark.php",
                                             @"bookmarkpage":@"http://www.pixiv.net/bookmark.php?p=%ld",
                                             @"illust":@{
                                                     @"big":@"http://www.pixiv.net/member_illust.php?mode=big&illust_id=%@",
                                                     @"medium":@"http://www.pixiv.net/member_illust.php?mode=medium&illust_id=%@"
                                                     }
                                             },
                                     @"bookmark":@{
                                             @"count":@"/html/body/div[@id='wrapper']/div[@class='layout-a']/div[@class='layout-column-2']/div/div/span",
                                             @"identifiers":@"/html/body/div[@id='wrapper']/div[@class='layout-a']/div[@class='layout-column-2']/div[@class='_unit manage-unit']/form/div[@class='display_editable_works']/ul/li/a[1]/@href"
                                             },
                                     @"illust":@{
                                             @"big":@{
                                                     @"image":@"/html/body/img/@src"
                                                     }
                                             }
                                     }
                             }];

}

- (instancetype)initWithScrapingDifinition:(NSDictionary *)definition
{
    self = [super init];
    if ( self ) {
        [self setDefinition:definition];
    }
    return self;
}

- (NSURL *)urlForKeyPath:(NSString *)keypath
{
    return [NSURL URLWithString:[[self definition] valueForKeyPath:keypath]];
}

- (NSString *)xpathForKeyPath:(NSString *)keypath
{
    return [[self definition] valueForKeyPath:keypath];
}

- (NSURLSessionTask *)loadTaskForCountOfBookmark:(void (^)(NSInteger count, NSError *error))completionHandler;
{
    NSURLSession *session = [NSURLSession sharedSession];
    return [session dataTaskWithURL:[self urlForKeyPath:kDefinitionKeyBookmarkURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if ( error ) {
            completionHandler( 0, error );
        } else {
            NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:data options:NSXMLDocumentTidyHTML error:&error];
            NSArray *nodes = [document nodesForXPath:[self xpathForKeyPath:kDefinitionKeyBookmarkCountXPath] error:&error];
            if ( [nodes count] > 0 ) {
                NSString *bookmarkCountString = [[nodes objectAtIndex:0] stringValue];
                NSScanner *scanner = [NSScanner scannerWithString:bookmarkCountString];
                NSInteger count = 0;
                if ( [scanner scanInteger:&count] ) {
                    completionHandler( count, nil );
                } else {
                    completionHandler( 0, error );
                }
            } else {
                completionHandler( 0, error );
            }
        }
    }];
}

- (NSURLSessionTask *)loadTaskForIdentifiersOnBookmarkAtPageIndex:(NSInteger)index completionHandler:(void (^)(NSArray *identifiers, NSError *error))completionHandler
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:[[self definition] valueForKeyPath:kDefinitionKeyBookmarkPageURL], index]];
    return [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ( error ) {
            completionHandler( nil, error );
        } else {
            NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:data options:NSXMLDocumentTidyHTML error:&error];
            NSArray *nodes = [document nodesForXPath:[self xpathForKeyPath:kDefinitionKeyBookmarkIdentifiersXPath] error:&error];
            if ( [nodes count] ) {
                NSMutableArray *identifiers = [NSMutableArray array];
                for ( NSXMLElement *element in nodes ) {
                    NSString *identiferString = [element stringValue];
                    NSScanner *scanner = [NSScanner scannerWithString:identiferString];
                    NSInteger identifier = 0;
                    if ( [scanner scanUpToString:@"illust_id=" intoString:nil] &&
                        [scanner scanString:@"illust_id=" intoString:nil] &&
                        [scanner scanInteger:&identifier] ) {
                        [identifiers addObject:[NSString stringWithFormat:@"%ld", identifier]];
                    } else {
                        // ???
                    }
                }
                completionHandler( identifiers, nil );
            } else {
                completionHandler( nil, error );
            }
        }
    }];
}

- (NSURLSessionTask *)loadTaskForImageURLWithIdentifier:(NSString *)identifier completionHandler:(void (^)(NSURL *imageURL, NSError *error))completionHandler
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:[[self definition] valueForKeyPath:kDefinitionKeyImageURL], identifier]];
    NSString *referer = [NSString stringWithFormat:[[self definition] valueForKeyPath:kDefinitionKeyIllustURL], identifier];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:referer forHTTPHeaderField:@"Referer"];
    return [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ( error ) {
            completionHandler( nil, error );
        } else {
            NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:data options:NSXMLDocumentTidyHTML error:&error];
            NSArray *nodes = [document nodesForXPath:[self xpathForKeyPath:kDefinitionKeyImageXPath] error:&error];
            if ( [nodes count] > 0 ) {
                completionHandler( [NSURL URLWithString:[[nodes objectAtIndex:0] stringValue]], nil );
            } else {
                completionHandler( nil, error );
            }
        }
    }];
}

- (NSURLSessionTask *)loadTaskForImageWithIdentifer:(NSString *)identifier imageURL:(NSURL *)imageURL completionHandler:(void (^)(NSBitmapImageRep *image, NSError *error))completionHandler
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *referer = [NSString stringWithFormat:[[self definition] valueForKeyPath:kDefinitionKeyImageURL], identifier];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageURL];
    [request setValue:referer forHTTPHeaderField:@"Referer"];
    return [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ( error ) {
            completionHandler( nil, error );
        } else {
            completionHandler( [[NSBitmapImageRep alloc] initWithData:data], nil );
        }
    }];
}

- (NSInteger)countPerPage
{
    return 20;
}

@end
