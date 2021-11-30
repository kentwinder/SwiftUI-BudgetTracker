//
//  Color.swift
//  BudgetTracker
//
//  Created by Kent Winder on 11/29/21.
//

import SwiftUI

extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
    
    public static var nileBlue: Color {
        return Color(hex: 0x1d3557)
    }
    
    public static var dullBlue: Color {
        return Color(hex: 0x457b9d)
    }
    
    public static var aquaIsland: Color {
        return Color(hex: 0xa8dadc)
    }
    
    public static var feta: Color {
        return Color(hex: 0xf1faee)
    }
    
    public static var amaranth: Color {
        return Color(hex: 0xe63946)
    }
}




