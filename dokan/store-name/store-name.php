<?php
/**
 * Plugin Name: SWD Dokan Store Name
 * Description: Read a Dokan vendor store name and update it the safe way, so dokan_store_name stays in sync.
 * Version: 1.0.0
 * Author: Rasel Hakkani
 * Author URI: https://swiftwebdev.com/
 * License: GPL-2.0-or-later
 * License URI: https://www.gnu.org/licenses/gpl-2.0.html
 *
 * Tutorial: https://swiftwebdev.com/blog/woocommerce-multi-vendor-marketplace-setup-guide/
 */

defined( 'ABSPATH' ) || exit;

/**
 * Get a vendor store name. Returns an empty string if none is set.
 *
 * Escape at output, for example esc_html( swd_get_vendor_store_name( $id ) ).
 *
 * @param int $vendor_id Vendor user ID.
 * @return string
 */
function swd_get_vendor_store_name( $vendor_id ) {
	$settings = get_user_meta( absint( $vendor_id ), 'dokan_profile_settings', true );

	if ( ! is_array( $settings ) || empty( $settings['store_name'] ) ) {
		return '';
	}

	return (string) $settings['store_name'];
}

/**
 * Update a vendor store name through the Dokan vendor object.
 *
 * set_store_name() plus save() writes both dokan_profile_settings and
 * dokan_store_name. Store search uses dokan_store_name.
 *
 * @param int    $vendor_id Vendor user ID.
 * @param string $new_name  New store name.
 * @return bool True if the save ran.
 */
function swd_set_vendor_store_name( $vendor_id, $new_name ) {
	$vendor_id = absint( $vendor_id );

	if ( ! function_exists( 'dokan' ) ) {
		return false;
	}

	if ( ! current_user_can( 'manage_options' ) && get_current_user_id() !== $vendor_id ) {
		return false;
	}

	$vendor = dokan()->vendor->get( $vendor_id );

	if ( ! $vendor || ! $vendor->get_id() ) {
		return false;
	}

	$vendor->set_store_name( sanitize_text_field( $new_name ) );
	$vendor->save();

	return true;
}
