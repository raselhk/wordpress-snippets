# Find injected spam (read-only)

`check.sh` runs read-only checks for the signs of an injected-spam hack. It never deletes or edits a site file. It writes two temporary page copies to a temp folder.

Tutorial: https://swiftwebdev.com/blog/hacked-wordpress-site-recovery-process/

## What it checks

1. The home page fetched as Googlebot and as a normal browser, with a size comparison (cloaking).
2. Spam words in the Googlebot copy.
3. Response headers and redirects as Googlebot.
4. URLs listed in the sitemap.
5. With a WordPress path: PHP files inside `uploads`, PHP files changed in the last 7 days, common malware patterns, `.htaccess` rewrite rules, administrators and newest content through WP-CLI.

## Run

```bash
bash check.sh https://example.com
bash check.sh https://example.com /var/www/html
```

## Status

Checked with `bash -n` for syntax only. It has not been run against a hacked site. Read the output by hand: a hit is a lead, not proof. Back up the site and work on staging before you remove anything.

The tutorial also covers the Google side: the Page indexing report, Security issues, removing URLs and requesting a review.
