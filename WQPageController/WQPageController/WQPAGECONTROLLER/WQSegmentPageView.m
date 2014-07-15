//
//  WQSegmentPageView.m
//  WQPageingProject
//
//  Created by Today on 14-7-2.
//  Copyright (c) 2014年 Today. All rights reserved.
//

#import "WQSegmentPageView.h"
#import "WQCommons.h"

@interface WQSegmentPageView (){
    UIView  *lineView;
    BOOL    _isObservingScrollView;
    NSInteger pageSum;
}

@property (weak, nonatomic) UIScrollView *observedScrollView;
@end

@implementation WQSegmentPageView

- (id)initWithFrame:(CGRect)frame withItems:(NSArray *)itmes
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        _isObservingScrollView = NO;
        self.pageNumber = 0;
        
        CGRect rc  = [self viewWithTag:self.pageNumber + kButtonTagStart].frame;
        lineView = [[UIView alloc]initWithFrame:CGRectMake(rc.origin.x, self.frame.size.height - 2, rc.size.width, 2)];
        lineView.backgroundColor = [UIColor colorWithRed:190.0/255.1 green:2.0/255.0 blue:1.0/255.0 alpha:1];
        [self addSubview:lineView];
        
        __block int offset_x = 10;
        [itmes enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
            button.tag = kButtonTagStart + idx;
            [button setTitle:title forState:UIControlStateNormal];
            CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(MAXFLOAT, 25)];
            button.frame = CGRectMake(offset_x, 5, size.width + 10, 25);
            [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            offset_x += size.width + 20;
            
        }];
        
        pageSum = itmes.count;
        self.contentSize = CGSizeMake(offset_x, frame.size.height);
        self.showsHorizontalScrollIndicator = NO;
        
       
    }
    return self;
}

-(void)onButtonClick:(UIButton *)button
{
    [self selectIndex:button.tag - kButtonTagStart];
}

-(void)selectIndex:(NSInteger)index
{
    //first of all ,we need to eliminate negative conditions
    if (self.pageNumber == index) return;
    self.pageNumber = index;
    if ([self.segmentDelegate respondsToSelector:@selector(wqSegmentSelectIndex:)]) {
        [self.segmentDelegate wqSegmentSelectIndex:index];
    }
    [UIView beginAnimations:@"CustomerAnimation" context:nil];
    [UIView setAnimationDuration:0.2];
    CGRect lineRC  = [self viewWithTag:self.pageNumber + kButtonTagStart].frame;
    lineView.frame = CGRectMake(lineRC.origin.x, lineView.frame.origin.y, lineRC.size.width, lineView.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark - 添加监视
-(void)addobserverScrollView:(UIScrollView *)scrollView
{
    self.observedScrollView = scrollView;
    [self removeCustonerObserver];
    _isObservingScrollView = YES;
    [self.observedScrollView addObserver:self forKeyPath:WQTITLEVIEW_KEYPATH options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - 监听回调方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![keyPath isEqualToString:WQTITLEVIEW_KEYPATH])return;
    if (self.pageNumber == pageSum - 1 && self.observedScrollView.contentOffset.x > 320) return;
    if (self.pageNumber == 0 && self.observedScrollView.contentOffset.x < 320) return;
    
    float radio = (float)((int)self.observedScrollView.contentOffset.x - 320)/SCREEN_WIDTH;
    int a = 1;
    if (self.observedScrollView.contentOffset.x < 320){
        a = -1;
        radio = -radio;
    }
    
    CGRect lineRC  = [self viewWithTag:self.pageNumber + kButtonTagStart].frame;
    CGRect lineRC2  = [self viewWithTag:self.pageNumber + a +kButtonTagStart].frame;
    float width = lineRC2.size.width;
    if (lineRC2.size.width < lineRC.size.width)
    {
        width =  lineRC.size.width - (lineRC.size.width-lineRC2.size.width)*radio;
    }
    else if(lineRC2.size.width > lineRC.size.width)
    {
        width =  lineRC.size.width + (lineRC2.size.width-lineRC.size.width)*radio;
    }
    float x = lineRC.origin.x + (lineRC2.origin.x - lineRC.origin.x)*radio;
    lineView.frame = CGRectMake(x, lineView.frame.origin.y,width,lineView.frame.size.height);

    
    if ((lineRC.origin.x - self.contentOffset.x ) > 160) {
        lineRC = [self ADDOrigin_x:80 withRect:lineRC];
    }else if (lineRC.origin.x > (self.contentSize.width - 320)){
        lineRC = [self setOrigin_x:self.contentSize.width - 320 withRect:lineRC];
    }else if ((lineRC.origin.x - self.contentOffset.x) < 50) {
        lineRC = [self ADDOrigin_x:-80 withRect:lineRC];
    }
    
    if (lineRC.origin.x < 50) {
        lineRC  = [self setOrigin_x:0 withRect:lineRC];
    }
    
    [self scrollRectToVisible:lineRC animated:YES];
}


-(CGRect)ADDOrigin_x:(CGFloat)x withRect:(CGRect)originalRC
{
    CGRect frame = originalRC;
    frame.origin.x += x;
    return frame;
}

-(CGRect)setOrigin_x:(CGFloat)x withRect:(CGRect)originalRC
{
    CGRect frame = originalRC;
    frame.origin.x = x;
    return frame;
}

-(void)removeCustonerObserver{
    if (_isObservingScrollView) {
        [self.observedScrollView removeObserver:self forKeyPath:WQTITLEVIEW_KEYPATH];
    }
}


@end
