//
//  UITableView+IndexPan.m
//  logisticsdriver
//
//  Created by sischen on 2018/2/7.
//  Copyright © 2018年 kmw. All rights reserved.
//

#import "UITableView+IndexPan.h"
#import <objc/runtime.h>

static void *indexPanBlkKey = &indexPanBlkKey;
static NSString *selectedSectionKey = @"selectedSection";

@implementation UITableView (IndexPan)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"_sectionIndexTouchesBegan:")),
                                       class_getInstanceMethod(self.class, @selector(cc_swizzling_sectionIndexTouchesBegan:Event:)));
        method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"_sectionIndexChanged:")),
                                       class_getInstanceMethod(self.class, @selector(cc_swizzling_sectionIndexChanged:Event:)));
        method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"_sectionIndexTouchesEnded:")),
                                       class_getInstanceMethod(self.class, @selector(cc_swizzling_sectionIndexTouchesEnded:Event:)));
    });
}

-(void)cc_swizzling_sectionIndexTouchesBegan:(UIControl *)indexView Event:(UIEvent *)event{
//    NSLog(@"_sectionIndexTouchesBegan:");
    [self handleSectionIndexTouchesOf:indexView WithTouch:event.allTouches.allObjects.lastObject];
    [self cc_swizzling_sectionIndexTouchesBegan:indexView Event:event];
}

-(void)cc_swizzling_sectionIndexChanged:(UIControl *)indexView Event:(UIEvent *)event{
//    NSLog(@"_sectionIndexChanged:");
    [self handleSectionIndexTouchesOf:indexView WithTouch:event.allTouches.allObjects.lastObject];
    [self cc_swizzling_sectionIndexChanged:indexView Event:event];
}

-(void)cc_swizzling_sectionIndexTouchesEnded:(UIControl *)indexView Event:(UIEvent *)event{
//    NSLog(@"_sectionIndexTouchesEnded:");
    [self handleSectionIndexTouchesOf:indexView WithTouch:event.allTouches.allObjects.lastObject];
    [self cc_swizzling_sectionIndexTouchesEnded:indexView Event:event];
}


-(void)handleSectionIndexTouchesOf:(UIControl *)indexView WithTouch:(UITouch *)touch{
    
    if (![indexView respondsToSelector:NSSelectorFromString(selectedSectionKey)] ||
        ![self.dataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) { return; }
    
    NSInteger currentIndex = ((NSNumber *)[indexView valueForKey:selectedSectionKey]).integerValue;
    
    if (currentIndex != NSIntegerMax) {
//        NSLog(@"currentIndex:%ld", (long)currentIndex);
        if (self.sectionIndexChanged) {
            self.sectionIndexChanged(currentIndex, indexView.tracking);
        }
    } else { // 触摸结束等情况下，selectedSection会变为NSIntegerMax，这里重算该值，以避免外部使用该值导致越界等异常
        NSInteger itemCount = [self.dataSource sectionIndexTitlesForTableView:self].count;
        
        CGFloat indexItemHeight = 14.0; // 测量得出的单个索引高度大约值，默认值
        if ([indexView respondsToSelector:NSSelectorFromString(@"font")]) {
            NSDictionary *attribute = @{NSFontAttributeName: (UIFont *)[indexView valueForKey:@"font"]};
            CGFloat textH = [@" " boundingRectWithSize:CGSizeMake(1, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:attribute context:nil].size.height;
            indexItemHeight = (textH * itemCount + 1.0 * (itemCount - 1)) / itemCount;
        }
        
        CGFloat indexFullHeight = itemCount * indexItemHeight;
        CGFloat startY = (CGRectGetHeight(self.bounds) - indexFullHeight) * 0.5;
        CGFloat touchY = [touch locationInView:touch.view].y;
        
        if (touchY < startY) {
            touchY = startY;
        } else if (touchY > (startY + indexFullHeight)) {
            touchY = startY + (itemCount-1) * indexItemHeight;
        }
        currentIndex = (touchY - startY) / indexItemHeight;
//        NSLog(@"currentIndex:%ld, NSIntegerMax appears", (long)currentIndex);
        if (self.sectionIndexChanged) {
            self.sectionIndexChanged(currentIndex, indexView.tracking);
        }
    }
    
}

#pragma mark - getter/setter
-(SectionIndexChangedBlock)sectionIndexChanged{
    return objc_getAssociatedObject(self, &indexPanBlkKey);
}

-(void)setSectionIndexChanged:(SectionIndexChangedBlock)sectionIndexChanged{
    objc_setAssociatedObject(self, &indexPanBlkKey, sectionIndexChanged, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
