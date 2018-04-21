//
//  UIImage+EKB.m
//  xiaoke
//
//  Created by PW on 15/2/2.
//  Copyright (c) 2015年 张玮. All rights reserved.
//

#import "UIImage+EKB.h"

@implementation UIImage (EKB)

+ (UIImage *)imageWithName:(NSString *)imageName
{
    UIImage *image = nil;
    
//    if (IOS7)
//    {
//        NSString *ios7Image = [imageName stringByAppendingString:@"_os7"];
//        image = [self imageNamed:ios7Image];
//    }
    
    if (image == nil) {
        image = [self imageNamed:imageName];
    }
    
    return image;
}

+ (UIImage *)resizeWithName:(NSString *)imageName
{
    return [self resizeWithName:imageName leftRate:0.5 topRatio:0.5];
}

+ (UIImage *)resizeWithName:(NSString *)imageName leftRate:(CGFloat)leftRate topRatio:(CGFloat)topRatio
{
    UIImage *image = [self imageWithName:imageName];
    CGFloat left = image.size.width * leftRate;
    CGFloat top = image.size.height * topRatio;
    return [image stretchableImageWithLeftCapWidth:left topCapHeight:top];
}

-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


@end
