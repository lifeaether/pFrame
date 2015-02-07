//
//  AppDelegate.m
//  pFrame
//
//  Created by lifeaether on 2014/10/24.
//  Copyright (c) 2014年 lifeaether. All rights reserved.
//

#import "AppDelegate.h"
#import "AppConstants.h"


@interface AppDelegate ()

- (void)updateMenuStatus;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application

    // Initialze Preferences.
    if ( ! [[NSUserDefaults standardUserDefaults] valueForKey:kApplicationPreferenceSlideShowOrdering] ) {
        [[NSUserDefaults standardUserDefaults] setValue:kApplicationPreferenceSlideShowOrderingDefault forKey:kApplicationPreferenceSlideShowOrdering];
    }
    
    if ( ! [[NSUserDefaults standardUserDefaults] valueForKey:kApplicationPreferenceSlideShowEffect] ) {
        [[NSUserDefaults standardUserDefaults] setValue:kApplicationPreferenceSlideShowEffectFade forKey:kApplicationPreferenceSlideShowEffect];
    }

    if ( ! [[NSUserDefaults standardUserDefaults] valueForKey:kApplicationPreferenceSlideShowTimeInterval] ) {
        [[NSUserDefaults standardUserDefaults] setValue:@(60) forKey:kApplicationPreferenceSlideShowTimeInterval];
    }
    if ( ! [[NSUserDefaults standardUserDefaults] valueForKey:kApplicationPreferenceSlideShowLayer] ) {
        [[NSUserDefaults standardUserDefaults] setValue:kApplicationPreferenceSlideShowLayerNormal forKey:kApplicationPreferenceSlideShowLayer];
    }
    if ( ! [[NSUserDefaults standardUserDefaults] valueForKey:kApplicationPreferenceSlideShowFrameSize] ) {
        [[NSUserDefaults standardUserDefaults] setValue:kApplicationPreferenceSlideShowFrameSizeNormal forKey:kApplicationPreferenceSlideShowFrameSize];
    }
    
    // Construct Menu Item.
    {
        NSMenuItem *item1 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Ordering", nil) action:@selector(selectOrder:) keyEquivalent:@""];
        NSMenuItem *item2 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Randomize", nil) action:@selector(selectOrder:) keyEquivalent:@""];
        [item1 setRepresentedObject:kApplicationPreferenceSlideShowOrderingDefault];
        [item2 setRepresentedObject:kApplicationPreferenceSlideShowOrderingRandomize];
        [[[self menuItemOrdering] submenu] addItem:item1];
        [[[self menuItemOrdering] submenu] addItem:item2];
    }
    {
        NSMenuItem *item1 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"1 minute", nil) action:@selector(selectTimeInterval:) keyEquivalent:@""];
        NSMenuItem *item2 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"3 minutes", nil) action:@selector(selectTimeInterval:) keyEquivalent:@""];
        NSMenuItem *item3 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"5 minutes", nil) action:@selector(selectTimeInterval:) keyEquivalent:@""];
        NSMenuItem *item4 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"10 minutes", nil) action:@selector(selectTimeInterval:) keyEquivalent:@""];
        NSMenuItem *item5 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"15 minutes", nil) action:@selector(selectTimeInterval:) keyEquivalent:@""];
        NSMenuItem *item6 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"30 minutes", nil) action:@selector(selectTimeInterval:) keyEquivalent:@""];
        NSMenuItem *item7 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"60 minutes", nil) action:@selector(selectTimeInterval:) keyEquivalent:@""];
        NSMenuItem *item8 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"90 minutes", nil) action:@selector(selectTimeInterval:) keyEquivalent:@""];
        [item1 setRepresentedObject:@(1)];
        [item2 setRepresentedObject:@(3)];
        [item3 setRepresentedObject:@(5)];
        [item4 setRepresentedObject:@(10)];
        [item5 setRepresentedObject:@(15)];
        [item6 setRepresentedObject:@(30)];
        [item7 setRepresentedObject:@(60)];
        [item8 setRepresentedObject:@(90)];
        [[[self menuItemTimeInterval] submenu] addItem:item1];
        [[[self menuItemTimeInterval] submenu] addItem:item2];
        [[[self menuItemTimeInterval] submenu] addItem:item3];
        [[[self menuItemTimeInterval] submenu] addItem:item4];
        [[[self menuItemTimeInterval] submenu] addItem:item5];
        [[[self menuItemTimeInterval] submenu] addItem:item6];
        [[[self menuItemTimeInterval] submenu] addItem:item7];
        [[[self menuItemTimeInterval] submenu] addItem:item8];
    }
    {
        NSMenuItem *item1 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Fade Quickly", nil) action:@selector(selectEffect:) keyEquivalent:@""];
        NSMenuItem *item2 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Fade", nil) action:@selector(selectEffect:) keyEquivalent:@""];
        NSMenuItem *item3 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Fade Slowly", nil) action:@selector(selectEffect:) keyEquivalent:@""];
        [item1 setRepresentedObject:kApplicationPreferenceSlideShowEffectFadeQuickly];
        [item2 setRepresentedObject:kApplicationPreferenceSlideShowEffectFade];
        [item3 setRepresentedObject:kApplicationPreferenceSlideShowEffectFadeSlowly];
        [[[self menuItemEffect] submenu] addItem:item1];
        [[[self menuItemEffect] submenu] addItem:item2];
        [[[self menuItemEffect] submenu] addItem:item3];
    }
    {
        NSMenuItem *item1 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Front", nil) action:@selector(selectLayer:) keyEquivalent:@""];
        NSMenuItem *item2 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Normal", nil) action:@selector(selectLayer:) keyEquivalent:@""];
        NSMenuItem *item3 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) action:@selector(selectLayer:) keyEquivalent:@""];
        [item1 setRepresentedObject:kApplicationPreferenceSlideShowLayerMostFront];
        [item2 setRepresentedObject:kApplicationPreferenceSlideShowLayerNormal];
        [item3 setRepresentedObject:kApplicationPreferenceSlideShowLayerMostBack];
        [[[self menuItemLayer] submenu] addItem:item1];
        [[[self menuItemLayer] submenu] addItem:item2];
        [[[self menuItemLayer] submenu] addItem:item3];
    }
    {
        NSMenuItem *item1 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Small", nil) action:@selector(selectFrameSize:) keyEquivalent:@""];
        NSMenuItem *item2 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Normal", nil) action:@selector(selectFrameSize:) keyEquivalent:@""];
        NSMenuItem *item3 = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Large", nil) action:@selector(selectFrameSize:) keyEquivalent:@""];
        [item1 setRepresentedObject:kApplicationPreferenceSlideShowFrameSizeSmall];
        [item2 setRepresentedObject:kApplicationPreferenceSlideShowFrameSizeNormal];
        [item3 setRepresentedObject:kApplicationPreferenceSlideShowFrameSizeLarge];
        [[[self menuItemFrameSize] submenu] addItem:item1];
        [[[self menuItemFrameSize] submenu] addItem:item2];
        [[[self menuItemFrameSize] submenu] addItem:item3];
    }
    
    [self updateMenuStatus];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:kApplicationPreferenceSlideShowOrdering options:NSKeyValueObservingOptionNew context:nil];
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:kApplicationPreferenceSlideShowTimeInterval options:NSKeyValueObservingOptionNew context:nil];
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:kApplicationPreferenceSlideShowEffect options:NSKeyValueObservingOptionNew context:nil];
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:kApplicationPreferenceSlideShowLayer options:NSKeyValueObservingOptionNew context:nil];
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:kApplicationPreferenceSlideShowFrameSize options:NSKeyValueObservingOptionNew context:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:kApplicationPreferenceSlideShowOrdering];
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:kApplicationPreferenceSlideShowTimeInterval];
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:kApplicationPreferenceSlideShowEffect];
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:kApplicationPreferenceSlideShowLayer];
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:kApplicationPreferenceSlideShowFrameSize];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self updateMenuStatus];
}

