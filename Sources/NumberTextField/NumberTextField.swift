//
//  FormattedTextField.swift
//  FormattedTextField
//
//  Created by Michael Centers on 1/15/22.
//

import SwiftUI
import UIKit

// MARK: - Number Text Field

public struct NumberTextField: UIViewRepresentable {
    
    /// The number formatter used for formatting the text field and value.
    internal var formatter: NumberFormatter
    
    /// The placeholder text that appears when the text field is empty.
    internal var placeholder: String
    
    /// The underlying value of the text field.
    @Binding public var value: Decimal?
    
    /// Boolean representing if the text field is first responder.
    @Binding public var isActive: Bool
    
    /// A method called when the number text field has commited its input.
    public var onCommit: (Decimal?) -> ()
    
    
    // MARK: - Init
    
    public init(placeholder: String, value: Binding<Decimal?>, formatter: NumberFormatter, isActive: Binding<Bool>, onCommit: @escaping (Decimal?) -> ()) {
        self.placeholder = placeholder
        self._value = value
        self.formatter = formatter
        self._isActive = isActive
        self.onCommit = onCommit
    }
    
    
    // MARK: - Make
    
    public func makeCoordinator() -> NumberTextField.Coordinator {
        return Coordinator(self)
    }
    
    
    public func makeUIView(context: UIViewRepresentableContext<NumberTextField>) -> UIOpenTextField {
        /// Frame is set to `.infinite` to fill all available space.
        let textField = UIOpenTextField(frame: .infinite)
        /// Set the vertical height to fit the the content of the view.
        /// Resulting in a horizontal fill, and vertical fit to content.
        textField.setContentHuggingPriority(.required, for: .vertical)
        
        textField.delegate = context.coordinator
        context.coordinator.setup(textField)
        
        self.setModifiers(textField, environment: context.environment)
        return textField
    }
    
    
    public func updateUIView(_ textField: UIOpenTextField, context: UIViewRepresentableContext<NumberTextField>) {
        self.setModifiers(textField, environment: context.environment)
        
        /// Update the text field's text property.
        context.coordinator.updateText(textField, decimal: value)
        
        /// Set first responder
        if isActive {
            if !textField.isFirstResponder {
                DispatchQueue.main.async {
                    textField.becomeFirstResponder()
                }
            }
            
        } else {
            if textField.isFirstResponder {
                DispatchQueue.main.async {
                    textField.resignFirstResponder()
                }
            }
        }
    }
}


// MARK: - Modifiers

extension NumberTextField {
    /**
     Set the view modifiers for the `UITextField`
     
     This method applies the modifiers from the environment to the text field.
     
     - parameter textField: The `UITextField` that will be modified.
     - parameter environment: The `EnvironmentValues` set for the `View` hierarchy.
     */
    private func setModifiers(_ textField: UITextField, environment: EnvironmentValues) {
        textField.placeholder = placeholder
        textField.keyboardType = .decimalPad
        textField.textAlignment = environment.numberTextField_TextAlignment
        textField.font = environment.numberTextField_Font
        textField.textColor = UIColor(environment.numberTextField_TextColor)
        
        let inputAccessory = environment.numberTextField_InputAccessory
        setInputAccessory(textField, accessory: inputAccessory)
    }
    
    /**
     Set the input accessory of the text field.
     
     The method forces the intrinsic content size to be applied to the input accessories constraints to resolve
     an issue with improper rendering of the view's height.
     
     - parameter textField: The text field that the input accessory will be applied to.
     - parameter accessory: The input accessory that will be applied to the text field.
     */
    private func setInputAccessory(_ textField: UITextField, accessory: UIView?) {
        guard let view = accessory
        else {
            textField.inputAccessoryView = nil
            return
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Set the intrinsic size of the view, to the constraints of the view.
        let size = view.intrinsicContentSize
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: size.width),
            view.heightAnchor.constraint(equalToConstant: size.height)
        ])
        
        textField.inputAccessoryView = view
    }
}


#if DEBUG

// MARK: - Previews

/// Use of container to see @State changes in Previews.
struct SomeContainer: View {
    private var formatter: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .currency
        return f
    }
    
    @State private var value: Decimal?
    @State private var isActive: Bool = false
    
    @State private var isActiveTwo: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            
            VStack {
                Button {
                    isActive.toggle()
                } label: {
                    Text("Toggle First Responder")
                }
            }
            
            Text("Raw value: \(value?.description ?? "nil")")
            
            NumberTextField(
                placeholder: "Enter...",
                value: $value,
                formatter: formatter,
                isActive: $isActive) { num in
                    
                }
                .background(Color(.secondarySystemBackground))
            
            VStack {
                Text("Change value to 123456.789")
                
                Text("Should result in $123,456.79.")
                .font(.caption)
                
                Button {
                    value = 123456.789
                } label: {
                    Text("Change value")
                }
            }
            
            
            VStack {
                Text("Change value to nil")
                
                Text("Should result in an empty field.")
                .font(.caption)
                
                Button {
                    value = nil
                } label: {
                    Text("Change value")
                }
            }
        }
    }
}

struct NumberTextField_Previews: PreviewProvider {
    static var previews: some View {
        SomeContainer()
    }
}
#endif
