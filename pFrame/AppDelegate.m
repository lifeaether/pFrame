//
//  AppDelegate.m
//  pFrame
//
//  Created by lifeaether on 2014/10/24.
//  Copyright (c) 2014年 lifeaether. All rights reserved.
//

#import "AppDelegate.h"
#import "FrameWindowController.h"

#import "PixivScrapper.h"

@interface AppDelegate ()

@property NSUInteger numberOfImage;
@property NSMutableDictionary *images;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self setNumberOfImage:0];
    [self setImages:[NSMutableDictionary dictionary]];

    [[self frameWindowController] showWindow:self];
    [[self frameWindowController] setDataSource:self];
    
    PixivScrapper *scrapper = [self sharedScrapper];
    NSURLSessionTask *task = [scrapper loadTaskForCountOfBookmark:^(NSInteger count, NSError *error){
        [self setNumberOfImage:count];
        [[self frameWindowController] reloadData];
    }];
    [task resume];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (PixivScrapper *)sharedScrapper
{
    return [[PixivScrapper alloc] initWithScrapingDifinition:@{
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

- (NSUInteger)numberOfFrameImage:(id)frameWindowController
{
    return [self numberOfImage];
}

- (BOOL)readyImageAtIndex:(id)frameWindowController atIndex:(NSUInteger)index
{
    NSDictionary *images = [self images];
    NSString *key = [NSString stringWithFormat:@"%ld", index];
    if ( [images valueForKey:key] ) {
        return YES;
    } else {
        PixivScrapper *scrapper = [self sharedScrapper];
        NSUInteger page = index / [scrapper countPerPage] + 1;
        NSURLSessionTask *task1 = [scrapper loadTaskForIdentifiersOnBookmarkAtPageIndex:page completionHandler:^(NSArray *identifiers, NSError *error) {
            if ( error ) {
                [images setValue:[NSNull null] forKey:key];
            } else {
                if ( (index % [scrapper countPerPage]) < [identifiers count] ) {
                    NSString *identifier = [identifiers objectAtIndex:index % [scrapper countPerPage]];
                    NSURLSessionTask *task2 = [scrapper loadTaskForImageURLWithIdentifier:identifier completionHandler:^(NSURL *imageURL, NSError *error) {
                        if ( error ) {
                            [images setValue:[NSNull null] forKey:key];
                        } else {
                            NSURLSessionTask *task3 = [scrapper loadTaskForImageWithIdentifer:identifier imageURL:imageURL completionHandler:^(NSImage *image, NSError *error) {
                                if ( error ) {
                                    [images setValue:[NSNull null] forKey:key];
                                } else {
                                    NSArray *representations = [image representations];
                                    if ( [representations count] ) {
                                        NSImageRep *representation = [representations objectAtIndex:0];
                                        NSSize newSize = NSMakeSize( [representation pixelsWide], [representation pixelsHigh] );
                                        [image setSize:newSize];
                                    }
                                    [images setValue:image forKey:key];
                                }
                            }];
                            [task3 resume];
                        }
                    }];
                    [task2 resume];
                } else {
                    [images setValue:[NSNull null] forKey:key];
                }
            }
        }];
        [task1 resume];
        return NO;
    }
}

- (NSImage *)imageAtIndex:(id)frameWindowController atIndex:(NSUInteger)index
{
    NSDictionary *images = [self images];
    NSString *key = [NSString stringWithFormat:@"%ld", index];
    return [images valueForKey:key];
}

@end
