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
    /// The state of the text field.
    @Binding var isActive: Bool
    
    
    public var body: some View {
        HStack {
            Spacer()
            NumberTextFieldViewRep(placeholder: self.placeholder,
                                   value: self.$value,
                                   formatter: self.formatter,
                                   onChange: self.onChange,
                                   onCommit: self.onCommit,
                                   isActive: self.$isActive)
            Spacer()
        }
        .onTapGesture {
            self.isActive = true
        }
    }
}


extension NumberTextField {
    /// Initialize a `NumberTextField` with a `Decimal?` binding.
    public init(_ placeholder: String, value: Binding<Decimal?>, formatter: NumberFormatter, isActive: Binding<Bool>) {
        self.placeholder = placeholder
        self._value = value
        self.formatter = formatter
        self._isActive = isActive
    }
    
    /// Initialize a `NumberTextField` with a `Decimal?` binding.
    public init(_ placeholder: String, value: Binding<Decimal?>, formatter: NumberFormatter, isActive: Binding<Bool>, onChange: @escaping (Decimal?) -> (), onCommit: @escaping (Decimal?) -> ()) {
        self.placeholder = placeholder
        self._value = value
        self.formatter = formatter
        self._isActive = isActive
        self.onChange = onChange
        self.onCommit = onCommit
    }
}


class SomeObject: ObservableObject {
    @Published var value: Decimal?
}


struct NumberTextField_Previews: PreviewProvider {
    @StateObject static var vm = SomeObject()
    
    static var formatter: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .currency
        return f
    }
    
    @State static var isActive: Bool = false
    
    static var previews: some View {
        VStack {
            NumberTextFieldViewRep(placeholder: "Enter..",
                                   value: $vm.value,
                                   formatter: formatter,
                                   onChange: { num in
                
            },
                                   onCommit: { num in
                
            },
                                   isActive: $isActive)
            
            Button {
                DispatchQueue.main.async {
                    vm.value = 5555555
                    isActive = true
                    
                }
                
                
            } label: {
                Text("Change")
            }

            
        }
    }
}
