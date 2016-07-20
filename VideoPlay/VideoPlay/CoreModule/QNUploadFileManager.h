//
//  UploadManager.h
//  VideoPlay
//
//  Created by 羊谦 on 16/7/19.
//  Copyright © 2016年 VideoPlay All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ComoleteBlock)(BOOL isSuccess);

@interface QNUploadFileManager : NSObject

/**
 *  上传文件
 *
 *  @param data          文件data
 *  @param completeBlcok 完成回调   是否成功
 */
- (void)uploadFileWithData:(NSData *)data complete:(ComoleteBlock)completeBlcok;

@end
