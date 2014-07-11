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
    NSArray *_titleArray,*_viewControllers;
    NSInteger _currentPage;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentPage = 0;
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    
    UIViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
     self.pageViewController.view.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    WQTitlePagerView *titleView = [[WQTitlePagerView alloc] initWithFrame:CGRectMake(0, 20, 150, 44)];
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
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
