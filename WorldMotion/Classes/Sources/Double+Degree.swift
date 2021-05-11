//
//  Double+Degree.swift
//  WorldMotion
//
//  Created by Ahmad Almasri on 12/05/2021.
//

import Foundation

public extension Double {
    
    func toDegrees() -> Double {
        
        self * 180 / .pi
    }
}
