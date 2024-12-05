BoxDirective uses the Angular 15+ Directive Composition Api. Standalone Directive have to be imported in the host component.

```typescript
@Directive({
  selector: '[boxed]',
  hostDirectives: [RedColorDirective, FontBoldDirective, WidthDirective, CenteredDirective],
})
export class BoxedDirective {}
```

Use in component:

```html
<div boxed>
    My layout is done using the "boxed" directive
</div>
```

>Note: You could organize the directives in a module and import the module in the host component instead of importing each directives individually. A sample is provided in the formatting.module.ts file.