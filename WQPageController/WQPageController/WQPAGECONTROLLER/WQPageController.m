//
//  WQPageController.m
//  WQPageController
//
//  Created by dev on 14-7-11.
//  Copyright (c) 2014年 Today. All rights reserved.
//

#import "WQPageController.h"
#import "TestViewController.h"
#import "WQTitlePagerView.h"
#import "WQCommons.h"


@interface WQPageController ()
{
    NSArray             *_titleArray,*_viewControllers;
    NSInteger           _currentPage;
    WQTitlePagerView    *titleView;
    WQSegmentPageView   *segmentView;
    WQPAGETYPE          typeStyle;
}
@end

@implementation WQPageController

-(instancetype)initWithChildViewControllers:(NSArray *)viewControllers andTitles:(NSArray *)titleArray
{
    self = [super init];
    if (self) {
        // Custom initialization
        _titleArray = titleArray;
        _viewControllers = viewControllers;
    }
    return self;
}
-(instancetype)initWithChildViewControllers:(NSArray *)viewControllers andTitles:(NSArray *)titleArray wihtType:(WQPAGETYPE)type
{
    typeStyle = type;
    return  [self initWithChildViewControllers:viewControllers andTitles:titleArray];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentPage = 1;
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_OFFSET_Y + 10, 60, 30)];
    backButton.backgroundColor = [UIColor redColor];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    UIViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pageViewController.view.frame = (CGRect){{0,80},self.view.frame.size};
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    

    if (typeStyle == WQPAGETITLEBARTYPE) {
        titleView = [[WQTitlePagerView alloc] initWithFrame:CGRectMake(0, 20, 150, 50)];
        titleView.backgroundColor = [UIColor blackColor];
        titleView.index = 0;
        [titleView addObjects:_titleArray];
        [self.view addSubview:titleView];
        self.pageViewController.view.frame = CGRectMake(0, 50 + SCREEN_OFFSET_Y, SCREEN_WIDTH, SCREEN_HEIGHT - 50 - SCREEN_OFFSET_Y + 40);
        titleView.center = CGPointMake(160, titleView.center.y);
        for (UIView *view in self.pageViewController.view.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                [titleView addobserverScrollView:(UIScrollView *)view];
                break;
            }
        }
    }else{
        self.pageViewController.view.frame = CGRectMake(0, SCREEN_OFFSET_Y + 50, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_OFFSET_Y - 50 + 40);
        
        segmentView = [[WQSegmentPageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35) withItems:_titleArray];
        segmentView.segmentDelegate = self;
        [self.pageViewController.view addSubview:segmentView];
        for (UIView *view in self.pageViewController.view.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                [segmentView addobserverScrollView:(UIScrollView *)view];
                break;
            }
        }
        
    }
    
}

-(void)onBackButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIViewController delegate
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([_titleArray count] == 0) || (index >= [_titleArray count])) {
        return nil;
    }
    return  (UIViewController *)_viewControllers[index];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(TestViewController *)vc{
    NSInteger index = vc.page;
    return [self viewControllerAtIndex:index - 1];
    
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(TestViewController *)vc{
    NSInteger index = vc.page;
    return [self viewControllerAtIndex:index + 1];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [_viewControllers count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (!completed)return;

    _currentPage = [[self.pageViewController.viewControllers lastObject] page];
    if (titleView) titleView.pageNumber = _currentPage;
    if (segmentView) segmentView.pageNumber = _currentPage;
}

#pragma mark -  以下方法只在SegmentPageView中使用
-(void)wqSegmentSelectIndex:(NSInteger)index{
    UIViewController *startingViewController = [self viewControllerAtIndex:index];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}
-(void)dealloc{
    if (titleView) [titleView removeCustonerObserver];
    if (segmentView) [segmentView removeCustonerObserver];
}

@end
