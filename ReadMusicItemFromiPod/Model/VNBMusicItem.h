//
//  CHMusicItem.h
//  iSmartTV
//
//  Created by 王斌 on 16/4/20.
//  Copyright © 2016年 Changhong electric Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface VNBMusicItem : NSObject

@property (strong, nonatomic) MPMediaItem  *audioItem;         ///< iPod-Library中的音乐
@property (strong, nonatomic) NSString     *artistName;        ///< 艺术家名称，歌手
@property (strong, nonatomic) NSString     *fileName;          ///< 文件名称，含后缀".mp3"
@property (strong, nonatomic) NSString     *trackName;         ///< 歌曲名 不含后缀
@property (strong, nonatomic) NSString     *albumName;         ///< 专辑名称
@property (strong, nonatomic) UIImage      *thumbnail;         ///< 专辑缩略图
@property (strong, nonatomic) NSString     *playBackDuration;  ///< 播放时长
@property (strong, nonatomic) NSNumber     *IntDuration;       ///< 时长
@property (strong, nonatomic) NSURL        *assetUrl;          ///< URL地址

//@property (assign, nonatomic) NSUInteger   duration;           ///< 总时间

//@property (strong, nonatomic) NSDictionary *metaData;          ///元数据

- (id)initWithMPMediaItem:(MPMediaItem *)item;

@end
