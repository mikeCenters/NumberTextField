//
//  NumberTextFieldViewRep.swift
//  NumberTextField
//
//  Created by Michael Centers on 1/15/22.
//

import SwiftUI
import UIKit

struct NumberTextFieldViewRep: UIViewRepresentable {
    @Environment(\.multilineTextAlignment) private var textAlignment: TextAlignment
    @Environment(\.font) private var font: Font?
    
    var placeholder: String
    @Binding var value: Decimal?
    var formatter: NumberFormatter
    var onChange: (Decimal?) -> ()
    var onCommit: (Decimal?) -> ()
    
    @Binding var isActive: Bool
    
    
    func makeUIView(context: UIViewRepresentableContext<NumberTextFieldViewRep>) -> UITextField {
        let textField = UIOpenTextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = self.placeholder
        context.coordinator.setup(textField)
        
        textField.setContentHuggingPriority(.required, for: .horizontal)
        textField.setContentHuggingPriority(.required, for: .vertical)
        
        self.setModifiers(textField, environment: context.environment)
        return textField
    }
    
    func updateUIView(_ textField: UITextField, context: UIViewRepresentableContext<NumberTextFieldViewRep>) {
        guard self.isActive
        else {
            DispatchQueue.main.async {
                context.coordinator.updateText(textField)
                textField.resignFirstResponder()
            }
            return
        }
        
        self.setModifiers(textField, environment: context.environment)
        
        DispatchQueue.main.async {
            context.coordinator.updateText(textField)
            
            if !textField.isFirstResponder {
                textField.becomeFirstResponder()
            }
        }
    }
    
    func makeCoordinator() -> NumberTextFieldViewRep.Coordinator {
        Coordinator(self)
    }
}


// MARK: - Modifiers
extension NumberTextFieldViewRep {
    /**
     Set the view modifiers for the `UITextField`
     
     This method applies the modifiers from the environment to the text field.
     
     - parameter textField: The `UITextField` that will be modified.
     - parameter environment: The `EnvironmentValues` set for the `View` hierarchy.
     */
    private func setModifiers(_ textField: UITextField, environment: EnvironmentValues) {
        textField.keyboardType = .decimalPad
        
        textField.textAlignment = NSTextAlignment.getAlignment(from: self.textAlignment)
        
        if let font = self.font {
            textField.font = UIFont.preferredFont(from: font)
        }
    }
}


// MARK: - NSTextAlignment
extension NSTextAlignment {
    static func getAlignment(from alignment: TextAlignment) -> NSTextAlignment {
        switch alignment {
        case .leading:
            return .left
        case .center:
            return .center
        case .trailing:
            return .right
        }
    }
}


// MARK: - UIFont
extension UIFont {
    class func preferredFont(from font: Font) -> UIFont {
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
