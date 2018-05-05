//
//  UserDefaults.h
//  iOTNews
//
//  Created by Airy on 15/6/11.
//  Copyright (c) 2015年 iotooth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject

+ (BOOL)saveObject:(id)object forKey:(NSString *)key;

+ (id)queryObjectForKey:(NSString *)key;

+ (void)removeObjectForKey:(NSString *)key;

@end
