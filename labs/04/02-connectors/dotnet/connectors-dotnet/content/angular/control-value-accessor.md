Examine `number-picker.component.ts`. It implements `ControlValueAccessor` and `Validator` interfaces.
- The `ControlValueAccessor` interface defines methods that Angular calls to notify the component when the value of the form control changes. This will allow the hosting component to make use of the formControl directive.
    - writeValue(obj: any): void;
    - registerOnChange(fn: any): void;
    - registerOnTouched(fn: any): void;
    - optional setDisabledState(isDisabled: boolean): void;
- The `Validator` interface defines a method that Angular calls to validate the value of the form control. The `NumberPickerComponent` class implements these methods to update the value of the form control and validate the value of the form control.<br>
