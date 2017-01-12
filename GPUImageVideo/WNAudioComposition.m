//
//  WNAudioComposition.m
//  网络音频的同步合成
//
//  Created by 布依男孩 on 15/8/3.
//  Copyright (c) 2015年 汪宁. All rights reserved.
//

#import "WNAudioComposition.h"
#import <AVFoundation/AVFoundation.h>
@interface WNAudioComposition ()

@property(nonatomic, strong) NSMutableArray *audioMixParams;

@end

@implementation WNAudioComposition

- (NSMutableArray *)audioMixParams{
    
    if (!_audioMixParams) {
        _audioMixParams = [NSMutableArray array];
    }
    
    return _audioMixParams;
}

/*
- (NSString *) exportAudioWithURL:(NSString *)asset1 otherAssetURL:(NSString *)asset2 saveFileName:(NSString *)fileName {
    
    //创建一个合成音视频合成对象
    AVMutableComposition *composition = [AVMutableComposition composition];
    //获取音频的URL
    NSURL *assetURL1 = [NSURL URLWithString:asset1];
    NSURL *assetURL2 = [NSURL URLWithString:asset2];
    
    //获取音效
    AVURLAsset *songAsset1 = [AVURLAsset URLAssetWithURL:assetURL1 options:nil];
    AVURLAsset *songAsset2 = [AVURLAsset URLAssetWithURL:assetURL2 options:nil];
    //设置开始时间,,CMTimeMakeWithSeconds(a,b,c,d) a = value  b = timescale c = flags  d = 循环数
    CMTime startTime = CMTimeMakeWithSeconds(0, 1);
    NSLog(@"开始时间==%d",startTime.timescale);
    
    //获取音效的持续时间,选择时间长的音频时间
    CMTime trackDuration = songAsset1.duration.value > songAsset2.duration.value ? songAsset1.duration : songAsset2.duration;
    NSLog(@"音频时间==%lld",trackDuration.value / 44100);
    
    /*
     真正要表達的時間就會是 time / timeScale 才會是秒.
     
     CMTimeMake(14*44100, 44100) == 14秒
     
     音频中每一秒的帧数为44100
     */
/*
    [self setUpAndAddAudioAtPath:assetURL1 toComposition:composition start:startTime dura:trackDuration offset:CMTimeMake(0, 44100)];
    
    [self setUpAndAddAudioAtPath:assetURL2 toComposition:composition start:startTime dura:trackDuration offset:CMTimeMake(0, 44100)];
    //混合音频
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    audioMix.inputParameters = [NSArray arrayWithArray:self.audioMixParams];
    
    //第二个参数:出口的预置模板的名称AVAssetExportPresetAppleM4A == 与iTunes无缝连接音频
    //创建一个输出资源会话
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
                                      initWithAsset: composition
                                      presetName:AVAssetExportPresetAppleM4A];
    exporter.audioMix = audioMix;
    //输出文件类型
    exporter.outputFileType = @"com.apple.m4a-audio";
    //存储的具体路径
    NSString *componet = [NSString stringWithFormat:@"%@.m4a",fileName];
    NSString *exportFile = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:componet];
    NSLog(@"输出文件路径%@",exportFile);
    
    //检查是否已经存在文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportFile]) {
        [[NSFileManager defaultManager] removeItemAtPath:exportFile error:nil];
    }
    
    //输出路径
    NSURL *exportURL = [NSURL fileURLWithPath:exportFile];
    exporter.outputURL = exportURL;
    
    // 开始输出文件
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        
        //完成输出后打印出输出的各种状态
        int exportStatus = exporter.status;
        switch (exportStatus) {
            case AVAssetExportSessionStatusFailed:{
                NSError *exportError = exporter.error;
                NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                break;
            }
            case AVAssetExportSessionStatusCompleted: NSLog (@"AVAssetExportSessionStatusCompleted"); break;
            case AVAssetExportSessionStatusUnknown: NSLog (@"AVAssetExportSessionStatusUnknown"); break;
            case AVAssetExportSessionStatusExporting: NSLog (@"AVAssetExportSessionStatusExporting"); break;
            case AVAssetExportSessionStatusCancelled: NSLog (@"AVAssetExportSessionStatusCancelled"); break;
            case AVAssetExportSessionStatusWaiting: NSLog (@"AVAssetExportSessionStatusWaiting"); break;
            default:  NSLog (@"didn't get export status"); break;
        }
    }];
    
    return exportFile;
}

*/

- (void) setUpAndAddAudioAtPath:(NSURL*)assetURL toComposition:(AVMutableComposition *)composition start:(CMTime)start dura:(CMTime)dura offset:(CMTime)offset{
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    //创建一个可变的混合音轨
    AVMutableCompositionTrack *track = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //获取资源的第一个音轨
    AVAssetTrack *sourceAudioTrack = [[songAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    
    NSError *error = nil;
    //获取开始时间
    CMTime startTime = start;
    //获取当前音效的持续时间
    CMTime trackDuration = dura;
    //音轨的range
    CMTimeRange tRange = CMTimeRangeMake(startTime, trackDuration);
    
    //音量
    AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
    //设置音量为5
    [trackMix setVolume:0.5f atTime:startTime];
    //将音量属性添加到一个数组
    [self.audioMixParams addObject:trackMix];
    
    //插入
    //offset表示当前音乐的总时间
    [track insertTimeRange:tRange ofTrack:sourceAudioTrack atTime:offset error:&error];
}

- (NSString *)exprotVideoWithAudio:(NSString *)videoURL secondAsset:(NSString *)audioURL saveFileName:(NSString *)fileName{
    
    //创建一个混合实例
    AVMutableComposition *compositionM = [[AVMutableComposition alloc] init];
    
    //创建一个混合轨道
    AVMutableCompositionTrack *videoTrack = [compositionM addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    //视频asset
    AVURLAsset *videoAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:videoURL] options:nil];
    //音频asset
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:audioURL] options:nil];
    
    //将抽出来的视频插入轨道
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    NSLog(@"视频的时间==%lld",videoAsset.duration.value / 44100);
    
    //将抽出来的音频插入轨道
    AVMutableCompositionTrack *audioTrack = [compositionM addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    NSLog(@"音频的时间==%lld",audioAsset.duration.value / 44100);
    
    //创建输出路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",fileName]];
    NSLog(@"%@",path);
    NSURL *url = [NSURL fileURLWithPath:path];
    
    //判断文件是否已经存在已经存在就删除
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    //创建输出会话,AVAssetExportPresetPassthrough混合合成的时候使用
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:compositionM presetName:AVAssetExportPresetPassthrough];
    //输出的url
    exportSession.outputURL = url;
    //输出的文件类型,com.apple.quicktime-movie
    exportSession.outputFileType = @"com.apple.quicktime-movie";
    //开始输出
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        if (exportSession.status == AVAssetExportSessionStatusFailed) {
            NSLog(@"输出失败!");
        }else if(exportSession.status == AVAssetExportSessionStatusCompleted){
            NSLog(@"输出成功!");
        }
    }];
    
    return path;
}
@end
