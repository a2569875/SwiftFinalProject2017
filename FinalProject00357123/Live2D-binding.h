//從微軟弄來的防止標頭檔重複include方法，不知道實際效率
#pragma once
#define _CRT_SECURE_NO_WARNINGS

//一般的防止標頭檔重複include方法
#ifndef Live2D_binding_h
#define Live2D_binding_h

//Swift會用到的東東
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <SceneKit/SceneKit.h>

//Live2D 程式庫的初始雨解構
@interface Live2D : NSObject
    + (void)initL2D;
    + (void)dispose;
    + (NSString *)live2DVersion;
@end

//Live2D C++ 模型物件連接Swift
@interface Live2DModelOpenGL : NSObject

    - (instancetype)initWithModelPath:(NSString *)modelPath;
    - (void)setTexture:(int)textureNo to:(uint32_t)openGLTextureNo;
    - (float)getCanvasWidth;
    - (void)setMatrix:(SCNMatrix4)matrix;
    - (void)setParam:(NSString *)paramId value:(CGFloat)value;
    - (void)setPartsOpacity:(NSString *)paramId opacity:(CGFloat)value;
    - (void)update;
    - (void)draw;

    //回傳c++物件的指標
    //注意，在Swift中使用極度危險！！
    - (void *)obj_ptr;

    @property (nonatomic, copy) NSString *modelPath;
    @property (nonatomic, strong) NSArray<NSString *> *texturePaths;
    @property (nonatomic, strong) NSArray<NSString *> *parts;

@end

//Live2D C++ 動作物件連接Swift
@interface Live2DMotionObj : NSObject
    - (instancetype)initWithMotionPath:(NSString *)motionPath;
    - (void)setFadeIn:(int)value;
    - (void)setFadeOut:(int)value;
    - (void)setLoop:(bool)value;

    //回傳c++物件的指標
    //注意，在Swift中使用極度危險！！
    - (void *)obj_ptr;
@end

//動作代理
@interface Live2DMotionAgent : NSObject
    - (instancetype)init;
    - (void)startMotion:(Live2DMotionObj *)motion value:(bool)value;
    - (void)updateParam:(Live2DModelOpenGL *)model;
    - (void)stopAllMotions;
    //bool isFinished (void);
    - (bool) isFinished;
@end

@interface UtSystem : NSObject
    + (CGFloat)getUserTimeMSec;
@end

#endif /* !Live2D_binding_h */
