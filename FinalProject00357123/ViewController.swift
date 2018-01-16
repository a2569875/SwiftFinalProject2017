//
//  ViewController.swift
//  FinalProject00357123
//
//  Created by 張宇帆 on 2018/1/10.
//  Copyright © 2018年 NTOU department of computer science. All rights reserved.
//

import ARKit
import GLKit
import SceneKit
import UIKit
import ReplayKit
import GameplayKit

class ViewController: GLKViewController {

    var loadded_setting : GobalSetting!
    var modelFile = "Nanachi"
    let contentUpdater = ContentUpdater()
    let controller = RPBroadcastController()
    var use_setting = true
    @IBOutlet var sceneView: ARSCNView!
    
    var session: ARSession {
        return sceneView.session
    }
    
    var live2DModel: Live2DModelOpenGL!
    var live2DMotions: Live2DMotionAgent!
    var live2DDrags: Live2DTargetPointObj!
    var live2Dphyics: Live2DPhysicsObj?
    var live2DMotionArray: [Live2DMotionObj] = []
    var context: EAGLContext!
    
    var texture_id : GLuint?
    
    var m_loc : ModelLocation = ModelLocation(x: -1.4, y: 0.8, scx: 2.8, scy: -2.8)
    
    // MARK: - View Controller Life Cycle
    @objc func pinch(recognizer:UIPinchGestureRecognizer){
        if recognizer.state == .changed {
            let scale = recognizer.scale
            let frm_x = m_loc.scx
            if CGFloat(frm_x) * scale < 5.6 && CGFloat(frm_x) * scale > 0.5 {
                m_loc.scx = frm_x * Float(scale)
                m_loc.scy = -frm_x * Float(scale)
                m_loc.x *= Float(scale)
                m_loc.y *= Float(scale)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = contentUpdater
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        
        if let lmySetting = GobalSetting.readFromFile() {
            self.loadded_setting = lmySetting
        }else{
            self.loadded_setting = GobalSetting()
        }
        
        if use_setting {
            if let lmyCharactors = Charactor.readFromFile() {
                if self.loadded_setting.selectid >= 0 && self.loadded_setting.selectid < lmyCharactors.count {
                    if let m_name = lmyCharactors[self.loadded_setting.selectid].modelName{
                        modelFile = m_name
                        
                        if let getted_img = lmyCharactors[self.loadded_setting.selectid].image_name, let getted_image = lmyCharactors[self.loadded_setting.selectid].image_image{
                               texture_id = TextureSwift.getTextureId(getted_image, img_name: getted_img)
                        }

                    }else{
                        ControllerUtil.showAlert(self, message: "未選擇角色 (預設將顯示娜娜奇)")
                    }
                }else{
                    ControllerUtil.showAlert(self, message: "未選擇角色 (預設將顯示娜娜奇)")
                }
            }
        }
        
        
        self.context = EAGLContext(api: .openGLES2)
        if context == nil {
            print("Failed to create ES context")
            return
        }
        
        guard let view = self.view as? GLKView else {
            print("Failed to cast view to GLKView")
            return
        }
        view.context = self.context
        
        //pinch
        let pinch = UIPinchGestureRecognizer(
            target: self,
            action: #selector(ViewController.pinch(recognizer:))
        )
        
        self.view.addGestureRecognizer(pinch)
        
        //drag
        live2DDrags = Live2DTargetPointObj()
        let pan = UIPanGestureRecognizer(
            target:self,
            action:#selector(ViewController.dragpan(recognizer:))
        )
        
        pan.minimumNumberOfTouches = 1
        pan.maximumNumberOfTouches = 1
        
        self.view.addGestureRecognizer(pan)
        
        self.setupGL()
    }

    @objc func dragpan(recognizer:UIPanGestureRecognizer){
        let point = recognizer.location(in: self.view)
        let size = self.view.bounds.size
        
        if recognizer.state == .changed{
            live2DDrags.set(x : Float((point.x) / size.width) * 2 - 1, y : Float((size.height - point.y) / size.height) * 2 - 1);
        } else if recognizer.state == .ended {
            live2DDrags.set(x : 0, y : 0);
        }

        //print("\(point.x),\(point.y)")
    }

    func draw_background() {
        var ogl: GLint = GLint( GL_NONE )
        guard let the_texture = texture_id else {
            return
        }

        glGetIntegerv( GLenum( GL_MATRIX_MODE ), &ogl )
        glPushMatrix()
 
            glMatrixMode(GLenum(GL_PROJECTION))
            glPushMatrix()
                glLoadIdentity()
                let size = self.view.bounds.size

                glOrthof(0.0, Float(size.width), Float(size.height), 0, -1, 1)
        
                glMatrixMode(GLenum(GL_MODELVIEW))
                glPushMatrix()
        
                    glEnableClientState(GLenum(GL_VERTEX_ARRAY));
                    glEnableClientState(GLenum(GL_NORMAL_ARRAY));
                    glEnableClientState(GLenum(GL_TEXTURE_COORD_ARRAY));
        
                    glColor4f(Float(0.0), Float(0.0), Float(1.0), Float(1.0))

                    let vertices : [vector_double3] = [
                        vector_double3(0.0,  100.0, 0.0),
                        vector_double3(100.0,  100.0, 0.0),
                        vector_double3(0.0, 0.0, 0.0),
                        vector_double3( 100.0, 0.0, 0.0)
                    ]
                    let normals : [vector_double3] = [
                        vector_double3(0.0, 0.0, 1.0),
                        vector_double3(0.0, 0.0, 1.0),
                        vector_double3(0.0, 0.0, 1.0),
                        vector_double3(0.0, 0.0, 1.0)
                    ]
                    let texCoords : [GLfloat] = [
                        0.0, 1.0,
                        1.0, 1.0,
                        0.0, 0.0,
                        1.0, 0.0
                    ]
        
                    glBindTexture(GLenum(GL_TEXTURE_2D), the_texture);
                    glVertexPointer(3, GLenum(GL_FLOAT), 0, vertices);
                    glNormalPointer(GLenum(GL_FLOAT), 0, normals);
                    glTexCoordPointer(2, GLenum(GL_FLOAT), 0, texCoords);
                    glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4);
        
                    glDisableClientState(GLenum(GL_VERTEX_ARRAY));
                    glDisableClientState(GLenum(GL_NORMAL_ARRAY));
                    glDisableClientState(GLenum(GL_TEXTURE_COORD_ARRAY));
                glMatrixMode(GLenum(GL_MODELVIEW))
                glPopMatrix()
        
            glMatrixMode(GLenum(GL_PROJECTION))
            glPopMatrix()

        glMatrixMode(GLenum(ogl))
        glPopMatrix()
        
        //glFinish()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        resetTracking()
        
        if self.isViewLoaded && self.view.window == nil {
            self.view = nil
            self.tearDownGL()
            
            if EAGLContext.current() == self.context {
                EAGLContext.setCurrent(nil)
            }
            self.context = nil
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        session.pause()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - Memory Management

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Utility
    func errorString(_ error: Error) -> String {
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        let errorMessage = messages.flatMap({ $0 }).joined(separator: "\n")
        return errorMessage
    }
    
    // MARK: - Instance Life Cycle

    deinit {
        self.tearDownGL()
        if EAGLContext.current() == self.context {
            EAGLContext.setCurrent(nil)
        }
        self.context = nil
    }
    
    // MARK: - Gesture action

    @IBAction func tapInfoButton() {
        let liveBroadcast = UIAlertAction(title: controller.isBroadcasting ? "Stop Broadcast" : "Live Broadcast", style: .default, handler: { action in
            if self.controller.isBroadcasting {
                self.stopBroadcast()
            } else {
                self.startBroadcast()
            }
        })
        
        let toggleSceneView = UIAlertAction(title: sceneView.isHidden ? "Show Front View" : "Hide Front View", style: .default, handler: { action in
            self.sceneView.isHidden = !self.sceneView.isHidden
        })
        
        let actionSheet = UIAlertController(title: "Option", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(liveBroadcast)
        actionSheet.addAction(toggleSceneView)

        actionSheet.addAction(UIAlertAction(title: "Cacnel", style: .cancel, handler: nil))
        
        self.show(actionSheet, sender: self)
    }
    
    // MARK: - ReplayKit Live broadcasting
    
    func startBroadcast() {
        RPScreenRecorder.shared().isMicrophoneEnabled = true // Not work?
        RPBroadcastActivityViewController.load { broadcastAVC, error in
            if error != nil {
                print("Load BroadcastActivityViewController failed. ::" + self.errorString(error!))
                return
            }
            if let broadcastAVC = broadcastAVC {
                broadcastAVC.delegate = self
                self.present(broadcastAVC, animated: true, completion: nil)
            }
        }
    }
    
    func stopBroadcast() {
        controller.finishBroadcast { error in
            if error != nil {
                print("Finish broadcast failed. ::" + self.errorString(error!))
                return
            }
        }
    }

    /// - Tag: ARFaceTrackingSetup
    func resetTracking() {
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    let texture_path = [1024, 2048]

    func setupGL() {
        EAGLContext.setCurrent(self.context)
        
        Live2D.initL2D()
        
        let textures = ["texture_00"]
        let motiones = ["idle/00","idle/01","idle/04","idle/05","idle/07","idle/08","idle/09",
                      "idle/idl_00","idle/idl_01","idle/idl_03","idle/idl_06","idle/idl_07","idle/idl_08","idle/idl_09"]
        
        guard let modelPath = Bundle.main.path(forResource: modelFile, ofType: "moc") else {
            print("Failed to find model file")
            return
        }
        
        //載入模型物件
        live2DModel = Live2DModelOpenGL(modelPath: modelPath)
        contentUpdater.live2DModel = live2DModel
        
        for (index, texture) in textures.enumerated() {
            for pathid in texture_path {
                //載入模型貼圖
                if let filePath = Bundle.main.path(forResource: "\(modelFile).\(pathid)/\(texture)", ofType: "png") {
                    let textureInfo = try! GLKTextureLoader.texture(withContentsOfFile: filePath, options: [GLKTextureLoaderApplyPremultiplication: false, GLKTextureLoaderGenerateMipmaps: true])
                    
                    let num = textureInfo.name
                    live2DModel?.setTexture(Int32(index), to: num)
                }
            }
        }
        
        //載入動作
        live2DMotions = Live2DMotionAgent()
        live2DMotionArray.removeAll()
        for mot in motiones {
            if let modelPath = Bundle.main.path(forResource: mot, ofType: "mtn") {
                //motionManager->startMotion( motion, false );//播放動作
                //live2DMotions.startMotion(Live2DMotionObj.init(motionPath: modelPath), value: false)
                live2DMotionArray.append(Live2DMotionObj.init(motionPath: modelPath))
            }
        }
        
        if let phyPath = Bundle.main.path(forResource: "physics", ofType: "json") {
            print("loadded physics data from \(phyPath)")
            live2Dphyics = Live2DPhysicsObj(phyPath: phyPath)
        }
        
        //view.insertSubview(backgroundview, at: 0)
        //view.sendSubview(toBack: backgroundview)
        //view.insertSubview(backgroundview, belowSubview: UIView(GLKView))
        //self.set

    }

    func tearDownGL() {
        live2DModel = nil
        Live2D.dispose()
        EAGLContext.setCurrent(self.context)
    }
    
    // MARK: - GLKViewDelegate
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {

        glClearColor(0.996, 0.78, 0.31, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        
        let size = UIScreen.main.bounds.size
        
        let scx: Float = (Float)(m_loc.scx / live2DModel.getCanvasWidth())
        let scy: Float = (Float)(m_loc.scy / live2DModel.getCanvasWidth() * (Float)(size.width/size.height))
        let x: Float = m_loc.x
        let y: Float = m_loc.y
        
        let matrix4 = SCNMatrix4(
            m11: scx, m12: 0,   m13: 0, m14: 0,
            m21: 0,   m22: scy, m23: 0, m24: 0,
            m31: 0,   m32: 0,   m33: 1, m34: 0,
            m41: x,   m42: y,   m43: 0, m44: 1)
        live2DModel.setMatrix(matrix4)
        
        //啟動物理運算
        if let phydata = self.live2Dphyics {
            phydata.update(model: live2DModel)
            live2DModel.update()
        }

        //隨機動作
        if live2DMotions.isFinished(){
            live2DMotions.startMotion(
                live2DMotionArray[Int((GKRandomDistribution(lowestValue: 0, highestValue: 100).nextUniform() * Float(live2DMotionArray.count - 1)))],
                value: false)
        }
        
        live2DMotions.updateParam(live2DModel)
 
        //跟著手指
        live2DDrags.update()
        let dragPt = live2DDrags.get()
        let dragX = dragPt.x
        let dragY = dragPt.y
        
        live2DModel.addParam(Live2DParamPropertyKeys.AngleX, value: (CGFloat)(dragX * 30))//-30到30
        live2DModel.addParam(Live2DParamPropertyKeys.AngleY, value: (CGFloat)(dragY * 30))
        
        live2DModel.addParam("PARAM_BODY_X", value: (CGFloat)(dragX * 10))
        
        live2DModel.addParam("PARAM_EYE_BALL_X", value: (CGFloat)(dragX))
        live2DModel.addParam("PARAM_EYE_BALL_Y", value: (CGFloat)(dragY))
        
        //更新並畫出
        live2DModel.update()
        live2DModel.draw()
        
        //draw_background()
        
    }
}

// MARK: - ARSessionDelegate

extension ViewController: ARSessionDelegate {    
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        let errorMessage = messages.flatMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            print("The AR session failed. ::" + errorMessage)
        }
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        DispatchQueue.main.async {
            self.resetTracking()
        }
    }
}

// MARK: - RPBroadcastActivityViewControllerDelegate

extension ViewController: RPBroadcastActivityViewControllerDelegate {
    func broadcastActivityViewController(_ broadcastActivityViewController: RPBroadcastActivityViewController, didFinishWith broadcastController: RPBroadcastController?, error: Error?) {
        if error != nil {
            broadcastActivityViewController.dismiss(animated: false, completion: nil)
            print("Set broadcast controller failed. ::" + self.errorString(error!))
            return
        }
        
        broadcastActivityViewController.dismiss(animated: true) {
            broadcastController?.startBroadcast { error in
                if error != nil {
                    print("Start broadcast failed. ::" + self.errorString(error!))
                    return
                }
            }
        }
    }
}

