# NumberTextField

A powerful SwiftUI text field that handles formatting and retaining number values.

[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](https://github.com/mikeCenters/NumberTextField/blob/main/LICENSE)


# Overview:
NumberTextField is package for SwiftUI that offers live formatting of a textfield. Rather than accepting a string for binding, NumberTextField requires an optional Decimal binding. This enables the developer to only worry about the underlying value of the textfield.

# Requirements:

    macOS(v12), iOS(v15), tvOS(v15), watchOS(v8)

    *Still under review. iOS building/testing at this time.*


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



## Bugs:
- Non-US-like decimal formats sometimes provide inconsistent behavior with symbols (example: German).
  - Specifically, a whitespace is added before a percent symbol `%` when it should not.
  - I attempted to remove all whitespaces at assignment during formatting, but it seems to not work.
  - Requires more investigation.


- Percentage Formatter:
  - Unable to input a zero after a decimal: "0.01%". Trailing zeroes are filtered?

  - UI
    - The keyboard is not changing when assigned in SwiftUI.
    - View is rendered full screen: AutoLayoutConstraints?


- Set access control.


---


## NumberFormatter

The NumberTextField requires a NumberFormatter to operate properly. This property is set by the developer and allows customization of how numbers are to be displayed.


### Global Parameters

The `alwaysShowDecimalSeparator` property is controlled by the `Coordinator`. If the developer chooses to not allow fractional input, set the `maximumFractionalDigits` property to zero.


### Fractional Digits

This property has a default value unique to the `NumberFormatter.numberStyle` property. If fractional input is not performing as expected, set the `.numberStyle` property appropriately before sending it to the view.


---


# Change Log:
## v0.1.1
    - Added decimal format support.
    
## v0.1.0
    - The initial release.
    - Currently supports percent format for US or similar decimal formats.
