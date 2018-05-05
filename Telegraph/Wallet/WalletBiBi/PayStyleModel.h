//
//  PayStyleModel.h
//  Telegraph
//
//  Created by 张玮 on 2018/4/27.
//

#import <Foundation/Foundation.h>

@interface PayStyleModel : NSObject

@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *frozenMoney;
@property (nonatomic,strong) NSString *img;
@property (nonatomic,strong) NSString *money;

@property (nonatomic, strong) UIColor *imgColor;


@end
