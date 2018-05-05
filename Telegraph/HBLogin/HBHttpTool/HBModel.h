//
//  HBModel.h
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/28.
//

#import <Foundation/Foundation.h>

@interface HBModel : NSObject

@property (nonatomic, assign) NSInteger         code;
@property (nonatomic, copy) NSString            *message;
@property (nonatomic, copy) NSString            *version;
@property (nonatomic, copy) NSString            *path;
@property (nonatomic, strong) NSDictionary      *data;

@end
