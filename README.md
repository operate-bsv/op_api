# Operate | API

Operate is an extensible Bitcoin meta programming protocol. It offers a way of constructing programs encapsulated in Bitcoin (SV) transactions that can be be used to process data, perform calculations and operations, and return any computable value.

**Operate | API** is a Phoenix-powered web application serving API endpoints.

## Endpoints

### GET `/ops`

Retrieves a list of all Ops.

#### Parameters:

* `fn` - If present, the Op function is included in the response.

### GET `/ops/{ref}`

Retrieves the Op identified by `ref`.

#### Parameters:

* `ref` - Either the Op reference, SHA-256 hash or txid.
* `fn` - If present, the Op function is included in the response.

### GET `/ops/{ref}/fn`

Retrieves the raw Op function for the Op identified by `ref`.

#### Parameters:

* `ref` - Either the Op reference, SHA-256 hash or txid.

### GET `/ops/{ref}/versions`

Retrieves a list of all versions of the Op identified by `ref`.

#### Parameters:

* `ref` - Either the Op reference, SHA-256 hash or txid.
* `fn` - If present, the Op function is included in the response.

### GET `/tapes/{txid}`

Retrieves the Tape by its `txid`. Returns the tapes cells.

#### Parameters:

* `txid` - The transaction ID of the tape.

### POST `/tapes/{txid}`

Runs the Tape identified by its `txid`. Returns the tape result.

#### Parameters:

* `txid` - The transaction ID of the tape.

## License

© Copyright 2019 Chronos Labs Ltd.

BSV-ex is free software and released under the [MIT license](https://github.com/operate-bsv/api.operatebsv.org/blob/master/LICENSE.md).