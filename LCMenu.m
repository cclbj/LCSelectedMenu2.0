//
//  LCMenu.m
//  LCMenuSelect
//  封装要点：通过按钮的点击事件将当前点击的页面的index用block传出到menu中，然后通过设置当前的页面的page(通过重写set方法),去设置page的contentOffset偏移量，由于有了偏移量，此时的scrollViewDidScroll会被调用，然后通过去获取当前页面的index，去设置menu的标题被选中，这样就将双联动都关联好了
//  Created by LCC on 15/10/21.
//  Copyright © 2015年 SunnyBoy. All rights reserved.
//

#import "LCMenu.h"
#import "TopMenu.h"
#import "PageView.h"

#define  MenuHeight 44

@interface LCMenu()<UIScrollViewDelegate>

@property (nonatomic,weak) TopMenu *topMenu;
@property (nonatomic,weak) PageView *pageView;
@property (nonatomic,assign) NSUInteger currentPage;

@end

@implementation LCMenu

+ (instancetype)lcMenu{

    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}


#pragma -mark 属性设置传递

- (void)setBarViewColor:(UIColor *)barViewColor{

    self.topMenu.barViewColor = barViewColor;
}

- (void)setTitleColor:(UIColor *)titleColor{
    
    self.topMenu.titleColor = titleColor;
    
}

- (void)setSelectColor:(UIColor *)selectColor{

    self.topMenu.selectColor = selectColor;
}

- (void)setTitleSize:(CGFloat)titleSize{
    
    self.topMenu.titleSize = titleSize;
}

//- (void)setCurrentMenuItem:(void (^)(id currentMenuItem))currentMenuItem{
//
//    _currentMenuItem = currentMenuItem;
//}

- (void)setCurrentMenuItem:(void (^)(int currentPage))currentMenuItem{

    _currentMenuItem = currentMenuItem;
}

#pragma -mark 创建子控件
- (void)willMoveToSuperview:(UIView *)newSuperview{
    
    //创建TopMenu菜单
    CGFloat topMenuX = 0;
    CGFloat topMenuY = 0;
    CGFloat topMenuW = self.frame.size.width;
    CGFloat topMenuH = MenuHeight;
    
    TopMenu *topMenu = [TopMenu defaultTopMenu];
    topMenu.frame = CGRectMake(topMenuX, topMenuY, topMenuW, topMenuH);
    [topMenu setCurrentPageBlock:^(NSInteger currentPage) {
        NSLog(@"当前第%ld按钮被点击",currentPage);
        [self moveToCurrentPage:currentPage];
//        self.currentMenuItem(self.pageView.pageArray[currentPage]);
    }];
    self.topMenu = topMenu;
    [self addSubview:topMenu];
    
    //创建pageScroll页面
    CGFloat pageScrollX = 0;
    CGFloat pageScrollY = CGRectGetMaxY(self.topMenu.frame);
    CGFloat pageScrollW = self.frame.size.width;
    CGFloat pageScrollH = self.frame.size.height - pageScrollY;
    
    PageView *pageView = [PageView pageView];
    pageView.frame = CGRectMake(pageScrollX, pageScrollY, pageScrollW, pageScrollH);
    pageView.delegate = self;
    [self addSubview:pageView];
    self.pageView = pageView;

}

- (void)moveToCurrentPage:(NSInteger)currentPage{

    CGFloat offsetX = currentPage * self.frame.size.width;
    [self.pageView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    self.currentPage = (scrollView.contentOffset.x + scrollView.frame.size.width*0.5) / self.frame.size.width;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

//    self.currentMenuItem(self.pageView.pageArray[self.currentPage]);
    self.currentMenuItem([[NSNumber numberWithInteger:self.currentPage] intValue]);
    NSLog(@"currentPage:%ld",self.currentPage);
}

- (void)setCurrentPage:(NSUInteger)currentPage{

    _currentPage = currentPage;
    self.topMenu.currentPage = currentPage;
}

#pragma -mark 加载页面后
- (void)didMoveToSuperview{
    
    self.topMenu.menuItemArray = self.menuItemArray;
    self.pageView.pageArray = self.pageArray;
}

@end
