//
//  Constants.swift
//  TryOn
//
//  Created by QiFeng on 7/26/15.
//  Copyright © 2015 QiFeng. All rights reserved.
//

import Foundation

enum GlassesType {
    case round, Oval, Wayfares, Cateye, Thick, Nerd, Geek, Fly, Grandpa, Hanjian, Dawn, Proces, Hefe
    func simpleDesp() -> String {
        switch self {
        case .round:
            return "Round"
        case .Oval:
            return "Oval"
        case .Wayfares:
            return "Wayfares"
        case .Cateye:
            return "Cateye"
        case .Thick:
            return "Thick"
        case .Nerd:
            return "Nerd"
        case .Geek:
            return "Geek"
        case .Fly:
            return "Fly"
        case .Grandpa:
            return "Grandpa"
        case .Hanjian:
            return "Hanjian"
        case .Dawn:
            return "Dawn"
        case .Proces:
            return "Proces"
        case .Hefe:
            return "Hefe"
        }
    }
}