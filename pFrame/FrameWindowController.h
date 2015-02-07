//
//  FrameWindowController.h
//  pFrame
//
//  Created by lifeaether on 2015/02/07.
//  Copyright (c) 2015年 lifeaether. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FrameWindowController : NSWindowController

- (instancetype)initWithImageItem:(NSDictionary *)imageItem;

@property (readonly,retain) NSDictionary *imageItem;

- (IBAction)fadeIn:(id)sender;
- (IBAction)fadeOut:(id)sender;

@property (weak) IBOutlet NSImageView *frameImageView;

@end
