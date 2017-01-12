//
//  WNAudioComposition.h
//  网络音频的同步合成
//
//  Created by 布依男孩 on 15/8/3.
//  Copyright (c) 2015年 汪宁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface WNAudioComposition : NSObject

/*
 视频与音频的合成
 videoURL:视频地址
 audioURL:音频地址
 fileName:要保存的文件名称
 */
- (NSString *)exprotVideoWithAudio:(NSString *)videoURL secondAsset:(NSString *)audioURL saveFileName:(NSString *)fileName;

/*
 两个音频的合成
 asset1, asset2:音频地址
 fileName: 保存到沙盒的文件名称
 */
//- (NSString *)exportAudioWithURL:(NSString *)asset1 otherAssetURL:(NSString *)asset2 saveFileName:(NSString *)fileName;
@end
