//
//  KeychainTool.h
//  iOTNews
//
//  Created by Airy on 15/5/8.
//  Copyright (c) 2015年 iotooth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainTool : NSObject

+ (void)keychainSave:(NSString *)service data:(id)data;

+ (id)keychainQuery:(NSString *)service;

+ (void)keychainDelete:(NSString *)service;

@end
