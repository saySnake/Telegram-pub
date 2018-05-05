//
//  HBFindNewsModel.h
//  Telegraph
//
//  Created by 段智林 on 2018/5/4.
//

#import <Foundation/Foundation.h>

@interface HBFindNewsModel : NSObject
@property(nonatomic,copy) NSString *title;
@property(nonatomic,assign) int viewCount;
@property(nonatomic,copy) NSString *date;

@property(nonatomic,copy) NSString *iconUrl;
@property(nonatomic,assign) int newsType;
@property(nonatomic,assign) int duration;
@end
