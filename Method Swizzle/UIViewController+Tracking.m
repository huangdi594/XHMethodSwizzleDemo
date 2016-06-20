//
//  UIViewController+Tracking.m
//  Method Swizzle
//
//  Created by XuHuan on 16/1/28.
//  Copyright © 2016年 XuHuan. All rights reserved.
//

#import "UIViewController+Tracking.h"
#import <objc/runtime.h>

@implementation UIViewController (Tracking)

+ (void)load {
    //类名
    NSString *className = NSStringFromClass(self.class);
    NSLog(@"className: %@",className);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelectot = @selector(xh_ViewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelectot);
        
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelectot, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
    });
}

- (void)xh_ViewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear: %@",self);
    [self xh_ViewWillAppear:animated];
}

@end
