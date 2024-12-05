- Examine `standalone.component.ts`. It imports all the modules it uses:

  ```typescript
  @Component({
    selector: 'app-standalone',
    standalone: true,
    imports: [CommonModule, MarkdownModule, MdRendererModule],
    templateUrl: './standalone.component.html',
    styleUrls: ['./standalone.component.scss'],
  })
  export class StandaloneComponent implements OnInit {}
  ```

>Note: The component was generated using the `--standalone flag`

- To create a standalone component use:

```bash
ng g c demos/samples/standalone --standalone
```

>Note: In Angular 17 the `--standalone` flag is not required as it is the default behavior.