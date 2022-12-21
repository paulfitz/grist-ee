import { Activation } from 'app/gen-server/lib/Activation';
import { configureSendGridNotifier } from 'app/gen-server/lib/configureSendGridNotifier';
import { checkAzureExternalStorage,
         configureAzureExternalStorage } from 'app/server/lib/configureAzureExternalStorage';
import { checkMinIOExternalStorage,
         configureMinIOExternalStorage } from 'app/server/lib/configureMinIOExternalStorage';
import { checkS3ExternalStorage,
         configureS3ExternalStorage } from 'app/server/lib/configureS3ExternalStorage';
import { makeSimpleCreator } from 'app/server/lib/ICreate';

export const create = makeSimpleCreator({
  storage: [
    {
      check: () => checkAzureExternalStorage() !== undefined,
      create: configureAzureExternalStorage,
    },
    {
      check: () => checkS3ExternalStorage() !== undefined,
      create: configureS3ExternalStorage,
    },
    {
      check: () => checkMinIOExternalStorage() !== undefined,
      create: configureMinIOExternalStorage,
    },
  ],
  billing: {
    create: (dbManager, gristConfig) => new Activation(dbManager, gristConfig),
  },
  notifier: {
    create: configureSendGridNotifier,
  },
});
