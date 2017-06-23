//
//  ViewController.h
//  GPUImageVideo
//
//  Created by Chuz NetTech on 16/9/7.
//  Copyright © 2016年 Chuz NetTech. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ViewController : UIViewController{
    GPUImageVideoCamera *videoCamera;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageMovieWriter *movieWriter;
    GPUImageView *filterView;
    GPUImageCropFilter * cropFliter;
}
@property (nonatomic, strong) GPUImageUIElement *uiElement;
@property (nonatomic, strong) GPUImageBrightnessFilter *brightFilter;
@property (nonatomic, strong) GPUImageAlphaBlendFilter *blendFliter;

@end

