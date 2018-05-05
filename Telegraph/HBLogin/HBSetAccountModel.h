//
//  HBSetAccountModel.h
//  Telegraph
//
//  Created by 陈俊儒 on 2018/5/3.
//

#import <Foundation/Foundation.h>

@interface HBSetAccountModel : NSObject

@property(copy,  nonatomic) NSString * account_name;
@property(copy,  nonatomic) NSString * email;
@property(copy,  nonatomic) NSString * phone;
@property(strong,nonatomic) NSNumber * verify_email;
@property(strong,nonatomic) NSNumber * verify_ga;
@property(strong,nonatomic) NSNumber * verify_phone;
@property(strong,nonatomic) NSString * token;

@end
