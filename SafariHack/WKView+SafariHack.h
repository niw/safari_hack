//
//  WKView+SafariHack.h
//  SafariHack
//
//  Created by Yoshimasa Niwa on 11/9/14.
//  Copyright (c) 2014 Yoshimasa Niwa. All rights reserved.
//

#import "WebKit.h"

@interface WKView (SafariHack)

- (NSURL *)sfh_mainFrameURL;
- (NSImage *)sfh_iconImageForURL:(NSURL *)url size:(CGSize)size;

@end
