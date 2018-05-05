//
//  HBPaymentTitleView.m
//  Telegraph
//
//  Created by 段智林 on 2018/4/25.
//

#import "HBPaymentTitleView.h"

@implementation HBPaymentTitleView

+(instancetype)defaultTitleView
{
    HBPaymentTitleView *titleView = [[HBPaymentTitleView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_NAV_BAR)];
    return titleView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) drawRect:(CGRect)rect
{
    CGSize textSize= [self.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName: [UIColor blackColor]}];
    CGSize imageSize = CGSizeMake(15,15);
    
    CGFloat text_origin_x = (self.bounds.size.width- textSize.width - (self.isPayment? imageSize.width:0))/2.0;
    CGFloat text_origin_y = (self.bounds.size.height- textSize.height)/2.0;
    
    //backgroundcolor
    CGContextRef context= UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, UIColorFromRGB(247, 247, 247).CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-0.5f));
    CGContextClosePath(context);
    
    CGContextRef context2= UIGraphicsGetCurrentContext();
    CGContextBeginPath(context2);
    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextFillRect(context2, CGRectMake(0, self.bounds.size.height-0.5f, self.bounds.size.width, 0.5f));
    CGContextClosePath(context2);
    
    //drawtext
    [self.title drawAtPoint:CGPointMake(text_origin_x, text_origin_y) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName: [UIColor blackColor]}];
    //drawimage
    if (self.isPayment) {
        CGFloat image_origin_x = (self.bounds.size.width+ textSize.width + imageSize.width)/2.0;
        CGFloat image_origin_y = (self.bounds.size.height- imageSize.height)/2.0;
        
        [self.isMutedImage drawInRect:CGRectMake(image_origin_x, image_origin_y, imageSize.width,imageSize.height)];
        
    }
}
-(UIImage *)isMutedImage{
    return [UIImage imageNamed:@"nav_title_arrow"];
}
-(void)setTitle:(NSString *)title
{
    if (![_title isEqualToString:title]) {
        _title= title;
        [self setNeedsDisplay];
        
    }
}
-(void)setMuted:(BOOL)payment
{
    if (_payment!= payment) {
        _payment = payment;
        
        [self setNeedsDisplay];
    }
}

@end
