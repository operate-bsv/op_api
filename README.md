# Operate | API

A Phoenix-powered web application serving an HTTP API for Operate.

## About Operate

Operate is a toolset to help developers build applications, games and services on top of Bitcoin (SV). It lets you write functions, called "Ops", and enables transactions to become small but powerful programs, capable of delivering new classes of services layered over Bitcoin.

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

## Developing

To run the API locally:

* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.setup`
* Start Phoenix endpoint with `mix phx.server`
* Visit [`http://localhost:4000/ops`](http://localhost:4000/ops) from your browser.

The Pheonix application itself is purely a read-only web API. It is intended to be used in conjunction with [Operate | Planaria](https://github.com/operate-bsv/op_planaria) which indexes the blockchain.

## License

[MIT License](https://github.com/operate-bsv/op_api/blob/master/LICENSE.md).

© Copyright 2019 Chronos Labs Ltd.