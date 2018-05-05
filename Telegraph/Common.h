//
//  Common.h
//  DrLink_IOS
//
//  Created by 张玮 on 15/3/17.
//  Copyright (c) 2015年 DrLink. All rights reserved.
//

#ifndef DrLink_IOS_Common_h
#define DrLink_IOS_Common_h

//行间距
#define kLineSpacing 5.0f
//持续时间长
#define Duration 2.0f
//偏移量
#define Offset 50.0f
//定义的颜色函数
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]
//7系统
#define IOS7 ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
//屏幕的高度
#define DScreenH [UIScreen mainScreen].bounds.size.height
//屏幕的宽带
#define DScreenW [UIScreen mainScreen].bounds.size.width
//IPhone4
#define DiPhone4 (DScreenH == 480)
#define DiPhone5 (DScreenH == 568)
#define DiPhone6P (DScreenH > 568 )
//6P的缩放系数
#define autoSizeScaleX  (DScreenH > 480?DScreenW/320:1)
#define autoSizeScaleY  (DScreenH > 480?DScreenH/568:1)
//延迟时间
#define KRequestUrlTimeOut  30
//iphone5
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
//通知
#define   IWNotificationCenter  [NSNotificationCenter defaultCenter]
//本地磁盘
#define   IWDefault  [NSUserDefaults standardUserDefaults]

#define CTColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//随机颜色
#define TGRandomColor CTColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))


#define KBaseColor HEXCOLOR(0x646464)

#if DEBUG
#define DLog(id, ...) NSLog((@"%s [Line %d] " id),__PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(id, ...)
#endif

//RGB颜色系数
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"

#define CHATVIEWBACKGROUNDCOLOR [UIColor colorWithRed:0.936 green:0.932 blue:0.907 alpha:1]

#define Max(a,b,c) (a>b?(a>c?a:c):(b>c?b:c))

#define EColorWithAlpha(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue &0xFF0000) >>16))/255.0 green:((float)((rgbValue &0xFF00) >>8))/255.0 blue:((float)(rgbValue &0xFF))/255.0 alpha:alphaValue]



////

////
#define kLinePixel  0.5
#define kMainBGColor            RGBACOLOR(235, 235, 241, 1)
#define kGlobalBarColor_n         RGBACOLOR(35, 63, 139, 1)
#define kGlobalBarColor_s         RGBACOLOR(28, 49, 119, 1)
#define kGlobalTitleColor         RGBACOLOR(78, 124, 198, 1)

#define  kMainTheme_Color        RGBACOLOR(11, 149, 255, 1)
#define  kLine_Color             RGBACOLOR(211, 212, 212,1)



/**字体设定**/
#define kFontBig              [UIFont systemFontOfSize:20]//[UIFont fontWithName:@"MicrosoftYaHei" size:20]//
#define kFontBig_b            [UIFont boldSystemFontOfSize:20]
#define kFontLarge_1            [UIFont systemFontOfSize:18]//[UIFont fontWithName:@"MicrosoftYaHei" size:18]//
#define kFontLarge_1_b          [UIFont boldSystemFontOfSize:18]

#define kFontLarge            [UIFont systemFontOfSize:16]//[UIFont fontWithName:@"MicrosoftYaHei" size:16]//
//#define kFontLarge_b          [UIFont boldSystemFontOfSize:16]

//#define kFontNormalBold         [UIFont boldSystemFontOfSize:14]
#define kFontNormal             [UIFont systemFontOfSize:15]//[UIFont fontWithName:@"MicrosoftYaHei" size:15]//
#define kFontMiddle             [UIFont systemFontOfSize:14]//[UIFont fontWithName:@"MicrosoftYaHei" size:14]//
#define kFont13                 [UIFont systemFontOfSize:13]//[UIFont fontWithName:@"MicrosoftYaHei" size:13]

#define kFontSmall              [UIFont systemFontOfSize:12]//[UIFont fontWithName:@"MicrosoftYaHei" size:12]//
//#define kFontSmallBold          [UIFont boldSystemFontOfSize:12]
#define kFontTiny               [UIFont systemFontOfSize:11]//[UIFont fontWithName:@"MicrosoftYaHei" size:11]//
#define kFontMini               [UIFont systemFontOfSize:10]//[UIFont fontWithName:@"MicrosoftYaHei" size:10]//




#define kColorBlue              [UIColor colorWithRed:50/255.0 green:168/255.0 blue:240/255.0 alpha:1]
#define kColorLightBlue         [UIColor colorWithRed:50/255.0 green:168/255.0 blue:240/255.0 alpha:0.5]

#define kColorBlueH             [UIColor colorWithRed:9/255.0 green:104/255.0 blue:184/255.0 alpha:1]
#define kColorBlueD             [UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:1]

#define kColorOrange            [UIColor colorWithRed:255/255.0 green:132/255.0 blue:0/255.0 alpha:1]
#define kColorGreen             [UIColor colorWithRed:76/255.0 green:217/255.0 blue:100/255.0 alpha:1]
#define kColorBackground1       [UIColor colorWithRed:236/255.0 green:238/255.0 blue:240/255.0 alpha:1]
#define kColorBackground2       [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1]
#define kColorLine1             [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1]
#define kColorLine2             [UIColor colorWithRed:174/255.0 green:174/255.0 blue:174/255.0 alpha:1]

#define kColorGray             [UIColor colorWithRed:101/255.0 green:101/255.0 blue:101/255.0 alpha:1]

#define kColorGray1             [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]
#define kColorGray2             [UIColor colorWithRed:141/255.0 green:142/255.0 blue:144/255.0 alpha:1]
#define kColorGray3             [UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:1]
#define kColorGray4             [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1]
#define kColorGray5             [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]


#define kColorRed               [UIColor colorWithRed:255/255.0 green:74/255.0 blue:74/255.0 alpha:1]
#define kColorRedH              [UIColor colorWithRed:210/255.0 green:58/255.0 blue:58/255.0 alpha:1]
#define kColorWhite             [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]



#endif
