Typing is done be providing a default value or by using FormControl<T>:
```typescript    
    personForm = new FormGroup({
    name: new FormControl(this.person.name, Validators.required),
    age: new FormControl(this.person.age),
    email: new FormControl<string>(this.person.email),
    gender: new FormControl<'male' | 'female' | 'not set' | null>(
        this.person.gender
    ),
    wealth: new FormControl(this.person.wealth),
});
```