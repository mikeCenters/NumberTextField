//
//  NumberCoordinator+Cursor.swift
//  NumberTextField
//
//  Created by Michael Centers on 1/15/22.
//

import UIKit


// MARK: - Cursor
extension NumberTextFieldViewRep.Coordinator {
    /**
     Move the cursor of the `TextField` within predetermined boundaries.
     
     The formatted strings will sometimes have symbols that show what the value of the `String` represent
     (currency, percentage, etc.). This method is used to prevent the cursor from crossing these symbols.
     This method requires the `NumberFormatter` of the `ViewRepresentable` to determine how to
     manipulate the cursor.
     
     - parameter textField: The textfield that will have it's cursor manipulated.
     - parameter cursorPosition: The index of the cursor's current position.
     - warning: This method updates the UI and should be called on the main thread.
     */
    internal func moveCursorWithinBounds(_ textField: UITextField, cursorPosition: Int) {
        switch self.viewRep.formatter.numberStyle {
        case .percent:
            self._withinPercentBounds(textField, cursorPosition: cursorPosition)
            
        case .currency:
            self._withinCurrencyBounds(textField, cursorPosition: cursorPosition)
            
        default:
            return
        }
    }
    
    /**
     Move the cursor within the boundaries of a percent number style.
     
     The cursor will not be allowed to cross the last character position; the `%` symbol.
     
     - parameter textField: The textfield that will have it's cursor manipulated.
     - parameter cursorPosition: The index of the cursor's current position.
     */
    private func _withinPercentBounds(_ textField: UITextField, cursorPosition: Int) {
        guard cursorPosition == textField.text?.count,
              let endingOffset = textField.position(from: textField.endOfDocument, offset: -1)
        else {
            return
        }
        
        textField.selectedTextRange = textField.textRange(from: endingOffset, to: endingOffset)
    }
    
    /**
     Move the cursor within the boundaries of a currency number style.
     
     The cursor will not be allowed to cross the currency character position.
     
     - parameter textField: The textfield that will have it's cursor manipulated.
     - parameter cursorPosition: The index of the cursor's current position.
     */
    private func _withinCurrencyBounds(_ textField: UITextField, cursorPosition: Int) {
        guard let text = textField.text,
              let beginningOffset = textField.position(from: textField.beginningOfDocument, offset: 1),
              let endingOffset = textField.position(from: textField.endOfDocument, offset: -1)
        else {
            return
        }
        
        if text.first == self.currencyChar {
            if cursorPosition == 0 {
                textField.selectedTextRange = textField.textRange(from: beginningOffset, to: beginningOffset)
            }
        }
        
        if text.last == self.currencyChar {
            if cursorPosition == text.count {
                textField.selectedTextRange = textField.textRange(from: endingOffset, to: endingOffset)
            }
        }
    }
}
