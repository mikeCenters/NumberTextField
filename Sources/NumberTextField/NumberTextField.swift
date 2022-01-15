//
//  FormattedTextField.swift
//  FormattedTextField
//
//  Created by Michael Centers on 1/15/22.
//

import SwiftUI
import Combine


public struct NumberTextField: View {
    /// The placeholder string for an empty textfield.
    var placeholder: String
    /// The binding value for the text field to render.
    @Binding var value: Decimal?
    /// The `NumberFormatter` that will be used for formatting the user input.
    var formatter: NumberFormatter
    /// The callback function that is called when the user inputs any change.
    var onChange: (Decimal?) -> () = { _ in }
    /// The callback function for when the user commits to their input.
    var onCommit: (Decimal?) -> () = { _ in }
    
    
    public var body: some View {
        NumberTextFieldViewRep(placeholder: self.placeholder,
                               value: self.$value,
                               formatter: self.formatter,
                               onChange: self.onChange,
                               onCommit: self.onCommit)
    }
}

extension NumberTextField {
    /// Initialize a `NumberTextField` with a `Decimal?` value.
    public init(_ placeholder: String, value: Binding<Decimal?>, formatter: NumberFormatter) {
        self.placeholder = placeholder
        self._value = value
        self.formatter = formatter
    }
    
    /// Initialize a `NumberTextField` with a `Decimal?` value.
    public init(_ placeholder: String, value: Binding<Decimal?>, formatter: NumberFormatter, onChange: @escaping (Decimal?) -> (), onCommit: @escaping (Decimal?) -> ()) {
        self.placeholder = placeholder
        self._value = value
        self.formatter = formatter
        self.onChange = onChange
        self.onCommit = onCommit
    }
}


#if DEBUG
// MARK: - Previews
struct NumberTextField_Previews: PreviewProvider {
    /// Not working properly.
    static var formatterGerman: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .init(identifier: "de_DE")
        return formatter
    }
    
    /// Working.
    static var formatterEnglish: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.locale = .init(identifier: "en_US")
        return formatter
    }
    @State static var value: Decimal? = 0.5
    
    static var previews: some View {
        VStack {
            NumberTextField(placeholder: "Enter here...",
                            value: Self.$value,
                            formatter: Self.formatterEnglish,
                            onChange: { _ in },
                            onCommit: { _ in })
        }
        .padding()
#if os(iOS)
        .background(Color(.secondarySystemBackground))
#elseif os(macOS)
        .background(Color(.black))
#endif
        .previewLayout(.sizeThatFits)
    }
}
#endif
