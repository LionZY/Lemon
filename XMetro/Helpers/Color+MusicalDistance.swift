import SwiftUI

extension Color {
    /// Color used to display a musical distance that is imperceptible (aka "in tune").
    static var imperceptibleMusicalDistance: Color { Theme.specialLightColor }
    /// Color used to display a musical distance that is perceptible (aka "out of tune").
    static var perceptibleMusicalDistance: Color { Theme.lightColor }
}
