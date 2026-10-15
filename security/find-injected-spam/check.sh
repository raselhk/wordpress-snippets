#!/usr/bin/env bash
# Read-only checks for injected spam on a WordPress site.
# Nothing here deletes or changes a site file. Usage:
#   ./check.sh https://example.com /path/to/wordpress
# The second argument is optional. Without it only the HTTP checks run.
set -u

URL="${1:-}"
WP_ROOT="${2:-}"

if [ -z "$URL" ]; then
	echo "Usage: $0 <site-url> [wordpress-path]"
	exit 1
fi

TMP="$(mktemp -d)"
GOOGLEBOT="Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
BROWSER="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36"

echo "== 1. Home page as Googlebot vs a normal browser =="
curl -sL -A "$GOOGLEBOT" "$URL" -o "$TMP/bot.html"
curl -sL -A "$BROWSER" "$URL" -o "$TMP/user.html"
echo "Googlebot bytes: $(wc -c < "$TMP/bot.html")"
echo "Browser bytes:   $(wc -c < "$TMP/user.html")"
echo "A big size gap can mean cloaking. Compare by hand:"
echo "  diff $TMP/bot.html $TMP/user.html | head -50"

echo
echo "== 2. Spam words in the Googlebot copy =="
grep -oiE "casino|viagra|cialis|pharmacy|payday|slot gacor|porn" "$TMP/bot.html" | sort | uniq -c | sort -rn | head

echo
echo "== 3. Status and redirect headers as Googlebot =="
curl -sI -A "$GOOGLEBOT" "$URL" | head -15

echo
echo "== 4. Sitemap URLs (first 50 each) =="
curl -sL "$URL/sitemap_index.xml" | grep -o "<loc>[^<]*</loc>" | head -50
curl -sL "$URL/sitemap.xml" | grep -o "<loc>[^<]*</loc>" | head -50

if [ -n "$WP_ROOT" ] && [ -d "$WP_ROOT" ]; then
	echo
	echo "== 5. PHP files inside uploads (normally there are none) =="
	find "$WP_ROOT/wp-content/uploads" -name "*.php" -type f

	echo
	echo "== 6. PHP files changed in the last 7 days (not uploads or cache) =="
	find "$WP_ROOT" -type f -name "*.php" -mtime -7 -not -path "*/uploads/*" -not -path "*/cache/*"

	echo
	echo "== 7. Common malware code patterns in PHP files =="
	grep -rlE "eval\(base64_decode|gzinflate\(base64_decode|str_rot13\(|FilesMan" --include="*.php" "$WP_ROOT" 2>/dev/null

	echo
	echo "== 8. .htaccess files and rewrite lines worth a look =="
	find "$WP_ROOT" -name ".htaccess" -type f
	grep -rnE "RewriteCond.*(google|bot|referer)|RewriteRule.*http" --include=".htaccess" "$WP_ROOT" 2>/dev/null

	if command -v wp >/dev/null 2>&1; then
		echo
		echo "== 9. WP-CLI: administrators and newest content =="
		wp --path="$WP_ROOT" user list --role=administrator --fields=ID,user_login,user_email,user_registered
		wp --path="$WP_ROOT" post list --post_type=any --post_status=any --orderby=date --order=DESC --fields=ID,post_title,post_name,post_date,post_status --format=table | head -30
	fi
fi

echo
echo "Done. Review the output by hand. Site files were not changed."
echo "Temporary copies of the pages are in $TMP"
