//
//  UserDefaults.m
//  iOTNews
//
//  Created by Airy on 15/6/11.
//  Copyright (c) 2015年 iotooth. All rights reserved.
//

#import "UserDefaults.h"

@implementation UserDefaults

+ (BOOL)saveObject:(id)object forKey:(NSString *)key
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:object forKey:key];
    return [user synchronize];
}

+ (id)queryObjectForKey:(NSString *)key
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:key];
}

+ (void)removeObjectForKey:(NSString *)key
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:key];
}

@end
