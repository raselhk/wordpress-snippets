# WordPress snippets

Small WordPress and WooCommerce snippets tested in a local lab, each linked to its tutorial on swiftwebdev.com.

| Snippet | What it does | Tested on | Tutorial |
| --- | --- | --- | --- |
| [renewal-hook](woocommerce-subscriptions/renewal-hook/) | Logs a line when a subscription renewal is due | WordPress 7.1.3, WooCommerce 11.2.1, Action Scheduler 4.1.0, PHP 8.2.12 (Subscriptions not installed, stand-in used) | [Guide](https://swiftwebdev.com/blog/custom-subscription-workflow-woocommerce/) |
| [store-name](dokan/store-name/) | Reads a Dokan store name and updates it so `dokan_store_name` stays in sync | WordPress 7.1.3, WooCommerce 11.2.1, Dokan Lite 5.3.1, PHP 8.2.12 | [Guide](https://swiftwebdev.com/blog/woocommerce-multi-vendor-marketplace-setup-guide/) |
| [php-compatibility](php-compatibility/) | Composer and PHPCS setup to scan plugins for PHP 8.2+ problems | PHP 8.2.12, PHP_CodeSniffer 4.0.4, PHPCompatibilityWP 3.0.0-alpha2 | [Guide](https://swiftwebdev.com/blog/php-version-compatibility-fix-wordpress/) |
| [find-injected-spam](security/find-injected-spam/) | Read-only shell checks for injected spam (syntax checked only) | `bash -n` | [Guide](https://swiftwebdev.com/blog/hacked-wordpress-site-recovery-process/) |

## How to use

PHP snippets (`renewal-hook.php`, `store-name.php`):

- As a mu-plugin: copy the file to `wp-content/mu-plugins/`. It loads on its own.
- Or paste the code (without the opening `<?php` and the docblock) into the Code Snippets plugin and run it everywhere.

Each folder has its own README with details and the exact tests.

## Author

Rasel Hakkani, [Swift Web Dev](https://swiftwebdev.com/). More about me: [swiftwebdev.com/about](https://swiftwebdev.com/about/).

## Disclaimer

Test on a staging site first. Back up before you change a live store. These snippets come with no warranty.

## License

GPL-2.0-or-later. See [LICENSE](LICENSE).
