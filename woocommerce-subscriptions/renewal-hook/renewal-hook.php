<?php
/**
 * Plugin Name: SWD Subscription Renewal Hook
 * Description: Logs a line when WooCommerce Subscriptions fires woocommerce_scheduled_subscription_payment. Read only.
 * Version: 1.0.0
 * Author: Rasel Hakkani
 * Author URI: https://swiftwebdev.com/
 * License: GPL-2.0-or-later
 * License URI: https://www.gnu.org/licenses/gpl-2.0.html
 *
 * Tutorial: https://swiftwebdev.com/blog/custom-subscription-workflow-woocommerce/
 */

defined( 'ABSPATH' ) || exit;

add_action( 'woocommerce_scheduled_subscription_payment', 'swd_log_subscription_renewal', 20, 1 );

/**
 * Write one WooCommerce log line when a renewal is due.
 *
 * Does not charge or change the subscription.
 *
 * @param int $subscription_id Subscription ID (not a renewal order ID).
 */
function swd_log_subscription_renewal( $subscription_id ) {
	// Without WooCommerce Subscriptions this function does not exist.
	if ( ! function_exists( 'wcs_get_subscription' ) ) {
		return;
	}

	$subscription = wcs_get_subscription( absint( $subscription_id ) );

	if ( ! $subscription ) {
		return;
	}

	wc_get_logger()->info(
		sprintf(
			'Renewal due for subscription #%d (status: %s)',
			$subscription->get_id(),
			$subscription->get_status()
		),
		array( 'source' => 'swd-renewals' )
	);
}
