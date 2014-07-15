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


@interface WQPageController ()
{
    NSArray             *_titleArray,*_viewControllers;
    NSInteger           _currentPage;
    WQTitlePagerView    *titleView;
    WQSegmentPageView   *segmentView;
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


#define PAGETYPE 1

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentPage = 1;
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    UIViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    
    

#if PAGETYPE == 1
    
    titleView = [[WQTitlePagerView alloc] initWithFrame:CGRectMake(0, 20, 150, 50)];
    titleView.backgroundColor = [UIColor blackColor];
    titleView.index = 0;
    [titleView addObjects:_titleArray];
    [self.view addSubview:titleView];
    titleView.center = CGPointMake(160, titleView.center.y);
    
    for (UIView *view in self.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [titleView addobserverScrollView:(UIScrollView *)view];
            break;
        }
    }
    
#elif PAGETYPE ==2
    
    segmentView = [[WQSegmentPageView alloc] initWithFrame:CGRectMake(0, 40, 320, 35) withItems:_titleArray];
    segmentView.segmentDelegate = self;
    [self.view addSubview:segmentView];


#endif


    
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
    NSLog(@"%d",_currentPage);
    titleView.pageNumber = _currentPage;
}



#pragma mark -  以下方法只在SegmentPageView中使用
-(void)wqSegmentSelectIndex:(NSInteger)index{
    UIViewController *startingViewController = [self viewControllerAtIndex:index];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width - 320) return;
    int page = (int)scrollView.contentOffset.x / 320 ;
    float radio = (float)((int)scrollView.contentOffset.x % 320)/320;
    [segmentView setLineOffsetWithPage:page andRatio:radio];
}



@end
