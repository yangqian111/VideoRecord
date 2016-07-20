//
//  EXFileManager.h
//  项目基础框架
//
//  Created by 羊谦 on 16/7/6.
//  Copyright © 2016年 NetEase-yangqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXFileManager : NSObject

/// 把对象归档存到沙盒里
+(void)saveObject:(id)object byFileName:(NSString*)fileName;

/// 通过文件名从沙盒中找到归档的对象
+(id)getObjectByFileName:(NSString*)fileName;

/// 根据文件名删除沙盒中的 plist 文件
+(void)removeFileByFileName:(NSString*)fileName;

/// 存储用户偏好设置 到 NSUserDefults
+(void)saveUserData:(id)data forKey:(NSString*)key;

/// 读取用户偏好设置
+(id)readUserDataForKey:(NSString*)key;

/// 删除用户偏好设置
+(void)removeUserDataForkey:(NSString*)key;


@end
