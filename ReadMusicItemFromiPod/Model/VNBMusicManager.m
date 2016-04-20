//
//  CHMusicModel.m
//  iSmartTV
//
//  Created by 王斌 on 16/4/18.
//  Copyright © 2016年 Changhong electric Co., Ltd. All rights reserved.
//

#import "VNBMusicManager.h"

#define Cache_Directory [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Web"]

@interface VNBMusicManager ()

@property (nonatomic, strong) AVAssetExportSession* exportSessionMusic;

@end

@implementation VNBMusicManager

/**
 *  读取音乐文件
 *
 *  @param completion 完成后返回一个包含所有音乐信息的 array，
 */
- (void)readMusicItemsFromeAlbumCompletion:(void (^)(NSMutableArray *musicArray, NSError *error))completion{
    __block NSMutableArray *musicItemsArray = [NSMutableArray array];
    __block NSError *err = nil;
    
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:@(MPMediaTypeAnyAudio) forProperty:MPMediaItemPropertyMediaType];
    MPMediaQuery *mediaQuery = [[MPMediaQuery alloc] initWithFilterPredicates:nil];
    [mediaQuery addFilterPredicate:predicate];

    NSArray *items = [mediaQuery items];
    
    for (int i = 0; i < [items count]; i++) {
        
        // 保存所有音乐信息
        VNBMusicItem *musicItem = [[VNBMusicItem alloc] initWithMPMediaItem:items[i]];

        // 不显示Apple Music里面下载的音乐
        /**
         *  由于iPhone 自带的音乐软件Music的推出.从iPod取出来的音乐MPMediaItemPropertyAssetURL属性可能为空.
         *  这是因为iPhone自带软件Music对音乐版权的保护,对于所有进行过 DRM Protection(数字版权加密保护)的音乐
         *  都不能被第三方APP获取并播放.即使这些音乐已经下载到本地.但是还是可以播放本地未进行过数字版权加密的音乐.
         *  也就是自己手动导入的音乐.
         */
        if (musicItem.assetUrl != nil) {
            [musicItemsArray addObject:musicItem];
        }
    }
    
    if (completion) {
        completion(musicItemsArray, err);
    }
}


/**
 *  准备共享音频：先把音频文件从 ipod 库中拷贝出来，再上传给电视播放
 *
 *  @param item       需要共享的音乐对象信息
 *  @param error      错误信息
 *  @param completion 完成后开始共享
 *
 *  @return 是否读取完成
 */
- (BOOL)prepareToShareAlbumItem:(VNBMusicItem *)item error:(NSError **)error completion:(void (^)(NSError *err))completion{
    
//    __block NSError *Error = nil;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    //若文件夹不存在，创建文件夹
    if (![fm fileExistsAtPath:Cache_Directory]) {
        [fm createDirectoryAtPath:Cache_Directory withIntermediateDirectories:YES attributes:nil error:error];
        if (*error) {
            NSLog(@"创建文件夹失败：%@", *error);
            return NO;
        }
    }
    
    [self clearCacheWithOutMusicItem:item];
    
    //音乐 m4a
    NSString *outPathUrl = [[Cache_Directory stringByAppendingPathComponent:item.trackName] stringByAppendingPathExtension:@"m4a"];
    
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:item.assetUrl];
    
    self.exportSessionMusic = [AVAssetExportSession exportSessionWithAsset:urlAsset presetName:AVAssetExportPresetAppleM4A];
    self.exportSessionMusic.outputFileType = AVFileTypeAppleM4A;
    self.exportSessionMusic.shouldOptimizeForNetworkUse = YES;
    self.exportSessionMusic.outputURL = [NSURL fileURLWithPath:outPathUrl];
    
    [self.exportSessionMusic exportAsynchronouslyWithCompletionHandler:^{
        
        switch (self.exportSessionMusic.status) {
            case AVAssetExportSessionStatusUnknown:{//0
                NSLog(@"exportSession.status AVAssetExportSessionStatusUnknown");
                break;
            }
            case AVAssetExportSessionStatusWaiting:{//1
                NSLog(@"exportSession.status AVAssetExportSessionStatusWaiting");
                break;
            }
            case AVAssetExportSessionStatusExporting:{//2
                NSLog(@"exportSession.status AVAssetExportSessionStatusExporting");
                break;
            }
            case AVAssetExportSessionStatusCompleted:{//3
                NSLog(@"exportSession.status AVAssetExportSessionStatusCompleted");
                
                //do something
                break;
            }
            case AVAssetExportSessionStatusFailed:{//4
                
                NSLog(@"exportSession.status2 AVAssetExportSessionStatusFailed");
                NSLog(@"error:%@",self.exportSessionMusic.error);
                break;
            }
            case AVAssetExportSessionStatusCancelled:{//5
                NSLog(@"exportSession.status2 AVAssetExportSessionStatusCancelled");
                break;
            }
            default:
                break;
        }
    }];
    
    return YES;
}

/**
 *  清除缓存
 *
 *  @param item 准备上传的音乐对象
 */
-(void)clearCacheWithOutMusicItem:(VNBMusicItem *)item{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *errors = nil;
    NSArray *fileList = [[NSArray alloc] init];
    fileList = [fm contentsOfDirectoryAtPath:Cache_Directory error:&errors];
    for (NSString *object in fileList) {
        NSString * filePath=[Cache_Directory stringByAppendingPathComponent:object];
        BOOL Ret = [fm fileExistsAtPath:filePath];
        if (Ret) {
            NSError *err;
            [fm removeItemAtPath:filePath error:&err];
        }
    }
}

@end


