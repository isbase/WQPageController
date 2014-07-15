//
//  RootViewController.m
//  WQPageController
//
//  Created by dev on 14-7-11.
//  Copyright (c) 2014年 Today. All rights reserved.
//

#import "RootViewController.h"
#import "TestViewController.h"
#import "WQPageController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.navigationController.navigationBarHidden = YES;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
    button.backgroundColor = [UIColor greenColor];
    [button setTitle:@"导航" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onShowButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 160, 100, 40)];
    button2.backgroundColor = [UIColor greenColor];
    [button2 setTitle:@"segment" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(onSegmentClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}

/**
 * 导航
 */
-(void)onShowButtonClick
{
    NSArray *titleArray = [NSArray arrayWithObjects:@"轻松一刻",@"头条",@"北京",@"房产",@"移动互联", nil];
    
    NSMutableArray *controllerArray = [[NSMutableArray alloc]init];
    int sum = 0;
    for (NSString* title in titleArray)
    {
        TestViewController *vc = [[TestViewController alloc]init];
        vc.labelTitle = [title stringByAppendingString:@"   Today's View Controller"];
        vc.page = sum;
        [controllerArray addObject:vc];
        sum += 1;
    }
    
    WQPageController *page = [[WQPageController alloc] initWithChildViewControllers:controllerArray andTitles:titleArray wihtType:WQPAGETITLEBARTYPE];
    [self.navigationController pushViewController:page animated:YES];
}


-(void)onSegmentClick
{
    NSArray *titleArray = [NSArray arrayWithObjects:@"轻松一刻",@"头条",@"北京",@"房产",@"移动互联",@"今日头条",@"明日预售",@"后天发布",@"天涯芳草", nil];
    
    NSMutableArray *controllerArray = [[NSMutableArray alloc]init];
    int sum = 0;
    for (NSString* title in titleArray)
    {
        TestViewController *vc = [[TestViewController alloc]init];
        vc.labelTitle = [title stringByAppendingString:@"   Today's View Controller"];
        vc.page = sum;
        [controllerArray addObject:vc];
        sum += 1;
    }
    
    WQPageController *page = [[WQPageController alloc] initWithChildViewControllers:controllerArray andTitles:titleArray wihtType:WQPAGEMENUTYPE];
    [self.navigationController pushViewController:page animated:YES];
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
