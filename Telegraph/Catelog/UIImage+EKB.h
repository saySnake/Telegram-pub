//
//  UIImage+EKB.h
//  xiaoke
//
//  Created by PW on 15/2/2.
//  Copyright (c) 2015年 张玮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (EKB)

+ (UIImage *)imageWithName:(NSString *)imageName;

+ (UIImage *)resizeWithName:(NSString *)imageName;

+ (UIImage *)resizeWithName:(NSString *)imageName leftRate:(CGFloat)leftRate topRatio:(CGFloat)topRatio;

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

@end
