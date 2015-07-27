//
//  Constants.swift
//  TryOn
//
//  Created by QiFeng on 7/26/15.
//  Copyright © 2015 QiFeng. All rights reserved.
//

import Foundation

enum GlassesType {
    case C1975, Arkh, Dawn, Proces, Hefe
    func simpleDesp() -> String {
        switch self {
        case .C1975:
            return "1975"
        case .Arkh:
            return "Arkh"
        case .Dawn:
            return "Dawn"
        case .Proces:
            return "Proces"
        case .Hefe:
            return "Hefe"
        }
    }
}