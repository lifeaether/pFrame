//
//  FrameWindowController.h
//  pFrame
//
//  Created by lifeaether on 2014/10/25.
//  Copyright (c) 2014年 lifeaether. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FrameView.h"

@protocol FrameWindowDataSource <NSObject>

@required - (NSUInteger)numberOfFrameImage:(id)frameWindowController;
@required - (NSImage *)imageAtIndex:(id)frameWindowController atIndex:(NSUInteger)index;
@optional - (BOOL)readyImageAtIndex:(id)frameWindowController atIndex:(NSUInteger)index;

@end

@interface FrameWindowController : NSWindowController<FrameViewDelegate>

@property (weak) id <FrameWindowDataSource> dataSource;

@property (retain,readonly) NSImage *image;
@property (getter=isHiddenControls) BOOL hiddenControls;

- (void)reloadData;

@end
