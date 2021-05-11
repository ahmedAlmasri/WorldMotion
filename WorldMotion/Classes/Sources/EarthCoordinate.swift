//
//  DeviceMotion.swift
//  WorldMotion
//
//  Created by Ahmad Almasri on 10/05/2021.
//

import Foundation
import CoreMotion

public protocol EarthCoordinateDelegate: AnyObject {
    
    func onOrientationChange(x: Double, y: Double, z: Double)
}

open class EarthCoordinate {

    private let manager = CMMotionManager()
    public weak var delegate: EarthCoordinateDelegate?
    public init() {}
    deinit {
        stop()
    }
    open func start(interval: TimeInterval, queue: OperationQueue) {
     
        manager.deviceMotionUpdateInterval = interval
        manager.startDeviceMotionUpdates(to: queue) {[weak self] deviceMotion, error in
            
            guard let deviceMotion = deviceMotion, let safeSelf = self else {
                return
            }
            let rotationMatrix = deviceMotion.attitude.rotationMatrix
            let matrixFromVector = rotationMatrix.getRotationMatrixFromVector()
            let coordinateMatrix = safeSelf.getCoordinateSystem(with: matrixFromVector)
            let acceleration = coordinateMatrix.getOrientation()
            safeSelf.delegate?.onOrientationChange(x: acceleration.x, y: acceleration.y, z: acceleration.z)
        }
        
    }
    
    open func stop() {
        
        manager.stopDeviceMotionUpdates()
    }
    
    
    private func getCoordinateSystem(with inMatrix: CMRotationMatrix) -> CMRotationMatrix {
        
        switch UIDevice.current.orientation {
        
        case .portrait:
            return inMatrix.coordinateSystem(CMRotationMatrix.axisX, CMRotationMatrix.axisMinusZ)
        case .portraitUpsideDown:
            return inMatrix.coordinateSystem(CMRotationMatrix.axisZ, CMRotationMatrix.axisMinusX)
        case .landscapeLeft:
            return inMatrix.coordinateSystem(CMRotationMatrix.axisMinusX, CMRotationMatrix.axisMinusZ)
        case .landscapeRight:
            return inMatrix.coordinateSystem(CMRotationMatrix.axisMinusX, CMRotationMatrix.axisZ)
        default:
            return inMatrix.coordinateSystem(CMRotationMatrix.axisMinusZ, CMRotationMatrix.axisY)
            
        }
    }
}
