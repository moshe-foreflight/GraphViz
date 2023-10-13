//
//  File.swift
//  
//
//  Created by Moshe Berman on 10/13/23.
//

import Foundation

extension Color {
    func with(alpha newAlpha: UInt8) -> Color? {
        switch self {
        case .rgb(let red, let green, let blue):
            return Color.rgba(red: red, green: green, blue: blue, alpha: newAlpha)
        case .rgba(let red, let green, let blue, _):
            return Color.rgba(red: red, green: green, blue: blue, alpha: newAlpha)
        default:
            return nil
        }
    }
}
