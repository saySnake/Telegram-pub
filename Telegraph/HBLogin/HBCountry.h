//
//  HBCountry.h
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/19.
//

#import <Foundation/Foundation.h>

@interface HBCountry : NSObject

@property (nonatomic, copy) NSString    *area_code;
@property (nonatomic, copy) NSString    *showCode;
@property (nonatomic, copy) NSString    *country_id;
@property (nonatomic, copy) NSString    *name_cn;
@property (nonatomic, copy) NSString    *name_en;
@property (nonatomic, copy) NSString    *name_ko;
@property (nonatomic, copy) NSString    *countries;

+ (NSArray *)commonCounttryList;
+ (NSArray *)searchText:(NSString *)text list:(NSArray *)list;

+ (instancetype)defautCountry;

@end
