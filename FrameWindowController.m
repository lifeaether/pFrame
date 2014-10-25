//
//  FrameWindowController.m
//  pFrame
//
//  Created by lifeaether on 2014/10/25.
//  Copyright (c) 2014年 lifeaether. All rights reserved.
//

#import "FrameWindowController.h"

@interface FrameWindowController ()

@property NSInteger currentIndex;
@property (readonly) NSInteger nextIndex;
@property (readonly) NSInteger previousIndex;
@property NSUInteger numberOfDataSource;

@property NSRect preferredFrame;

@property (retain) NSImage *image;

@property (retain) NSTimer *timer;

- (void)updateFrame;

@end

@implementation FrameWindowController

- (instancetype)init
{
    self = [self initWithWindowNibName:@"FrameWindowController"];
    if ( self ) {
        [self setCurrentIndex:0];
        [self setNumberOfDataSource:0];
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self setPreferredFrame:[[self window] frame]];
}


- (void)windowDidMove:(NSNotification *)notification
{
    [self setPreferredFrame:[[self window] frame]];
}

- (void)reloadData
{
    if ( [[self dataSource] respondsToSelector:@selector(numberOfFrameImage:)] ) {
        [self setNumberOfDataSource:[[self dataSource] numberOfFrameImage:self]];
    }
}

- (void)updateFrame
{
    NSSize size = [[self image] size];
    if ( size.width > 0 && size.height ) {
        NSRect preferredFrame = [self preferredFrame];
        NSSize maximumSize = preferredFrame.size;
        if ( size.height > maximumSize.height ) {
            size.width *= maximumSize.height / size.height;
            size.height = maximumSize.height;
        }
        if ( size.width > maximumSize.width ) {
            size.height *= maximumSize.width / size.width;
            size.width = maximumSize.width;
        }
        NSRect newFrame = NSMakeRect( NSMidX(preferredFrame)-size.width/2, NSMidY(preferredFrame)-size.height/2, size.width, size.height);
        [[self window] setFrame:newFrame display:NO animate:NO];
    }
}

- (NSInteger)nextIndex
{
    NSInteger next = [self currentIndex] + 1;
    if ( next < [self numberOfDataSource]-1 ) {
        return next;
    } else {
        return 0;
    }
}

- (NSInteger)previousIndex
{
    NSInteger previous = [self currentIndex] - 1;
    if ( previous < 0 ) {
        return [self numberOfDataSource]-1;
    } else {
        return previous;
    }
}

- (void)fire:(NSTimer *)timer
{
    [self previous:self];
}

- (IBAction)previous:(id)sender {
    id dataSource = [self dataSource];
    if ( [dataSource respondsToSelector:@selector(readyImageAtIndex:atIndex:)] && ! [dataSource readyImageAtIndex:self atIndex:[self previousIndex]] ) {
        // pareparing data source.
    } else {
        if ( [dataSource respondsToSelector:@selector(imageAtIndex:atIndex:)] ) {
            [self setImage:[dataSource imageAtIndex:self atIndex:[self previousIndex]]];
            [self setCurrentIndex:[self previousIndex]];
            [self updateFrame];
            if ( [dataSource respondsToSelector:@selector(readyImageAtIndex:atIndex:)] ) {
                [dataSource readyImageAtIndex:self atIndex:[self previousIndex]];
            }

        }
    }
}

- (IBAction)next:(id)sender {
    id dataSource = [self dataSource];
    if ( [dataSource respondsToSelector:@selector(readyImageAtIndex:atIndex:)] && ! [dataSource readyImageAtIndex:self atIndex:[self nextIndex]] ) {
        // pareparing data source.
    } else {
        if ( [dataSource respondsToSelector:@selector(imageAtIndex:atIndex:)] ) {
            [self setImage:[dataSource imageAtIndex:self atIndex:[self nextIndex]]];
            [self setCurrentIndex:[self nextIndex]];
            [self updateFrame];
            if ( [dataSource respondsToSelector:@selector(readyImageAtIndex:atIndex:)] ) {
                [dataSource readyImageAtIndex:self atIndex:[self nextIndex]];
            }
        }
    }
}

- (IBAction)stop:(id)sender {
    [sender setAction:@selector(play:)];
    [sender setTitle:@"|>"];
    
    if ( [self timer] ) {
        [[self timer] invalidate];
        [self setTimer:nil];
    } else {
    }
}

- (IBAction)play:(id)sender {
    [sender setAction:@selector(stop:)];
    [sender setTitle:@"||"];
    
    if ( [self timer] ) {
    } else {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(fire:) userInfo:nil repeats:YES];
        [self setTimer:timer];
    }
}

- (IBAction)random:(id)sender {
    [self setCurrentIndex:rand()%[self numberOfDataSource]];
    [self next:sender];
}

- (void)frameViewMouseEntered
{
    [self setHiddenControls:NO];
    [[[self window] standardWindowButton:NSWindowCloseButton] setHidden:NO];
    [[[self window] standardWindowButton:NSWindowMiniaturizeButton] setHidden:NO];
    [[[self window] standardWindowButton:NSWindowZoomButton] setHidden:NO];
}

- (void)frameViewMouseExited
{
    [self setHiddenControls:YES];
    [[[self window] standardWindowButton:NSWindowCloseButton] setHidden:YES];
    [[[self window] standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
    [[[self window] standardWindowButton:NSWindowZoomButton] setHidden:YES];
}

@end
