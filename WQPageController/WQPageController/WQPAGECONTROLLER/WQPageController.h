//
//  WQPageController.h
//  WQPageController
//
//  Created by dev on 14-7-11.
//  Copyright (c) 2014年 Today. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQSegmentPageView.h"
#import "WQCommons.h"

typedef enum : NSUInteger {
    WQPAGETITLEBARTYPE,
    WQPAGEMENUTYPE,
} WQPAGETYPE;

@interface WQPageController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate,WQsegmentIndexDelegate>


-(instancetype)initWithChildViewControllers:(NSArray *)viewControllers andTitles:(NSArray *)titleArray;

-(instancetype)initWithChildViewControllers:(NSArray *)viewControllers andTitles:(NSArray *)titleArray wihtType:(WQPAGETYPE)type;

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end
