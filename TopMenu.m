//
//  TopMenu.m
//  LCMenuSelect
//
//  Created by LCC on 15/10/21.
//  Copyright © 2015年 SunnyBoy. All rights reserved.
//

#import "TopMenu.h"

#define INTRVAL 20

@interface TopMenu ()

@property (nonatomic,strong) NSMutableArray *itemBtnArray;
@property (nonatomic,strong) NSMutableArray *itemBarViewArray;
@property (nonatomic,weak) UIView *currentBarView;
@property (nonatomic,assign) CGFloat menuContentWidth;

@property (nonatomic,assign) CGFloat offsetX;

@property (nonatomic,assign) CGFloat currentX;

@end

@implementation TopMenu

#pragma -mark 初始化方法操作

+ (instancetype)defaultTopMenu{
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

#pragma -mark 属性设置方法

- (void)setBarViewColor:(UIColor *)barViewColor{

    for (UIView *barView in self.itemBarViewArray) {
        barView.backgroundColor = barViewColor;
    }
    
    self.currentBarView.backgroundColor = barViewColor;
    
}

- (void)setTitleSize:(CGFloat)titleSize{

    for (UIButton *btn in self.itemBtnArray) {
        btn.titleLabel.font = [UIFont systemFontOfSize:titleSize];
    }
    
}

//使用block将点击事件的按钮位置传递出去
- (void)setCurrentPageBlock:(void (^)(NSInteger currentPage))currentPageBlock{

    _currentPageBlock = currentPageBlock;
}

- (void)setMenuItemArray:(NSArray *)menuItemArray{

    NSLog(@"数组链接成功");
    _menuItemArray = menuItemArray;
    self.itemBtnArray = [[NSMutableArray alloc]init];
    self.itemBarViewArray = [[NSMutableArray alloc]init];
    
    CGFloat interval = INTRVAL;
    CGFloat btnX = interval;
    CGFloat btnY = self.frame.size.height/2.0-5;
    
    //添加菜单按钮
    for (int i = 0; i < menuItemArray.count; i++) {

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.tag = i;
        [btn setSelected: i ? NO:YES];
        btn.titleLabel.font = [UIFont systemFontOfSize:self.titleSize ? self.titleSize : 13];
        [btn setTitle:menuItemArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:self.titleColor ? self.titleColor : [UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:self.selectColor ? self.titleColor : [UIColor redColor] forState:UIControlStateSelected];
        
        NSString *titleContent = menuItemArray[i];
        UIFont *font = [UIFont systemFontOfSize:self.titleSize ? self.titleSize : 13];
        
        //计算标题宽度
        CGRect textRect = [titleContent boundingRectWithSize:CGSizeMake(10000,font.pointSize) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName:font} context:nil];
//        NSLog(@"btnW:%f",textRect.size.width);
        
        CGFloat btnW = textRect.size.width+10;
        CGFloat btnH = 20;
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        [btn addTarget:self action:@selector(menuItemTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.itemBtnArray addObject:btn];
        
        //添加菜单栏底部视图
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(btnX-2, btnY+btnH+2, btnW+2, 2)];
        bottomView.backgroundColor = self.titleColor ? self.titleColor : [UIColor redColor];
        bottomView.hidden = YES;
        [self addSubview:bottomView];
        [self.itemBarViewArray addObject:bottomView];
        
        if (i==0) {
            UIView *currentBarView = [[UIView alloc]initWithFrame:bottomView.frame];
            currentBarView.backgroundColor = self.titleColor ? self.titleColor : [UIColor blueColor];
            [self addSubview:currentBarView];
            currentBarView.hidden = NO;
            self.currentBarView = currentBarView;
            self.currentX = bottomView.frame.origin.x;
        }
        
        btnX += btnW+interval;
    }
    self.menuContentWidth = btnX;
    
    //计算item的总宽度是否超出屏幕范围，如果超出不做标题处理，如果没有超出屏幕，保证标题在屏幕中间
    BOOL isNeedAdjustMenu = btnX > self.frame.size.width ? NO : YES;
    if (isNeedAdjustMenu) {
        [self adjustMenu];
    }
    
    //设置scrollview的contentsize大小
    self.contentSize = CGSizeMake(btnX, 0);
    self.showsHorizontalScrollIndicator = NO;
}

- (void)setTitleColor:(UIColor *)titleColor{

    _titleColor = titleColor;
    for (UIButton *btn in self.itemBtnArray) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
}

- (void)setSelectColor:(UIColor *)selectColor{

    _selectColor = selectColor;
    for (UIButton *btn in self.itemBtnArray) {
        [btn setTitleColor:selectColor forState:UIControlStateSelected];
    }
}

#pragma -mark 功能性方法（属性set方法用到）

- (void)adjustMenu{

    CGFloat offsetX = (self.frame.size.width - self.menuContentWidth)*0.5;
    self.offsetX = offsetX;
    
    //将所有的菜单栏进行移动，保证整体居中显示
    for (int i=0; i<self.itemBtnArray.count; i++) {
        
        //调整菜单按钮
        UIButton *itemButton = self.itemBtnArray[i];
        
        CGFloat itemBtnX = itemButton.frame.origin.x;
        CGFloat itemBtnY = itemButton.frame.origin.y;
        CGFloat itemBtnW = itemButton.frame.size.width;
        CGFloat itemBtnH = itemButton.frame.size.height;
        
        itemBtnX += offsetX;
        
        CGRect itemBtnrectNew = CGRectMake(itemBtnX, itemBtnY, itemBtnW, itemBtnH);
        itemButton.frame = itemBtnrectNew;
        
        //调整下方的菜单条
        UIView *barView = self.itemBarViewArray[i];
        
        CGFloat barViewX = barView.frame.origin.x;
        CGFloat barViewY = barView.frame.origin.y;
        CGFloat barViewW = barView.frame.size.width;
        CGFloat barViewH = barView.frame.size.height;
        
        barViewX += offsetX;
        CGRect barRectNew = CGRectMake(barViewX, barViewY, barViewW, barViewH);
        if (i==0) {
            self.currentBarView.frame = barRectNew;
        }
        barView.frame = barRectNew;
    }
    
}

- (void)menuItemTouch:(UIButton *)btn{
    
    NSLog(@"menu click");
    
    //使用block传递出当前的按钮位置进而改变page的indexPage
    self.currentPageBlock(btn.tag);
}

//改变按钮状态
- (void)changeBtnPosition:(UIButton *)btn{

    [self clearButtonState];
    
    [btn setTitleColor:self.selectColor ? self.selectColor : [UIColor redColor] forState:UIControlStateSelected];
    [btn setSelected:YES];
    
    UIView *barView = self.itemBarViewArray[btn.tag];
    [UIView animateWithDuration:0.3 animations:^{
        //transform以后，被transform的对象的x将被transform之后的x被覆盖
//        self.currentBarView.transform = CGAffineTransformMakeTranslation(barView.frame.origin.x - self.offsetX-6, 0);
        self.currentBarView.transform = CGAffineTransformMakeTranslation(barView.frame.origin.x - self.currentX-4, 0);
    }];
    
    //更新底部bar的宽度
    CGFloat currentBarViewX = self.currentBarView.frame.origin.x;
    CGFloat currentBarViewY = self.currentBarView.frame.origin.y;
    CGFloat currentBarViewW = self.currentBarView.frame.size.width;
    CGFloat currentBarViewH = self.currentBarView.frame.size.height;
    
    currentBarViewW = barView.frame.size.width;
    CGRect currentBarNew = CGRectMake(currentBarViewX, currentBarViewY, currentBarViewW, currentBarViewH);
    self.currentBarView.frame = currentBarNew;
    
    //判断是否需要滚动到可见位置
    CGFloat currentRightBtnX = btn.frame.origin.x + btn.frame.size.width;
    CGFloat screenRightX = self.contentOffset.x + self.frame.size.width;
    CGFloat offsetX = self.contentOffset.x - (currentBarViewX - screenRightX);
    
    if (currentRightBtnX > screenRightX) {
//        NSLog(@"右边要显示出来啦");
        [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }

    //当偏移量小于屏幕的时候显示出左边的隐藏控件
    CGFloat currentLeftBtnX = btn.frame.origin.x;
    CGFloat screenLeftX = self.contentOffset.x;
    
    if (currentLeftBtnX<screenLeftX) {
//        NSLog(@"左边要显示出来啦");
        self.contentOffset = CGPointMake(currentLeftBtnX, 0);
    }
}

//清除按钮效果
- (void)clearButtonState{

    for (int i=0;i<self.itemBtnArray.count;i++) {
        UIButton *btn = self.itemBtnArray[i];
        btn.selected = NO;
        
    }
    
}

//实现连动效果
- (void)setCurrentPage:(NSUInteger)currentPage{

    UIButton *currentBtn = self.itemBtnArray[currentPage];
    [self changeBtnPosition:currentBtn];
    
}


@end
