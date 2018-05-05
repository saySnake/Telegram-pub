//
//  HBPriceModel.h
//  Telegraph
//
//  Created by 段智林 on 2018/5/3.
//

#import <Foundation/Foundation.h>

@interface HBPriceModel : NSObject

@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *platorm;
@property(nonatomic,assign) SInt64 count;
@property(nonatomic,assign) double price;
@property(nonatomic,assign) double level;

@end
