//
//  Live2D-binding.mm
//  FinalProject00357123
//
//  Created by 張宇帆 on 2018/1/13.
//  Copyright © 2018年 NTOU department of computer science. All rights reserved.
//

#import "Live2D-binding.h"

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <SceneKit/SceneKit.h>

//C++的環境下必須include下述標頭檔。
//#include <motion/EyeBlinkMotion.h>
#import "motion/EyeBlinkMotion.h"

//#include <Live2DMotion.h>
#import "Live2DMotion.h"

//#include <MotionQueueManager.h>
#import "MotionQueueManager.h"

#import "Live2DModelOpenGL.h"
#import "UtSystem.h"

#pragma mark - Live2D class
    /*
     class Live2D : NSObject
     {
        public:
        Live2D();
        ~Live2D();
        NSString * live2DVersion;
     }
     */
    @implementation Live2D

        /*
         Live2D::Live2D(){
            live2d::Live2D::init();
         }
         */
        + (void)initL2D {
            live2d::Live2D::init();
        }

        /*
         Live2D::~Live2D(){
            live2d::Live2D::dispose();
         }
         */
        + (void)dispose {
            live2d::Live2D::dispose();
        }

        /*
         NSString * Live2D::live2DVersion
         {
            return (NSString*)&live2d::Live2D::getVersionStr();
         }
         */
        + (NSString *)live2DVersion {
            return [NSString stringWithUTF8String:live2d::Live2D::getVersionStr()];
        }
    @end

/*
 @interface Live2DMotionObj : NSObject
 - (instancetype)initWithMotionPath:(NSString *)motionPath;
 - (void)setFadeIn:(int)value;
 - (void)setFadeOut:(int)value;
 - (void)setLoop:(bool)value;
 @end
 */
#pragma mark - Live2DMotionObj class
    @interface Live2DMotionObj ()
        @property (nonatomic, assign) live2d::Live2DMotion *live2DMotion;

    @end

    @implementation Live2DMotionObj
        - (instancetype)initWithMotionPath:(NSString *)modelPath {
            if (self = [super init]) {
                /*
                 播放動作需要使用Live2DMotion這個class。
                 動作中會利用的資訊為副檔名「.mtn」的動作檔案。
                 使用loadMotion函數讀取.mtn動作資訊。
                 幾乎所有的平台都提供從檔案路徑讀取和位元組陣列讀取這2種讀取方法。
                 */
                //Live2DMotion motion = Live2DMotion::loadMotion( path );
                _live2DMotion = live2d::Live2DMotion::loadMotion( [modelPath UTF8String] ) ;

            }
            return self;
        }

        - (void)setFadeIn:(int)value {
            self->_live2DMotion->setFadeIn(value);
        }

        - (void)setFadeOut:(int)value {
            self->_live2DMotion->setFadeOut(value);
        }

        - (void)setLoop:(bool)value {
            self->_live2DMotion->setLoop(value);
        }

        - (void *)obj_ptr{
            return self->_live2DMotion;
        }
    @end
/*
 @interface Live2DMotionAgent : NSObject
 - (void)startMotion:(Live2DMotionObj *)motion value:(bool)value;
 - (void)updateParam:(Live2DModelOpenGL *)model;
 - (void)stopAllMotions;
 @end
 */
#pragma mark - Live2DMotionAgent class
    @interface Live2DMotionAgent ()
        @property (nonatomic, assign) live2d::MotionQueueManager *live2DMotion;

    @end

    @implementation Live2DMotionAgent
        - (instancetype)init{
            if (self = [super init]) {
                _live2DMotion = new live2d::MotionQueueManager( ) ;
            }
            return self;
        }
        - (void)startMotion:(Live2DMotionObj *)motion value:(bool)value{
            self->_live2DMotion->startMotion((live2d::Live2DMotion *)[motion obj_ptr], value);
        }
        - (void)updateParam:(Live2DModelOpenGL *)motion{
            self->_live2DMotion->updateParam((live2d::Live2DModelOpenGL *)[motion obj_ptr]);
        }
        - (void)stopAllMotions{
            self->_live2DMotion->stopAllMotions();
        }
        - (bool) isFinished{
            return self->_live2DMotion->isFinished();
        }
    @end

