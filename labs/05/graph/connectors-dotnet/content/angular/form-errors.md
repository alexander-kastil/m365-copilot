This sample makes use of the global errors collection. It also contains a custom validation:

```typescript
validateName(control: FormControl): { [s: string]: boolean } | null {
if (control.value === 'Hugo') {
    return { nameError: true };
}
    return null;
}
```