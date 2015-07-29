//
//  Constants.swift
//  TryOn
//
//  Created by QiFeng on 7/26/15.
//  Copyright © 2015 QiFeng. All rights reserved.
//

import Foundation

enum GlassesType {
    case round, Oval, Dawn, Proces, Hefe
    func simpleDesp() -> String {
        switch self {
        case .round:
            return "Round"
        case .Oval:
            return "Oval"
        case .Dawn:
            return "Dawn"
        case .Proces:
            return "Proces"
        case .Hefe:
            return "Hefe"
        }
    }
}