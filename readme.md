
# CapRover Custom NGINX Pages

Easily customize the default NGINX error and landing pages for your CapRover server. This project provides improved versions of:
- `index.html` (default landing page)
- `502` and generic error pages

## Features
- Clean, modern design for error and landing pages
- Simple installation with a single command
- Easy to update or revert

## Quick Install
Run this command on your CapRover server:

```bash
curl -fsSL https://raw.githubusercontent.com/AlmossaidLLC/caprover-nginx-pages/main/install.sh | sh
```

This will automatically replace the default NGINX pages with the custom versions from this repository.

## How It Works
- Downloads and replaces the default CapRover NGINX HTML files with improved versions from this repo
- No downtime or service restart required

## Customization
You can further customize the pages by editing the files in the `theme/default/` directory before running the install script, or by forking this repository and using your own version.

## Uninstall / Revert
To revert to the original CapRover pages, simply restore the original files or re-install CapRover's default NGINX configuration.

## Support & Feedback
For issues, suggestions, or contributions, please open an issue or pull request on the [GitHub repository](https://github.com/AlmossaidLLC/caprover-nginx-pages).

---
**Maintained by [AlmossaidLLC](https://github.com/AlmossaidLLC)**