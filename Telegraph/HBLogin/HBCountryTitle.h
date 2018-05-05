//
//  HBCountryTitle.h
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/19.
//

#import <Foundation/Foundation.h>

@interface HBCountryTitle : NSObject

@property (nonatomic, copy) NSString    *title;
@property (nonatomic, strong) NSArray   *list;

+ (instancetype)titleWithTitle:(NSString *)title list:(NSArray *)list;
- (instancetype)initWithTitle:(NSString *)title list:(NSArray *)list;

+ (NSArray *)reloadList:(NSArray *)list;

@end