#pragma mark - Live2DModelOpenGL class
    @interface Live2DModelOpenGL ()

        @property (nonatomic, assign) live2d::Live2DModelOpenGL *live2DModel;
        //自動眨眼
        //參考 http://www.live2d.com/usermanual/cubism2_cn/sdk_tutorial/live2d_library/eyeblink.html
        //宣告變數。先放在和Live2D模型同一個地方比較好。
        //using namespace live2d;
        //EyeBlinkMotion eyeBlink;
        @property (nonatomic, assign) live2d::EyeBlinkMotion *eyeBlink;

    @end


    /*
     @interface Live2DModelOpenGL : NSObject
     class Live2DModelOpenGL :  NSObject
     {
        public:
            instancetype initWithModelPath(NSString * modelPath);
            void setTexture(int textureNo, uint32_t openGLTextureNo);
            float getCanvasWidth();
            void setMatrix(SCNMatrix4 matrix);
            void setParam(NSString* paramId, CGFloat value);
            void setPartsOpacity(NSString* paramId, CGFloat value);
            void update();
            void draw();
     
            NSString* modelPath;
            NSArray<NSString*>* texturePaths;
            NSArray<NSString*>* parts;
     }
     */
    @implementation Live2DModelOpenGL
        - (instancetype)initWithModelPath:(NSString *)modelPath {
            if (self = [super init]) {
                _live2DModel = live2d::Live2DModelOpenGL::loadModel( [modelPath UTF8String] ) ;
                
                //模型在初始化時，先產生實體。
                //eyeBlink = new EyeBlinkMotion();
                _eyeBlink = new live2d::EyeBlinkMotion();
            }
            return self;
        }

        - (void *)obj_ptr{
            return self->_live2DModel;
        }

        //bind texture
        - (void)setTexture:(int)textureNo to:(uint32_t)openGLTextureNo {
            //bind textue 使用texture buffer id (glGenTexture)
            self.live2DModel->setTexture( textureNo , openGLTextureNo ) ;
        }

        - (float)getCanvasWidth {
            return self.live2DModel->getCanvasWidth();
        }

        //設定矩陣
        - (void)setMatrix:(SCNMatrix4)matrix {
            float fMatrix[] = {
                matrix.m11, matrix.m12, matrix.m13, matrix.m14,
                matrix.m21, matrix.m22, matrix.m23, matrix.m24,
                matrix.m31, matrix.m32, matrix.m33, matrix.m34,
                matrix.m41, matrix.m42, matrix.m43, matrix.m44
            };
            //glSetFloatv(GL_MODELVIEW_MATRIX, fMatrix);
            self.live2DModel->setMatrix(fMatrix);
        }

        - (void)setParam:(NSString *)paramId value:(CGFloat)value {
            self.live2DModel->setParamFloat([paramId UTF8String], (float)(value));
        }

        - (void)setPartsOpacity:(NSString *)paramId opacity:(CGFloat)value {
            self.live2DModel->setPartsOpacity([paramId UTF8String], (float)(value));
        }

        - (void)update {
            //叫用live2D的模型更新功能
            self.live2DModel->update();
            
            //在執行Live2D模型的update method前先如下更新眼睛的參數。
            //eyeBlink->setParam(live2DModel);
            //this->eyeBlink
            self.eyeBlink->setParam(self.live2DModel);
        }

        - (void)draw {
            //render
            self.live2DModel->draw();
        }
    @end

#pragma mark - UtSystem class
    @implementation UtSystem
        + (CGFloat)getUserTimeMSec {
            return live2d::UtSystem::getUserTimeMSec();
        }
    @end
