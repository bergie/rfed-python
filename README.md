# rfed-python

Python client for **[RFed (Reticulum Federation)](https://github.com/jrl290/RFed)**
channels — publish/subscribe over [Reticulum](https://github.com/markqvist/Reticulum).

A from-scratch port of the canonical `@reticulum/core` `RFedClient`
(JavaScript) and the [RFed spec](https://github.com/jrl290/RFed)'s `SPEC.md`
"CANONICAL WIRE FORMAT" (Rust reference node), byte-compatible with both: channel hashes, EC envelopes, LXMF tails,
and PoW stamps cross-validate across implementations. Extracted from the
[Dacar](https://github.com/bergie/dacar) Python implementation, where it was
originally developed.

## Install

```sh
pip install rfed
```

Dependencies: [`rns`](https://pypi.org/project/rns/) (>= 1.5.4) and
`msgpack` — the same stack the rest of the Reticulum ecosystem uses.

## Usage

```python
import RNS
from rfed._lxmf import LxmfMessage
from rfed.client import RFedClient

reticulum = RNS.Reticulum()  # boots a transport (e.g. AutoInterface)
identity = RNS.Identity()    # your subscriber identity
client = RFedClient(identity, reticulum)

NODE = bytes.fromhex("…")            # any rfed.* destination hash of a node
CHANNEL = "my.channel.v1"

# Subscribe — also caches the node's advertised PoW stamp cost.
result = client.subscribe(NODE, CHANNEL)
print(result.ok, result.stamp_cost)

# Publish an LXMF-envelope message (fire-and-forget SEND).
message = LxmfMessage(content=b"hello over rfed")
client.publish(NODE, CHANNEL, message)

# Listen for live fanout deliveries on your rfed.delivery destination.
def on_message(decoded):
    print(decoded.message.content, decoded.signature_valid)

client.listen(on_message)

# Or catch up after being offline: drain the node's deferred queue.
page = client.pull(NODE, CHANNEL)
while page.more_pending:
    page = client.pull(NODE, CHANNEL)
```

RFed treats the encrypted `inner_blob` **opaquely**, so applications may
carry their own inner format instead of the LXMF envelope (Dacar, for
example, ships a compact Delta format that fits more payload under the RNS
MTU). For that, use the raw primitives:

- `client.send_publish(node_hash, rfed_payload)` — fire-and-forget SEND of a
  pre-wrapped payload,
- `client.listen_raw(on_fanout)` — undecoded `(channel_name,
  channel_identity, inner_blob)` deliveries, decrypt/decode yourself.

The pure codec modules (`rfed.constants`, `rfed.channel`, `rfed._lxmf`,
`rfed.blob`, `rfed.stamp`) work **without a running Reticulum** — only
`RFedClient`'s network methods need a live transport.

## Wire format

```
plaintext    = "RTID"(4) ‖ sender_identity_pub(64) ‖ LXMF_tail
LXMF_tail    = source_hash(16) ‖ signature(64) ‖ msgpack_payload
inner_blob   = EC_encrypt(channel_identity.X25519_pub, plaintext)
rfed_payload = channel_hash(16) ‖ inner_blob ‖ stamp(32)?
```

Channels are derived deterministically from their name
(`rfed.channel.derive_channel`), so any party knowing the name can derive the
shared keypair — no registration. Stamps use the standard LXMF PoW mechanism
(memory-hard HKDF workblock) at rfed's 16 expansion rounds.

## Status

Early beta (0.x). The wire format follows the RFed spec's "CANONICAL WIRE
FORMAT" and cross-validates with `@reticulum/core` (JS) and the Rust
reference node, but the RFed protocol itself is still evolving.

Implemented with LLM assistance.

## License

EUPL-1.2, same as Dacar and reticulum-js.
