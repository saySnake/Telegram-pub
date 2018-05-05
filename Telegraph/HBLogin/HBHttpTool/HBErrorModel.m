//
//  HBErrorModel.m
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/27.
//

#import "HBErrorModel.h"
#import "YYModel.h"

@implementation HBErrorModel

- (NSString *)description
{
    NSDictionary *dict = [self yy_modelToJSONObject];
    NSMutableString *string = [NSMutableString string];
    [string appendString:@"{\n"];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [string appendFormat:@"\t%@", key];
        [string appendString:@" : "];
        [string appendFormat:@"%@,\n", obj];
    }];
    [string appendString:@"}"];
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound)
        [string deleteCharactersInRange:range];
    return string;
}

@end
