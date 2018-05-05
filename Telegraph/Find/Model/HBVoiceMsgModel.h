//
//  HBVoiceMsgModel.h
//  Telegraph
//
//  Created by 段智林 on 2018/5/3.
//

#import <Foundation/Foundation.h>

@interface HBVoiceMsgModel : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *avatar;
@property(nonatomic,assign) int starLevel;
@property(nonatomic,assign) int duration;
@end
