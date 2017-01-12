//
//  SecondViewController.m
//  GPUImageVideo
//
//  Created by Chuz NetTech on 16/10/22.
//  Copyright © 2016年 Chuz NetTech. All rights reserved.
//

#import "SecondViewController.h"
#define kFCScreenWidth  ([UIScreen mainScreen ].bounds.size.width)
#define kFCScreenHeight ([UIScreen mainScreen ].bounds.size.height)
@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *playView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFCScreenWidth, kFCScreenHeight)];
    [self.view addSubview:playView];
    AVPlayerItem *item =  [AVPlayerItem playerItemWithURL:self.videoURL];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.frame = CGRectMake(0, 0, kFCScreenWidth , kFCScreenHeight);
    [playView.layer addSublayer:layer];
    
    [player play];
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
