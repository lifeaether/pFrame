//
//  FrameWindow.m
//  pFrame
//
//  Created by lifeaether on 2014/10/25.
//  Copyright (c) 2014年 lifeaether. All rights reserved.
//

#import "FrameWindow.h"

@implementation FrameWindow

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
    if ( self ) {
//        [self setOpaque:NO];
//        [self setBackgroundColor:[NSColor clearColor]];
        [self setTitleVisibility:NSWindowTitleHidden];
        [self setTitlebarAppearsTransparent:YES];
    }
    return self;
}

- (BOOL)isMovableByWindowBackground
{
    return YES;
}

@end
