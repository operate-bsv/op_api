# Operate | API

Operate is an extensible Bitcoin meta programming protocol. It offers a way of constructing programs encapsulated in Bitcoin (SV) transactions that can be be used to process data, perform calculations and operations, and return any computable value.

**Operate | API** is a Phoenix-powered web application serving API endpoints.

More infomation:

* [Project website](https://www.operatebsv.org)

## Endpoints

<table width="100%">
  <thead>
    <tr>
      <th>Endpoint</th>
      <th>Parameters</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td valign="top">
        <h4><code>GET /ops</code></h4>
        <p>Retrieves a list of all Ops.</p>
      </td>
      <td valign="top">
        <h4>Query params</h4>
        <ul>
          <li><code>fn</code> - If present, the Op function is included in the response.</li>
        </ul>
      </td>
    </tr>
    <tr>
      <td valign="top">
        <h4><code>GET /ops/{ref}</code></h4>
        <p>Retrieves a single Op.</p>
      </td>
      <td valign="top">
        <h4>Path params</h4>
        <ul>
          <li><code>ref</code> - Either the Op reference, SHA-256 hash or txid.</li>
        </ul>
        <h4>Query params</h4>
        <ul>
          <li><code>fn</code> - If present, the Op function is included in the response.</li>
        </ul>
      </td>
    </tr>
    <tr>
      <td valign="top">
        <h4><code>GET /ops/{ref}/fn</code></h4>
        <p>Retrieves the raw Op function.</p>
      </td>
      <td valign="top">
        <h4>Path params</h4>
        <ul>
          <li><code>ref</code> - Either the Op reference, SHA-256 hash or txid.</li>
        </ul>
      </td>
    </tr>
    <tr>
      <td valign="top">
        <h4><code>GET /ops/{ref}/versions</code></h4>
        <p>Retrieves a list of all Op versions.</p>
      </td>
      <td valign="top">
        <h4>Path params</h4>
        <ul>
          <li><code>ref</code> - Either the Op reference, SHA-256 hash or txid.</li>
        </ul>
        <h4>Query params</h4>
        <ul>
          <li><code>fn</code> - If present, the Op function is included in the response.</li>
        </ul>
      </td>
    </tr>
    <tr>
      <td valign="top">
        <h4><code>GET /tapes/{txid}</code></h4>
        <p>Retrieves a single Tape and responds with an array of tape cells.</p>
      </td>
      <td valign="top">
        <h4>Path params</h4>
        <ul>
          <li><code>txid</code> - The transaction ID of the tape.</li>
        </ul>
      </td>
    </tr>
    <tr>
      <td valign="top">
        <h4><code>POST /tapes/{txid}</code></h4>
        <p>Runs the Tape and responds with the tape result.</p>
      </td>
      <td valign="top">
        <h4>Path params</h4>
        <ul>
          <li><code>txid</code> - The transaction ID of the tape.</li>
        </ul>
      </td>
    </tr>
  </tbody>
</table>

## Usage

The Pheonix application itself is purely a web API. It is intended to be used in conjunction with [Operate | Planaria](https://github.com/operate-bsv/planaria) which indexes the blockchain.

To run the API locally:

* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.setup`
* Start Phoenix endpoint with `mix phx.server`
* Visit [`GET /ops`](http://localhost:4000/ops) from your browser.

## License

© Copyright 2019 Chronos Labs Ltd.

BSV-ex is free software and released under the [MIT license](https://github.com/operate-bsv/api.operatebsv.org/blob/master/LICENSE.md).