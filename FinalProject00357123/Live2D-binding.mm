#import "Live2D-binding.h"

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <SceneKit/SceneKit.h>
#import "Live2DModelOpenGL.h"
#import "UtSystem.h"

#pragma mark - Live2D class

@implementation Live2D
+ (void)initL2D {
    live2d::Live2D::init();
}

+ (void)dispose {
    live2d::Live2D::dispose();
}

+ (NSString *)live2DVersion {
    return [NSString stringWithUTF8String:live2d::Live2D::getVersionStr()];
}
@end

#pragma mark - Live2DModelOpenGL class

@interface Live2DModelOpenGL ()

@property (nonatomic, assign) live2d::Live2DModelOpenGL *live2DModel;

@end

@implementation Live2DModelOpenGL
- (instancetype)initWithModelPath:(NSString *)modelPath {
    if (self = [super init]) {
        _live2DModel = live2d::Live2DModelOpenGL::loadModel( [modelPath UTF8String] ) ;
    }
    return self;
}

- (void)setTexture:(int)textureNo to:(uint32_t)openGLTextureNo {
    self.live2DModel->setTexture( textureNo , openGLTextureNo ) ;
}

- (float)getCanvasWidth {
    return self.live2DModel->getCanvasWidth();
}

- (void)setMatrix:(SCNMatrix4)matrix {
    float fMatrix[] = {
        matrix.m11, matrix.m12, matrix.m13, matrix.m14,
        matrix.m21, matrix.m22, matrix.m23, matrix.m24,
        matrix.m31, matrix.m32, matrix.m33, matrix.m34,
        matrix.m41, matrix.m42, matrix.m43, matrix.m44
    };
    self.live2DModel->setMatrix(fMatrix);
}

- (void)setParam:(NSString *)paramId value:(CGFloat)value {
    self.live2DModel->setParamFloat([paramId UTF8String], (float)(value));
}

- (void)setPartsOpacity:(NSString *)paramId opacity:(CGFloat)value {
    self.live2DModel->setPartsOpacity([paramId UTF8String], (float)(value));
}
    
- (void)update {
    self.live2DModel->update();
}

- (void)draw {
    self.live2DModel->draw();
}
@end

#pragma mark - UtSystem class

@implementation UtSystem
+ (CGFloat)getUserTimeMSec {
    return live2d::UtSystem::getUserTimeMSec();
}
@end
