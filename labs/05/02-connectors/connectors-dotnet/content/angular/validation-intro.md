There are two types of validation:

For a specific FormControl, or
For the entire FormGroup

```typescript
registerForm = new FormGroup(
    {   //FormControls
        email: new FormControl('', [Validators.required, Validators.email]),
        password: new FormControl('', {
        validators: [Validators.required, Validators.minLength(4)],
        nonNullable: true,
        }),
    },
    {   //FormGroup
        updateOn: 'blur',
        validators: [this.passwordsMatchValidator],
    }
);
```