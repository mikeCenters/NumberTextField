//
//  NumberCoordinator+Formatter.swift
//  NumberTextField
//
//
//  Created by Michael Centers on 1/16/22.
//

import Foundation


extension NumberTextFieldViewRep.Coordinator {
    /**
     Check the `ViewRepresentative.NumberFormatter` for proper setup.
     
     The `NumberFormatter` is sometimes altered throughout formatting  the`UITextField.text`
     and `ViewRepresentative.value` properties. This method is called at setup of the `Coordinator`
     to store defined values that will be altered. When the `onChange` and `onCommit` closures are called,
     these defined properties will be applied to the value.
     */
    internal func checkFormatter() {
        let formatter = self.viewRep.formatter
        self.definedMinimumFractionalDigits = formatter.minimumFractionDigits
    }
}
