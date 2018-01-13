//v

import SceneKit
import ARKit

class ContentUpdater: NSObject, ARSCNViewDelegate {
    
    // MARK: - Properties
    var live2DModel: Live2DModelOpenGL!

    // MARK: - ARSCNViewDelegate
    
    /// - Tag: ARNodeTracking
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    }
    
    /// - Tag: ARFaceGeometryUpdate
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        guard let eyeBlinkLeft = faceAnchor.blendShapes[.eyeBlinkLeft] as? Float,
            let eyeBlinkRight = faceAnchor.blendShapes[.eyeBlinkRight] as? Float,
            let browInnerUp = faceAnchor.blendShapes[.browInnerUp] as? Float,
            let browOuterUpLeft = faceAnchor.blendShapes[.browOuterUpLeft] as? Float,
            let browOuterUpRight = faceAnchor.blendShapes[.browOuterUpRight] as? Float,
            let mouthFunnel = faceAnchor.blendShapes[.mouthFunnel] as? Float,
            let jawOpen = faceAnchor.blendShapes[.jawOpen] as? Float
            else { return }
        
        let c = faceAnchor.transform.columns

        live2DModel.setParam(ViewController.PropertyKeys.AngleZ, value: (CGFloat)(atan2f(c.1.x, c.1.y) * 180 / Float.pi))

        live2DModel.setParam(ViewController.PropertyKeys.BrowLeftY, value: -(CGFloat)(0.5 - browOuterUpLeft))
        live2DModel.setParam(ViewController.PropertyKeys.BrowRightY, value: -(CGFloat)(0.5 - browOuterUpRight))
        live2DModel.setParam(ViewController.PropertyKeys.BrowLeftAngle, value: 2*(CGFloat)(browInnerUp - browOuterUpLeft))
        live2DModel.setParam(ViewController.PropertyKeys.BrowRightAngle, value: 2*(CGFloat)(browInnerUp - browOuterUpRight))

        live2DModel.setParam(ViewController.PropertyKeys.LeftEyeOpen, value: (CGFloat)(1.0 - eyeBlinkLeft))
        live2DModel.setParam(ViewController.PropertyKeys.RightEyeOpen, value: (CGFloat)(1.0 - eyeBlinkRight))
        
        live2DModel.setParam(ViewController.PropertyKeys.MouseOpenY, value: (CGFloat)(jawOpen*1.8))
        live2DModel.setParam(ViewController.PropertyKeys.MouseForm, value: (CGFloat)(1 - mouthFunnel*2))
    }
}

