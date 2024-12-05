- Examine routing config in `demo.routing.module.ts` and also check in Network View of Browser Dev Tools:

```bash
children: [
...
{ path: 'lazy-standalone', loadComponent: () =>
    import('./samples/lazy-standalone/lazy-standalone.component').then(
    (c) => c.LazyStandaloneComponent
    ),
},
```

- Examine `lazy-standalone.component.ts` and `lazy-standalone.component.html`:

```typescript
@Component({
  selector: 'app-lazy-standalone',
  standalone: true,
  imports: [CommonModule, MarkdownModule, MdRendererModule, RouterModule],
  templateUrl: './lazy-standalone.component.html',
  styleUrls: ['./lazy-standalone.component.scss'],
})
export class LazyStandaloneComponent {
  constructor() { }
}
```