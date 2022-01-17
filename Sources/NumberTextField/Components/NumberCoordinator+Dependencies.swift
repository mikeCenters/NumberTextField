//
//  NumberCoordinator+Dependencies.swift
//  NumberTextField
//  
//
//  Created by Michael Centers on 1/17/22.
//

import UIKit


// MARK: - State Management
extension NumberTextFieldViewRep.Coordinator {
    /**
     Set the state of text field editing
     
     This method will also assign the defined parameters of the `NumberFormatter` that may have
     been altered via the `Coordinator`.
     
     - parameter isEditing: The `Bool` value of the text field edit state.
     */
    internal func textField(isEditing: Bool) {
        let f = self.viewRep.formatter
        
        self.isEditing = isEditing
        
        if !isEditing {
            f.minimumFractionDigits = self.definedMinimumFractionalDigits
            f.alwaysShowsDecimalSeparator = false
        }
    }
    
    /**
     Set the decimal separator condition.
     
     This method applies a condition to the `ViewRepresentable.NumberFormatter` to always show
     or hide the decimal separator. Before making any changes to the property, the method checks the
     formatter for the maximum fractional digits to determine the allowance of a decimal separator.
     
     The primary purpose of this method is to assist formatting the `textField.text` property. When a
     user wants to input fractional digits ("123."), the decimal separator is left at the trailing end of the filtered
     string. When that string is converted into a decimal via the `NumberFormatter`, the trailing separator
     is lost. This method will preserve the separtor during conversion.
     
     - parameter textField: The `UITextField` that is being manipulated.
     - warning: This method should only be called immediately before formatting and setting the textField's
     text property.
     */
    internal func _setDecimalSeparator(_ textField: UITextField) {
        guard self.isEditing else { return }
        
        guard self.viewRep.formatter.maximumFractionDigits > 0,
              let text = textField.text
        else {
            self.viewRep.formatter.alwaysShowsDecimalSeparator = false
            return
        }
        
        if text.contains(self.decimalChar) {
            self.viewRep.formatter.alwaysShowsDecimalSeparator = true
            
        } else {
            self.viewRep.formatter.alwaysShowsDecimalSeparator = false
        }
    }
    
    /**
     Set the `NumberFormatter.minimumFractionalDigits` property.
     
     This method sets the `NumberFormatter.minimumFractionalDigits`property according to how
     the text is being entered. When the `textField.text` property is formatted, the minimum fractional
     digits is applied. This will cause the textfield to insert zeros or prevent the end-user from erasing the
     textfield.
     
     This method also allows the input of trailing zeroes after a decimal separator. When the `NumberFormatter`
     formats the string, the `viewRep.value` is used to make the formatted string. Trailing zeroes are not
     preserved on the `Decimal`, thus the formatted string will not show the desired output.
     
     - parameter textField: The `UITextField` that is being manipulated.
     - warning: This method should only be called immediately before formatting and setting the textField's
     text property.
     */
    internal func _setMinimumFractionalDigits(_ textField: UITextField) {
        guard self.isEditing else { return }
        
        guard let text = textField.text,
              text.contains(self.decimalChar)
        else {
            self.viewRep.formatter.minimumFractionDigits = 0
            return
        }
        
        let numString = self.filter(text)
        let formatter = self.viewRep.formatter
        let numChars = "1234567890"
        /**
         Separate the number into whole and fractional parts.
         Get the count of the fractional numbers.
         Set the `minimumFractionalDigits` property according to the condition.
         */
        let separatorIndex = numString.firstIndex(of: self.decimalChar)!
        let fractionalNumbers = numString[separatorIndex...].filter { numChars.contains($0) }
        
        if fractionalNumbers.count < formatter.maximumFractionDigits {
            formatter.minimumFractionDigits = fractionalNumbers.count
        } else {
            formatter.minimumFractionDigits = formatter.maximumFractionDigits
        }
    }
}


// MARK: - Filter
extension NumberTextFieldViewRep.Coordinator {
    /**
     Filter a string and return a `NumberString`
     
     The provided `String` will be filtered and converted into a `NumberString`. This method eases
     the burden of creating a `Decimal` type from a `String`. This method will use the
     `ViewRepresentable`'s formatter to determine the correct decimal separator. This method will also
     remove inappropriate decimal separators.
     
     - parameter s: The `String` that will be filtered.
     - returns: A `NumberString` which is a `String` type that has only numbers and a single decimal separator.
     */
    internal func filter(_ s: String) -> NumberString {
        let numberChars: String = "0123456789"
        guard s.contains(self.decimalChar)
        else {  /// No decimal char found.
            return s.filter { numberChars.contains($0)}
        }
        
        /**
         Decimal character exists:
         Separate the number into whole and fractional parts.
         Filter both parts, then return the combined string.
         */
        let firstIndex = s.firstIndex(of: self.decimalChar)!
        let wholeNumbers = s[..<firstIndex].filter { numberChars.contains($0)}
        let fractionalNumbers = s[firstIndex...].filter { numberChars.contains($0)}
        return "\(wholeNumbers)" + "\(self.decimalChar)" + "\(fractionalNumbers)"
    }
}
