//
//  FrameView.h
//  pFrame
//
//  Created by lifeaether on 2014/10/25.
//  Copyright (c) 2014年 lifeaether. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol FrameViewDelegate <NSObject>

@optional - (void)frameViewMouseEntered;
@optional - (void)frameViewMouseExited;

@end

@interface FrameView : NSImageView

@property (weak) IBOutlet id <FrameViewDelegate> delegate;

@end
