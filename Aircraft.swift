//
//  Aircraft.swift
//  AR
//
//  Created by Maria Stezhko on 3/16/18.
//  Copyright © 2018 Maria Stezhko. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class Aircraft: SCNNode {
    func loadModel() {
        print("Trying to load model")
        guard let virtualObjectScene = SCNScene(named: "Objects/ufo.scn") else {
            print("Couldn't")
            return }
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        addChildNode(wrapperNode)
    }

}
