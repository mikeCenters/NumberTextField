//
//  NumberTextFieldViewRep.swift
//  NumberTextField
//
//  Created by Michael Centers on 1/15/22.
//

import SwiftUI
import UIKit

struct NumberTextFieldViewRep: UIViewRepresentable {
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
        textField.textAlignment = environment.numberTextField_TextAlignment
        textField.font = environment.numberTextField_Font
        textField.textColor = UIColor(environment.numberTextField_TextColor)
    }
}
