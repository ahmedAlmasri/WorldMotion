//
//  DeviceMotion.swift
//  WorldMotion
//
//  Created by Ahmad Almasri on 10/05/2021.
//

import Foundation
import CoreMotion

class EarthCoordinate {

    private let manager = CMMotionManager()
    public var interval = 0.2
    
    func start(interval: TimeInterval, queue: OperationQueue) {
     
        manager.deviceMotionUpdateInterval = interval
        manager.startDeviceMotionUpdates(to: queue) {deviceMotion, error in
            
            guard let deviceMotion = deviceMotion else {
                return
            }
            let rotationMatrix = deviceMotion.attitude.rotationMatrix
            let matrixFromVector = rotationMatrix.getRotationMatrixFromVector()
            
            let a = self.getCoordinateSystem(with: matrixFromVector)
            
        }
        
    }
    
    private func getCoordinateSystem(with inMatrix: CMRotationMatrix) -> CMRotationMatrix {
     
        switch UIDevice.current.orientation {
        
        case .portrait:
            return inMatrix.coordinateSystem(X: CMRotationMatrix.axisY, Y: CMRotationMatrix.axisMinusX)
        case .portraitUpsideDown:
            return inMatrix.coordinateSystem(X: CMRotationMatrix.axisMinusY, Y: CMRotationMatrix.axisX)
        case .landscapeLeft:
            return inMatrix.coordinateSystem(X: CMRotationMatrix.axisMinusX, Y: CMRotationMatrix.axisMinusY)
        case .landscapeRight:
            return inMatrix.coordinateSystem(X: CMRotationMatrix.axisY, Y: CMRotationMatrix.axisMinusX)
        default:
            return inMatrix.coordinateSystem(X: CMRotationMatrix.axisY, Y: CMRotationMatrix.axisMinusX)
            
        }
    }
}
