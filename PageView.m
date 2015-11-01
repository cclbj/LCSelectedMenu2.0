//
//  PageView.m
//  LCMenuSelect
//
//  Created by LCC on 15/10/21.
//  Copyright © 2015年 SunnyBoy. All rights reserved.
//

#import "PageView.h"

@implementation PageView

#pragma -mark 初始化操作

+ (instancetype)pageView{

    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

#pragma -mark 重写set方法

- (void)setPageArray:(NSArray *)pageArray{

    _pageArray = pageArray;
    self.contentSize = CGSizeMake(pageArray.count * self.frame.size.width, self.frame.size.height);
    
    CGFloat pageX = 0;
    CGFloat pageY = 0;
    CGFloat pageW = self.frame.size.width;
    CGFloat pageH = self.frame.size.height;
    //创建界面
    for (int i=0; i<pageArray.count;i++) {
        UIView *view = pageArray[i];
        view.frame = CGRectMake(pageX, pageY, pageW, pageH);
        [self addSubview:pageArray[i]];
        pageX+=pageW;
    }
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    
}



@end
