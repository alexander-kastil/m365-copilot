FormBuilder can shorten form initialization in TypeScript. There is also a `NonNullableFormBuilder` available.

```typescript
personForm = this.fb.group({
    id: [this.person.id],
    name: [this.person.name, { validators: [Validators.required] }],
    age: [this.person.age, { validators: [Validators.min(1)] }],
    email: [this.person.email, { validators: [Validators.email] }],
    gender: [this.person.gender, { validators: [Validators.pattern(this.genderPattern)] }],
    wealth: [this.person.wealth],
});
```