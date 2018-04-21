//
//  NSString+Util.m
//  UsedCar
//
//  Created by Alan on 13-11-8.
//  Copyright (c) 2013年 Alan. All rights reserved.
//

#import "NSString+Util.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
//#import "Base64.h"
//#import "OpenUDID.h"

#define gKey    @"drlink.http.api"
#define gIv     @"drlink.api"

#define kAESKey @"1234ZLIS90abcDEF";

@implementation NSString (Util)

+ (NSString *)openUDID
{
    return nil;
    //return [OpenUDID value];
}
-(NSString *)md5_16{
    const char *cStr = [self UTF8String];
    unsigned char result[32];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [[hash lowercaseString] substringWithRange:NSMakeRange(8, 16)];

}
- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

- (NSString*) sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes,(CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

- (NSString *)encrypt3DES
{
    return [self encrypt3DES:gKey iv:gIv];
}

// 3DES加密
- (NSString *)encrypt3DES:(NSString *)key iv:(NSString *)iv
{
    NSData      *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    size_t      plainTextBufferSize = [data length];
    const void  *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t         *bufferPtr = NULL;
    size_t          bufferPtrSize = 0;
    size_t          movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void  *vkey = (const void *)[key UTF8String];
    const void  *vinitVec = (const void *)[iv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData      *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString    *result = [myData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    free(bufferPtr);
    
    return result;
}

- (NSString *)decrypt3DES
{
    return [self decrypt3DES:gKey iv:gIv];
}

// 3DES解密
- (NSString *)decrypt3DES:(NSString *)key iv:(NSString *)iv
{
    NSData      *encryptData =//[Base64 decode:self];
    [[NSData alloc]initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    size_t      plainTextBufferSize = [encryptData length];
    const void  *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t         *bufferPtr = NULL;
    size_t          bufferPtrSize = 0;
    size_t          movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void  *vkey = (const void *)[key UTF8String];
    const void  *vinitVec = (const void *)[iv UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    
    free(bufferPtr);
    
    return result;
}

-(NSString *)encryptAES{
    NSString *key=kAESKey;
    NSData *strData=[self dataUsingEncoding:NSUTF8StringEncoding];
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
     void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [strData bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *enData=[NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        NSString *base64Str=[enData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        return base64Str;
    }else{
        free(buffer);
        return nil;
    }
}
-(NSString *)decryptAES{
    NSString *key=kAESKey;
    NSData *strData=[[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];

    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [strData bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *deData=[NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        return [[NSString alloc] initWithData:deData encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}


/* 转url编码 */
- (NSString *)encodeURL
{
    NSString *strEncode = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    return strEncode;
}

/* 修剪 */
- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/* 防止显示（null） */
- (NSString *)dNull
{
    return (self.length > 0 ? self : @"");
}

/* 中英区别统计长度 英占1 中占2 */
- (int)lengthUnicode {
    int strlength = 0;
    char* p = (char *)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength + 1) / 2;
}

/* 字符串超出宽度省略号 */
- (NSString *)omitForSize:(CGSize)size font:(UIFont *)font
{
    //NSMutableString *str = [NSMutableString stringWithString:self];
    //[self componentsSeparatedByCharactersInSet:(NSCharacterSet *)]
    
    //    CGSize orgSize = [self sizeWithFont:font constrainedToSize:CGSizeMake(size.width, MAXFLOAT) lineBreakMode:UILineBreakModeCharacterWrap];
    //
    //    if (orgSize.height <= size.height && orgSize.width <= size.width)
    //        return self;
    
    NSMutableString *strOmit = [NSMutableString string];
    
    CGSize newSize = CGSizeZero;
    NSUInteger index = 0;
    BOOL isNewline = NO;
    while (YES) {
        
        if (newSize.height > size.height) {
            // 删除两个使其超出范围的字符 (一个删除超出, 一个为了替换成"…");
            [strOmit deleteCharactersInRange:NSMakeRange(index - 2, 2)];
            [strOmit appendString:@"…"];
            break;
        }
        
        if (index < self.length) {
            if (isNewline) {
                [strOmit insertString:@"\n" atIndex:strOmit.length - 1];
            } else {
                [strOmit appendString:[self substringWithRange:NSMakeRange(index, 1)]];
                index++;
            }
        } else
            break;
        
        CGSize tmpSize = [strOmit boundingRectWithSize:CGSizeMake(size.width, MAXFLOAT)  options:0 attributes:@{NSFontAttributeName:font} context:nil].size;
        if (newSize.height > 0 && newSize.height < tmpSize.height)
            isNewline = YES;
        else
            isNewline = NO;
        newSize = tmpSize;
    }
    
    return strOmit;
}

- (BOOL)isContainsEmoji
{
    __block BOOL returnValue = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

-(BOOL)isChinese{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

-(BOOL)pwValid{
    NSString *regex=@"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch=[pred evaluateWithObject:self];
    return isMatch;

}


-(BOOL)isURL{
    NSString *regex=@"[a-zA-z]+://[^\\s]*";//@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch=[pred evaluateWithObject:[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return isMatch;
}


//-(WebModel *)isFile{
//
//
//    NSString *decodeUrl=[self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSArray *urlinfo=[decodeUrl componentsSeparatedByString:@"/"];
//    if (urlinfo.count<4) {
//        return nil;
//    }else{
//        NSString *header=urlinfo.firstObject;
//        BOOL ishttp=[header rangeOfString:@"http"].length>0;
//        if (!ishttp) {
//            return nil;
//        }
//        NSString *host=urlinfo[2];
//
//        NSPredicate *pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",KFILE_HOST];
//        BOOL isMatch=[pred evaluateWithObject:[host stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        NSInteger isContain=[[host stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] rangeOfString:OSSMainPath].length;
//        if (isMatch==NO && isContain==NO) {
//            return nil;
//        }
//        NSString *fileName=urlinfo.lastObject;
//
//        WebModel *model=[[WebModel alloc] init];
//        model.isFile=YES;
//        model.fileURL=[NSURL URLWithString:self];
//        model.fileName=fileName;
//        model.fileType=[fileName pathExtension];
//        model.fileIcon=[NSString imageWithFileType:model.fileType];
//
//        return model;
//    }
//}


+(UIImage *)imageWithFileType:(NSString *)type{
    NSString *imagename;
    if (type.length==0) {
        imagename=@"qita";
    }else
        if ([type isEqualToString:@"doc"]||[type isEqualToString:@"docx"]) {
            imagename=@"word";
        }else if ([type isEqualToString:@"xls"]||[type isEqualToString:@"xlsx"]){
            imagename=@"excel";
        }else if ([type isEqualToString:@"ppt"]||[type isEqualToString:@"pptx"]){
            imagename=@"ppt";
        }else if ([type isEqualToString:@"pdf"]){
            imagename=@"pdf";
        }else if ([type isEqualToString:@"jpg"]||[type isEqualToString:@"jpeg"]){
            imagename=@"jpg";
        }else if ([type isEqualToString:@"mp3"]){
            imagename=@"mp3";
        }else if ([type isEqualToString:@"rar"]||[type isEqualToString:@"zip"]){
            imagename=@"rar";
        }else if ([type isEqualToString:@"text"]){
            imagename=@"text";
        }else{
            imagename=@"qitaimg";
        }
    return [UIImage imageNamed:imagename];
}

+ (NSString *)decodeUTF8ToChinese:(NSString *)encodeStr;
{
    return [encodeStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)encodeChineseToUTF8:(NSString *)encodeStr;
{
    return [[NSString stringWithFormat:@"%@",encodeStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(NSMutableAttributedString *)lineSpacing:(NSInteger)spc{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:spc];
    [attributedString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle1} range:NSMakeRange(0, [self length])];
    
    return attributedString;
}
@end


@implementation NSString (NSDate)
/*----返回日期格式如：12月25日/星期四----*/
+(NSString *)getDateString:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy/MM/dd hh:mm:ss"];
    
    NSDate *date = [formatter dateFromString:string];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone: timeZone];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSWeekdayCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周天", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSString *dateString = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld/%@",(long)year,(long)month,(long)day,[weekdays objectAtIndex:week]];
    
    return dateString;
}


+(NSString *)nowDateFmtStr:(NSString *)fmt{
    NSDate *now=[NSDate date];
    if (fmt) {
        NSDateFormatter *dfmt=[[NSDateFormatter alloc]init];
        [dfmt setDateFormat:fmt];
        return [dfmt stringFromDate:now];
    }else {
        NSDateFormatter *dfmt=[[NSDateFormatter alloc]init];
        [dfmt setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        return [dfmt stringFromDate:now];
        
    }
    
}
+(NSString *)timeStamp
{
    static int i=0;
    i++;
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%lld",(long long)time+i];
}

+(NSString *)dateFmtStr:(NSString *)fmt date:(NSDate *)date{
    if (!fmt) {
        fmt=@"yyyy-MM-dd hh:ss:mm";
    }
    NSDateFormatter *dfmt=[[NSDateFormatter alloc]init];
    [dfmt setDateFormat:fmt];
    return [dfmt stringFromDate:date];
}


+(NSString *)fmtDateString:(NSString *)date withFmt:(NSString *)fmt{
    NSDateFormatter *datefmt=[[NSDateFormatter alloc] init];
    datefmt.dateFormat=fmt;
    NSDate *fmtdate=[datefmt dateFromString:date];
    
    return [NSString timeIntervalDescription:fmtdate];
}


+(NSString *)timeIntervalDescription:(NSDate *)date
{
    NSTimeInterval timeInterval = -[date timeIntervalSinceNow];
    if (timeInterval < 60) {
        return @"1分钟内";
        
    } else if (timeInterval < 3600) {
        return [NSString stringWithFormat:@"%.f分钟前", timeInterval / 60];
        
    } else if (timeInterval < 86400) {
        return [NSString stringWithFormat:@"%.f小时前", timeInterval / 3600];
        
    } else if (timeInterval < 2592000) {//30天内
        return [NSString stringWithFormat:@"%.f天前", timeInterval / 86400];
        
    } else if (timeInterval < 31536000) {//30天至1年内
        return [NSString dateFmtStr:@"M月d日" date:date];
    } else {
        return [NSString dateFmtStr:@"y年M月d日" date:date];//[NSString stringWithFormat:@"%.f年前", timeInterval / 31536000];
    }
}
-(NSDateComponents *)componentsWithFormat:(NSString *)fmt{
    NSDateFormatter *datefmt=[[NSDateFormatter alloc] init];
    datefmt.dateFormat=fmt;
    NSDate *date=[datefmt dateFromString:self];
    return [[NSCalendar currentCalendar]components:NSCalendarUnitDay|NSCalendarUnitMonth|kCFCalendarUnitYear|NSCalendarUnitWeekday fromDate:date];
}



+ (NSString *)stringFromDate:(NSNumber *)number{
    
        NSDate *date =[NSDate dateWithTimeIntervalSince1970:number.longLongValue/1000];
        return [NSString dateFmtStr:@"yyyy-MM-dd" date:date];
}
                    
+ (NSString *)getConstellation:(NSDate *)date {
    //计算星座
    
    NSString *retStr=@"";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];    [dateFormat setDateFormat:@"MM"];
    int i_month = 0;
    NSString *theMonth = [dateFormat stringFromDate:date];
    if([[theMonth substringToIndex:0] isEqualToString:@"0"]) {
        i_month = [[theMonth substringFromIndex:1] intValue];
    } else {
        i_month = [theMonth intValue];
    }
    
    [dateFormat setDateFormat:@"dd"];
    int i_day = 0;
    NSString *theDay = [dateFormat stringFromDate:date];
    if([[theDay substringToIndex:0] isEqualToString:@"0"]) {
        i_day = [[theDay substringFromIndex:1] intValue];
    } else {
        i_day = [theDay intValue];
    }
    /*
     摩羯座 12月22日------1月19日
     水瓶座 1月20日-------2月18日
     双鱼座 2月19日-------3月20日
     白羊座 3月21日-------4月19日
     金牛座 4月20日-------5月20日
     双子座 5月21日-------6月21日
     巨蟹座 6月22日-------7月22日
     狮子座 7月23日-------8月22日
     处女座 8月23日-------9月22日
     天秤座 9月23日------10月23日
     天蝎座 10月24日-----11月21日
     射手座 11月22日-----12月21日
     */
    switch (i_month) {
        case 1:
            if(i_day>=20 && i_day<=31){
                retStr=@"水瓶座";
            }
            if(i_day>=1 && i_day<=19){
                retStr=@"摩羯座";
            }
            break;
        case 2:
            if(i_day>=1 && i_day<=18){
                retStr=@"水瓶座";
            }
            if(i_day>=19 && i_day<=31){
                retStr=@"双鱼座";
            }
            break;
        case 3:
            if(i_day>=1 && i_day<=20){
                retStr=@"双鱼座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"白羊座";
            }
            break;
        case 4:
            if(i_day>=1 && i_day<=19){
                retStr=@"白羊座";
            }
            if(i_day>=20 && i_day<=31){
                retStr=@"金牛座";
            }
            break;
        case 5:
            if(i_day>=1 && i_day<=20){
                retStr=@"金牛座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"双子座";
            }
            break;
        case 6:
            if(i_day>=1 && i_day<=21){
                retStr=@"双子座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"巨蟹座";
            }
            break;
        case 7:
            if(i_day>=1 && i_day<=22){
                retStr=@"巨蟹座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"狮子座";
            }
            break;
        case 8:
            if(i_day>=1 && i_day<=22){
                retStr=@"狮子座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"处女座";
            }
            break;
        case 9:
            if(i_day>=1 && i_day<=22){
                retStr=@"处女座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"天秤座";
            }
            break;
        case 10:
            if(i_day>=1 && i_day<=23){
                retStr=@"天秤座";
            }
            if(i_day>=24 && i_day<=31){
                retStr=@"天蝎座";
            }
            break;
        case 11:
            if(i_day>=1 && i_day<=21){
                retStr=@"天蝎座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"射手座";
            }
            break;
        case 12:
            if(i_day>=1 && i_day<=21){
                retStr=@"射手座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"摩羯座";
            }
            break;
    }
    return retStr;
}

@end

