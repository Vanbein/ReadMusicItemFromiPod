//
//  CHMusicItem.m
//  iSmartTV
//
//  Created by 王斌 on 16/4/20.
//  Copyright © 2016年 Changhong electric Co., Ltd. All rights reserved.
//

#import "VNBMusicItem.h"

@implementation VNBMusicItem


- (id)initWithMPMediaItem:(MPMediaItem *)item{
    self = [super init];
    if (self) {
        
        self.audioItem = item;

        //URL 地址
        self.assetUrl = [item valueForProperty:MPMediaItemPropertyAssetURL];
        //歌手
        self.artistName = [item valueForProperty:MPMediaItemPropertyArtist];
        //歌曲名
        self.trackName = [item valueForProperty:MPMediaItemPropertyTitle];

        //文件名
        NSString *fileExt = @".mp3";
        self.fileName = [NSString stringWithFormat:@"%@%@", self.trackName,fileExt];
        
        //专辑名
        self.albumName = [item valueForProperty: MPMediaItemPropertyAlbumTitle];

        //专辑缩略图
        MPMediaItemArtwork *artwork = [item valueForProperty:MPMediaItemPropertyArtwork];
        if (artwork!=nil) {
            self.thumbnail = [artwork imageWithSize:artwork.bounds.size];
        }
        //播放时长
        self.playBackDuration = [self getDurationOfAudioWithItem:item];
        //时长
        self.IntDuration = [self getIntDurationOfAudioWithItem:item];
        
    }
    return self;
}


-(NSString *)getDurationOfAudioWithItem:(id)item{
    
    NSNumber *time = NULL;//= [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
    //获取ALAsset中的时长
    if ([item isKindOfClass:[ALAsset class]]) {
        time = [(ALAsset*)item valueForProperty:ALAssetPropertyDuration];
    }else{
        //获取MPMediaItem中的时长
        time = [(MPMediaItem *)item valueForProperty:MPMediaItemPropertyPlaybackDuration];
    }
    //将秒数转化为分钟
    NSInteger minute = [[NSString stringWithFormat:@"%@",time] integerValue]/60;
    NSInteger second = [[NSString stringWithFormat:@"%@",time] integerValue]%60;
    NSInteger hour = [[NSString stringWithFormat:@"%@",time] integerValue]/3600;
    NSString *duration = @"";
    //    if (minute<10) {
    //        duration=[NSString stringWithFormat:@"%01ld:%02ld",(long)minute,(long)second];
    //    }else if(minute<100){
    //        duration=[NSString stringWithFormat:@"%02ld:%02ld",(long)minute,(long)second];
    //    }else{
    //        duration=[NSString stringWithFormat:@"%03ld:%02ld",(long)minute,(long)second];
    //    }
    //如果时间小于60分钟为mm:ss形式,大于1小时为hh:mm:ss形式
    if (minute < 60) {
        duration=[NSString stringWithFormat:@"%02ld:%02ld",(long)minute,(long)second];
    } else {
        duration=[NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hour,(long)minute,(long)second];
    }

    return duration;
}


-(NSNumber *)getIntDurationOfAudioWithItem:(id)item{
    
    NSNumber *time = NULL;//= [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
    if ([item isKindOfClass:[ALAsset class]]) {
        time = [(ALAsset*)item valueForProperty:ALAssetPropertyDuration];
    }else{
        time = [(MPMediaItem *)item valueForProperty:MPMediaItemPropertyPlaybackDuration];
    }
    return time;
}



@end
