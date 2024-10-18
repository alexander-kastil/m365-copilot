The options nonNullable or updateOn with Validators or asyncValidators allow you to control details of the validator.

```typescript
email: [
    this.person.email,
    {
        nonNullable: true,
        updateOn: 'blur',
        validators: [Validators.required, Validators.email],
        asyncValidators: [this.mailExistsValidator],
    },
],
```
