# PHP compatibility check

Scan a plugin or theme for code that breaks or warns on PHP 8.2 and newer, using PHPCompatibilityWP.

Tutorial: https://swiftwebdev.com/blog/php-version-compatibility-fix-wordpress/

## Tested on

PHP 8.2.12 CLI, WP-CLI 2.12.0, WordPress 7.1.3, 16 October 2026. Installed versions: PHP_CodeSniffer 4.0.4, PHPCompatibility 10.0.0-alpha2, PHPCompatibilityWP 3.0.0-alpha2. These are alpha releases.

## Install

```bash
cd php-compatibility
composer install
vendor/bin/phpcs -i
```

Composer needs `minimum-stability` set to `dev` here. Without it the install failed:
`phpcompatibility/php-compatibility ^10.0@dev ... does not match your minimum-stability`.
The `composer.json` in this folder already sets `minimum-stability: dev` and `prefer-stable: true`.

## Run

```bash
vendor/bin/phpcs path/to/your-plugin
# or set the PHP version on the command line
vendor/bin/phpcs -p path/to/your-plugin --runtime-set testVersion 8.3-
```

The `*/vendor/*` ignore did not exclude a `vendor_prefixed` folder in the lab, so those files still appear in reports.

## Real excerpt

Yoast SEO 9.4 (an old release) scanned with `testVersion 8.3-`. The scan found 1 error and 20 warnings in 16 files:

```
FILE: wordpress-seo/frontend/class-frontend.php
 585 | WARNING | Using ${var} in strings is deprecated since PHP 8.2, use
     |         | {$var} instead. Found: ${marker}
```

Yoast SEO 9.4 was then activated on PHP 8.2.12 with WP_DEBUG_LOG on. No fatal errors. debug.log held the matching runtime line:

```
PHP Deprecated:  Using ${var} in strings is deprecated, use {$var} instead in .../wp-content/plugins/wordpress-seo/frontend/class-frontend.php on line 585
```

The static scan and the runtime log agreed on line 585. Contact Form 7 5.1.1 scanned with `testVersion 8.2-` gave 0 errors and 2 warnings.
