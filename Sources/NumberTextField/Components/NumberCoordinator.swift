//
//  NumberCoordinator.swift
//  NumberTextField
//
//  Created by Michael Centers on 1/15/22.
//

import UIKit

// MARK: - Coordinator

public extension NumberTextField {
    
    final class Coordinator: NSObject, UITextFieldDelegate {
        
        public var parent: NumberTextField
        
        // MARK: - Helper Properties
        
        /// The decimal character for decimal values.
        internal var decimalChar: String.Element {
            Character(parent.formatter.decimalSeparator ?? "") }
        
        /// The grouping character for decimal values.
        internal var groupingChar: String.Element {
            Character(parent.formatter.groupingSeparator ?? "") }
        
        /// The currency character for decimal values.
        internal var currencyChar: String.Element {
            Character(parent.formatter.currencySymbol ?? "") }
        
        /// The percent character for decimal values.
        internal var percentChar: String.Element {
            Character(parent.formatter.percentSymbol ?? "") }
        
        /// The locale used for number formatting.
        internal var locale: Locale {
            parent.formatter.locale }
        
        internal var isEditing: Bool {
            parent.isActive }
        
        
        // MARK: - Controls
        /// The minimum fractional digits initially set via the provided `NumberFormatter`.
        internal var definedMinimumFractionalDigits: Int
        
        
        // MARK: - Init
        
        init(_ parent: NumberTextField) {
            self.parent = parent
            
            self.definedMinimumFractionalDigits = parent.formatter.minimumFractionDigits
        }
        
        
        // MARK: - Setup
        
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
        }
    }
}


// MARK: - Delegate Methods

public extension NumberTextField.Coordinator {
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.parent.isActive = true
            
            self.updateText(textField, decimal: self.parent.value)
            
            if let text = textField.text {
                self.moveCursorWithinBounds(textField, cursorPosition: text.count)
            }
        }
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        DispatchQueue.main.async {
            self._setDecimalSeparator(textField)
            self._setMinimumFractionalDigits(textField)
            
            self.updateValue(textField)
            self.updateText(textField, decimal: self.parent.value)
            
            /// Check if cursor is within bounds.
            if let range = textField.selectedTextRange?.start {
                let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: range)
                self.moveCursorWithinBounds(textField, cursorPosition: cursorPosition)
            }
            
        }
    }
    
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.parent.isActive = false
            
            self.parent.formatter.minimumFractionDigits = self.definedMinimumFractionalDigits
            self.parent.formatter.alwaysShowsDecimalSeparator = false
            
            self.updateText(textField, decimal: self.parent.value)
            self.parent.onCommit(self.parent.value)
        }
    }
    
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
