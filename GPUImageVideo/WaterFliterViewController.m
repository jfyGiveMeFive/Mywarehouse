//
//  WaterFliterViewController.m
//  GPUImageVideo
//
//  Created by Chuz NetTech on 17/1/10.
//  Copyright © 2017年 Chuz NetTech. All rights reserved.
//

#import "WaterFliterViewController.h"
#import "LeafButton.h"
#import "CustomTools.h"
#import "SecondViewController.h"

#define kFCScreenWidth  ([UIScreen mainScreen ].bounds.size.width)
#define kFCScreenHeight ([UIScreen mainScreen ].bounds.size.height)

@interface WaterFliterViewController (){
    NSURL * currentMovieURL;
    BOOL currentVideoType;
}

@property (nonatomic, retain) LeafButton * cameraPlayButton;
@property (nonatomic, strong) GPUImageMovie *movieFile;
@end

@implementation WaterFliterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor whiteColor];
#pragma mark  ---- 录制视频并加水印 ----- 
    
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionFront];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    videoCamera.horizontallyMirrorRearFacingCamera = NO;
    
    
    GPUImageView *backView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, kFCScreenWidth, kFCScreenHeight)];
    [self.view addSubview:backView];
    
    filter = [[GPUImageSepiaFilter alloc] init];
    [(GPUImageSepiaFilter *)filter setIntensity:0];
    
    filterView = (GPUImageView *)backView;
    filterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    
    UIImage *image = [UIImage imageNamed:@"123456.jpeg"];
    UIImageView *waterFliter = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 150)];
    [waterFliter setImage:image];
    
    UIView *cotentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFCScreenWidth, kFCScreenHeight)];
    cotentView.backgroundColor = [UIColor clearColor];
    [cotentView addSubview:waterFliter];
    
    _brightFilter = [[GPUImageBrightnessFilter alloc] init];
    _brightFilter.brightness = 0.0f;
    
    _uiElement = [[GPUImageUIElement alloc] initWithView:cotentView];
    
    _blendFliter = [[GPUImageAlphaBlendFilter alloc] init];
    _blendFliter.mix = 1.0;
    
    __weak typeof(self) weakSelf = self;
    [_brightFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime Time) {
        [weakSelf.uiElement update];
    }];
    
    [videoCamera addTarget:_brightFilter];
    [_brightFilter addTarget:_blendFliter];
    [_uiElement addTarget:_blendFliter];
    
    [_blendFliter addTarget:filterView];
    
    [videoCamera startCameraCapture];
    
    currentVideoType = NO;
    [self.view addSubview:self.cameraPlayButton];
    
    
#pragma mark  ----  现有视频加水印  ----
    /*
     NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"loginmovie" withExtension:@"mp4"];
     
     _movieFile = [[GPUImageMovie alloc] initWithURL:sampleURL];
     _movieFile.runBenchmark = YES;
     _movieFile.playAtActualSpeed = NO;
     
     AVAsset *fileas = [AVAsset assetWithURL:sampleURL];
     CGSize movieSize = fileas.naturalSize;
     
     UIImage *image = [UIImage imageNamed:@"123456.jpeg"];
     UIImageView *waterFliter = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 150)];
     [waterFliter setImage:image];
    
     UIView *cotentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, movieSize.width, movieSize.height)];
     cotentView.backgroundColor = [UIColor clearColor];
     [cotentView addSubview:waterFliter];
    
    _brightFilter = [[GPUImageBrightnessFilter alloc] init];
    _brightFilter.brightness = 0.0f;
    
    _uiElement = [[GPUImageUIElement alloc] initWithView:cotentView];
    
    _blendFliter = [[GPUImageAlphaBlendFilter alloc] init];
    _blendFliter.mix = 1.0;
    
    __weak typeof(self) weakSelf = self;
    [_brightFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime Time) {
        [weakSelf.uiElement update];
    }];
    
     NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Movie_%@.mp4",[CustomTools getTimeAndUUID]]];
     unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
     NSURL * movieURL = [NSURL fileURLWithPath:pathToMovie];
     currentMovieURL = movieURL;
     
     _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640, 480)];
    
    [_movieFile addTarget:_brightFilter];
    [_brightFilter addTarget:_blendFliter];
    [_uiElement addTarget:_blendFliter];
    
    [_blendFliter addTarget:_movieWriter];
    
    _movieWriter.shouldPassthroughAudio = YES;
    _movieFile.audioEncodingTarget = _movieWriter;
    [_movieFile enableSynchronizedEncodingUsingMovieWriter:_movieWriter];
    
    [_movieWriter startRecording];
    [_movieFile startProcessing];
    
    [_movieWriter setCompletionBlock:^{
        [weakSelf.brightFilter removeTarget:weakSelf.movieWriter];
        [weakSelf.movieWriter finishRecording];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"" message:@"已经成功加入水印！点击红色按钮播放" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
        });
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((kFCScreenWidth - 100) / 2, kFCScreenHeight - 150, 100, 100);
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    */
    
}

- (void)videoAtPathToSavedPhotos:(UIButton *)sender {
    if (currentVideoType == NO) {
        NSLog(@"Movie start");
        currentVideoType = YES;
        NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Movie_%@.mp4",[CustomTools getTimeAndUUID]]];
        unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
        NSURL * movieURL = [NSURL fileURLWithPath:pathToMovie];
        currentMovieURL = movieURL;
        
        _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480, 640)];
        
        _movieWriter.encodingLiveVideo = YES;
        
        [_blendFliter addTarget:_movieWriter];
        
        double delayToStartRecording = 0.1;
        dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, delayToStartRecording * NSEC_PER_SEC);
        dispatch_after(startTime, dispatch_get_main_queue(), ^(void){
            
            //            videoCamera.audioEncodingTarget = movieWriter;
            [_movieWriter startRecording];
            
        });
    }
    else {
        currentVideoType = NO;
        [self stopVideoCamera:currentMovieURL];
    }
    
    
}
- (void)stopVideoCamera:(NSURL *)movieURL {
    [_brightFilter removeTarget:_movieWriter];
    videoCamera.audioEncodingTarget = nil;
    [_movieWriter finishRecording];
    NSLog(@"Movie completed -- 文件大小%lld",[self fileSizeAtPath:[movieURL path]]);
    
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

-(void)buttonAction{
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    secondVC.videoURL = currentMovieURL;
    [self presentViewController:secondVC animated:YES completion:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
