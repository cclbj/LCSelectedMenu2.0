//
//  TopMenu.h
//  LCMenuSelect
//
//  Created by LCC on 15/10/21.
//  Copyright © 2015年 SunnyBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopMenu : UIScrollView

@property (nonatomic,strong) NSArray *menuItemArray;
@property (nonatomic,weak) UIColor *titleColor;
@property (nonatomic,weak) UIColor *selectColor;
@property (nonatomic,assign) CGFloat titleSize;
@property (nonatomic,assign) NSUInteger currentPage;
@property (nonatomic,weak) UIColor *barViewColor;
@property (nonatomic,copy) void (^currentPageBlock) (NSInteger currentPage);

+ (instancetype)defaultTopMenu;

- (void)setCurrentPageBlock:(void (^)(NSInteger currentPage))currentPageBlock;

@end
