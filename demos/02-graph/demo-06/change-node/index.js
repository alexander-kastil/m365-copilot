#!/usr/bin/env node

import { app } from './app';
import { createDatabase } from './helpers/dbHelper';

createDatabase();

app.set('port', process.env.PORT || 3000);

const server = app.listen(app.get('port'), () => {
  // eslint-disable-next-line no-console
  console.log('Express server listening on port ' + server.address().port);
});
