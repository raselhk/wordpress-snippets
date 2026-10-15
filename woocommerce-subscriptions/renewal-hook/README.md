# Subscription renewal hook

Logs a line to WooCommerce > Status > Logs (source `swd-renewals`) when `woocommerce_scheduled_subscription_payment` fires. It only reads data.

Tutorial: https://swiftwebdev.com/blog/custom-subscription-workflow-woocommerce/

## Tested on

WordPress 7.1.3, WooCommerce 11.2.1 (bundled Action Scheduler 4.1.0), PHP 8.2.12, 16 October 2026.

WooCommerce Subscriptions is paid and was NOT installed. A small stand-in for `wcs_get_subscription()` supplied the subscription object. That tested the hook wiring, the argument and the logger. It did not test Subscriptions logic, or whether the renewal order exists at priority 20.

## Why the guard

The first run had no `function_exists()` check. Action Scheduler marked the action failed: `Call to undefined function wcs_get_subscription()`. With the guard the callback exits quietly.

## Queue and run it (staging only)

A real renewal can charge a real payment method. Use staging with a test gateway.

```bash
# Queue one action (without Subscriptions the guard makes it a no-op)
wp eval 'echo as_schedule_single_action( time(), "woocommerce_scheduled_subscription_payment", array( "subscription_id" => 123 ) );'

# See what is pending
wp action-scheduler action list --hook=woocommerce_scheduled_subscription_payment --status=pending

# Run this hook only
wp action-scheduler run --hooks=woocommerce_scheduled_subscription_payment --batch-size=1 --batches=1

# Or run one chosen action by ID
wp action-scheduler action run <id>
```

`wp action-scheduler list` is not a command. Use `wp action-scheduler action list`.

`wp action-scheduler run` printed "Success: 0 scheduled tasks completed." even when the action completed. Trust the action status and the Action Scheduler log.
