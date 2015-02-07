//
//  AppDelegate.h
//  pFrame
//
//  Created by lifeaether on 2014/10/24.
//  Copyright (c) 2014年 lifeaether. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

- (IBAction)selectOrder:(id)sender;
- (IBAction)selectTimeInterval:(id)sender;
- (IBAction)selectEffect:(id)sender;
- (IBAction)selectLayer:(id)sender;

@property (weak) IBOutlet NSMenuItem *menuItemOrdering;
@property (weak) IBOutlet NSMenuItem *menuItemTimeInterval;
@property (weak) IBOutlet NSMenuItem *menuItemEffect;
@property (weak) IBOutlet NSMenuItem *menuItemLayer;

@end

