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
    @inlinable public func uiFont(_ font: Font, weight: UIFont.Weight = .regular, design: UIFontDescriptor.SystemDesign = .default) -> some View {
        environment(\.numberTextField_Font, UIFont.preferredFont(from: font).withWeight(weight).withDesign(design))
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
    public func withDesign(_ design: UIFontDescriptor.SystemDesign) -> UIFont {
        guard let descriptor = fontDescriptor.withDesign(design) else {
            return self
        }
        
        return UIFont(descriptor: descriptor, size: self.pointSize)
    }
    
    
    public func withWeight(_ weight: UIFont.Weight) -> UIFont {
        var attributes = self.fontDescriptor.fontAttributes
        var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]

        traits[.weight] = weight

        attributes[.name] = nil
        attributes[.traits] = traits
        attributes[.family] = familyName
        
        let descriptor = UIFontDescriptor(fontAttributes: attributes)

        return UIFont(descriptor: descriptor, size: pointSize)
    }
    
    public class func preferredFont(from font: Font) -> UIFont {
        switch font {
        case .largeTitle:
            return UIFont.preferredFont(forTextStyle: .largeTitle)
        case .title:
            return UIFont.preferredFont(forTextStyle: .title1)
        case .title2:
            return UIFont.preferredFont(forTextStyle: .title2)
        case .title3:
            return UIFont.preferredFont(forTextStyle: .title3)
        case .headline:
            return UIFont.preferredFont(forTextStyle: .headline)
        case .subheadline:
            return UIFont.preferredFont(forTextStyle: .subheadline)
        case .callout:
            return UIFont.preferredFont(forTextStyle: .callout)
        case .caption:
            return UIFont.preferredFont(forTextStyle: .caption1)
        case .caption2:
            return UIFont.preferredFont(forTextStyle: .caption2)
        case .footnote:
            return UIFont.preferredFont(forTextStyle: .footnote)
        case .body:
            return UIFont.preferredFont(forTextStyle: .body)
        default:
            return UIFont.preferredFont(forTextStyle: .body)
        }
    }
}
