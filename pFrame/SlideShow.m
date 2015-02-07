//
//  SlideShow.m
//  pFrame
//
//  Created by lifeaether on 2015/02/07.
//  Copyright (c) 2015年 lifeaether. All rights reserved.
//

#import "SlideShow.h"
#import "PixivScrapper.h"
#import "FrameWindowController.h"
#import "AppConstants.h"

@interface SlideShow ()

@property (retain) PixivScrapper *pixiv;

@property (readonly) NSTimeInterval timeInterval;
@property (readonly) NSString *orderingType;
@property (readonly) NSInteger windowLevel;
@property (readonly) CGFloat sizeScale;

@property NSInteger currentImageIndex;
@property NSInteger numberOfImages;

@property (getter=isLoading, setter=setLoading:) BOOL loading;

@property NSTimer *timer;
- (void)timeFire:(NSTimer *)timer;

@property (retain) FrameWindowController *nextWindowController;
@property (retain) FrameWindowController *previousWindowController;

- (void)loadImageAtIndex:(NSInteger)index;
- (void)replaceImage:(NSDictionary *)imageItem;

@end

@implementation SlideShow

- (instancetype)init
{
    return [self initWithConfigure:nil];
}

- (instancetype)initWithConfigure:(NSDictionary *)configure
{
    self = [super init];
    if ( self ) {
        [self setPixiv:[[PixivScrapper alloc] init]];
        [self setCurrentImageIndex:0];
        [self setNumberOfImages:0];
        [self setLoading:NO];
        [self ready];
        
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:kApplicationPreferenceSlideShowTimeInterval options:NSKeyValueObservingOptionNew context:nil];
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:kApplicationPreferenceSlideShowLayer options:NSKeyValueObservingOptionNew context:nil];
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:kApplicationPreferenceSlideShowFrameSize options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:kApplicationPreferenceSlideShowTimeInterval];
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:kApplicationPreferenceSlideShowLayer];
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:kApplicationPreferenceSlideShowFrameSize];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( [keyPath isEqualToString:kApplicationPreferenceSlideShowLayer] ) {
        [[[self nextWindowController] window] setLevel:[self windowLevel]];
    } else if ( [keyPath isEqualToString:kApplicationPreferenceSlideShowFrameSize] ) {
        if ( [self nextWindowController] ) {
            [self replaceImage:[[self nextWindowController] imageItem]];
        }
    } else if ( [keyPath isEqualToString:kApplicationPreferenceSlideShowTimeInterval] ) {
        [self restart:nil];
    }
}

- (void)ready
{
    NSURLSessionTask *task = [[self pixiv] loadTaskForCountOfBookmark:^(NSInteger numberOfBookmark, NSError *error){
        if ( error ) {
            NSLog( @"loadTaskForCountOfBookmark\n%@", error );
        } else {
            NSLog( @"numberOfImage %ld", numberOfBookmark );
            dispatch_async( dispatch_get_main_queue(), ^() {
                [self setNumberOfImages:numberOfBookmark];
                [self loadImageAtIndex:0];
                [self start:nil];
            });
        }
    }];
    [task resume];
}

- (BOOL)isReady
{
    return [self numberOfImages] > 0;
}

- (BOOL)isStarted
{
    return [self timer] != nil;
}

- (NSTimeInterval)timeInterval
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kApplicationPreferenceSlideShowTimeInterval] floatValue];
}

- (NSString *)orderingType
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kApplicationPreferenceSlideShowOrdering];
}

- (NSInteger)windowLevel
{
    if ( [[[NSUserDefaults standardUserDefaults] valueForKey:kApplicationPreferenceSlideShowLayer] isEqualToString:kApplicationPreferenceSlideShowLayerNormal] ) {
        return kCGNormalWindowLevel;
    } else if ( [[[NSUserDefaults standardUserDefaults] valueForKey:kApplicationPreferenceSlideShowLayer] isEqualToString:kApplicationPreferenceSlideShowLayerMostFront] ) {
        return kCGFloatingWindowLevel;
    } else if ( [[[NSUserDefaults standardUserDefaults] valueForKey:kApplicationPreferenceSlideShowLayer] isEqualToString:kApplicationPreferenceSlideShowLayerMostBack] ) {
        return kCGDesktopIconWindowLevel+1;
    } else {
        return kCGNormalWindowLevel;
    }
}

- (CGFloat)sizeScale
{
    if ( [[[NSUserDefaults standardUserDefaults] valueForKey:kApplicationPreferenceSlideShowFrameSize] isEqualToString:kApplicationPreferenceSlideShowFrameSizeNormal] ) {
        return 0.66f;
    } else if ( [[[NSUserDefaults standardUserDefaults] valueForKey:kApplicationPreferenceSlideShowFrameSize] isEqualToString:kApplicationPreferenceSlideShowFrameSizeSmall] ) {
        return 0.33f;
    } else if ( [[[NSUserDefaults standardUserDefaults] valueForKey:kApplicationPreferenceSlideShowFrameSize] isEqualToString:kApplicationPreferenceSlideShowFrameSizeLarge] ) {
        return 1.0f;
    } else {
        return 0.5f;
    }
}

- (void)timeFire:(NSTimer *)timer
{
    if ( [[self orderingType] isEqualToString:kApplicationPreferenceSlideShowOrderingDefault] ) {
        [self next:nil];
    } else if ( [[self orderingType] isEqualToString:kApplicationPreferenceSlideShowOrderingRandomize] ) {
        [self random:nil];
    } else {
        [self next:nil];
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:[self timeInterval]
                                             target:self
                                           selector:@selector(timeFire:) userInfo:nil
                                            repeats:NO];
    [self setTimer:timer];
}

