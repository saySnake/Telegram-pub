//
//  HBRoundView.h
//  newbi
//
//  Created by 张锐 on 2017/9/11.
//  Copyright © 2017年 张锐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBRoundView : UIView

@property (nonatomic, assign) CGFloat   progress;
@property (nonatomic, strong) UIColor   *strokeColor;

- (void)beginAnimation;
- (void)endAnimation;

@end
