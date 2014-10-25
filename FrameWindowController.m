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

@property NSRect preferredWindowFrame;

@property (retain) NSImage *image;

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
    [self setPreferredWindowFrame:[[self window] frame]];
}


- (void)windowDidResize:(NSNotification *)notification
{
//    [self setPreferredWindowFrame:[[self window] frame]];
    NSLog( @"%@", notification );
}

- (void)reloadData
{
    if ( [[self dataSource] respondsToSelector:@selector(numberOfFrameImage:)] ) {
        [self setNumberOfDataSource:[[self dataSource] numberOfFrameImage:self]];
    }
}

- (NSInteger)nextIndex
{
    return MIN( [self currentIndex] + 1, MAX( [self numberOfDataSource]-1, 0 ) );
}

- (NSInteger)previousIndex
{
    return MAX( [self currentIndex] - 1, 0 );
}

- (IBAction)previous:(id)sender {
    id dataSource = [self dataSource];
    if ( [dataSource respondsToSelector:@selector(readyImageAtIndex:atIndex:)] && ! [dataSource readyImageAtIndex:self atIndex:[self previousIndex]] ) {
        // pareparing data source.
    } else {
        if ( [dataSource respondsToSelector:@selector(imageAtIndex:atIndex:)] ) {
            [self setImage:[dataSource imageAtIndex:self atIndex:[self previousIndex]]];
            [self setCurrentIndex:[self previousIndex]];
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
        }
    }
}

- (IBAction)stop:(id)sender {
    [sender setAction:@selector(play:)];
    [sender setTitle:@"||"];
}

- (IBAction)play:(id)sender {
    [sender setAction:@selector(stop:)];
    [sender setTitle:@"|>"];
}

@end
