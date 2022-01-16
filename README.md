# NumberTextField

A powerful SwiftUI text field that handles formatting and retaining number values.

[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](https://github.com/mikeCenters/NumberTextField/blob/main/LICENSE)


# Overview:
`NumberTextField` is package for `SwiftUI` that offers live formatting of a textfield. Rather than accepting a string for binding, `NumberTextField` requires an optional Decimal binding. This allows the developer to only worry about the underlying value of the textfield.


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


# NumberFormatter

The `NumberTextField` requires a `NumberFormatter` to operate properly. This property is set by the developer and allows customization of how numbers are to be displayed and emitted.

## Formatter Setup

```swift
var numberFormatter: NumberFormatter {
    let f = NumberFormatter()
    /*
     Setup your formatter.
     */
    f.numberStyle = .decimal
    f.minimumFractionDigits = 3
    f.maximumFractionDigits = 7
    return f
}
```

## Formatter Attributes

### NumberFormatter.alwaysShowDecimalSeparator
The `alwaysShowDecimalSeparator` property is manipulated by the `Coordinator`. If the developer chooses to not allow fractional input, set the `maximumFractionalDigits` property to zero. This will also filter the decimal separator from user input.

### Fractional Digits
These properties have a default value unique to the `NumberFormatter.numberStyle` property. If fractional input is not performing as expected, set the `.maximumFractionDigits` and `.minimumFractionDigits` in conjunction with the `.numberStyle` property appropriately before sending it to the view.


# Current Issues / Objectives

*In no particular order*

#### UI
  - The keyboard is not changing to different types when assigned in SwiftUI.
  - View is rendered full screen.
    - AutoLayoutConstraints?

#### Non US-Like Decimal Formats (German)
  - These formats provide inconsistent behavior with symbols.
    - Specifically, a whitespace is added before a percent symbol `%` when it should not.
    - I attempted to remove all whitespaces at assignment during formatting, but it seems to not work.
    - Requires more investigation.

#### Decimal Value
  - When a limit is set on the formatter, the value binding is not retaining the limits.
    - The limit is only applying to the formatted string.
    - Test whole and fractional limits.
    - This can likely be resolved with the use of the NumberFormatter during assignment of the value.

#### Currency Value
  - The `NumberFormatter.minimumFractionDigit` property is not preserved for commit.
      - This is due to the Coordinator adjusting the minimum value for trailing zeroes.
        - Resolve this issue by assigning the defined minimum on commit.

#### Access Control
  - The package needs to be scanned for access control of stuctures and classes prior to major release.


# Change Log

## v0.1.2
    - Added currency format support.

    - Fixed issue not allowing trailing zeroes to be input within fractional numbers.


## v0.1.1
    - Added decimal format support.


## v0.1.0
    - The initial release.
    - Currently supports percent format for US or similar decimal formats.
