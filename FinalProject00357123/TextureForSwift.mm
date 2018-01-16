//
//  TextureForSwift.mm
//  FinalProject00357123
//
//  Created by 張宇帆 on 2018/1/16.
//  Copyright © 2018年 NTOU department of computer science. All rights reserved.
//

#import "Live2D-binding.h"

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <SceneKit/SceneKit.h>
#include <OpenGLES/ES2/glext.h>
#include <string>

#import "UIImageToTextureObjC.h"
#import "TextureChecker.hpp"


@interface TextureObjC()
    //none
@end

@implementation TextureObjC
    + (GLuint)UIImageToTexture:(UIImage *)the_image name:(NSString *)name{
        
        std::string img_name = std::string( [name UTF8String] );
        
        if(check_texture(img_name)){
            return get_texture(img_name);
        }
        
        CGImageRef imageRef = [the_image CGImage];
        size_t width = CGImageGetWidth(imageRef);
        size_t height = CGImageGetHeight(imageRef);
        
        GLubyte* textureData = (GLubyte *)malloc(width * height * 4); // if 4 components per pixel (RGBA)
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        NSUInteger bytesPerPixel = 4;
        NSUInteger bytesPerRow = bytesPerPixel * width;
        NSUInteger bitsPerComponent = 8;
        CGContextRef context = CGBitmapContextCreate(textureData, width, height,
                     bitsPerComponent, bytesPerRow, colorSpace,
                     kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        
        CGColorSpaceRelease(colorSpace);
        
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
        CGContextRelease(context);
        
        GLuint textureID;
        glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
        glGenTextures(1, &textureID);
        
        glBindTexture(GL_TEXTURE_2D, textureID);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
        
        update_texturemap(img_name, textureID);
        return textureID;
    }
@end
