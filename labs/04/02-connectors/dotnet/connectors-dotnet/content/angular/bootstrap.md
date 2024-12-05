- Examine sample `standalone-component-app` in this modules folder. Explain how `main.ts` is used to provide modules and routing:

  ```typescript
  ...
  import { AppComponent } from './app/app.component';
  import { environment } from './environments/environment';

  if (environment.production) {
    enableProdMode();
  }

  bootstrapApplication(AppComponent, {
    providers: [
      importProvidersFrom(HttpClientModule),
      provideRouter(APP_ROUTES)
    ],
  }
  ).catch((err) => console.error(err));
  ```

- Migrate existing projects to standalone:

  ```bash
  ng g @angular/core:standalone
  ```