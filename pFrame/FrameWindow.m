//
//  FrameWindow.m
//  pFrame
//
//  Created by lifeaether on 2015/02/01.
//  Copyright (c) 2015年 lifeaether. All rights reserved.
//

#import "FrameWindow.h"

@implementation FrameWindow

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
    if ( self ) {
        [self setBackgroundColor:[NSColor blackColor]];
    }
    return self;
}

- (BOOL)isMovableByWindowBackground
{
    return YES;
}

@end
