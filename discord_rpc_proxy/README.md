# Discord RPC Proxy DLL

This folder contains a proxy `discord-rpc.dll` for 444.

## What It Does

- Exports the same 9 functions as the stock `discord-rpc.dll`.
- Forwards calls to the original library renamed as `discord-rpc-original.dll`.
- Overrides selected Rich Presence text fields in `Discord_UpdatePresence`.

## Edit The Text

In `discord_rpc_proxy.cpp`, update these constants:

- `kMainDetailsLine`
- `k444LargeImageKey`
- `k444SmallImageKey`
- `kLargeImageHoverText`
- `kBuildHoverPrefix`
- `kDiscordButtonLabel`
- `kDiscordButtonUrl`
- `kOverrideApplicationId` (optional; leave empty to keep Fortnite app id)

Notes:

- The details line is set to `Playing Fortnite`.
- The state line is generated as `In Lobby` or `In-Game` from detected presence signals.
- Large-image hover text is fixed (`444 Link` by default).
- Small-image hover text is `vX.XX` (parsed from the build folder name), otherwise `Unknown Version`.
- A clickable Rich Presence button is sent as `444 Discord` -> `https://discord.gg/GqgakxU6bm`.
- Both image keys must exist as assets on the Discord application in use.

## Build

1. Open a Visual Studio Developer Command Prompt.
2. Run:

```bat
cd discord_rpc_proxy
build-proxy.cmd
```

That outputs:

- `discord_rpc_proxy/build/discord-rpc.dll`
- `444_link_flutter/assets/dlls/discord-rpc.dll` (copied automatically)

## Runtime Behavior In 444

On launch, 444 now:

1. Backs up each build's original DLL as `discord-rpc-original.dll` (once).
2. Copies the custom `discord-rpc.dll` into:

`FortniteGame\Binaries\ThirdParty\Discord\Win64`

If backup is missing but custom DLL is already present, 444 skips that build to avoid breaking forwarding.
