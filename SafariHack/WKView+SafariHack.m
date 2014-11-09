//
//  WKView+SafariHack.m
//  SafariHack
//
//  Created by Yoshimasa Niwa on 11/9/14.
//  Copyright (c) 2014 Yoshimasa Niwa. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WKView+SafariHack.h"

@implementation WKView (SafariHack)

- (NSURL *)sfh_mainFrameURL
{
    WKPageRef wkPage = self.pageRef;
    if (wkPage) {
        WKFrameRef wkFrame = WKPageGetMainFrame(wkPage);
        if (wkFrame) {
            WKURLRef wkURL = WKFrameCopyURL(wkFrame);
            if (wkURL) {
                NSURL *url = (__bridge NSURL *)WKURLCopyCFURL(CFAllocatorGetDefault(), wkURL);
                WKRelease(wkURL);
                return url;
            }
        }
    }
    return nil;
}

- (NSImage *)sfh_iconImageForURL:(NSURL *)url size:(CGSize)size;
{
    WKPageRef wkPage = self.pageRef;
    if (url && wkPage) {
        WKURLRef wkURL = WKURLCreateWithUTF8CString([[url absoluteString] UTF8String]);
        WKContextRef wkContext = WKPageGetContext(wkPage);
        WKIconDatabaseRef wkIconDatabase = WKContextGetIconDatabase(wkContext);

        CGFloat scale = [NSScreen mainScreen].backingScaleFactor;
        WKSize wkSize = (WKSize){.width = size.width * scale, .height = size.height * scale};

        CGImageRef icon = WKIconDatabaseTryGetCGImageForURL(wkIconDatabase, wkURL, wkSize);
        WKRelease(wkURL);
        if (icon) {
            NSImage *image = [[NSImage alloc] initWithCGImage:icon size:CGSizeMake(size.width, size.height)];
            return image;
        }
    }
    return nil;
}

@end
