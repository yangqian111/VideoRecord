//
//  UploadManager.m
//  VideoPlay
//
//  Created by 羊谦 on 16/7/19.
//  Copyright © 2016年 VideoPlay All rights reserved.
//

#import "QNUploadFileManager.h"
#import <QiniuSDK.h>
#import "QN_GTM_Base64.h"
#include <CommonCrypto/CommonCrypto.h>


#define bucket @"yangqian-test"//七牛文件存储空间名
#define accessKey @"KLRJ2Xho4pw3OoIto31l1v321ycVAUBfvsezq__0"//账户公钥
#define secretKey @"XsJQIem9Px8jvzOCH_5X02dQ5tY_VJ0cr7mivGuQ"//账户密钥

@interface QNUploadFileManager ()

@property (nonatomic, assign) int expires;

@end

@implementation QNUploadFileManager

-(void)uploadFileWithData:(NSData *)data complete:(ComoleteBlock)completeBlcok {
    
}


- (NSString *)makeToken
{
    const char *secretKeyStr = [secretKey UTF8String];
    
    NSString *policy = [self marshal];
    
    NSData *policyData = [policy dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *encodedPolicy = [QN_GTM_Base64 stringByWebSafeEncodingData:policyData padded:TRUE];
    const char *encodedPolicyStr = [encodedPolicy cStringUsingEncoding:NSUTF8StringEncoding];
    
    char digestStr[CC_SHA1_DIGEST_LENGTH];
    bzero(digestStr, 0);
    
    CCHmac(kCCHmacAlgSHA1, secretKeyStr, strlen(secretKeyStr), encodedPolicyStr, strlen(encodedPolicyStr), digestStr);
    
    NSString *encodedDigest = [QN_GTM_Base64 stringByWebSafeEncodingBytes:digestStr length:CC_SHA1_DIGEST_LENGTH padded:TRUE];
    
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  accessKey, encodedDigest, encodedPolicy];
    
    return token;//得到了token
}
- (NSString *)marshal
{
    time_t deadline;
    time(&deadline);//返回当前系统时间
    
    deadline += (self.expires > 0) ? self.expires : 3600*24; // +3600秒,即默认token保存1小时.
    
    NSNumber *deadlineNumber = [NSNumber numberWithLongLong:deadline];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:bucket forKey:@"scope"];//根据
    
    [dic setObject:deadlineNumber forKey:@"deadline"];
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *json = [jsonString copy];
    
    return json;
}


@end
