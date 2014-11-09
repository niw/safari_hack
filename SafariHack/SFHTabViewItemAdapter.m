//
//  SFHTabViewItemAdapter.m
//  SafariHack
//
//  Created by Yoshimasa Niwa on 11/9/14.
//  Copyright (c) 2014 Yoshimasa Niwa. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <objc/message.h>
#import "SafariHack.h"
#import "SFHTabViewItemAdapter.h"
#import "WKView+SafariHack.h"

static const CGFloat kIconWidth = 16.0;
static const CGFloat kIconHeight = 16.0f;

NSString * const SFHWKViewDidFinishLoadForMainFrameNotification = @"SFHWKViewDidFinishLoadForMainFrameNotification";

@implementation SFHTabViewItemAdapter
{
    BrowserTabViewItem *_tabViewItem;
}

- (instancetype)initWithBrowserTabViewItem:(BrowserTabViewItem *)tabViewItem
{
    if (self = [super init]) {
        _tabViewItem = tabViewItem;
#if USE_DID_FINISH_LOAD_FOR_MAIN_FRAME
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_wkViewDidFinishLoadForMainFrame:) name:SFHWKViewDidFinishLoadForMainFrameNotification object:nil];
#endif
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

#if USE_DID_FINISH_LOAD_FOR_MAIN_FRAME
- (void)_wkViewDidFinishLoadForMainFrame:(NSNotification *)notification
{
    WKView *wkView = (WKView *)notification.object;

    if (_tabViewItem.wkView == wkView) {
        [self updateIcon];
    }
}
#endif

#pragma mark - Public Methods

- (void)setupScrollableTabButton:(ScrollableTabButton *)tabButton
{
    if (tabButton) {
        RolloverImageButton *button = tabButton.closeButton;
        button.hidden = NO;
    }
}

- (void)updateIcon
{
    NSURL *url = [_tabViewItem.wkView sfh_mainFrameURL];

    __weak typeof (self) weakSelf = self;
    [self _iconForURL:url completion:^(NSImage *iconImage) {
        [weakSelf _setIconImage:iconImage];
    }];
}

- (void)_setIconImage:(NSImage *)iconImage
{
    if (iconImage) {
        _tabViewItem.scrollableTabButton.closeButton.image = iconImage;
    }
}

- (void)_iconForURL:(NSURL *)url completion:(void (^)(NSImage *iconImage))completion
{
    if (completion) {
#if USE_TOUCH_ICON
        [self _touchIconForURL:url completion:completion];
#else
        NSImage *iconImage = [self _faviconForURL:url];
        completion(iconImage);
#endif
    }
}

- (NSImage *)_faviconForURL:(NSURL *)url
{
    return [_tabViewItem.wkView sfh_iconImageForURL:url size:CGSizeMake(kIconWidth, kIconHeight)];
}

#if USE_TOUCH_ICON
- (void)_touchIconForURL:(NSURL *)url completion:(void (^)(NSImage *iconImage))completion
{
    if (!completion || !url) {
        return;
    }

    NSImage *iconImage = [[self _touchIconsCache] touchIconForURLString:[url absoluteString]];
    if (iconImage) {
        iconImage.size = CGSizeMake(kIconWidth, kIconHeight);
        completion(iconImage);
    } else {
        CGFloat scale = [NSScreen mainScreen].backingScaleFactor;
        CGSize size = CGSizeMake(kIconWidth * scale, kIconHeight * scale);
        TouchIconRequest *request = [self _touchIconRequestForURL:url minimumIconSize:size maximumIconSize:size];
        [[self _siteMetadataManager] registerRequest:request priority:0 responseHandler:^(SiteMetadataResponse *response) {
            TouchIconResponse *iconResponse = (TouchIconResponse *)response;
            NSImage *iconImage = iconResponse.prerenderedIcon;
            iconImage.size = CGSizeMake(kIconWidth, kIconHeight);
            completion(iconImage);
        }];
    }
}

- (TouchIconsCache *)_touchIconsCache
{
    Class TouchIconsCacheClass = objc_getClass("TouchIconsCache");
    return [TouchIconsCacheClass sharedCache];
}

- (SiteMetadataManager *)_siteMetadataManager
{
    Class SiteMetadataManagerClass = objc_getClass("SiteMetadataManager");
    return [SiteMetadataManagerClass sharedManager];
}

- (TouchIconRequest *)_touchIconRequestForURL:(NSURL *)url minimumIconSize:(CGSize)minimumIconSize maximumIconSize:(CGSize)maximumIconSize
{
    Class TouchIconRequestClass = objc_getClass("TouchIconRequest");
    return [[TouchIconRequestClass alloc] initWithURL:url minimumIconSize:minimumIconSize maximumIconSize:maximumIconSize];
}
#endif

@end
