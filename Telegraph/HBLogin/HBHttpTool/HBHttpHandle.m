//
//  HBHttpHandle.m
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/28.
//

#import "HBHttpHandle.h"

@implementation HBHttpHandle


+ (void)task:(NSURLSessionDataTask *)task
       error:(NSError *)error
     failure:(void (^)(NSError *error))failure
{
    error = [self error:error task:task obj:nil];
    [self failureError:error];
    if (error.code == 9998) {
        //        return;
    }
    
    if (failure) {
        failure(error);
    }
}

+ (void)task:(NSURLSessionDataTask *)task
         obj:(id)obj
     success:(void (^)(id obj))success
     failure:(void (^)(NSError *error))failure
{
    
    NSInteger ret = -1;
    if ([obj objectForKey:@"code"]) {
        ret = [obj[@"code"] integerValue];
    }
    
    if (ret == 200) {
        [self successObj:obj task:task];
        if (success) {
            success(obj);
        }
    } else if (ret == HBHttp_error_token_overdue || ret == HBHttpCode_unauthorized) {
        
        if (failure) {
            NSError *error = [self error:nil task:task obj:obj];
            [self failureError:error];
            failure(error);
        }
    } else {
        if (failure) {
            NSError *error = [self error:nil task:task obj:obj];
            [self failureError:error];
            failure(error);
        }
    }
    if (ret == HBHttpCode_close) {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:obj[@"msg"]
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:nil, nil]
         show];
    }
}

+ (NSError *)error:(NSError *)error task:(NSURLSessionDataTask *)task obj:(id)obj
{
    NSString *HTTPMethod = task.originalRequest.HTTPMethod;
    NSString *parameters = @"";
    
    NSInteger responseStatusCode = 0;
    if (task) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        responseStatusCode = httpResponse.statusCode;
        id repData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        if (repData) {
            obj = [repData yy_modelToJSONObject];
            if (!obj) {
                NSString *str = [[NSString alloc] initWithData:repData encoding:NSUTF8StringEncoding];
                NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:nil];
                if (dict) {
                    obj = dict;
                }
            }
        }
    }
    
    NSData *data = task.originalRequest.HTTPBody;
    if (data.length > 0) {
        parameters = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    
    if (obj) {
        
        HBModel *m = [HBModel yy_modelWithJSON:obj];
        
        NSString *url = [NSString stringWithFormat:@"%@", task.currentRequest.URL];
        
        
        NSString *header = [NSString stringWithFormat:@"%@%@", response.allHeaderFields, task.currentRequest.allHTTPHeaderFields];
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:obj];
        
        userInfo[@"statusCode"] = [NSString stringWithFormat:@"%zd", response.statusCode];
        userInfo[@"url"] = url;
        userInfo[@"message"] = m.message;
        userInfo[@"HTTPMethod"] = HTTPMethod;
        userInfo[@"HTTPBody"] = parameters;
        userInfo[@"HTTPHeader"] = header;
        userInfo[@"responseStatusCode"] = @(responseStatusCode);
        if (m.data.count > 0) {
            userInfo[@"data"] = m.data;
        }
        
        NSError *err = [NSError errorWithDomain:NSURLErrorDomain
                                           code:m.code
                                       userInfo:userInfo];
        
        return err;
    } else {
        NSInteger code = HBHttpCode_networkError;
        NSString *msg = HBHttpMsg_network_error;
        NSString *url = [NSString stringWithFormat:@"%@", task.currentRequest.URL];
        NSString *header = [NSString stringWithFormat:@"%@%@", response.allHeaderFields, task.currentRequest.allHTTPHeaderFields];
        
        NSInteger statusCode = error.code;
        
        if (-999 == statusCode) {
            msg = HBHttpMsg_network_error;
            code = HBHttpCode_cancelNetwork;
        }
        
        NSDictionary *userInfo = @{@"statusCode" : [NSString stringWithFormat:@"%zd", statusCode],
                                   @"code" : [NSString stringWithFormat:@"%zd", code],
                                   @"url" : url,
                                   @"message" : msg,
                                   @"HTTPMethod" : HTTPMethod,
                                   @"HTTPBody" : parameters,
                                   @"HTTPHeader" : header,
                                   @"desc" : error.debugDescription,
                                   @"responseStatusCode" : @(responseStatusCode)};
        
        NSError *err = [NSError errorWithDomain:NSURLErrorDomain
                                           code:code
                                       userInfo:userInfo];
        return err;
    }
}

+ (void)successObj:(id)obj task:(NSURLSessionDataTask *)task
{
#ifdef DEBUG
    
    NSMutableString *strM = [NSMutableString string];
    
    [strM appendString:@"\n**************************************************************************************************\n"];
    [strM appendString:@"**************************************************************************************************\n"];
    
    NSString *HTTPMethod = task.originalRequest.HTTPMethod;
    [strM appendString:@"\n********* HTTP *********\n"];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
    [strM appendFormat:@"%zd", httpResponse.statusCode];
    [strM appendString:@"\n"];
    [strM appendString:HTTPMethod];
    [strM appendString:@"\n"];
    [strM appendFormat:@"%@", httpResponse.URL];
    [strM appendString:@"\n***********************\n"];
    [strM appendString:@"\n********* HTTPHeader *********\n"];
    [strM appendFormat:@"%@", [self dictToStrWithDict:httpResponse.allHeaderFields]];
    [strM appendFormat:@"%@", [self dictToStrWithDict:task.currentRequest.allHTTPHeaderFields]];
    [strM appendString:@"\n******************************\n"];
    
    NSData *data = task.originalRequest.HTTPBody;
    [strM appendString:@"\n********* HTTPBody *********\n"];
    if (data.length > 0) {
        NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [strM appendFormat:@"%@", [self dictToStrWithDict:parameters]];
    }
    [strM appendString:@"\n****************************\n"];
    if (obj) {
        [strM appendString:@"\n********* ResponseData *********\n"];
        [strM appendFormat:@"%@", [self dictToStrWithDict:obj]];
        [strM appendString:@"\n********************************\n"];
    }
    NSLog(@"%@", strM);
#endif
}

+ (void)failureError:(NSError *)error
{
#ifdef DEBUG
    HBErrorModel *m = [HBErrorModel yy_modelWithJSON:error.userInfo];
    NSLog(@"%@", m.description);
#endif
}

+ (NSString *)dictToStrWithDict:(NSDictionary *)dict
{
    NSMutableString *string = [NSMutableString string];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        string = [[dict yy_modelToJSONString] mutableCopy];
    } else {
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [string appendFormat:@"%@", key];
            [string appendString:@" : "];
            [string appendFormat:@"%@,\n", obj];
        }];
        NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
        if (range.location != NSNotFound)
            [string deleteCharactersInRange:range];
    }
    
    return string;
}

@end
