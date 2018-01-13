#ifndef Live2D_binding_h
#define Live2D_binding_h

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <SceneKit/SceneKit.h>

@interface Live2D : NSObject
    + (void)initL2D;
    + (void)dispose;
    + (NSString *)live2DVersion;
@end

@interface Live2DModelOpenGL : NSObject

    - (instancetype)initWithModelPath:(NSString *)modelPath;
    - (void)setTexture:(int)textureNo to:(uint32_t)openGLTextureNo;
    - (float)getCanvasWidth;
    - (void)setMatrix:(SCNMatrix4)matrix;
    - (void)setParam:(NSString *)paramId value:(CGFloat)value;
    - (void)setPartsOpacity:(NSString *)paramId opacity:(CGFloat)value;
    - (void)update;
    - (void)draw;
    - (void *)obj_ptr;

    @property (nonatomic, copy) NSString *modelPath;
    @property (nonatomic, strong) NSArray<NSString *> *texturePaths;
    @property (nonatomic, strong) NSArray<NSString *> *parts;

@end

@interface Live2DMotionObj : NSObject
    - (instancetype)initWithMotionPath:(NSString *)motionPath;
    - (void)setFadeIn:(int)value;
    - (void)setFadeOut:(int)value;
    - (void)setLoop:(bool)value;
    - (void *)obj_ptr;
@end

@interface Live2DMotionAgent : NSObject
    - (instancetype)init;
    - (void)startMotion:(Live2DMotionObj *)motion value:(bool)value;
    - (void)updateParam:(Live2DModelOpenGL *)model;
    - (void)stopAllMotions;
    //bool isFinished (int motionQueueEntNo);
    - (bool) isFinished;
@end

@interface UtSystem : NSObject
    + (CGFloat)getUserTimeMSec;
@end

#endif /* !Live2D_binding_h */
