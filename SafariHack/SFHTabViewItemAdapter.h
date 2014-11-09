//
//  SFHTabViewItemAdapter.h
//  SafariHack
//
//  Created by Yoshimasa Niwa on 11/9/14.
//  Copyright (c) 2014 Yoshimasa Niwa. All rights reserved.
//

#import "WebKit.h"
#import "Safari.h"

extern NSString * const SFHWKViewDidFinishLoadForMainFrameNotification;

@interface SFHTabViewItemAdapter : NSObject

- (instancetype)initWithBrowserTabViewItem:(BrowserTabViewItem *)tabViewItem;
- (void)setupScrollableTabButton:(ScrollableTabButton *)tabButton;
- (void)updateIcon;

@end
