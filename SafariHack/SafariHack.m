//
//  SafariHack.m
//  SafariHack
//
//  Created by Yoshimasa Niwa on 11/8/14.
//  Copyright (c) 2014 Yoshimasa Niwa. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <objc/message.h>
#import "SafariHack.h"
#import "Safari+SafariHack.h"

void objc_exchangeInstanceMethodImplementations(const char* className, SEL originlSelector, SEL replacementSelector)
{
    Class class = objc_getClass(className);
    Method originalMethod = class_getInstanceMethod(class, originlSelector);
    Method replacementMethod = class_getInstanceMethod(class, replacementSelector);
    method_exchangeImplementations(originalMethod, replacementMethod);
}

@implementation SafariHack

#define EXCHANGE_METHOD(class, method) objc_exchangeInstanceMethodImplementations(class, @selector(method), @selector(sfh_##method))

+ (void)load
{
    EXCHANGE_METHOD("ScrollableTabButton", setHasMouseOverHighlight:shouldAnimateCloseButton:);
    EXCHANGE_METHOD("ScrollableTabButton", _updateCloseButtonImages);

    EXCHANGE_METHOD("BrowserTabViewItem", scrollableTabButton);
    EXCHANGE_METHOD("BrowserTabViewItem", updateLabelNow);

    NSLog(@"Safari Hack is loaded.");
}

@end