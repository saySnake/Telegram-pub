//
//  HBHttpHandle.h
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/28.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface HBHttpHandle : NSObject

+ (void)task:(NSURLSessionDataTask *)task
       error:(NSError *)error
     failure:(void (^)(NSError *error))failure;

+ (void)task:(NSURLSessionDataTask *)task
         obj:(id)obj
     success:(void (^)(id obj))success
     failure:(void (^)(NSError *error))failure;



@end
