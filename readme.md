
# CapRover Custom NGINX Pages

Easily customize the default NGINX error and landing pages for your CapRover server. This project provides improved versions of:
- `index.html` (default landing page)
- `502` and generic error pages

## Features
- Clean, modern design for error and landing pages
- Simple installation with a single command
- Multiple themes available (default, dark, winter, orange)
- Easy to update or revert

## Quick Install
Run this command on your CapRover server:

```bash
curl -fsSL https://raw.githubusercontent.com/AlmossaidLLC/caprover-nginx-pages/main/install.sh | sudo sh
```

This will automatically replace the default NGINX pages with the custom versions from this repository.

## Theme Selection
You can choose a theme by passing the `--theme` argument. Available themes: `default`, `dark`, `winter`, `orange`.

Example:

```bash
curl -fsSL https://raw.githubusercontent.com/AlmossaidLLC/caprover-nginx-pages/main/install.sh | sudo sh --theme=winter
```

Or download and run locally:

```bash
./install.sh --theme=orange
```

## How It Works
- Downloads and replaces the default CapRover NGINX HTML files with improved versions from this repo
- No downtime or service restart required

## Customization
You can further customize the pages by editing the files in the `theme/` directory before running the install script, or by forking this repository and using your own version. Multiple themes are available in the `theme/` directory.

## Uninstall / Revert
To revert to the original CapRover pages, simply restore the original files or re-install CapRover's default NGINX configuration.

## Support & Feedback
For issues, suggestions, or contributions, please open an issue or pull request on the [GitHub repository](https://github.com/AlmossaidLLC/caprover-nginx-pages).

---
**Maintained by [AlmossaidLLC](https://github.com/AlmossaidLLC)**