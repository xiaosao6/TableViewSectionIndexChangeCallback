//
//  UITableView+IndexPan.h
//  logisticsdriver
//
//  Created by sischen on 2018/2/7.
//  Copyright © 2018年 kmw. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 UITableView索引滑动回调

 @param sectionIndex 当前索引序号
 @param isTracking 是否正在触摸跟踪
 */
typedef void(^SectionIndexChangedBlock)(NSInteger sectionIndex, BOOL isTracking);


@interface UITableView (IndexPan)

/**
 UITableView索引滑动回调，注意在该block内使用weak避免循环引用
 */
@property (nonatomic, copy) SectionIndexChangedBlock _Nullable sectionIndexChanged;

@end
