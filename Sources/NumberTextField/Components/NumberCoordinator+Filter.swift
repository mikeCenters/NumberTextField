//
//  NumberCoordinator+Filter.swift
//  NumberTextField
//
//  Created by Michael Centers on 1/15/22.
//


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
