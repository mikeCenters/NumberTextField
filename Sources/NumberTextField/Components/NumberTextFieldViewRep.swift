//
//  NumberTextFieldViewRep.swift
//  NumberTextField
//
//  Created by Michael Centers on 1/15/22.
//

import SwiftUI
import UIKit

struct NumberTextFieldViewRep: UIViewRepresentable {
    var placeholder: String
    @Binding var value: Decimal?
    var formatter: NumberFormatter
    var onChange: (Decimal?) -> ()
    var onCommit: (Decimal?) -> ()
    
    
    func makeUIView(context: UIViewRepresentableContext<NumberTextFieldViewRep>) -> UITextField {
        let textField = UIOpenTextField()
        textField.delegate = context.coordinator
        textField.placeholder = self.placeholder
        
        textField.autocorrectionType = .no
        context.coordinator.setup(textField)
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<NumberTextFieldViewRep>) {
        DispatchQueue.main.async {
            context.coordinator.updateText(uiView)
        }
    }
    
    func makeCoordinator() -> NumberTextFieldViewRep.Coordinator {
        Coordinator(self)
    }
}
