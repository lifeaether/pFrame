//
//  FrameWindowController.m
//  pFrame
//
//  Created by lifeaether on 2015/02/07.
//  Copyright (c) 2015年 lifeaether. All rights reserved.
//

#import "FrameWindowController.h"
#import "AppConstants.h"

@interface FrameWindowController ()

@property (retain) NSDictionary *imageItem;
@property (readonly) NSTimeInterval fadeDuration;

@end

@implementation FrameWindowController

- (instancetype)initWithImageItem:(NSDictionary *)imageItem
{
    self = [super initWithWindowNibName:@"FrameWindowController"];
    if ( self ) {
        [self setImageItem:imageItem];
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (NSTimeInterval)fadeDuration
{
    NSString *effect = [[NSUserDefaults standardUserDefaults] valueForKey:kApplicationPreferenceSlideShowEffect];
    if ( [effect isEqualToString:kApplicationPreferenceSlideShowEffectFade] ) {
        return 1.f;
    } else if ( [effect isEqualToString:kApplicationPreferenceSlideShowEffectFadeQuickly] ) {
        return 0.5f;
    } else if ( [effect isEqualToString:kApplicationPreferenceSlideShowEffectFadeSlowly] ) {
        return 1.5f;
    } else {
        abort();
        return 2.f;
    }
}

- (IBAction)fadeIn:(id)sender
{
    NSWindow *window = [self window];
    [window setAlphaValue:0.f];
    [window makeKeyAndOrderFront:nil];
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:[self fadeDuration]];
    [[window animator] setAlphaValue:1.f];
    [NSAnimationContext endGrouping];
}

- (IBAction)fadeOut:(id)sender
{
    NSWindow *window = [self window];
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:[self fadeDuration]];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [window orderOut:nil];
        [window setAlphaValue:1.f];
    }];
    [[window animator] setAlphaValue:0.f];
    [NSAnimationContext endGrouping];
}

@end
