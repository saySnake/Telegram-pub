//
//  HBCountryTitle.m
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/19.
//

#import "HBCountryTitle.h"
#import "HBCountry.h"


@implementation HBCountryTitle

+ (NSArray *)reloadList:(NSArray *)list
{
//    LanguageType type = [HBLanguageTool shareLanguage].type;
    for (HBCountry *c in list) {
        if ([c.area_code hasPrefix:@"00"]) {
            NSString *code = [c.area_code substringFromIndex:2];
            c.showCode = [NSString stringWithFormat:@"+%@", code];
//            switch (type) {
//                case LanguageType_en:
//                    c.countries = c.name_en;
//                    break;
//                case LanguageType_zh:
//                    c.countries = c.name_cn;
//                    break;
//                case LanguageType_ko:
//                    if (c.name_ko.length>0) {
//                        c.countries = c.name_ko;
//                    }else{
//                        c.countries = c.name_en;
//                    }
//                    break;
//                default:
//                    c.countries = c.name_en;
//                    break;
//            }
            c.countries = c.name_cn;//暂时先为中文
        }
    }
    //挑选出常用的国家
    NSArray *commonCounttryList = [HBCountry commonCounttryList];
    
    NSMutableArray *commonList = [NSMutableArray array];
    for (NSString *area_code in commonCounttryList) {
        for (HBCountry * c in list) {
            if ([area_code isEqualToString:c.country_id]) {
                [commonList addObject:c];
            }
        }
    }
    
    HBCountryTitle *common = [HBCountryTitle titleWithTitle:TGLocalized(@"country_category_common") list:commonList];
    HBCountryTitle *all = [HBCountryTitle titleWithTitle:TGLocalized(@"country_category_all") list:list];
    return @[common, all];
//    return @[all];

}
+ (instancetype)titleWithTitle:(NSString *)title list:(NSArray *)list
{
    return [[self alloc] initWithTitle:title list:list];
}

- (instancetype)initWithTitle:(NSString *)title list:(NSArray *)list
{
    HBCountryTitle *c = [[HBCountryTitle alloc] init];
    c.title = title;
    c.list = list;
    return c;
}

@end
