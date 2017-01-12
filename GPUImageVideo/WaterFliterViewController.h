//
//  WaterFliterViewController.h
//  GPUImageVideo
//
//  Created by Chuz NetTech on 17/1/10.
//  Copyright © 2017年 Chuz NetTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterFliterViewController : UIViewController{
    GPUImageVideoCamera *videoCamera;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageView *filterView;
}
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, strong) GPUImageUIElement *uiElement;
@property (nonatomic, strong) GPUImageBrightnessFilter *brightFilter;
@property (nonatomic, strong) GPUImageAlphaBlendFilter *blendFliter;
@end
