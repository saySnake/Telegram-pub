//
//  HBLanguageTool.h
//  newbi
//
//  Created by 张锐 on 2017/8/17.
//  Copyright © 2017年 张锐. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

#define HBLocalizedString(key) [[HBLanguageTool shareLanguage] getStringForKey:key]

typedef NS_ENUM(NSUInteger, LanguageType)
{
    LanguageType_unknown = 0,
    LanguageType_zh,
    LanguageType_en,
    LanguageType_ko,
};

@interface HBLanguageTool : NSObject

@property (nonatomic, assign) LanguageType   type;

- (void)defaultLanguage;

- (NSString *)getStringForKey:(NSString *)key;
- (NSString *)languageString;
- (void)settingLangeType:(LanguageType)type;
- (NSString *)webLanguageString;


singleH(Language);

@end
