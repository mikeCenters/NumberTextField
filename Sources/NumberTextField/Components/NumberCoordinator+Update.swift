//
//  NumberCoordinator+Update.swift
//  NumberTextField
//
//  Created by Michael Centers on 1/15/22.
//

import UIKit

// MARK: - Update Text

public extension NumberTextField.Coordinator {
    /**
     Update the text parameter within the text field.
     
     The text of the text field should always be in a formatted manner. This is to assist the end-user in
     formatting the text properly during input. This method should be called during any changes to the
     `textField.text` or `ViewRepresentable.value` properties to ensure proper user feedback
     and synchronization of these two properties. This method also formats the `textField.text`
     property to the specifications set via the `ViewRepresentable.NumberFormatter`. This method
     will use the current `ViewRepresentable.value` to update the `textField.text`.
     
     - parameter textField: The `UITextField` that will be used for `.text` updating.
     - parameter decimal: The `decimal` value to be used for updating the text field.
     - warning: This method updates the UI and should be called on the main thread.
     */
    internal func updateText(_ textField: UITextField, decimal: Decimal?) {
        guard let value = decimal,
              let formattedString = parent.formatter.string(from: value as NSDecimalNumber)
        else {
            textField.text = ""
            return
        }
        
        textField.text = formattedString
    }
}


// MARK: - Update Value

extension NumberTextField.Coordinator {
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
            parent.value = nil
            return
        }
        
        let numString = filter(text)
        
        switch parent.formatter.numberStyle {
        case .percent:
            _assignPercent(numString)
            
        case .decimal, .currency:
            _assignDecimal(numString)
            
        default:
            _assignDecimal(numString)
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
              let percent = Decimal(string: s, locale: locale)
        else {
            parent.value = nil
            return
        }
        /*
         This will not work:
         self.viewRep.value = self.viewRep.formatter.number(from: "\(percent / 100)")?.decimalValue
         The formatter does not respect to the .maximumFractionDigits property when making a number.
         */
        guard let str = parent.formatter.string(from: (percent / 100) as NSDecimalNumber),
              let num = parent.formatter.number(from: str)
        else {
            parent.value = nil
            return
        }
        
        parent.value = num.decimalValue
    }
    
    /**
     Assign a decimal value.
     
     This method accepts a `NumberString` and assigns it's value.
     
     - parameter s: The `NumberString` that will be converted into a `Decimal` for the value.
     */
    private func _assignDecimal(_ s: NumberString) {
        guard !s.isEmpty,
              let decimal = Decimal(string: s, locale: locale)
        else {
            parent.value = nil
            return
        }
        
        /**
         This will not work:
         self.viewRep.value = self.viewRep.formatter.number(from: "\(decimal)")?.decimalValue
         
         The formatter does not respect to the .maximumFractionDigits property when making a number.
         */
        guard let str = parent.formatter.string(from: decimal as NSDecimalNumber),
              let num = parent.formatter.number(from: str)
        else {
            parent.value = nil
            return
        }
        
        parent.value = num.decimalValue
    }
}
