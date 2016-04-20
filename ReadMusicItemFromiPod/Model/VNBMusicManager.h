//
//  CHMusicModel.h
//  iSmartTV
//
//  Created by 王斌 on 16/4/18.
//  Copyright © 2016年 Changhong electric Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import "VNBMusicItem.h"

@interface VNBMusicManager : NSObject


- (void)readMusicItemsFromeAlbumCompletion:(void (^)(NSMutableArray *musicArray, NSError *error))completion;

@end


