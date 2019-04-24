/**
 * Purge the inbox for the selected fiscal code
 * Set the following environment variables:
 *
 * FISCAL_CODE_TO_PURGE=<user's fiscal code>
 * CUSTOMCONNSTR_COSMOSDB_KEY=<cosmosdb key>
 * CUSTOMCONNSTR_COSMOSDB_URI="https://agid-cosmosdb-test.documents.azure.com:443/"
 * COSMOSDB_NAME="agid-cosmosdb-test"
 */
// tslint:disable

import { DocumentClient as DocumentDBClient } from "documentdb";
import { StrMap } from "fp-ts/lib/StrMap";
import * as documentDbUtils from "../lib/utils/documentdb";
import { reduceResultIterator } from "../lib/utils/documentdb";
import { getRequiredStringEnv } from "../lib/utils/env";

const fiscalCode = getRequiredStringEnv("FISCAL_CODE_TO_PURGE");
const cosmosDbName = getRequiredStringEnv("COSMOSDB_NAME");
const cosmosDbUri = getRequiredStringEnv("CUSTOMCONNSTR_COSMOSDB_URI");
const cosmosDbKey = getRequiredStringEnv("CUSTOMCONNSTR_COSMOSDB_KEY");

const documentDbDatabaseUrl = documentDbUtils.getDatabaseUri(cosmosDbName);

const messagesCollectionUrl = documentDbUtils.getCollectionUri(
  documentDbDatabaseUrl,
  "messages"
);

const documentClient = new DocumentDBClient(cosmosDbUri, {
  masterKey: cosmosDbKey
});

const docsIterator = documentDbUtils.queryDocuments(
  documentClient,
  messagesCollectionUrl,
  {
    parameters: [
      {
        name: "@fiscalCode",
        value: fiscalCode
      }
    ],
    query: `SELECT * FROM m WHERE m.fiscalCode = @fiscalCode`
  },
  fiscalCode
);

function deleteDocument(
  documentClient: DocumentDBClient,
  partitionKey: string,
  self: string
): Promise<any> {
  return new Promise((resolve, reject) => {
    documentClient.deleteDocument(
      self,
      {
        partitionKey
      },
      (err, res) => {
        if (err) {
          return reject(err);
        }
        resolve(res);
      }
    );
  });
}

const it = reduceResultIterator(docsIterator, async (prev, message) => {
  try {
    await prev;
    console.log(message);

    await deleteDocument(documentClient, message.fiscalCode, message._self);

    return message.id;
  } catch (e) {
    console.error(e);
    return message.id;
  }
});

documentDbUtils
  .iteratorToValue(it, new StrMap<string>({}))
  .then()
  .catch(console.error);
