//
//  HBErrorModel.h
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/27.
//

#import <Foundation/Foundation.h>

@interface HBErrorModel : NSObject

@property (nonatomic, assign) NSInteger         code;
@property (nonatomic, assign) NSInteger         statusCode;
@property (nonatomic, copy) NSString            *message;
@property (nonatomic, copy) NSString            *version;
@property (nonatomic, copy) NSString            *path;
@property (nonatomic, copy) NSString            *url;
@property (nonatomic, copy) NSString            *sessionid;
@property (nonatomic, copy) NSString            *HTTPMethod;
@property (nonatomic, copy) NSString            *HTTPBody;
@property (nonatomic, copy) NSString            *HTTPHeader;
@property (nonatomic, copy) NSString            *desc;
@property (nonatomic, strong) NSDictionary      *data;
@property (nonatomic, assign) NSInteger         responseStatusCode;

@end
