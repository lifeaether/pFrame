//
//  FrameView.m
//  pFrame
//
//  Created by lifeaether on 2014/10/25.
//  Copyright (c) 2014年 lifeaether. All rights reserved.
//

#import "FrameView.h"

@interface FrameView ()

@property (retain) NSTrackingArea *trackingArea;

@end

@implementation FrameView

- (void)awakeFromNib
{
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:[self frame]
                                                                options:NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways
                                                                  owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
    [self setTrackingArea:trackingArea];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (BOOL)mouseDownCanMoveWindow
{
    return YES;
}

- (void)setFrame:(NSRect)frame
{
    [super setFrame:frame];
    [self removeTrackingArea:[self trackingArea]];
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:[self frame]
                                                                options:NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways
                                                                  owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
    [self setTrackingArea:trackingArea];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    id delegate = [self delegate];
    if ( [delegate respondsToSelector:@selector(frameViewMouseEntered)] ) {
        [delegate frameViewMouseEntered];
    }
}

- (void)mouseExited:(NSEvent *)theEvent
{
    id delegate = [self delegate];
    if ( [delegate respondsToSelector:@selector(frameViewMouseExited)] ) {
        [delegate frameViewMouseExited];
    }
}

@end
