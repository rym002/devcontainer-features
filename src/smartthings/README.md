
# SmartThings CLI (smartthings)

SmartThings CLI feature

## Example Usage

```json
"features": {
    "ghcr.io/rym002/devcontainer-features/smartthings:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Version of SmartThings CLI to install | string | 1.10.4 |
| arch | CPU Architecture of SmartThings CLI to install | string | x64 |
| autocomplete | Enable SmartThings CLI autocompletion | boolean | true |
| installLuaLibs | Install the SmartThings lua libs source | boolean | true |
| luaLibsVersion | Version of SmartThings lua libs to install | string | v13_56 |
| enableLogin | Enable SmartThings CLI login support | boolean | false |

# Config
Smartthings cli config is bind mounted to to your home directory to enable reuse.

```bash
mkdir -p ~/.config/@smartthings/
```

# Login
To login to smartthings, set `"enableLogin": true` and add the below to devcontainer.json to open a browser in the host when the cli opens the login port.

```json
    "portsAttributes": {
        "61973": {
            "label": "Smartthings Login",
            "onAutoForward": "openBrowser"
        }
    }
```

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/rym002/devcontainer-features/blob/main/src/smartthings/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