- (void)updateMenuStatus
{
    for ( NSMenuItem *item in [[[self menuItemOrdering] submenu] itemArray] ) {
        if ( [[item representedObject] isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:kApplicationPreferenceSlideShowOrdering]] ) {
            [item setState:NSOnState];
        } else {
            [item setState:NSOffState];
        }
    }
    for ( NSMenuItem *item in [[[self menuItemTimeInterval] submenu] itemArray] ) {
        if ( [[item representedObject] isEqualToNumber:[[NSUserDefaults standardUserDefaults] valueForKey:kApplicationPreferenceSlideShowTimeInterval]] ) {
            [item setState:NSOnState];
        } else {
            [item setState:NSOffState];
        }
    }
    for ( NSMenuItem *item in [[[self menuItemEffect] submenu] itemArray] ) {
        if ( [[item representedObject] isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:kApplicationPreferenceSlideShowEffect]] ) {
            [item setState:NSOnState];
        } else {
            [item setState:NSOffState];
        }
    }
    for ( NSMenuItem *item in [[[self menuItemLayer] submenu] itemArray] ) {
        if ( [[item representedObject] isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:kApplicationPreferenceSlideShowLayer]] ) {
            [item setState:NSOnState];
        } else {
            [item setState:NSOffState];
        }
    }
    for ( NSMenuItem *item in [[[self menuItemFrameSize] submenu] itemArray] ) {
        if ( [[item representedObject] isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:kApplicationPreferenceSlideShowFrameSize]] ) {
            [item setState:NSOnState];
        } else {
            [item setState:NSOffState];
        }
    }
}


- (IBAction)selectOrder:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:[sender representedObject] forKey:kApplicationPreferenceSlideShowOrdering];
}

- (IBAction)selectTimeInterval:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:[sender representedObject] forKey:kApplicationPreferenceSlideShowTimeInterval];
}

- (IBAction)selectEffect:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:[sender representedObject] forKey:kApplicationPreferenceSlideShowEffect];
}

- (IBAction)selectLayer:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:[sender representedObject] forKey:kApplicationPreferenceSlideShowLayer];
}

- (IBAction)selectFrameSize:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:[sender representedObject] forKey:kApplicationPreferenceSlideShowFrameSize];
}

@end
