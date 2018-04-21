//
//  NSObject+Util.m
//  HuanYouWang
//
//  Created by liuwenjie on 15/5/15.
//  Copyright (c) 2015年 cc.huanyouwang. All rights reserved.
//

#import "NSObject+Util.h"
@implementation NSObject (Util)

- (CGSize)sizeWithText:(NSString *)text
{
    NSDictionary *attribute =@{NSFontAttributeName :kFont13};
    CGSize size =[text boundingRectWithSize:CGSizeMake(1000, MAXFLOAT) options:0|1 attributes:attribute context:nil].size;
    return size;
}


- (CGSize)sizeWithText:(NSString *)text withFont:(CGFloat)font
{
    NSDictionary *attribute =@{NSFontAttributeName :[UIFont systemFontOfSize:font]};
    CGSize size =[text boundingRectWithSize:CGSizeMake(1000, MAXFLOAT) options:0|1 attributes:attribute context:nil].size;
    return size;
}

- (CGSize)sizeWithWidth:(NSString *)text float:(CGFloat )flo
{
    NSDictionary *attribute =@{NSFontAttributeName :kFont13};
    CGSize size =[text boundingRectWithSize:CGSizeMake(flo, MAXFLOAT) options:0|1 attributes:attribute context:nil].size;
    return size;
    
}


- (CGSize)sizeWithWidth:(NSString *)text float:(CGFloat )flo heght:(CGFloat)height
{
    NSDictionary *attribute =@{NSFontAttributeName :kFont13};
    
    CGSize size =[text boundingRectWithSize:CGSizeMake(flo, height) options:0|1 attributes:attribute context:nil].size;
    return size;
}

-(NSArray *)properties{
    u_int count=0;
    objc_property_t *properties=class_copyPropertyList([self class], &count);
    NSMutableArray *marray=[NSMutableArray array];
    for (int i=0; i<count; i++) {
        const char* pname=property_getName(properties[i]);
        NSString *key=[NSString stringWithUTF8String:pname];
        id value=[self valueForKey:key];
        if (value) {
            [marray addObject:@{key:value}];
        }
        
    }
    free(properties);
    return [marray copy];
}
-(NSArray *)values{
    u_int count=0;
    objc_property_t *properties=class_copyPropertyList([self class], &count);
    NSMutableArray *marray=[NSMutableArray array];
    for (int i=0; i<count; i++) {
        const char* pname=property_getName(properties[i]);
        NSString *key=[NSString stringWithUTF8String:pname];
        id value=[self valueForKey:key];
        if (value) {
            [marray addObject:value];
        }
        
    }
    free(properties);
    return [marray copy];

}
-(instancetype)initWithDict:(NSDictionary *)dict{
    self=[self init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return self;
    }
    u_int count=0;
    objc_property_t *properties=class_copyPropertyList([self class], &count);
    for (int i=0; i<count; i++) {
        const char* pname=property_getName(properties[i]);
        NSString *key=[NSString stringWithUTF8String:pname];
        
        id value=dict[key];
        if ([key isEqualToString:@"description"]) {
            value=nil;
        }
        if ([value isMemberOfClass:[NSNull class]]) {
            value=nil;
        }
        if (value) {
            [self setValue:value forKey:key];
        }
    }
    free(properties);
    return self;
}
-(void)delay:(NSTimeInterval)timer task:(dispatch_block_t)task{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timer * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        task();                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    });
}
-(void)cancle:(dispatch_block_t)task{
    if (task) {
        dispatch_block_cancel(task);
    }
}

- (void)fastEncode:(NSCoder *)aCoder{
    
    u_int count=0;
    objc_property_t *properties=class_copyPropertyList([self class], &count);
    for (int i=0; i<count; i++) {
        const char* pname=property_getName(properties[i]);
        NSString *key=[NSString stringWithUTF8String:pname];
        id value=[self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    free(properties);

}
-(void)fastDecode:(NSCoder *)aDecoder{
    u_int count=0;
    objc_property_t *properties=class_copyPropertyList([self class], &count);
    for (int i=0; i<count; i++) {
        const char* pname=property_getName(properties[i]);
        NSString *key=[NSString stringWithUTF8String:pname];
        id value=[aDecoder decodeObjectForKey:key];
        if (value) {
            [self setValue:value forKey:key];
        }
    }
    free(properties);
}
@end

@implementation NSDictionary (Util)
-(NSDictionary *)nullHandle{
    NSMutableDictionary *mdict=[NSMutableDictionary dictionaryWithDictionary:self];
    [mdict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSNull class]]) {
            [mdict setObject:@"" forKey:key];
        }
    }];
    return [mdict copy];
}
@end

@implementation NSObject (Alert)

-(UIAlertView *)showAlertMessage:(NSString *)message canclebtns:(NSString *)cancle other:(NSString *)other handle:(void (^)(NSInteger))callBack{
    UIAlertView  *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:cancle otherButtonTitles:other, nil];
    [alert show];
    objc_setAssociatedObject(self, "callback", callBack, OBJC_ASSOCIATION_COPY);
    return alert;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    void (^callBack)(NSInteger index)= objc_getAssociatedObject(self, "callback");
    if (callBack) {
        callBack(buttonIndex);
    }
}
@end
@implementation NSNull (JSON)

- (void)forwardInvocation:(NSInvocation *)invocation
{
    if ([self respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:self];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *sig = [[NSNull class] instanceMethodSignatureForSelector:selector];
    if(sig == nil) {
        sig = [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
    }
    return sig;
}
@end
@implementation UIResponder (Router)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}

@end
