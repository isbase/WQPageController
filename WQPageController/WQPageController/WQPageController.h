//
//  WQPageController.h
//  WQPageController
//
//  Created by dev on 14-7-11.
//  Copyright (c) 2014年 Today. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQSegmentPageView.h"

@interface WQPageController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate,WQsegmentIndexDelegate>


-(instancetype)initWithChildViewControllers:(NSArray *)viewControllers andTitles:(NSArray *)titleArray;

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end
