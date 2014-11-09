//
//  Safari+SafariHack.h
//  SafariHack
//
//  Created by Yoshimasa Niwa on 11/9/14.
//  Copyright (c) 2014 Yoshimasa Niwa. All rights reserved.
//

#import "Safari.h"

#pragma mark -

@interface NSButton (SafariHack)

- (void)sfh__updateCloseButtonImages;
- (void)sfh_setHasMouseOverHighlight:(BOOL)hasMouseOverHighlight shouldAnimateCloseButton:(BOOL)animateCloseButton;

@end

#pragma mark -

#if USE_DID_FINISH_LOAD_FOR_MAIN_FRAME
@interface NSView (SafariHack)

- (void)sfh__didFinishLoadForMainFrame;

@end
#endif

#pragma mark -

@interface NSTabViewItem (SafariHack)

- (ScrollableTabButton *)sfh_scrollableTabButton;
#if !USE_DID_FINISH_LOAD_FOR_MAIN_FRAME
- (void)sfh_updateLabelNow;
#endif
- (void)sfh_updateIcon;

@end