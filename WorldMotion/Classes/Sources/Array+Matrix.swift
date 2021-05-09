//
//  Array+Matrix.swift
//  WorldMotion
//
//  Created by Ahmad Almasri on 10/05/2021.
//

import Foundation
import CoreMotion

extension Array where Element == Double {
    
    func toMatrix() -> CMRotationMatrix {
        if self.count != 9 {
            fatalError("the matrix array should be have 3x3")
        }
        var outR = CMRotationMatrix()
        outR.m11 = self[0]
        outR.m12 = self[1]
        outR.m13 = self[2]
        outR.m21 = self[3]
        outR.m22 = self[4]
        outR.m23 = self[5]
        outR.m31 = self[6]
        outR.m32 = self[7]
        outR.m33 = self[8]
        return outR
    }
}
