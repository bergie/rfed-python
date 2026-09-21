"""RFed (Reticulum Federation) channel client for Python.

A from-scratch Python port of the canonical ``@reticulum/core`` ``RFedClient``
(JS) and the ``RFed/SPEC.md`` "CANONICAL WIRE FORMAT" (Rust). Extracted from
the Dacar Python implementation (https://github.com/bergie/dacar), where it
was originally developed.

It depends only on ``rns`` + ``msgpack`` (+ ``cryptography`` via ``rns``).
The pure codec modules (:mod:`rfed.constants`, :mod:`rfed.channel`,
:mod:`rfed._lxmf`, :mod:`rfed.blob`, :mod:`rfed.stamp`) work **without a
running Reticulum**; only :class:`rfed.client.RFedClient`'s network methods
need a live transport (``RNS.Destination`` / ``RNS.Link`` creation).

Submodules:
- :mod:`rfed.constants` — wire-format constants.
- :mod:`rfed.channel`     — deterministic channel derivation.
- :mod:`rfed._lxmf`        — minimal canonical LXMF wire codec.
- :mod:`rfed.blob`         — Phase-0 RTID envelope (wrap/unwrap).
- :mod:`rfed.stamp`        — rfed PoW stamp contract.
- :mod:`rfed.client`      — ``RFedClient`` (subscribe/publish/pull/listen).
"""

from __future__ import annotations

__all__: list[str] = []  # submodules imported explicitly by callers
