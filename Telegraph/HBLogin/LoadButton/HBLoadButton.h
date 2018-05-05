//
//  HBLoadButton.h
//  newbi
//
//  Created by 张锐 on 2017/8/16.
//  Copyright © 2017年 张锐. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBLoadButton;

@interface HBLoadButton : UIButton

- (void)beginAnimation;
- (void)endAnimation;

- (BOOL)isLoading;

@end
