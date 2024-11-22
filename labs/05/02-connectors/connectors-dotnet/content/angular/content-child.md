ContentChild is used to access projected content of a component. Projector implementation:

```html
<div class="expander">
    <h1>projector.component.html - child with ng-content</h1>
    <div class="projection"><ng-content ></ng-content></div>
</div>
```

Projector usage:

```html
<div><h3>content-child.component.html</h3>
  <app-projector>
    <div #comment>things are not always as they seem to be</div>
  </app-projector>
</div>
```
Watch console for output:

```typescript
export class ProjectorComponent implements AfterContentInit {
  @ContentChild('comment') divComment: ElementRef | null = null;
  ngAfterContentInit(): void {
    console.log('the comment: ', this.divComment?.nativeElement);
  }
}
```
