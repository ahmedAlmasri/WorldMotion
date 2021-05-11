//
//  ViewController.swift
//  WorldMotion
//
//  Created by ahmed.almasri@ymail.com on 05/09/2021.
//  Copyright (c) 2021 ahmed.almasri@ymail.com. All rights reserved.
//

import UIKit
import WorldMotion
import CoreMotion
import AVKit
class ViewController: UIViewController, EarthCoordinateDelegate {
   
    

    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var previewView: UIView!
    let dev = EarthCoordinate()
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private var initialDegrees: Double!
    override func viewDidLoad() {
        super.viewDidLoad()
        dev.delegate = self
        dev.start(interval: 0.2, queue: .init())
     
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession = AVCaptureSession()
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspect
        self.videoPreviewLayer.frame = self.previewView.bounds
        previewView.layer.addSublayer(videoPreviewLayer)
    }
    
    func onOrientationChange(x: Double, y: Double, z: Double) {
        
        DispatchQueue.main.async {
            let degrees = x.toDegrees()
            let fullAngle = 360.0
            if (self.initialDegrees == nil) {
                self.initialDegrees = degrees
            }
            var xAngle = degrees - self.initialDegrees
            
            if (xAngle < 0 ) {
                xAngle += fullAngle
            }
            
            let angle = fullAngle - xAngle
            
           self.orLabel.text = String(format: "%.0f°", floor(angle))
        }
    }
}

