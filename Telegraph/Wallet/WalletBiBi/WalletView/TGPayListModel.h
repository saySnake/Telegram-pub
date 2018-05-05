//
//  TGPayListModel.h
//  Telegraph
//
//  Created by 张玮 on 2018/4/28.
//

#import <Foundation/Foundation.h>

@interface TGPayListModel : NSObject

+(NSString *)payListStr:(NSInteger)type;


+ (NSString *)getCoinStr:(NSInteger)tag;//Coin筛选

@end
