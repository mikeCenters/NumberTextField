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
    public var placeholder: String
    /// The binding value for the text field to render.
    @Binding public var value: Decimal?
    /// The `NumberFormatter` that will be used for formatting the user input.
    public var formatter: NumberFormatter
    /// The callback function that is called when the user inputs any change.
    public var onChange: (Decimal?) -> () = { _ in }
    /// The callback function for when the user commits to their input.
    public var onCommit: (Decimal?) -> () = { _ in }
    
    
    public var body: some View {
        NumberTextFieldViewRep(placeholder: self.placeholder,
                               value: self.$value,
                               formatter: self.formatter,
                               onChange: self.onChange,
                               onCommit: self.onCommit)
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
