//
//  CustomImageView.m
//  pFrame
//
//  Created by lifeaether on 2015/02/01.
//  Copyright (c) 2015年 lifeaether. All rights reserved.
//

#import "FrameImageView.h"
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CoreImage.h>

@implementation FrameImageView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if ( self ) {
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (BOOL)mouseDownCanMoveWindow
{
    return YES;
}


@end
