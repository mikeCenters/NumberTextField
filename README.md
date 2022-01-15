# NumberTextField
### v0.1.0
A powerful SwiftUI text field that handles formatting and retaining number values.

# Overview:
This is a Text Field package for SwiftUI that offers live formatting of a textfield. Specifically, this package assists with displaying numbered text labels during user input, while keeping the numbers formatted appropriately. Rather than showing the correct format upon a user committing to a change, Text Field Formatting offers live display during user input.

# Requirements:
    macOS(v12), iOS(v15), tvOS(v15), watchOS(v8)

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
        
    - Set access control for objects.
        
    
    
# NumberFormatter:
    The NumberedTextField requires a NumberFormatter to operate properly. This property is set by the developer and allows customization of how numbers are to be displayed and collected.
    
## Global Parameters:
    The `alwaysShowDecimalSeparator` property is controlled by the `Coordinator`. If the developer chooses to not allow fractional input, set the `maximumFractionalDigits` property to zero.
    
## Fractional Digits:
    This property has a default value unique to the `NumberFormatter.numberStyle` property. If fractional input is not performing as expected, set the `.numberStyle` property appropriately before sending it to the view.


# Change Log: 
## v0.1.0
    - The initial release. 
    - Currently supports decimal format for US or similar decimal formats.


# Flow Chart:

    - User Input
    - Process
        - Filter
        - Then:
            - Decimal?
            - Currency?
            - Percent?
            
    - Format
    - Set User Input 
    - Then:
        - Callback functions


# Current:
Fix the percentage. Figure out how to handle erasing the percent and last char.
