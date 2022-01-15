//
//  NumberCoordinator+Update.swift
//  NumberTextField
//
//  Created by Michael Centers on 1/15/22.
//

import UIKit


// MARK: - Update Text
extension NumberTextFieldViewRep.Coordinator {
    /**
     Update the text parameter within the text field.
     
     The text of the text field should always be in a formatted manner. This is to assist the end-user in
     formatting the text properly during input. This method should be called during any changes to the
     `textField.text` or `ViewRepresentable.value` properties to ensure proper user feedback
     and synchronization of these two properties. This method also formats the `textField.text`
     property to the specifications set via the `ViewRepresentable.NumberFormatter`. This method
     will use the current `ViewRepresentable.value` to update the `textField.text`.
     
     - parameter textField: The `UITextField` that will be used for `.text` updating.
     - warning: This method updates the UI and should be called on the main thread.
     */
    internal func updateText(_ textField: UITextField) {
        guard let value = self.viewRep.value
        else {
            textField.text = ""
            return
        }
        /// When the string is formatted, the decimal separator is lost. This method preserves the separator.
        self._setDecimalSeparator(textField)
        
        switch self.viewRep.formatter.numberStyle {
        case .percent:
            guard let formattedString = self.viewRep.formatter.string(from: value as NSDecimalNumber)
            else {
                textField.text = ""
                return
            }
            
            textField.text = formattedString
            
        default:
            guard let formattedString = self.viewRep.formatter.string(from: value as NSDecimalNumber)
            else {
                textField.text = ""
                return
            }
            
            textField.text = formattedString
        }
    }
}


// MARK: - Update Value
extension NumberTextFieldViewRep.Coordinator {
    /**
     Update the value of the text field.
     
     The value is the underlying `Decimal` type that the text field is representing. This method accepts a
     text field and uses the provided `textField.text` property to update the value. This method is the
     global entry into updating any value (percentage, decimal, currency, etc.), requiring assistance from the
     `ViewRepresentable.NumberFormatter`.
     
     - parameter textField: The `UITextField` that will be used to update the value.
     - warning: When calling this method, consider using the main thread to prevent conflict with UI changes.
     */
    internal func updateValue(_ textField: UITextField) {
        guard let text = textField.text
        else {
            self.viewRep.value = nil
            return
        }
        
        let numString = self.filter(text)
        switch self.viewRep.formatter.numberStyle {
        case .percent:
            self._assignPercent(numString)
            
        default:
            break
        }
    }
    
    /**
     Assign a percent value.
     
     This method accepts a `NumberString` and assigns it's value. The provided `NumberString`
     must be of the percent representation, and will be converted into a `Decimal`.
     (e.g. s = "100" is "1" in decimal format.)
     
     - parameter s: The `NumberString` that will be converted into a `Decimal` for the value.
     */
    private func _assignPercent(_ s: NumberString) {
        guard !s.isEmpty,
              let percent = Decimal(string: s, locale: self.locale)
        else {
            self.viewRep.value = nil
            return
        }
        /// Convert the percent to a decimal via division.
        self.viewRep.value = percent / 100
    }
}


// MARK: - Dependencies
extension NumberTextFieldViewRep.Coordinator {
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
    fileprivate func _setDecimalSeparator(_ textField: UITextField) {
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
}