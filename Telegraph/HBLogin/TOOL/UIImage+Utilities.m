//
//  UIImage+Utilities.m
//  iOTNews
//
//  Created by Airy on 15/5/8.
//  Copyright (c) 2015年 iotooth. All rights reserved.
//

#import "UIImage+Utilities.h"


@implementation UIImage (Utilities)


#pragma mark - resizable
+ (UIImage *)resizableImage:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    CGFloat w = image.size.width * 0.5;
    CGFloat h = image.size.height * 0.5;
    return [image stretchableImageWithLeftCapWidth:w topCapHeight:h];
}

#pragma mark - Color
- (UIImage *)imageWithColor:(UIColor *)color
{

    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
//    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextTranslateCTM(context, 0, self.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    CGContextSetBlendMode(context, kCGBlendModeNormal);
//    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
//    CGContextClipToMask(context, rect, self.CGImage);
//    [color setFill];
//    CGContextFillRect(context, rect);
//    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageWithAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); 
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (id)createRoundedRectImage:(UIImage *)image size:(CGSize)size radius:(NSInteger)r
{
    // the size of CGContextRef
    int w = image.size.width;
    int h = image.size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}


/**
 *  返回一张密码输入框网格图片
 *
 *  @param gridCount 网格数
 *  @param gridLineColor 网格线颜色
 *  @param gridLineWidth 网格线宽度
 *
 *  @return 网格图片
 */
+ (instancetype)passwordInputGridImageWithGridCount:(NSInteger)gridCount gridLineColor:(UIColor *)gridLineColor gridLineWidth:(CGFloat)gridLineWidth
{
    CGFloat gridWidth = 54;
    CGSize size = CGSizeMake(gridWidth * gridCount, gridWidth);
    
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    // 获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 画外边框
    CGFloat marginFix = gridLineWidth * 0.5;
    CGContextMoveToPoint(context, marginFix, marginFix);
    CGContextAddLineToPoint(context, size.width - marginFix, marginFix);
    CGContextAddLineToPoint(context, size.width - marginFix, size.height - marginFix);
    CGContextAddLineToPoint(context, marginFix, size.height - marginFix);
    CGContextAddLineToPoint(context, marginFix, marginFix);
    // 画内边框
    for (int i = 1 ; i < gridCount; i ++) {
        CGContextMoveToPoint(context, i * gridWidth, 0);
        CGContextAddLineToPoint(context, i * gridWidth, gridWidth);
    }
    
    // 设置填充颜色
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    // 设置线条颜色
    [gridLineColor setStroke];
    //设置线条宽度
    CGContextSetLineWidth(context, gridLineWidth);
    //设置连接样式,,,必须要连接在一起的，首位相接的，第二条线的起点不是你用CGContextMoveToPoint自己写的，才有用
    CGContextSetLineJoin(context, kCGLineJoinBevel );
    //设置顶角样式
    CGContextSetLineCap(context, kCGLineCapRound);
    //渲染，线段，图片用rect,后边的参数是渲染方式kCGPathFillStroke,表示既有边框，又有填充；kCGPathFill只填充
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //获取图片
    UIImage *gridImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭位图
    UIGraphicsEndImageContext();
    
    return gridImage;
}


+ (UIImage *)circleAndStretchableImageWithColor:(UIColor *)color size:(CGSize)size
{
    if (size.width <= 1) {
        size.width = 100;
        size.height = 100;
    }
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    //获取当前图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //添加一个椭圆，第一个参数是在那个上下文上面添加，，，第二个参数是设定一个矩形框，这个椭圆会”填充“这个矩形框，如果这个矩形框是正方形，那么就是圆
    CGRect rect =CGRectMake(0, 0, size.width, size.height);
    CGContextAddEllipseInRect(context,rect);
    CGContextClip(context);
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    // 裁剪
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    ;
}


+ (UIImage *)createQrCodeImage:(UIImage *)codeImage
                     logoImage:(UIImage *)logoImage
                         title:(NSString *)title
                    qrCodeName:(NSString *)qrCodeName
                        amount:(NSString *)amount
                      currency:(NSString *)currency
                         phone:(NSString *)phone
                          addr:(NSString *)addr
                       appName:(NSString *)appName
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIGraphicsBeginImageContextWithOptions(size ,NO, 0.0);
    
    UIImage *bg_image = [UIImage imageNamed:@"Bitmap"];
    [bg_image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    CGFloat content_image_x = 20;
    CGFloat content_image_y = 80;
    CGFloat content_image_w = size.width - (content_image_x * 2);
    CGFloat content_image_h = 436;
    UIImage *content_image = [UIImage imageNamed:@"qrcode_bg_img"];
    [content_image drawInRect:CGRectMake(content_image_x, content_image_y, content_image_w, content_image_h)];
    
    // title
    NSDictionary *title_attr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:23],
                           NSForegroundColorAttributeName : HBColor(31, 63, 89)};
    CGSize title_size = [title sizeWithAttributes:title_attr];
    CGFloat title_x = (size.width - title_size.width) / 2;
    CGFloat title_y = content_image_y + 44;
    [title drawInRect:CGRectMake(title_x, title_y, title_size.width, title_size.height)
       withAttributes:title_attr];
    
    
    // amount
    CGFloat amount_y = title_y + title_size.height + 20;
    if (amount.length > 0) {
        
        NSDictionary *amount_attr = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                                      NSForegroundColorAttributeName : HBColor(31, 63, 89)};
        CGSize amount_size = [amount sizeWithAttributes:amount_attr];
        NSDictionary *currency_attr = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                                        NSForegroundColorAttributeName : HBColor_alpha(31, 63, 89, 0.5)};
        CGSize currency_size = [currency sizeWithAttributes:currency_attr];
        
        CGFloat gap = 3;
        
        CGFloat amount_x = (size.width - amount_size.width - gap - currency_size.width) / 2;
        
        CGFloat currency_x = amount_x + gap + amount_size.width;
        CGFloat currency_y = amount_y;
        
        [amount drawInRect:CGRectMake(amount_x, amount_y, amount_size.width, amount_size.height)
            withAttributes:amount_attr];
        [currency drawInRect:CGRectMake(currency_x, currency_y, currency_size.width, currency_size.height)
            withAttributes:currency_attr];
        
    } else {
        NSDictionary *qrCodeName_attr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                          NSForegroundColorAttributeName : HBColor(31, 63, 89)};
        CGSize qrCodeName_size = [qrCodeName sizeWithAttributes:qrCodeName_attr];
        CGFloat qrCodeName_x = (size.width - qrCodeName_size.width) / 2;
        CGFloat qrCodeName_y = amount_y;
        [qrCodeName drawInRect:CGRectMake(qrCodeName_x, qrCodeName_y, qrCodeName_size.width, qrCodeName_size.height)
                withAttributes:qrCodeName_attr];
    }
    
    // codeImage
    CGFloat codeImage_w = 190;
    CGFloat codeImage_h = 190;
    CGFloat codeImage_x = (size.width - codeImage_w) / 2;
    CGFloat codeImage_y = amount_y + 25 + 10;
    [codeImage drawInRect:CGRectMake(codeImage_x, codeImage_y, codeImage_w, codeImage_h)];
    
    // phone
    NSDictionary *phone_attr = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName : HBColor_alpha(31, 63, 89, 0.5)};
    CGSize phone_size = [phone sizeWithAttributes:phone_attr];
    CGFloat phone_x = (size.width - phone_size.width) / 2;
    CGFloat phone_y = codeImage_y + codeImage_h + 10;
    [phone drawInRect:CGRectMake(phone_x, phone_y, phone_size.width, phone_size.height)
       withAttributes:phone_attr];
    
    // addr
    NSDictionary *addr_attr = @{NSFontAttributeName: [UIFont systemFontOfSize:10],
                                NSForegroundColorAttributeName : HBColor(31, 63, 89)};
    CGSize addr_size = [addr sizeWithAttributes:addr_attr];
    CGFloat addr_x = (size.width - addr_size.width) / 2;
    CGFloat addr_y = phone_y + phone_size.height + 23;
    [addr drawInRect:CGRectMake(addr_x, addr_y, addr_size.width, addr_size.height)
      withAttributes:addr_attr];
    
    // logo
    CGFloat logo_gap = 10;
    CGFloat logoImage_w = logoImage.size.width;
    CGFloat logoImage_h = logoImage.size.height;
    CGFloat logoImage_y = ((size.height - content_image_y - content_image_h) / 2) + content_image_y + content_image_h - (logoImage.size.height / 2);
    NSDictionary *appName_attr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
                           NSForegroundColorAttributeName : [UIColor whiteColor]};
    CGSize appName_size = [appName sizeWithAttributes:appName_attr];
    CGFloat appName_y = logoImage_y + ((logoImage_h - appName_size.height) / 2);
    CGFloat logoImage_x = (size.width - logo_gap - logoImage_w - appName_size.width) / 2;
    CGFloat appName_x = logoImage_x + logoImage_w + logo_gap;
    [logoImage drawInRect:CGRectMake(logoImage_x, logoImage_y, logoImage_w, logoImage_h)];
    [appName drawInRect:CGRectMake(appName_x, appName_y, appName_size.width, appName_size.height)
        withAttributes:appName_attr];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

@end
