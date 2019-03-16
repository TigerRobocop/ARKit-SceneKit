//
//  ViewController.swift
//  ARtemplate
//
//  Created by aluno on 15/03/19.
//  Copyright © 2019 aluno. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints]

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
//        sceneView.allowsCameraControl = true
    }
    
    private func importEarth() {
        let scene = SCNScene(named: "art.scnassets/Earth.dae")!
        
        if let earthNode = scene.rootNode.childNode(withName: "Earth", recursively: true) {
            
            earthNode.position = SCNVector3(0, 0, -2)
            
            let moveSequence = (SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi * 2), z: 0, duration: 7))
            let moveLoop = SCNAction.repeatForever(moveSequence)
            
            earthNode.runAction(moveLoop)
            
            sceneView.scene.rootNode.addChildNode(earthNode)
        }
    }

    
    private func importEarth(position: SCNVector3) {
        let scene = SCNScene(named: "art.scnassets/Earth.dae")!
        
        if let earthNode = scene.rootNode.childNode(withName: "Earth", recursively: true) {
            earthNode.position = position
            
            let moveSequence = (SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi * 2), z: 0, duration: 7))
            let moveLoop = SCNAction.repeatForever(moveSequence)
            
            earthNode.runAction(moveLoop)
            
            sceneView.scene.rootNode.addChildNode(earthNode)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)

            let results = sceneView.hitTest(touchLocation, types: ARHitTestResult.ResultType.existingPlaneUsingExtent)

            if let hitResult = results.first {
//                createSphere()
                //                spawnShape()
                let vector = SCNVector3(
                    hitResult.worldTransform.columns.3.x,
                    hitResult.worldTransform.columns.3.y,
                    hitResult.worldTransform.columns.3.z
                )
//
                
                createCube()
                
                let node1 = createTextNode(string: "Hello")
                
                sceneView.scene.rootNode.addChildNode(node1)
                
               
//
//                importEarth(vector: vector)
            }
            
            let hits = sceneView.hitTest(touchLocation, options: nil)
            
            if let tappedNode = hits.first?.node {
                tappedNode.runAction(SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi * 2), z: 0, duration: 7))
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if let anchor = anchor as? ARPlaneAnchor {
            createPlane(node: node, anchor: anchor)
        }
    }

    private func createPlane(node: SCNNode, anchor: ARPlaneAnchor) {
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))

        let planeNode = SCNNode()
        
        let position = SCNVector3(anchor.center.x, 0, anchor.center.z - 1)
        
        planeNode.position = position

        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
//
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red

        plane.materials = [material]
        planeNode.geometry = plane

        node.addChildNode(planeNode)
       
        
//        importEarth(position: position);
    }
    
    
    
    func createTextNode(string: String) -> SCNNode {
        let text = SCNText(string: string, extrusionDepth: 0.1)
        text.font = UIFont.systemFont(ofSize: 1.0)
        text.flatness = 0.01
        text.firstMaterial?.diffuse.contents = UIColor.white
        
        let textNode = SCNNode(geometry: text)
        
        let fontSize = Float(0.04)
        textNode.scale = SCNVector3(fontSize, fontSize, fontSize)
        
        return textNode
    }
    
    func spawnShape() {
        // 1
        var geometry:SCNGeometry
        geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        // 2
//        switch ShapeType.random() {
//        default:
//            // 3
//            geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
//        }
        // 4
        let geometryNode = SCNNode(geometry: geometry)
        
         geometryNode.position = SCNVector3(0, 1, -2)
        
        // 5
        sceneView.scene.rootNode.addChildNode(geometryNode)
    }
    
    private func createSphere() {
        // Creates a sphere
        let sphere = SCNSphere(radius: 0.1)
        
        // Creates a material for the sphere. The material is what is made of.
        let material = SCNMaterial()
        
        // Sets the material to be red. This will cause the cube to be all read
        material.diffuse.contents = UIColor.red
        
        // Then apply the materials to the cube
        sphere.materials = [material]
        
        // Creates a node. This is a 3D position (x, y, z). Remember that when the Z is increased, it is coming towards.
        let node = SCNNode()
        node.position = SCNVector3(0, 0.1, -0.5)
        
        // Apply the node geometry it will be linked with
        node.geometry = sphere
        
        sceneView.scene.rootNode.addChildNode(node)
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    private func createCube() {
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        
        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.red
        
        let node = SCNNode()
        
        node.position = SCNVector3(0, 0.1, -0.5)
        
        node.geometry = cube
        
        sceneView.scene.rootNode.addChildNode(node)
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
