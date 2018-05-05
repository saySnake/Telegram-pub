//
//  KeychainTool.m
//  iOTNews
//
//  Created by Airy on 15/5/8.
//  Copyright (c) 2015年 iotooth. All rights reserved.
//

#import "KeychainTool.h"

@implementation KeychainTool

+ (NSDictionary *)getKeychainQuery:(NSString *)service
{
    NSString *groupStr = [[NSBundle mainBundle].infoDictionary objectForKey:@"AppIdentifierPrefix"];
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
            service, (__bridge_transfer id)kSecAttrService,
            service, (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
            groupStr, (__bridge_transfer id)kSecAttrAccessGroup,
            nil];
}

+ (void)keychainSave:(NSString *)service data:(id)data
{
    
    NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionary];
    
    keychainQuery.dictionary = [self getKeychainQuery:service];
    
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
}

+ (id)keychainQuery:(NSString *)service
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionary];
    keychainQuery.dictionary = [self getKeychainQuery:service];
    
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
            
        }
    }
    return ret;
}

+ (void)keychainDelete:(NSString *)service
{
    NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionary];
    keychainQuery.dictionary = [self getKeychainQuery:service];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
}

@end
