# Dokan store name

Read a vendor store name, and change it the safe way.

Tutorial: https://swiftwebdev.com/blog/woocommerce-multi-vendor-marketplace-setup-guide/

## Tested on

WordPress 7.1.3, WooCommerce 11.2.1, Dokan Lite 5.3.1, PHP 8.2.12, 16 October 2026. Dokan Pro, Redis and page caches were not tested.

## Safe update

```php
$vendor = dokan()->vendor->get( $vendor_id );
$vendor->set_store_name( $new_name );
$vendor->save();
```

`swd_set_vendor_store_name()` wraps this with a capability check (admin, or the vendor editing their own store).

## Why not a raw update

Dokan keeps the name in two places: the `dokan_profile_settings` array and a separate `dokan_store_name` user meta key. Store listing search and REST store search query `dokan_store_name`.

In the lab, a raw `update_user_meta()` of `dokan_profile_settings` to "Zebra Raw" changed `get_shop_name()` on a fresh vendor object. But `dokan_store_name` stayed "API Updated Store". A store search for "Zebra" returned 0 results, and the old name still matched.

An already loaded vendor object also keeps the old name in memory. Fetch it again after any raw write.

`set_store_name()` plus `save()` wrote both keys.
