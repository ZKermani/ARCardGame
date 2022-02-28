//
//  ViewController.swift
//  ARCardGame
//
//  Created by Zahra Sadeghipoor on 2/28/22.
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
        sceneView.autoenablesDefaultLighting = true
                
//        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
//
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration() //ARWorldTrackingConfiguration()
        
        guard let imagesToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Cards", bundle: .main) else {
            fatalError("Failed to load images to track")
        }
        configuration.trackingImages = imagesToTrack
        configuration.maximumNumberOfTrackedImages = 2

        // Run the view's session
        sceneView.session.run(configuration)
        //session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor {
            
            print("Image detected")
            // Q: What about the position?
            let referenceImage = imageAnchor.referenceImage
            let plane = SCNPlane(width: referenceImage.physicalSize.width,
                                 height: referenceImage.physicalSize.height)
            let planeMaterial = SCNMaterial()
            planeMaterial.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            plane.materials = [planeMaterial]
            let planeNode = SCNNode(geometry: plane)
            //planeNode.opacity = 0.5
            planeNode.eulerAngles.x = -Float.pi / 2
            
            let sphere = SCNSphere(radius: 0.05)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.red
            sphere.materials = [material]
            let sphereNode = SCNNode(geometry: sphere)
            sphereNode.position = SCNVector3(CGFloat(planeNode.position.x) ,
                                             CGFloat(planeNode.position.y) ,
                                             CGFloat(planeNode.position.z) + 0.05)
            
            planeNode.addChildNode(sphereNode)
            
            node.addChildNode(planeNode)
        }
    }
}
