//
//  LCMenu.h
//  LCMenuSelect
//
//  Created by LCC on 15/10/21.
//  Copyright © 2015年 SunnyBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCMenu : UIView

@property (nonatomic,strong) NSArray *menuItemArray;
@property (nonatomic,strong) NSArray *pageArray;

@property (nonatomic,weak) UIColor *titleColor;
@property (nonatomic,weak) UIColor *selectColor;
@property (nonatomic,assign) CGFloat titleSize;
@property (nonatomic,weak) UIColor *barViewColor;

//使用之前务必将这个block属性设置一下，如果不设置可能会报错
//@property (nonatomic,copy) void (^currentMenuItem) (id currentMenuItem);
@property (nonatomic,copy) void (^currentMenuItem) (int indexPage);

+ (instancetype)lcMenu;

//- (void)setCurrentMenuItem:(void (^)(id currentMenuItem))currentMenuItem;

- (void)setCurrentMenuItem:(void (^)(int currentPage))currentMenuItem;



@end
