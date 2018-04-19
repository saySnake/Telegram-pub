//
//  UIView+Util.m
//  UsedCar
//
//  Created by Alan on 13-10-25.
//  Copyright (c) 2013年 Alan. All rights reserved.
//

#import "UIView+Util.h"
//#import "AMBlurView.h"

@implementation UIView (Util)
@dynamic borderColor;

//MARK:X
- (CGFloat)minX {
	return self.frame.origin.x;
}

- (void)setMinX:(CGFloat)x {
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}
//MARK:Y
- (CGFloat)minY {
	return self.frame.origin.y;
}

- (void)setMinY:(CGFloat)y {
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}
//MARK:maxX
- (CGFloat)maxX {
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setMaxX:(CGFloat)x {
	CGRect frame = self.frame;
	frame.origin.x = x - frame.size.width;
	self.frame = frame;
}
//MARK:maxY
- (CGFloat)maxY {
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setMaxY:(CGFloat)y {
	CGRect frame = self.frame;
	frame.origin.y = y - frame.size.height;
	self.frame = frame;
}
//MARK:width
- (CGFloat)width {
	return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
//MARK:height
- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
//MARK:origin
- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
//MARK:size
- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

//MARK:cornerRadius
- (CGFloat)cornerRadius{
    return self.layer.cornerRadius;
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius=cornerRadius;
    self.layer.masksToBounds=YES;
}
//MARK:borderColor
-(void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderWidth=kLinePixel;
    self.layer.cornerRadius=4.f;
    self.layer.borderColor=borderColor.CGColor;
}

//MARK:screenViewX
- (CGFloat)screenViewX {
	CGFloat x = 0;
	for (UIView* view = self; view; view = view.superview) {
		x += view.minX;
		
		if ([view isKindOfClass:[UIScrollView class]]) {
			UIScrollView* scrollView = (UIScrollView*)view;
			x -= scrollView.contentOffset.x;
		}
	}
	
	return x;
}
//MARK:screenViewY
- (CGFloat)screenViewY {
	CGFloat y = 0;
	for (UIView* view = self; view; view = view.superview) {
		y += view.minY;
		
		if ([view isKindOfClass:[UIScrollView class]]) {
			UIScrollView* scrollView = (UIScrollView*)view;
			y -= scrollView.contentOffset.y;
		}
	}
	return y;
}

- (CGRect)screenFrame {
	return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}


- (UIView*)subviewWithFirstResponder {
	if ([self isFirstResponder])
		return self;
	
	for (UIView *subview in self.subviews) {
		UIView *view = [subview subviewWithFirstResponder];
		if (view) return view;
	}
	
	return nil;
}

- (UIView*)subviewWithClass:(Class)cls {
	if ([self isKindOfClass:cls])
		return self;
	
	for (UIView* subview in self.subviews) {
		UIView* view = [subview subviewWithClass:cls];
        //DLog(@"view:%@",view);
		if (view) return view;
	}
	
	return nil;
}

- (UIView*)superviewWithClass:(Class)cls {
	if ([self isKindOfClass:cls]) {
		return self;
	} else if (self.superview) {
		return [self.superview superviewWithClass:cls];
	} else {
		return nil;
	}
}

-(void)addTopLine:(CGFloat)h{
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, h) color:kLine_Color];
    [self addSubview:line];
}
-(void)addBottomLine:(CGFloat)h{
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, self.height-h, self.width, h) color:kLine_Color];
    [self addSubview:line];

}
-(void)addLeftLine:(CGFloat)w{
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, w, self.height) color:kLine_Color];
    [self addSubview:line];

}
-(void)addRightLine:(CGFloat)w{
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(self.width-w, 0, w, self.height) color:kLine_Color];
    [self addSubview:line];

}


- (void)removeAllSubviews {
	while (self.subviews.count) {
		UIView* child = self.subviews.lastObject;
		[child removeFromSuperview];
	}
}

