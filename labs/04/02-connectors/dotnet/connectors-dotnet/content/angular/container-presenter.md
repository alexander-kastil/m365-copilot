- Examine the code in the `container-presenter.component.ts` and `presenter-edit.component.ts` files. It is demonstrating a Container-Presenter pattern and is using the Angular 16 required input

```typescript
export class PresenterEditComponent {
  @Input({ required: true }) person: Person = new Person();
```
