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