- (UIImage *)screenshot{
//    //支持retina高分的关键
//    if(/* DISABLES CODE */ (&UIGraphicsBeginImageContextWithOptions) != NULL){
//    }
//    else{
//        UIGraphicsBeginImageContext(self.bounds.size);
//    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);

    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


//初始化
-(instancetype)initWithFrame:(CGRect)frame color:(UIColor *)bgColor{

    self = [self initWithFrame:frame];
	self.backgroundColor = bgColor;
	return self;
}

/** super UIViewController */
- (UIViewController*)viewController {
	for (UIView* next = [self superview]; next; next = next.superview) {
		UIResponder* nextResponder = [next nextResponder];
		if ([nextResponder isKindOfClass:[UIViewController class]]) {
			return (UIViewController*)nextResponder;
		}
	}
	return nil;
}




@end

@implementation UITextField (Util)

-(void)showToolBar{
    UIToolbar *bar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 39)];
    bar.backgroundColor=kMainBGColor;
    UIButton *finish=[UIButton buttonWithType:UIButtonTypeCustom];
    finish.frame=CGRectMake(DScreenW-54, 0, 54, bar.height);
    finish.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
    [finish setTitle:@"完成" forState:UIControlStateNormal];
    [finish setTitleColor:kColorBlue forState:UIControlStateNormal];
    [finish addTarget:self action:@selector(finishInput) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:finish];
    self.inputAccessoryView=bar;
}
-(void)finishInput{
    [self resignFirstResponder];
}
@end

@implementation UITextView (Util)

-(void)showToolBar{
    UIToolbar *bar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 39)];
    bar.backgroundColor=kMainBGColor;
    UIButton *finish=[UIButton buttonWithType:UIButtonTypeCustom];
    finish.frame=CGRectMake(DScreenW-54, 0, 54, bar.height);
    finish.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
    [finish setTitle:@"完成" forState:UIControlStateNormal];
    [finish setTitleColor:kColorBlue forState:UIControlStateNormal];
    [finish addTarget:self action:@selector(finishInput) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:finish];
    self.inputAccessoryView=bar;

}
-(void)finishInput{
    [self resignFirstResponder];
}

@end



@implementation UILabel (RedPoint)

-(instancetype)initRedPoint:(CGPoint)center{
    if (self=[super init]) {
        self.bounds=CGRectMake(0, 0, 14, 14);
        self.center=center;
        self.cornerRadius=7;
        self.backgroundColor=[UIColor redColor];//RGBACOLOR(230, 70, 60, 1);
        self.textAlignment=NSTextAlignmentCenter;
        self.font=kFontSmall;
        self.clipsToBounds=YES;
        self.textColor=[UIColor whiteColor];
    }
    return self;
}
-(instancetype)initUnreadRedPoint:(CGPoint)center;
{
    if (self=[super init]) {
        self.bounds=CGRectMake(0, 0, 18, 18);
        self.center=center;
        self.cornerRadius=9;
        self.backgroundColor=[UIColor redColor];//RGBACOLOR(239, 49, 65, 1);
        self.textAlignment=NSTextAlignmentCenter;
        self.font=kFontSmall;
        self.clipsToBounds=YES;
        self.textColor=[UIColor whiteColor];
    }
    return self;
}
-(void)setBadgeValue:(NSString *)value attribute:(NSDictionary *)attribute{
    
    UIFont *font=attribute[NSFontAttributeName];
    UIColor *fcolor=attribute[NSForegroundColorAttributeName];
    if (font) {
        self.font=font;
    }
    if (fcolor) {
        self.textColor=fcolor;
    }
    CGSize size=[value sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.font.pointSize+4]}];
    self.textAlignment=NSTextAlignmentCenter;
//    size.width+=5;
//    size.height+=5;
    CGPoint center=self.center;
    if (size.width>size.height) {
        self.size=size;
    }else{
        self.size=CGSizeMake(size.height, size.height);
    }
    BOOL isStopUpdate=[attribute[@"stopUpdateCenter"] boolValue];
    if (isStopUpdate==NO) {
        self.center=center;
    }
    self.cornerRadius=size.height/2;
    self.clipsToBounds=YES;
    self.hidden=NO;
    self.text=value;
}
@end





















