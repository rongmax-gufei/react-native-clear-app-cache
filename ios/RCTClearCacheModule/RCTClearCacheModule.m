//
//  RCTClearCacheModule.m
//  RCTClearCacheModule
//
//  Created by ruby on 2018/01/04.
//  Copyright © 2018年 Learnta. All rights reserved.
//

#import "RCTClearCacheModule.h"

@implementation RCTClearCacheModule
@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

//获取缓存大小
RCT_EXPORT_METHOD(getAppCacheSize:(RCTResponseSenderBlock)callback)
{
    NSString* fileSize = [self filePath:@"2"];
    NSString* fileSizeName = [self filePath:@"1"];
    callback(@[fileSize, fileSizeName]);
}

//清除缓存
RCT_EXPORT_METHOD(clearAppCache:(RCTResponseSenderBlock)callback)
{
    [self clearFile:callback];
}

// 显示缓存大小
- (NSString*)filePath:(NSString*)type
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    return [self folderSizeAtPath :cachPath type:type];
}

// 1:首先我们计算一下 单个文件的大小
- (long long)fileSizeAtPath:( NSString *) filePath {
    NSFileManager * manager = [ NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]) {
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    return 0;
}

// 2:遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）
- (NSString*)folderSizeAtPath:(NSString *) folderPath type:(NSString*)type {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString *fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ) {
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingMode = NSNumberFormatterRoundFloor;
    formatter.maximumFractionDigits = 2;
    
    NSString* strFileSize = [[NSString alloc]init];
    NSMutableString* strFileName = [[NSMutableString alloc]init];
    if (folderSize < 1024) {
        NSNumber* fileSize = [NSNumber numberWithFloat: folderSize];
        strFileSize = [formatter stringFromNumber:fileSize];
        [strFileName setString:@"B"];
    } else if (folderSize < 1048576) {
        NSNumber* fileSize = [NSNumber numberWithFloat: (folderSize / 1024.0)];
        strFileSize = [formatter stringFromNumber:fileSize];
        [strFileName setString:@"KB"];
    } else if(folderSize < 1073741824) {
        NSNumber* fileSize = [NSNumber numberWithFloat: (folderSize / 1048576.0)];
        strFileSize = [formatter stringFromNumber:fileSize];
        [strFileName setString:@"MB"];
    } else {
        NSNumber* fileSize = [NSNumber numberWithFloat: (folderSize / 1073741824.0)];
        strFileSize = [formatter stringFromNumber:fileSize];
        [strFileName setString:@"G"];
    }
    
    if ([type isEqualToString:@"1"]) {
        return strFileName;
    } else {
        return strFileSize;
    }
}

// 清理缓存
- (void)clearFile:(RCTResponseSenderBlock)callback
{
    NSString * cachPath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES ) firstObject];
    
    NSArray * files = [[NSFileManager defaultManager]subpathsAtPath:cachPath];
    
    NSLog ( @"cachpath = %@" , cachPath);
    
    for ( NSString * p in files) {
        NSError * error = nil ;
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
    }
    
    callback(@[[NSNull null]]);
    
}


@end
