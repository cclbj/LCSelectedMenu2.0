//
//  PageView.h
//  LCMenuSelect
//
//  Created by LCC on 15/10/21.
//  Copyright © 2015年 SunnyBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageView : UIScrollView

@property (nonatomic,strong) NSArray *pageArray;


+ (instancetype)pageView;

@end
