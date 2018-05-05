//
//  HBCountry.m
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/19.
//

#import "HBCountry.h"

@implementation HBCountry

+ (instancetype)defautCountry
{
    HBCountry *country = [[HBCountry alloc] init];
    country.area_code = @"0086";
    country.showCode = @"+86";
    country.name_cn = @"中国";
    country.name_en = @"China";
    country.name_ko = @"중국";
    country.country_id = @"country_id";
//    switch ([HBLanguageTool shareLanguage].type) {
//        case LanguageType_en:
//            country.countries = country.name_en;
//            break;
//        case LanguageType_ko:
//            country.countries = country.name_ko;
//            break;
//        case LanguageType_zh:
//            country.countries=country.name_cn;
//            break;
//        default:
//            country.countries = country.name_en;
//            break;
//    }
    country.countries=country.name_cn;
    return country;
}

+ (NSArray *)commonCounttryList
{
    
    //    return @[@"CN",
    //             @"HK",
    //             @"TW",
    //             @"MO",
    //             @"US",
    //             @"JP",
    //             @"KR",
    //             @"BY",
    //             @"GB",
    //             @"DE",
    //             @"CA"];
    //    return @[@"中国",
    //             @"中国香港",
    //             @"中国台湾",
    //             @"中国澳门",
    //             @"美国",
    //             @"日本",
    //             @"韩国",
    //             @"俄罗斯",
    //             @"英国",
    //             @"德国",
    //             @"加拿大"];
    return @[@"37",
             @"71",
             @"169",
             @"100",  //@"中国澳门",
             @"183",  //没有美国 新接口
             @"83",
             @"88",
             @"142", //@"俄罗斯",
             @"182",
             @"60",
             @"32"];
}

+ (NSArray *)searchText:(NSString *)text list:(NSArray *)list
{
    text = [text lowercaseString];
    NSMutableArray *arrayM = [NSMutableArray array];
    for (HBCountry *c in list) {
        NSString *lowercaseCountriesE = [c.name_en lowercaseString];
        if ([lowercaseCountriesE rangeOfString:text].location !=NSNotFound) {
            [arrayM addObject:c];
        } else if ([c.name_cn rangeOfString:text].location !=NSNotFound) {
            [arrayM addObject:c];
        } else if ([c.area_code rangeOfString:text].location !=NSNotFound) {
            [arrayM addObject:c];
        }
    }
    return arrayM;
}

@end
