//
//  NSObject+Util.h
//  HuanYouWang
//
//  Created by liuwenjie on 15/5/15.
//  Copyright (c) 2015年 cc.huanyouwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSObject (Util)
- (CGSize)sizeWithText:(NSString *)text;
- (CGSize)sizeWithText:(NSString *)text withFont:(CGFloat)font;

/*!
 * flo:宽度 @lxa
 */
- (CGSize)sizeWithWidth:(NSString *)text float:(CGFloat )flo;

- (CGSize)sizeWithWidth:(NSString *)text float:(CGFloat )flo heght:(CGFloat)height;
@property (nonatomic,strong,readonly)NSArray *properties;

@property (nonatomic,strong,readonly)NSArray *values;


-(instancetype)initWithDict:(NSDictionary *)dict;

-(void)delay:(NSTimeInterval)timer task:(dispatch_block_t) task;
-(void)cancle:(dispatch_block_t)task;



- (void)fastEncode:(NSCoder *)aCoder;
- (void)fastDecode:(NSCoder *)aDecoder;

@end


@interface NSDictionary (Util)
-(NSDictionary *)nullHandle;
@end

@interface NSObject (Alert)<UIAlertViewDelegate>
-(UIAlertView *)showAlertMessage:(NSString *)message
                            canclebtns:(NSString *)cancle
                           other:(NSString *)other
                          handle:(void (^)(NSInteger index))callBack;
@end

@interface NSNull (JSON)

@end
@interface UIResponder (Router)
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;

@end
