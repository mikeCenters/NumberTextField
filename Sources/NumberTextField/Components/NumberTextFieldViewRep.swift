//
//  NumberTextFieldViewRep.swift
//  NumberTextField
//
//  Created by Michael Centers on 1/15/22.
//

import SwiftUI
import UIKit

public struct NumberTextFieldViewRep: UIViewRepresentable {
    var placeholder: String
    @Binding var value: Decimal?
    var formatter: NumberFormatter
    var onChange: (Decimal?) -> ()
    var onCommit: (Decimal?) -> ()
    
    @Binding var isActive: Bool
    
    
    public func makeUIView(context: UIViewRepresentableContext<NumberTextFieldViewRep>) -> UITextField {
        /// Frame is set to `.infinite` to fill all available space.
        let textField = UIOpenTextField(frame: .infinite)
        /// Set the vertical height to fit the the content of the view.
        /// Resulting in a horizontal fill, and vertical fit to content.
        textField.setContentHuggingPriority(.required, for: .vertical)
        
        textField.delegate = context.coordinator
        context.coordinator.setup(textField)
        
        self.setModifiers(textField, environment: context.environment)
        return textField
    }
    
    
    public func updateUIView(_ textField: UITextField, context: UIViewRepresentableContext<NumberTextFieldViewRep>) {
        self.setModifiers(textField, environment: context.environment)
        
        guard self.isActive
        else {
            DispatchQueue.main.async {
                context.coordinator.updateText(textField, decimal: self.value)
                textField.resignFirstResponder()
            }
            return
        }
        
        DispatchQueue.main.async {
            context.coordinator.updateText(textField, decimal: self.value)
            
            if !textField.isFirstResponder {
                textField.becomeFirstResponder()
            }
        }
    }
    
    
    public func makeCoordinator() -> NumberTextFieldViewRep.Coordinator {
        Coordinator(self)
    }
}

// MARK: - Init

///// Initialize a `NumberTextField` with a `Decimal?` binding.
//public init(_ placeholder: String, value: Binding<Decimal?>, formatter: NumberFormatter, isActive: Binding<Bool>) {
//    self.placeholder = placeholder
//    self._value = value
//    self.formatter = formatter
//    self._isActive = isActive
//}
//
///// Initialize a `NumberTextField` with a `Decimal?` binding.
//public init(_ placeholder: String, value: Binding<Decimal?>, formatter: NumberFormatter, isActive: Binding<Bool>, onChange: @escaping (Decimal?) -> (), onCommit: @escaping (Decimal?) -> ()) {
//    self.placeholder = placeholder
//    self._value = value
//    self.formatter = formatter
//    self._isActive = isActive
//    self.onChange = onChange
//    self.onCommit = onCommit
//}


// MARK: - Modifiers
private extension NumberTextFieldViewRep {
    /**
     Set the view modifiers for the `UITextField`
     
     This method applies the modifiers from the environment to the text field.
     
     - parameter textField: The `UITextField` that will be modified.
     - parameter environment: The `EnvironmentValues` set for the `View` hierarchy.
     */
    private func setModifiers(_ textField: UITextField, environment: EnvironmentValues) {
        textField.placeholder = placeholder
        textField.keyboardType = .decimalPad
        textField.textAlignment = environment.numberTextField_TextAlignment
        textField.font = environment.numberTextField_Font
        textField.textColor = UIColor(environment.numberTextField_TextColor)
        
        let accessory = environment.numberTextField_InputAccessory
        accessory?.translatesAutoresizingMaskIntoConstraints = false
        accessory?.frame = textField.bounds
        textField.inputAccessoryView = environment.numberTextField_InputAccessory
    }
}
