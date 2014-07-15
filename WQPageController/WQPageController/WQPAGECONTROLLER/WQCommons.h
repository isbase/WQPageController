//
//  WQCommons.h
//  WQPageController
//
//  Created by dev on 14-7-15.
//  Copyright (c) 2014年 Today. All rights reserved.
//

#ifndef WQPageController_WQCommons_h
#define WQPageController_WQCommons_h

#define IOS6                        (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
#define SCREEN_HEIGHT               (([UIScreen mainScreen].bounds.size.height) - (IOS6?20:0))    //屏幕高度
#define SCREEN_WIDTH                [UIScreen mainScreen].bounds.size.width
#define SCREEN_OFFSET_Y             (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1?0:20)

//WQTitlePagerView
#define  WQTITLEVIEW_KEYPATH @"contentOffset"

//WQSegmentPageView
#define kButtonTagStart 100
#define kPATH_OFFSET_X @"contentOffset.x"


#endif
