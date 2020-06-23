# Online Voting App

simple implementation of a safe and anynomous voting system

based on [**"A practical Secret Voting Scheme for Large Scale Elections"**](https://link.springer.com/chapter/10.1007/3-540-57220-1_66)
by Atsushi Fujioka, Tatsuaki Okamoto and Kazuo Ohta

Project is just an API service with no real frontend, [Voters Frontend Project](https://github.com/merynos94/voters) is an atempt to solve this.


#### How it works:

The project implements the structure of an online voting scheme proposed by Fujioka et al. which consists of following stages,
| Stage        | Action      |
| ------------- |-------------|
| PREPARATION |  Voter fills in a ballot, makesthe messageusing the blind signature technique to get the administrator's signature, and sends it to the administrator. |
| ADMINISTRATION |  Administrator signs the messagein which the voter's ballot is hidden, and returns the signature to the voter.|
| VOTING |  The voter gets the ballot signed by administrator, and sends it to the counter anonymously. |
| COLLECTING | Counter publishes a list of the received ballots. |
| OPENING | The voter opens his vote by sending his encryption key anonymously. |
| COUNTING | Counter counts the voting and announcesthe result. |

The encryption and key generation is mostly done by good old [OpenSSL](https://ruby.github.io/openssl/) with a slight twist on blinding which had to be custom made as `OpenSSL` doesn't support it out of the box.

#### How to build
Each project is to be built on it's own. You can find the steps inside particular project `README`.

### How to document

We use `rdoc` and `sdoc` to generate documentation. Once you write some docs just do
```
$ rake rdoc
```
and appropriate docs will be generated

#### Code documentation:
* [Voter module documentation](voter/doc/index.html)
* [Administrator module documentation](administrator/doc/index.html)
* [Counter module documentation](counter/doc/index.html)
* [Lib documentation](lib/doc/index.html)


#### API documentation
* [Counter](https://counter4.docs.apiary.io/l)
* [Administrator](https://admin58.docs.apiary.io/)
* [Voter](https://voterprojectpi.docs.apiary.io/)

**Author**: beniutek
