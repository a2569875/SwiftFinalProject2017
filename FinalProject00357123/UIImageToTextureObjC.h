//
//  UIImageToTextureObjC.h
//  FinalProject00357123
//
//  Created by 張宇帆 on 2018/1/16.
//  Copyright © 2018年 NTOU department of computer science. All rights reserved.
//
#pragma once
#define _CRT_SECURE_NO_WARNINGS

#ifndef UIImageToTextureObjC_h
#define UIImageToTextureObjC_h

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <SceneKit/SceneKit.h>
#import <UIKit/UIKit.h>
#import <OpenGLES/gltypes.h>

@interface TextureObjC : NSObject
    + (GLuint)UIImageToTexture: (UIImage *)the_image name:(NSString *)name;
@end

#endif /* !UIImageToTextureObjC_h */
