//
//  ViewController.m
//  GPUImageVideo
//
//  Created by Chuz NetTech on 16/9/7.
//  Copyright © 2016年 Chuz NetTech. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "LeafButton.h"
#import "CustomTools.h"
#import "SDCycleScrollView.h"
#import "GPUImageBeautifyFilter.h"
#import "WNAudioComposition.h"
#import "SecondViewController.h"

#define kFCScreenWidth  ([UIScreen mainScreen ].bounds.size.width)
#define kFCScreenHeight ([UIScreen mainScreen ].bounds.size.height)
@interface ViewController ()<SDCycleScrollViewDelegate>{
    NSURL * currentMovieURL;
    BOOL currentVideoType;
    NSMutableDictionary *videoSettings;
//    NSMutableDictionary *audioSettings;
    NSDictionary *audio;
//    GPUImageMovie *_movieFile;
//    GPUImageBrightnessFilter *_brightnessFilter;
//    GPUImageUIElement *_landInput;
//    GPUImageAlphaBlendFilter *_landBlendFilter;
}
@property (nonatomic, retain) LeafButton * cameraPlayButton;
@end

@implementation ViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
#pragma mark  -----  录制视频加滤镜与美颜  ------
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    videoCamera.horizontallyMirrorRearFacingCamera = NO;

    
    GPUImageView *backView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, kFCScreenWidth, kFCScreenWidth)];
    [self.view addSubview:backView];
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"0000",@"1111",@"2222",@"3333",@"4444",@"5555", nil];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 50, kFCScreenWidth, 200) shouldInfiniteLoop:YES imageNamesGroup:array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    cycleScrollView.backgroundColor = [UIColor clearColor];
    cycleScrollView.delegate = self;
    cycleScrollView.autoScroll = NO;
    cycleScrollView.showPageControl = NO;
    
    [self.view addSubview:cycleScrollView];

    filter = [[GPUImageSepiaFilter alloc] init];
    [(GPUImageSepiaFilter *)filter setIntensity:0];
    
    
    cropFliter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.0, (kFCScreenHeight - kFCScreenWidth) / 2.0 / kFCScreenHeight, 1.0, kFCScreenWidth / kFCScreenHeight)];
    
    [videoCamera addTarget:filter];
    
    [filter addTarget:cropFliter];
    
    filterView = (GPUImageView *)backView;
    filterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    
    
    [cropFliter addTarget:filterView];
    
    [videoCamera startCameraCapture];
    
    [self.view addSubview:self.cameraPlayButton];
    currentVideoType = NO;
    
}

//  点击开始录音的 button 的方法
- (void)videoAtPathToSavedPhotos:(UIButton *)sender {
    if (currentVideoType == NO) {
        NSLog(@"Movie start");
        currentVideoType = YES;
        NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Movie_%@.mp4",[CustomTools getTimeAndUUID]]];
        unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
        NSURL * movieURL = [NSURL fileURLWithPath:pathToMovie];
        currentMovieURL = movieURL;
        
        movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480, 480)];
        
        movieWriter.encodingLiveVideo = YES;
        
        [cropFliter addTarget:movieWriter];
        
        double delayToStartRecording = 0.1;
        dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, delayToStartRecording * NSEC_PER_SEC);
        dispatch_after(startTime, dispatch_get_main_queue(), ^(void){
            
//            videoCamera.audioEncodingTarget = movieWriter;
            [movieWriter startRecording];
            
        });
    }
    else {
        currentVideoType = NO;
        [self stopVideoCamera:currentMovieURL];
    }
    
    
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
    NSLog(@"%ld",(long)index);
    switch (index) {
        case 0:
        {
            [videoCamera removeAllTargets];
            filter = [[GPUImageBeautifyFilter alloc] init];
            [videoCamera addTarget:filter];
            [filter addTarget:cropFliter];
            [cropFliter addTarget:filterView];
            break;
        }
        case 1:{
            [videoCamera removeAllTargets];
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"cross_1"];
            [videoCamera addTarget:filter];
            [filter addTarget:cropFliter];
            [cropFliter addTarget:filterView];
            break;
        }
        case 2:{
            [videoCamera removeAllTargets];
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"cross_2"];
            [videoCamera addTarget:filter];
            [filter addTarget:cropFliter];
            [cropFliter addTarget:filterView];
            break;
        }
        case 3:{
            [videoCamera removeAllTargets];
            filter = [[GPUImageSepiaFilter alloc] init];
            [(GPUImageSepiaFilter *)filter setIntensity:0];
            [videoCamera addTarget:filter];
            [filter addTarget:cropFliter];
            [cropFliter addTarget:filterView];
            break;
        }
        case 4:{
            [videoCamera removeAllTargets];
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"cross_3"];
            [videoCamera addTarget:filter];
            [filter addTarget:cropFliter];
            [cropFliter addTarget:filterView];
            break;
        }
        case 5:{
            [videoCamera removeAllTargets];
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"cross_4"];
            [videoCamera addTarget:filter];
            [filter addTarget:cropFliter];
            [cropFliter addTarget:filterView];
            break;
        }
            
        default:
            break;
    }
}
- (void)stopVideoCamera:(NSURL *)movieURL {
    
    [filter removeTarget:movieWriter];
    videoCamera.audioEncodingTarget = nil;
    [movieWriter finishRecording];
    NSLog(@"Movie completed -- 文件大小%lld",[self fileSizeAtPath:[movieURL path]]);
    
    NSString *videoPath = [[WNAudioComposition alloc] exprotVideoWithAudio:[movieURL absoluteString] secondAsset:nil saveFileName:@"myVideo"];
    NSLog(@"视频路径 %@",videoPath);
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    secondVC.videoURL = currentMovieURL;
    [self presentViewController:secondVC animated:YES completion:nil];
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (LeafButton *)cameraPlayButton
{
    if (_cameraPlayButton == nil) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _cameraPlayButton = [[LeafButton alloc] initWithFrame:CGRectMake((screenSize.width - 80)/2, screenSize.height - 80 - 80, 80, 80)];
        [_cameraPlayButton setType:LeafButtonTypeVideo];
        [_cameraPlayButton setClickedBlock:^(LeafButton *button) {
            [self videoAtPathToSavedPhotos:nil];
        }];
    }
    return _cameraPlayButton;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // Map UIDeviceOrientation to UIInterfaceOrientation.
    UIInterfaceOrientation orient = UIInterfaceOrientationPortrait;
    switch ([[UIDevice currentDevice] orientation])
    {
        case UIDeviceOrientationLandscapeLeft:
            orient = UIInterfaceOrientationLandscapeLeft;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            orient = UIInterfaceOrientationLandscapeRight;
            break;
            
        case UIDeviceOrientationPortrait:
            orient = UIInterfaceOrientationPortrait;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            orient = UIInterfaceOrientationPortraitUpsideDown;
            break;
            
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationUnknown:
            // When in doubt, stay the same.
            orient = fromInterfaceOrientation;
            break;
    }
    videoCamera.outputImageOrientation = orient;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES; // Support all orientations.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
