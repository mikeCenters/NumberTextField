//
//  NumberCoordinator.swift
//  NumberTextField
//
//  Created by Michael Centers on 1/15/22.
//

import UIKit


// MARK: - Coordinator
extension NumberTextFieldViewRep {
    class Coordinator: NSObject, UITextFieldDelegate {
        var viewRep: NumberTextFieldViewRep
        
        /// The decimal character for decimal values.
        internal var decimalChar: String.Element {
            return Character(self.viewRep.formatter.decimalSeparator ?? ".")
        }
        /// The grouping character for decimal values.
        internal var groupingChar: String.Element {
            return Character(self.viewRep.formatter.groupingSeparator ?? ",")
        }
        /// The locale of the text field `NumberFormatter`.
        internal var locale: Locale {
            return self.viewRep.formatter.locale
        }
        
        
        init(_ viewRep: NumberTextFieldViewRep) {
            self.viewRep = viewRep
        }
        
        /**
         Setup the `Coordinator`.
         
         This method will link the delegate methods and other events to the `UIOpenTextField`.
         
         - parameter textField: The `UIOpenTextField` that will be linked to the delegate.
         */
        func setup(_ textField: UIOpenTextField) {
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
            textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
            
            textField.onCursorPositionChange = { position in
                DispatchQueue.main.async {
                    self.moveCursorWithinBounds(textField, cursorPosition: position)
                }
            }
            
            /// Set the initial text property of the textfield.
            DispatchQueue.main.async {
                self.updateText(textField)
            }
        }
    }
}


// MARK: - Delegate Methods
extension NumberTextFieldViewRep.Coordinator {
    @objc
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.updateText(textField)
            
            if let text = textField.text {
                self.moveCursorWithinBounds(textField, cursorPosition: text.count)
            }
        }
    }
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.updateValue(textField)
            self.updateText(textField)
            
            /// Check if cursor is within bounds.
            if let range = textField.selectedTextRange?.start {
                let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: range)
                self.moveCursorWithinBounds(textField, cursorPosition: cursorPosition)
            }
            
            self.viewRep.onChange(self.viewRep.value)
        }
    }
    
    @objc
    func textFieldDidEndEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.viewRep.onCommit(self.viewRep.value)
        }
    }
}
