# README

Voter module is basically a helper for a voter.

So that he won't have to do all the complicated cryptographic operations like signing, blinding or encrypting messages.

Voter doesn't have a database because it's not needed.
Voter connects to the Administrator and Counter modules.

## Building the project

  ```
  $ git pull
  $ bundle install
  ```

## Running the project

  ```
  $rails server
  ```

## Enviromental variables
list of env vars that have to be set before starting the project

```
  ADMINISTRATOR_MODULE_URI
  COUNTER_MODULE_URI
```
