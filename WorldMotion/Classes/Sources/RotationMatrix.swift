//
//  RotationMatrix.swift
//  WorldMotion
//
//  Created by Ahmad Almasri on 09/05/2021.
//

import Foundation
import CoreMotion

public extension CMRotationMatrix {
    
    static var axisX = 1
    static var axisY = 2
    static var axisZ = 3
    static var axisMinusX = axisX | 0x80
    static var axisMinusY = axisY | 0x80
    static var axisMinusZ = axisZ | 0x80
    
    ///  Computes the device's orientation based on the rotation matrix.
    /// - Returns: The array values are as follows:
    /**
      1. x:
     *Pitch*, angle of rotation about the x axis. * This value represents the angle between a plane parallel * to the device's screen and a plane parallel to the ground. * Assuming that the bottom edge of the device faces the * user and that the screen is face-up, tilting the top edge * of the device toward the ground creates a positive pitch * angle. The range of values is -π to π..
    
     2. y:
     *Roll*, angle of rotation about the y axis. This value represents the angle between a plane perpendicular to the device's screen and a plane perpendicular to the ground. Assuming that the bottom edge of the device faces the user and that the screen is face-up, tilting the left edge of the device toward the ground creates a positive roll angle. The range of values is -π/2 to π/2.
     
     3. z:
     *Azimuth*, angle of rotation about the -z axis. * This value represents the angle between the device's y * axis and the magnetic north pole. When facing north, this * angle is 0, when facing south, this angle is π. * Likewise, when facing east, this angle is π/2, and * when facing west, this angle is -π/2. The range of * values is -π to π..
     */
    ///  Applying these three rotations in the azimuth, pitch, roll order
    /// * transforms a rotation matrix to the Acceleration passed into this
    /// * method. Also, note that all three orientation angles are expressed in radians.
    func getOrientation() -> CMAcceleration {
        var accelerationRef = CMAcceleration()
        
        accelerationRef.x = atan2(self.m12, self.m22)
        accelerationRef.y = asin(-self.m32)
        accelerationRef.z =  atan2(-self.m31, self.m33)
        return accelerationRef
    }
    
    /// Helper function to convert a rotation vector to a rotation matrix.
    /// - Returns: The following matrix is returned:
    ///
    /**
          /  R[ 0]   R[ 1]   R[ 2]   \
          |  R[ 3]   R[ 4]   R[ 5]   |
          \  R[ 6]   R[ 7]   R[ 8]   /
     */
    func getRotationMatrixFromVector() -> CMRotationMatrix {
        var rotationMatrix = CMRotationMatrix()
        let q0 = self.m21
        let q1 = self.m11
        let q2 = self.m12
        let q3 = self.m13
        
        let sqQ1 = 2 * q1 * q1
        let sqQ2 = 2 * q2 * q2
        let sqQ3 = 2 * q3 * q3
        let q1Q2 = 2 * q1 * q2
        let q3Q0 = 2 * q3 * q0
        let q1Q3 = 2 * q1 * q3
        let q2Q0 = 2 * q2 * q0
        let q2Q3 = 2 * q2 * q3
        let q1Q0 = 2 * q1 * q0
        
        rotationMatrix.m11 = 1 - sqQ2 - sqQ3
        rotationMatrix.m12 = q1Q2 - q3Q0
        rotationMatrix.m13 = q1Q3 + q2Q0
        
        rotationMatrix.m21 = q1Q2 + q3Q0
        rotationMatrix.m22 = 1 - sqQ1 - sqQ3
        rotationMatrix.m23 = q2Q3 - q1Q0
        
        rotationMatrix.m31 = q1Q3 - q2Q0
        rotationMatrix.m32 = q2Q3 + q1Q0
        rotationMatrix.m33 = 1 - sqQ1 - sqQ2
        return rotationMatrix
    }
    
    /// Rotates the supplied rotation matrix so it is expressed in a different coordinate system. This is typically used when an application needs to compute the three orientation angles of the device
     func coordinateSystem(_ X: Int, _ Y: Int) -> CMRotationMatrix {
        var outR = CMRotationMatrix()
        var outArr = outR.toArray()
        let inArr = self.toArray()
        
        
        var Z = X ^ Y
        let x = (X & 0x3) - 1
        let y = (Y & 0x3) - 1
        let z = (Z & 0x3) - 1
        
        let axisY = (z + 1) % 3;
        let axisZ = (z + 2) % 3;
        
        if (((x ^ axisY) | (y ^ axisZ)) != 0) {
            Z ^= 0x80;
        }
        
        let sx = (X >= 0x80)
        let sy = (Y >= 0x80)
        let sz = (Z >= 0x80)
        
        let rowLength = 3
        
        for j in 0 ..< 3 {
            let offset = j * rowLength
            for i in 0 ..< 3 {
                
                if (x == i) {
                    outArr[offset + i] = sx ? -inArr[offset + 0] : inArr[offset + 0]
                }
                if (y == i) {
                    outArr[offset + i] = sy ? -inArr[offset + 1] : inArr[offset + 1]
                }
                
                if (z == i) {
                    outArr[offset + i] = sz ? -inArr[offset + 2] : inArr[offset + 2]
                }
            }
        }
        
        return outArr.toMatrix()
        
    }
    
    private func toArray() ->  [Double] {
      
        return [self.m11, self.m12, self.m13, self.m21, self.m22, self.m23, self.m31, self.m32, self.m33]
    }
    

}
