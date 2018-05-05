//
//  TGWallectModel.h
//  Telegraph
//
//  Created by 张玮 on 2018/4/25.
//

#import <Foundation/Foundation.h>

@interface TGWallectModel : NSObject
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 按钮数组,存放的是图片名称 */
@property (nonatomic, strong) NSArray *btns;
/** segment数组 */
@property (nonatomic, strong) NSArray *segments;



@end
