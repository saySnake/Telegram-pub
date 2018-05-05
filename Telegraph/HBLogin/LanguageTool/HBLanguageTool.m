//
//  HBLanguageTool.m
//  newbi
//
//  Created by 张锐 on 2017/8/17.
//  Copyright © 2017年 张锐. All rights reserved.
//

#import "HBLanguageTool.h"
//#import "AppDelegate.h"
#import "UserDefaults.h"
//#import "AppDelegate+Common.h"
//#import "HBNavigationController.h"
//#import "HBNewSettingVC.h"

#define ZH @"zh"
#define EN @"en"
#define KO @"ko"

// zh-Hans
// en

#define LANGUAGE_TYPE @"LANGUAGE_TYPE"

static HBLanguageTool *sharedModel;

@interface HBLanguageTool()

@property(nonatomic,copy)NSString *language;

@end

@implementation HBLanguageTool

- (void)defaultLanguage
{
    NSString *localeLanguageCode = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    
    NSNumber *number = [UserDefaults queryObjectForKey:LANGUAGE_TYPE];
    
    LanguageType type = number.integerValue;
    
    if (type != LanguageType_unknown) {
        _type = type;
    } else if ([localeLanguageCode isEqualToString:ZH]) {
        _type = LanguageType_zh;
    } else if ([localeLanguageCode isEqualToString:EN]) {
       _type = LanguageType_en;
    } else if ([localeLanguageCode isEqualToString:KO]) {
       _type = LanguageType_ko;
    } else {
      _type = LanguageType_en;
    }
}

- (void)setType:(LanguageType)type
{
    _type = type;
    [self defaultLanguage];
    [UserDefaults saveObject:@(type) forKey:LANGUAGE_TYPE];
    if (type == LanguageType_unknown) return;
    [self defaultLanguage];
//    [self resetRootVC];
}

- (NSString *)languageString
{
    NSString *string = @"zh-cn";
    switch (_type) {
        case LanguageType_en:
            string = @"en-us";
            break;
         case LanguageType_ko:
            string = @"ko-kr";
            break;
         case LanguageType_zh:
            string = @"zh-cn";
            break;
        default:
            string = @"en-us";
            break;
    }
    return string;
}

- (NSString *)webLanguageString
{
    NSString *string = @"zh";
    switch (_type) {
        case LanguageType_en:
            string = @"en";
            break;
        case LanguageType_ko:
            string = @"ko";
            break;
        case LanguageType_zh:
            string = @"zh";
            break;
        default:
            string = @"en";
            break;
    }
    return string;
}

//- (void)resetRootVC
//{
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate languageResetRootVC];
//    
//    UITabBarController *tabBarVC = (UITabBarController *)appDelegate.window.rootViewController;
//    tabBarVC.selectedIndex = 1;
//    HBNavigationController *nav = tabBarVC.viewControllers[1];
//    HBNewSettingVC *vc = [UIStoryboard storyboardWithName:@"Setting" identifier:NSStringFromClass([HBNewSettingVC class])];
//    [nav pushViewController:vc animated:YES];
//}

- (NSString *)getStringForKey:(NSString *)key
{
    NSString *path = [self getPathWithType:_type];
    NSString *text = [[NSBundle bundleWithPath:path] localizedStringForKey:key value:nil table:@"Localizable"];
    return text;
}

- (NSString *)getPathWithType:(LanguageType)type
{
    NSString *path = @"";
    switch (type) {
        case LanguageType_en:
            path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
            break;
            
        case LanguageType_zh:
            path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
            break;
        case LanguageType_ko:
            path = [[NSBundle mainBundle] pathForResource:@"ko" ofType:@"lproj"];
            break;
            
        default:
            path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
            break;
    }
    return path;
}

- (void)settingLangeType:(LanguageType)type
{
    _type = type;
    [self defaultLanguage];
    [UserDefaults saveObject:@(type) forKey:LANGUAGE_TYPE];
    if (type == LanguageType_unknown) return;
}

singleM(Language);

@end
