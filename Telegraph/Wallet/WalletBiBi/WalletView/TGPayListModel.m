//
//  TGPayListModel.m
//  Telegraph
//
//  Created by 张玮 on 2018/4/28.
//

#import "TGPayListModel.h"

@implementation TGPayListModel

+(NSString *)payListStr:(NSInteger)tag
{
    NSString *str;
    
    switch(tag){
        case 0:
            str =@"HotPay交易";
            break;
        case 1:
            str =@"发币交易";
            break;
        case 2:
            str =@"币币交易";
            break;
        case 3:
            str =@"红包";
            break;
        case 4:
            str =@"糖果";
            break;
        case 5:
            str =@"火腿";
            break;
    }
    return str;
}

+ (NSString *)getCoinStr:(NSInteger)tag
{
    NSString *str;
    switch (tag) {
        case 0:{
            str =@"BTC";
        }
            
            break;
        case 1:{
            str =@"ETH";
        }
            break;
        case 2:{
            str =@"USDT";
            
        }
            break;
        default:
            break;
    }
    return str;
}

@end
