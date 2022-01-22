//
//  NumberTextField+Keys.swift
//  
//
//  Created by Michael Centers on 1/20/22.
//

import SwiftUI

// MARK: - Keys
extension View {
    ///. Sets the environment value of `NumberTextField_TextColor`.
    @inlinable public func textColor(_ color: Color) -> some View {
        environment(\.numberTextField_TextColor, color)
    }
    
    /// Sets the environment value of `NumberTextField_TextAlignment`.
    @inlinable public func textAlignment(_ alignment: NSTextAlignment) -> some View {
        environment(\.numberTextField_TextAlignment, alignment)
    }
    
    /// Sets the environment value of `NumberTextField_Font`.
    @inlinable public func uiFont(_ style: UIFont.TextStyle, weight: UIFont.Weight = .regular, design: UIFontDescriptor.SystemDesign = .default) -> some View {
        environment(\.numberTextField_Font, UIFont.preferredFont(style, weight: weight).with(design: design))
    }
    
    /// Sets the environment value of `NumberTextField_Font`.
    @inlinable public func uiFont(_ font: UIFont) -> some View {
        environment(\.numberTextField_Font, font)
    }
}


// MARK: - Text Color
extension EnvironmentValues {
    ///. The foreground color of text in a `NumberTextField`.
    public var numberTextField_TextColor: Color {
        get { self[NumberTextField_TextColor.self] }
        set { self[NumberTextField_TextColor.self] = newValue }
    }
}

private struct NumberTextField_TextColor: EnvironmentKey {
    static let defaultValue: Color = .primary
}


// MARK: - Text Alignment
extension EnvironmentValues {
    ///. The text alignment in a `NumberTextField`.
    public var numberTextField_TextAlignment: NSTextAlignment {
        get { self[NumberTextField_TextAlignment.self] }
        set { self[NumberTextField_TextAlignment.self] = newValue }
    }
}

private struct NumberTextField_TextAlignment: EnvironmentKey {
    static let defaultValue: NSTextAlignment = .center
}


// MARK: - Font
extension EnvironmentValues {
    ///. The environment value of `NumberTextField_Font`.
    public var numberTextField_Font: UIFont {
        get { self[NumberTextField_Font.self] }
        set { self[NumberTextField_Font.self] = newValue }
    }
}

private struct NumberTextField_Font: EnvironmentKey {
    static let defaultValue: UIFont = UIFont.preferredFont(forTextStyle: .body)
}

extension UIFont {
    /// Set the design of the `UIFont`.
    public func with(design: UIFontDescriptor.SystemDesign) -> UIFont {
        guard let descriptor = self.fontDescriptor.withDesign(design) else {
            return self
        }
        
        return UIFont(descriptor: descriptor, size: self.pointSize)
    }
    
    /// Create a system `UIFont` with the provided text style. The weight defaults to `.regular`.
    public class func preferredFont(_ style: UIFont.TextStyle, weight: UIFont.Weight = .regular) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: descriptor.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
    
}
