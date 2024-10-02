Examine a base reactive form in reactive-forms.component.ts:

```typescript
this.personForm = new FormGroup({
    //include the id even if you do not want to render it to support updated
    id: new FormControl(this.person.id),
    name: new FormControl(this.person.name, Validators.required),
    lastname: new FormControl(this.person.lastname, Validators.required),
    age: new FormControl(this.person.age),
    email: new FormControl(this.person.email),
    gender: new FormControl(this.person.gender),
    wealth: new FormControl(this.person.wealth),
});
```