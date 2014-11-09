//
//  Safari+SafariHack.m
//  SafariHack
//
//  Created by Yoshimasa Niwa on 11/9/14.
//  Copyright (c) 2014 Yoshimasa Niwa. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <objc/message.h>
#import "SafariHack.h"
#import "Safari+SafariHack.h"
#import "SFHTabViewItemAdapter.h"

@implementation NSButton (SafariHack)

- (void)sfh__updateCloseButtonImages
{
    [self sfh__updateCloseButtonImages];

    [((ScrollableTabButton *)self).tabViewItem sfh_updateIcon];
}

- (void)sfh_setHasMouseOverHighlight:(BOOL)hasMouseOverHighlight shouldAnimateCloseButton:(BOOL)animateCloseButton
{
    [self sfh_setHasMouseOverHighlight:hasMouseOverHighlight shouldAnimateCloseButton:animateCloseButton];

    ((ScrollableTabButton *)self).closeButton.hidden = NO;
}

@end

#pragma mark -

#if USE_DID_FINISH_LOAD_FOR_MAIN_FRAME
@implementation NSView (SafariHack)

- (void)sfh__didFinishLoadForMainFrame
{
    [self sfh__didFinishLoadForMainFrame];

    [[NSNotificationCenter defaultCenter] postNotificationName:SFHWKViewDidFinishLoadForMainFrameNotification object:self];
}

@end
#endif

#pragma mark -

@implementation NSTabViewItem (SafariHack)

static const void * const kSFHBrowserTabViewItemAdapterKey = &kSFHBrowserTabViewItemAdapterKey;

- (ScrollableTabButton *)sfh_scrollableTabButton
{
    ScrollableTabButton *tabButton = [self sfh_scrollableTabButton];

    if (tabButton && !objc_getAssociatedObject(self, kSFHBrowserTabViewItemAdapterKey)) {
        SFHTabViewItemAdapter *adapter = [[SFHTabViewItemAdapter alloc] initWithBrowserTabViewItem:(BrowserTabViewItem *)self];
        [adapter setupScrollableTabButton:tabButton];
        objc_setAssociatedObject(self, kSFHBrowserTabViewItemAdapterKey, adapter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return tabButton;
}

#if !USE_DID_FINISH_LOAD_FOR_MAIN_FRAME
- (void)sfh_updateLabelNow
{
    [self sfh_updateLabelNow];
    [self sfh_updateIcon];
}
#endif

- (void)sfh_updateIcon
{
    SFHTabViewItemAdapter *adapter = objc_getAssociatedObject(self, kSFHBrowserTabViewItemAdapterKey);
    if (adapter) {
        [adapter updateIcon];
    }
}

@end
