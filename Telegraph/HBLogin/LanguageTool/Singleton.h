//
//  Singleton.h
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/27.
//

//#ifndef Singleton_h
//#define Singleton_h

/**
 *  单例
 */

#define singleH(name)  +(instancetype)share##name

/******************** ARC ***********************/
#if __has_feature(objc_arc)
#define singleM(name) \
static id _instance; \
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (instancetype)share##name\
{\
return  _instance;\
}\
+ (void)initialize\
{\
_instance = [[self alloc] init];\
}\
\
- (id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
\
- (id)mutableCopyWithZone:(NSZone *)zone;\
{\
return _instance;\
}

/******************** MRC ***********************/
#else
#define singleM(name) \
static id _instance; \
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (instancetype)share##name\
{\
return  _instance;\
}\
+ (void)initialize\
{\
_instance = [[self alloc] init];\
}\
\
- (oneway void)release\
{}\
- (id)retain\
{\
return _instance;\
}\
\
- (NSUInteger)retainCount\
{\
return 1;\
}\
\
- (id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
\
- (id)mutableCopyWithZone:(NSZone *)zone;\
{\
return _instance;\
}

#endif

/* Singleton_h */
