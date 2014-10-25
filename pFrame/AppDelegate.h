//
//  AppDelegate.h
//  pFrame
//
//  Created by lifeaether on 2014/10/24.
//  Copyright (c) 2014年 lifeaether. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FrameWindowController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet FrameWindowController *frameWindowController;

@end

