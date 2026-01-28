### Introduction

This document describes the OAuth 2.0 Authorization Server used to authorize a DiGA to access FHIR resources of medical devices and implants. The Authorization Server is the main component of the [pairing process](pairing.html). It is responsible for authenticating a DiGA, presenting a consent dialog to the patient, issuing access and refresh tokens, and generating a [Pairing ID](pairing.html#pairing-id). The Authorization Server MUST adhere to the prerequisites described in [OAuth2 Authorization Server Prerequisites](pairing.html#oauth2-authorization-server-prerequisites).

The `access_token` issued by the Authorization Server is used as a **Bearer token** in the HTTP `Authorization` header for all requests from the DiGA to the [FHIR Resource Server](himi-diga-api.html). Resource Servers validate this token and enforce the granted [SMART scopes](smart-scopes.html) before returning any data.

The OAuth 2.0 Authorization Server has **no use-case-specific components**. Its behavior and configuration are uniform across all Device Data Recorders. A Device Data Recorder manufacturer MUST implement the core endpoints defined below but MAY support additional OAuth 2.0 endpoints if desired.

### Endpoints

A Device Data Recorder MUST implement the following endpoints, which form the core of the OAuth 2.0 Authorization Server for pairing:

* [OAuth 2.0 Authorization Server Metadata](authorization-server-metadata-endpoint.html)
* [OAuth 2.0 Pushed Authorization Request](authorization-server-par-endpoint.html)
* [OAuth 2.0 Authorization Endpoint](authorization-server-authorization-endpoint.html)
* [OAuth 2.0 Token Endpoint](authorization-server-token-endpoint.html)
* [OAuth 2.0 Revocation Endpoint](authorization-server-revocation-endpoint.html)
