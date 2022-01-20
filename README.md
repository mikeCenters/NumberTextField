# NumberTextField
#### Author: Mike Centers
A powerful SwiftUI text field that handles formatting and retaining number values.

#### [GitHub](https://github.com/mikeCenters/NumberTextField)
[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](https://github.com/mikeCenters/NumberTextField/blob/main/LICENSE)


# Overview:
`NumberTextField` is package for `SwiftUI` that offers live formatting of a text field. Rather than accepting a string for binding, `NumberTextField` requires an optional `Decimal` binding. This allows the developer to only worry about the underlying `value` of the text field.


# Requirements:

    macOS(v12), iOS(v15), tvOS(v15), watchOS(v8)

    * Still under review. iOS building/testing at this time. *


# Usage:

```swift
struct ContentView: View {
    var numberFormatter: NumberFormatter {
        let f = NumberFormatter()
        /*
         Setup your formatter.
         */
        f.numberStyle = .percent
        f.maximumFractionDigits = 5
        return f
    }

    @State var value: Decimal? =  1.5


    var body: some View {
        NumberTextField("Enter here...",
                        value: self.$value,
                        formatter: self.numberFormatter,
                        onChange: { num in
                            // num is a Decimal? type
                        },
                        onCommit: { num in
                            // num is a Decimal? type
                        })
    }
}
```

# Value

The `value` parameter for the `NumberTextField` is a binding to an optional `Decimal` type. This binding is always updated to the current text field change. The `value` can also have a value assigned prior to binding to the `NumberTextField`, for if the developer wants the user to update the `value`.

### value = nil
- This would indicate an empty string or an underlying `nil` text property to the `UIOpenTextField`.
- In either case, this would indicate no value is assigned to the binding.


# NumberFormatter

The `NumberTextField` requires a `NumberFormatter` to operate properly. This parameter allows customization of how numbers are to be displayed and emitted. However the `NumberFormatter` is setup, the `NumberTextField` should always respect the attributes set via the developer.

## Formatter Setup

```swift
var numberFormatter: NumberFormatter {
    let f = NumberFormatter()

    /*
     It is recommended to set the following parameters for every formatter.
     These can be of whatever value you choose, just make sure they are set.
     */
    f.numberStyle = .decimal        // Set the style first.
    f.minimumFractionDigits = 3
    f.maximumFractionDigits = 7

    return f
}
```

## Formatter Attributes

### NumberFormatter.numberStyle
#### Percent
The `NumberTextField` expects the `value` to be in a decimal format.
- 100% would be "value = 1.0"
- 50% would be "value = 0.5"

### Fractional Digits
These attributes have a default value unique to the `NumberFormatter.numberStyle` attribute. If fractional input is not performing as expected, set the `.maximumFractionDigits` and `.minimumFractionDigits` attributes to the desired output.

### NumberFormatter.alwaysShowDecimalSeparator
The `.alwaysShowDecimalSeparator` attribute is manipulated via the `Coordinator`. If the developer chooses to not allow fractional input, set the `.maximumFractionalDigits` attribute to zero. This will also filter the decimal separator from user input.


# Keyboard

When using the `.keyboardType` modifier of a `View`, the UIKit text field will not receive the modification. The `KeyboardType` assigned to the text field is the `.decimalPad`. There will be no button to call the resignFirstResponder() method. To resolve this, a keyboard accessory must be made within SwiftUI to toggle the state of the text field. 



# Current Issues / Objectives

*In no particular order*

#### UI
- The text field always places the cursor towards the trailing end of the text field on changes.
    - The cursor will remain in bounds.
    - Inserting still works.
    - This does not break the text field; however, the cursor retaining the position is necessary.

#### Access Control
- The package needs to be scanned for access control of stuctures and classes prior to major release.

#### ViewRep.UpdateUI
- Will require a catch to check for changes prior to calling the updateText() method.
    - At current, UpdateText() is called twice on every change.
        - The way updating UITextField.text is designed, the value is formatted and assigned to the text field.

- A resolution to this would be: When the onChange delegate event is called:
    - Update the text first with proper formatting, then assign the value.
    - When the updateUIView method is called, check for changes in the value and text before calling the updateText() method.

- updateUIView is required to assign the initial text and update the text field when external changes in value occur.

```swift
func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<NumberTextFieldViewRep>) {
    // Insert a check for change in uiView.text
    DispatchQueue.main.async {
        context.coordinator.updateText(uiView)
    }
}
```


# Change Log
## v0.2.0
- Fixed bug found with cursor placement.

## v0.1.5
- Added support for View modifiers:
    - Multiline Text Alignment
    - Font 
        - Only system dynamic fonts(.title, .headline, .body, etc.) work at this time.
        - To display a custom font, set the font within the ViewRepresentable.
        
- Resolved view sizing
- Added the KeyboardType.decimalPad as the keyboard.
- Added a binding to control the state of the text field.


## v0.1.4
- Resolved the issue with cursor not moving correctly within bounds when a whitespace is added via the `NumberFormatter`. The cursor will now only stay within the range of the first and last number character.
- All instances of the `NumberFormatter.Locale` should be supported.
- All fractional digit settings are supported.
- Currency values, and those with a `.minimumFractionDigits` greater than 0, will retain the correct formatting while the text field is not active. While active, the text field allows the end-user to freely stay within the `.maximumFractionDigits`.


## v0.1.3
- Added percent format support.

- `NumberFormatter` now assigns the `value` and `text` properties.
- Enhanced tracking of text field changes to refactor unnecessary code.
- Extended moveCursorWithinBounds() to support percent numbers.

#### Found Bug:
- Update text is being called on update of @State value due to the updateUI method of ViewRepresentable.
    - While this is supposed to happen, updateUI method should not update the text if the values are the same.


## v0.1.2
- Added currency format support.

- Fixed issue where input is not allowing trailing zeroes within fractional numbers.


## v0.1.1
- Added decimal format support.


## v0.1.0
- The initial release.
- Currently supports percent format for US or similar decimal formats.
