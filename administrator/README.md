# README

Admin module is responsible for checking if the voter is allowed

to vote and whether he has sent correctly signed vote.

If all is correct admin should sign the vote so that it can be unblinded and presented to Counter module.

## Building the project

```
  $ git pull
  $ bundle install
```

## Running the project
```
  $ rails server
```

## Enviromental variables
list of env vars that have to be set before starting the project

Admin private key which is used to sign the votes
```
  ONLINE_VOTING_SECRET
```
