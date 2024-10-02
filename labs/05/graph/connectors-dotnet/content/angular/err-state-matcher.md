Custom ErrorStateMatcher allow you to controll globaly when errors are evaluated. The ErrorStateMatcher can be registered at:

Control Level:

```html
<input
    type="text"
    matInput
    placeholder="Email Address"
    id="username"
    formControlName="email"
    [errorStateMatcher]="matcher"
/>
```
Component or Module Level:

```typescript
@Component({
  selector: 'app-err-state-matcher',
  templateUrl: './err-state-matcher.component.html',
  styleUrls: ['./err-state-matcher.component.scss'],
  providers: [{ provide: ErrorStateMatcher, useClass: CustomStateMatcher }],
})
```