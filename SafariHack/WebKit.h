//
//  WebKit.h
//  SafariHack
//
//  Created by Yoshimasa Niwa on 11/9/14.
//  Copyright (c) 2014 Yoshimasa Niwa. All rights reserved.
//

typedef const void *WKTypeRef;

typedef struct WKSize {
    double width;
    double height;
} WKSize;

void WKRelease(WKTypeRef type);

#pragma mark WKURL

typedef const struct OpaqueWKURL *WKURLRef;

CFURLRef WKURLCopyCFURL(CFAllocatorRef alloc, WKURLRef URL) CF_RETURNS_RETAINED;
WKURLRef WKURLCreateWithUTF8CString(const char* string);

#pragma mark WKIconDatabase

typedef const struct OpaqueWKIconDatabase* WKIconDatabaseRef;

CGImageRef WKIconDatabaseTryGetCGImageForURL(WKIconDatabaseRef iconDatabase, WKURLRef url, WKSize size);

#pragma mark WKContext

typedef const struct OpaqueWKContext* WKContextRef;

WKIconDatabaseRef WKContextGetIconDatabase(WKContextRef context);

#pragma mark WKFrame

typedef const struct OpaqueWKFrame *WKFrameRef;

WKURLRef WKFrameCopyURL(WKFrameRef frame);

#pragma mark WKPage

typedef const struct OpaqueWKPage *WKPageRef;

WKContextRef WKPageGetContext(WKPageRef page);
WKFrameRef WKPageGetMainFrame(WKPageRef page);

#pragma mark -

@interface WKView : NSView <NSTextInputClient>

@end

@interface WKView (Private)

@property (readonly) WKPageRef pageRef;

- (void)_didFinishLoadForMainFrame;

@end
