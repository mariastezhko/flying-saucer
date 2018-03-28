//
//  ViewController.swift
//  AR
//
//  Created by Maria Stezhko on 3/16/18.
//  Copyright © 2018 Maria Stezhko. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    let drone = Aircraft()
    var myAudioPlayer = AVAudioPlayer()
    let kMovingLengthPerLoop: CGFloat = 0.5
    let kRotationRadianPerLoop: CGFloat = 1.5
    let kAnimationDurationMoving: CGFloat = 10
    var sound = false
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var upImageView: UIImageView!
    @IBOutlet weak var downImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    
    @IBOutlet weak var forwardImageView: UIImageView!
    @IBOutlet weak var backwardImageView: UIImageView!
    @IBOutlet weak var rotateLeftImageView: UIImageView!
    @IBOutlet weak var rotateRightImageView: UIImageView!
    
    
    
    
    @IBAction func soundButtonPressed(_ sender: UIButton) {
        
        guard let url = Bundle.main.url(forResource: "ufo", withExtension: "wav") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            myAudioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            
            myAudioPlayer.numberOfLoops = -1
            
            if !sound {
                myAudioPlayer.play()
                sound = true
            } else {
                myAudioPlayer.stop()
                sound = false
            }
        
            print("playing")
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func upLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        print("hi")
        
        let action = SCNAction.moveBy(x: 0, y: kMovingLengthPerLoop, z: 0, duration: TimeInterval(kAnimationDurationMoving))
        execute(action: action, sender: sender)
        
    }
    
    
    @IBAction func downLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        let action = SCNAction.moveBy(x: 0, y: -kMovingLengthPerLoop, z: 0, duration: TimeInterval(kAnimationDurationMoving))
        execute(action: action, sender: sender)
        
    }
    
    
    @IBAction func leftLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        let x = -deltas().cos
        let z = deltas().sin
        moveDrone(x: x, z: z, sender: sender)
        
    }
    
    
    
    @IBAction func rightLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        let x = deltas().cos
        let z = -deltas().sin
        moveDrone(x: x, z: z, sender: sender)
        
    }
    
    
    
    @IBAction func rotateLeftLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        rotateDrone(yRadian: kRotationRadianPerLoop, sender: sender)
        
        
        
    }
    
    
    @IBAction func rotateRightLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        rotateDrone(yRadian: -kRotationRadianPerLoop, sender: sender)
        
    }
    
    
    @IBAction func moveForwardLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        let x = -deltas().sin
        let z = -deltas().cos
        moveDrone(x: x, z: z, sender: sender)
        
    }
    
    
    @IBAction func moveBackwardLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        let x = deltas().sin
        let z = deltas().cos
        moveDrone(x: x, z: z, sender: sender)
        
    }
    
    
    private func deltas() -> (sin: CGFloat, cos: CGFloat) {
        return (sin: kMovingLengthPerLoop * CGFloat(sin(drone.eulerAngles.y)), cos: kMovingLengthPerLoop * CGFloat(cos(drone.eulerAngles.y)))
    }
    
    private func moveDrone(x: CGFloat, z: CGFloat, sender: UILongPressGestureRecognizer) {
        let action = SCNAction.moveBy(x: x, y: 0, z: z, duration: TimeInterval(kAnimationDurationMoving))
        execute(action: action, sender: sender)
    }
    
    private func rotateDrone(yRadian: CGFloat, sender: UILongPressGestureRecognizer) {
        
        
        
        let action = SCNAction.rotateBy(x: 0, y: yRadian, z: 0, duration: TimeInterval(kAnimationDurationMoving))
        execute(action: action, sender: sender)
    }
    
    private func execute(action: SCNAction, sender: UILongPressGestureRecognizer) {
        let loopAction = SCNAction.repeatForever(action)
        if sender.state == .began {
            drone.runAction(loopAction)
        } else if sender.state == .ended {
            drone.removeAllActions()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello")
        upImageView.isUserInteractionEnabled = true
        downImageView.isUserInteractionEnabled = true
        leftImageView.isUserInteractionEnabled = true
        rightImageView.isUserInteractionEnabled = true
        
        forwardImageView.isUserInteractionEnabled = true
        backwardImageView.isUserInteractionEnabled = true
        rotateLeftImageView.isUserInteractionEnabled = true
        rotateRightImageView.isUserInteractionEnabled = true
        
        setupScene()
        addDrone()
//        func setupScene() {
//            print("Hello")
//            let scene = SCNScene()
//            sceneView.scene = scene
//        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupConfiguration()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupScene() {
        print("Hello")
        let scene = SCNScene()
        sceneView.scene = scene
    }
    func setupConfiguration() {
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    func addDrone() {
        print("Trying to add drone")
        //let drone = Aircraft()
        drone.loadModel()
        sceneView.scene.rootNode.addChildNode(drone)
    }
}

