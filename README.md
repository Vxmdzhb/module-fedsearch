# astrx/module-fedsearch

Federated search across site content and the astrx-suite engines — the **Federated search** module of [AstrX](https://github.com/Vxmdzhb/astrx).

![One search box, with a tab per engine](docs/screenshot.png)

- Module key: `fedsearch` (switch it on in the site's `resources/config/Modules.config.php`)
- Pages: `federated_search`
- Requires: `astrx/cms`, `astrx/framework`, `astrx/library`, `astrx/module-search`

It ships its own templates, catalogs (en, it), default configuration and SQL in
`resources/`; the site overrides any of them from its own `resources/`.

AstrX isn't on Packagist and doesn't tag versions: you install from each
repository's `main`, and your `composer.lock` pins the exact commit. Tell
Composer where to find the package and the AstrX packages it depends on:

```json
{
    "minimum-stability": "dev",
    "prefer-stable": true,
    "repositories": [
        { "type": "vcs", "url": "https://github.com/Vxmdzhb/module-fedsearch" },
        { "type": "vcs", "url": "https://github.com/Vxmdzhb/cms" },
        { "type": "vcs", "url": "https://github.com/Vxmdzhb/framework" },
        { "type": "vcs", "url": "https://github.com/Vxmdzhb/library" },
        { "type": "vcs", "url": "https://github.com/Vxmdzhb/module-search" }
    ]
}
```

Then:

```sh
composer require astrx/module-fedsearch:dev-main
```

After that, list `AstrX\FederatedSearch\FederatedSearchModule::class` in the
site's `ApplicationModules::INSTALLED` and run the installer to create its
tables. See [modules](https://github.com/Vxmdzhb/astrx/blob/main/docs/MODULES.md).

Issues and pull requests are welcome here. [AstrX](https://github.com/Vxmdzhb/astrx)
is the site that puts all the packages together.
