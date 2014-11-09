//
//  Safari.h
//  SafariHack
//
//  Created by Yoshimasa Niwa on 11/9/14.
//  Copyright (c) 2014 Yoshimasa Niwa. All rights reserved.
//

#import "WebKit.h"

@interface SiteMetadataRequest : NSObject <NSCopying>

@end

@interface SiteMetadataResponse : NSObject

@end

@interface SiteMetadataManager : NSObject

+ (instancetype)sharedManager;
- (id)registerRequest:(SiteMetadataRequest *)request priority:(NSInteger)priority responseHandler:(void (^)(SiteMetadataResponse *response))responseHandler;

@end

#pragma mark TouchIcon

@interface TouchIconRequest : SiteMetadataRequest

- (instancetype)initWithURL:(NSURL *)url minimumIconSize:(CGSize)minimumIconSize maximumIconSize:(CGSize)maximumIconSize;

@end

@interface TouchIconResponse : SiteMetadataResponse

@property (nonatomic, readonly) NSImage *prerenderedIcon;

@end

#pragma mark TouchIconCache

@interface SiteMetadataImageCache : NSObject

@end

@interface TouchIconsCache : SiteMetadataImageCache

+ (instancetype)sharedCache;
- (NSImage *)touchIconForURLString:(NSString *)urlString;

@end

#pragma mark -

@interface ButtonPlus : NSButton

@end

@interface RolloverTrackingButton : ButtonPlus

@end

@interface RolloverImageButton : RolloverTrackingButton

@property (nonatomic, retain) NSImage *rolloverImage;

@end

#pragma mark -

@class BrowserTabViewItem;

@interface ScrollableTabBarViewButton : NSButton

@end

@interface ScrollableTabButton : ScrollableTabBarViewButton

@property (readonly) RolloverImageButton *closeButton;
@property (readonly) BrowserTabViewItem *tabViewItem;
@property (nonatomic, getter=isShowingCloseButton) BOOL showingCloseButton;

- (void)_updateCloseButtonImages;
- (void)setHasMouseOverHighlight:(BOOL)hasMouseOverHighlight shouldAnimateCloseButton:(BOOL)animateCloseButton;

@end

#pragma mark -

@interface BrowserTabViewItem : NSTabViewItem

- (WKView *)wkView;
- (ScrollableTabButton *)scrollableTabButton;
- (void)updateLabelNow;

@end