- (void)loadImageAtIndex:(NSInteger)index
{
    [self setLoading:YES];
    
    PixivScrapper *pixiv = [self pixiv];
    NSInteger countPerPage = [pixiv countPerPage];
    NSInteger indexOfPage = index / countPerPage + 1;
    NSURLSessionTask *task1 = [pixiv loadTaskForIdentifiersOnBookmarkAtPageIndex:indexOfPage completionHandler:^(NSArray *identifiers, NSError *error){
        NSLog( @"%@, %@", identifiers, error );
        if ( error ) {
            [self setLoading:NO];
        } else {
            NSInteger indexOnPage = index % countPerPage;
            if ( indexOnPage < [identifiers count] ) {
                NSString *identifier = [identifiers objectAtIndex:indexOnPage];
                NSURLSessionTask *task2 = [pixiv loadTaskForImageURLWithIdentifier:identifier completionHandler:^(NSURL *imageURL, NSError *error){
                    NSLog( @"%@, %@", imageURL, error );
                    if ( error ) {
                        [self setLoading:NO];
                    } else {
                        NSURLSessionTask *task3 = [pixiv loadTaskForImageWithIdentifer:identifier imageURL:imageURL completionHandler:^(NSBitmapImageRep *imageRep, NSError *error){
                            NSLog( @"%@, %@", imageRep, error );
                            if ( error || ! imageRep ) {
                                [self setLoading:NO];
                            } else {
                                [self setLoading:NO];
                                
                                NSSize size = NSMakeSize( [imageRep pixelsWide], [imageRep pixelsHigh] );
                                NSImage *image = [[NSImage alloc] initWithSize:size];
                                [image addRepresentation:imageRep];
                                [self performSelectorOnMainThread:@selector(replaceImage:) withObject:@{@"image":image,@"identifier":identifier} waitUntilDone:NO];
                            }
                        }];
                        [task3 resume];
                    }
                }];
                [task2 resume];
            } else {
                NSLog( @"showImageAtIndex: out of index." );
            }
        }
    }];
    
    [task1 resume];
}

- (void)replaceImage:(NSDictionary *)imageItem
{
    FrameWindowController *previous = [self nextWindowController];
    FrameWindowController *next = [[FrameWindowController alloc] initWithImageItem:imageItem];
    
    NSRect screenFrame = [[[(previous ? previous : next) window] screen] visibleFrame];
    NSRect previousFrame = [[(previous ? previous : next) window] frame];
    
    CGFloat sizeScale = [self sizeScale];
    NSSize imageSize = [[imageItem valueForKey:@"image"] size];
    if ( imageSize.width > screenFrame.size.width * sizeScale ) {
        NSSize newSize = NSMakeSize( screenFrame.size.width * sizeScale, screenFrame.size.width * sizeScale * imageSize.height / imageSize.width );
        imageSize = newSize;
    }
    if ( imageSize.height > screenFrame.size.height * sizeScale ) {
        NSSize newSize = NSMakeSize( screenFrame.size.height * sizeScale * imageSize.width / imageSize.height, screenFrame.size.height * sizeScale );
        imageSize = newSize;
    }
    NSPoint center = NSMakePoint( NSMidX( previousFrame ), NSMidY( previousFrame ) );
    NSRect nextFrame = NSMakeRect( center.x - imageSize.width/2, center.y - imageSize.height/2, imageSize.width, imageSize.height );
    [[next window] setFrame:nextFrame display:NO];
    
    [[next window] setLevel:[self windowLevel]];
    
    [previous fadeOut:nil];
    [next fadeIn:nil];
    
    [self setPreviousWindowController:previous];
    [self setNextWindowController:next];
}

- (IBAction)start:(id)sender
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:[self timeInterval]
                                                      target:self
                                                    selector:@selector(timeFire:) userInfo:nil
                                                     repeats:NO];
    [self setTimer:timer];
}

- (IBAction)stop:(id)sender
{
    [[self timer] invalidate];
    [self setTimer:nil];
}

- (IBAction)restart:(id)sender
{
    [self stop:self];
    [self start:self];
}

- (IBAction)next:(id)sender
{
    NSInteger nextIndex = MIN( [self currentImageIndex] + 1, [self numberOfImages]-1 );
    [self setCurrentImageIndex:nextIndex];
    [self loadImageAtIndex:[self currentImageIndex]];
    if ( [self isStarted] ) {
        [self restart:sender];
    }
}

- (IBAction)previous:(id)sender
{
    NSInteger previousIndex = MAX( [self currentImageIndex] - 1, 0 );
    [self setCurrentImageIndex:previousIndex];
    [self loadImageAtIndex:[self currentImageIndex]];
    if ( [self isStarted] ) {
        [self restart:sender];
    }
}

- (IBAction)random:(id)sender
{
    [self setCurrentImageIndex:arc4random()%[self numberOfImages]];
    [self loadImageAtIndex:[self currentImageIndex]];
    if ( [self isStarted] ) {
        [self restart:sender];
    }
}

- (IBAction)open:(id)sender
{
    NSString *identifier = [[[self nextWindowController] imageItem] valueForKey:@"identifier"];
    NSString *urlString = [NSString stringWithFormat:@"http://www.pixiv.net/member_illust.php?mode=medium&illust_id=%@", identifier];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]];
}

@end
