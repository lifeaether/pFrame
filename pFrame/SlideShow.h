//
//  SlideShow.h
//  pFrame
//
//  Created by lifeaether on 2015/02/07.
//  Copyright (c) 2015年 lifeaether. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlideShow : NSObject

- (instancetype)initWithConfigure:(NSDictionary *)configure;
- (void)ready;

@property (readonly, getter=isReady) BOOL ready;
@property (readonly, getter=isStarted) BOOL started;
@property (readonly, getter=isLoading) BOOL loading;

- (IBAction)start:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)restart:(id)sender;
- (IBAction)next:(id)sender;
- (IBAction)previous:(id)sender;
- (IBAction)random:(id)sender;
- (IBAction)open:(id)sender;

@end
