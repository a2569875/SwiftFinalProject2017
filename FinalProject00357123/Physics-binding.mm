//
//  Physics-binding.mm
//  FinalProject00357123
//
//  Created by 張宇帆 on 2018/1/15.
//  Copyright © 2018年 NTOU department of computer science. All rights reserved.
//

#import "Live2D-binding.h"

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <SceneKit/SceneKit.h>

#import "L2DPhysics.h"

#import "Live2DModelOpenGL.h"
#import "UtSystem.h"

@interface Live2DPhysicsObjC ()
    @property (nonatomic, assign) live2d::framework::L2DPhysics *live2Dphys;
@end

@implementation Live2DPhysicsObjC
    -(instancetype)initWithModelPath:(NSString *)phyPath{
        if (self = [super init]) {
            _live2Dphys = new live2d::framework::L2DPhysics();
            _live2Dphys = _live2Dphys->load( [phyPath UTF8String] );
        }
        return self;
    }

    -(void)update:(Live2DModelOpenGL *)model{
        self->_live2Dphys->updateParam((live2d::Live2DModelOpenGL *)[model obj_ptr]);
    }
@end
