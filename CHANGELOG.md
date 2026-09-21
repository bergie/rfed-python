# Changelog

All notable changes to rfed will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.1] - 2026-09-22

### Changed
- README improvements: corrected the license note (EUPL-1.2, same as Dacar
  and reticulum-js) and added an LLM-assistance note.

## [0.1.0] - 2026-09-22

### Added
- Initial release, extracted from the Dacar Python implementation
  (https://github.com/bergie/dacar, `dacar.rfed` subpackage → standalone
  `rfed` package). No API changes — imports move from `dacar.rfed.*` to
  `rfed.*`. Contents:
  - `rfed.constants` — protocol-invariant wire-format constants.
  - `rfed.channel` — deterministic channel derivation (`derive_channel`,
    `delivery_hash_for`, `channel_path`).
  - `rfed._lxmf` — minimal canonical LXMF message wire codec,
    byte-for-byte compatible with Python LXMF `pack()`/`unpack_from_bytes()`.
  - `rfed.blob` — Phase-0 RTID envelope (`wrap_channel_message` /
    `unwrap_channel_message`, fanout/send payload parsing).
  - `rfed.stamp` — standard-LXMF PoW stamp contract at rfed's 16 expansion
    rounds (`generate_channel_stamp` / `validate_channel_stamp` /
    `stamp_workblock` / `stamp_value` / `stamp_valid`).
  - `rfed.client` — `RFedClient`: `subscribe` / `unsubscribe` / `publish` /
    `pull` / `listen` (LXMF envelope), plus the raw `send_publish` /
    `listen_raw` / `channel` / `stamp_cost` primitives for
    application-specific inner formats.
  - `RFedClient.send_publish()` supports oversized channel publishes over
    links, mirroring the reference rfed node and `@reticulum/rfed` 0.8.2.
    Payloads up to the link MDU (`rfed.constants.PUBLISH_DATA_MAX`, 431 B at
    the default 500 B MTU) go out as a single fire-and-forget DATA packet;
    anything larger is sent as an `RNS.Resource` over a link to the
    `rfed.channel.publish` destination (which accepts both paths) and
    awaited to `COMPLETE`.
  - `RFedClient.pull()` raises the new `rfed.client.RFedPullError` when the
    node answers with a numeric error code (`0xF0` ERROR_NO_IDENTITY /
    `0xF4` ERROR_INVALID_DATA) instead of silently returning an empty page,
    so callers can re-identify on a fresh link.

### Changed
- RNS requirement is `>=1.5.4`, pairing with the `@reticulum/*` 0.8.2 wire
  protocol (rfed link publishes, pull error codes).
