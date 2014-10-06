# Function for generating proper configuration SQL statements.
#
# @author    Oktay Acikalin <oktay.acikalin@gmail.com>
# @copyright Oktay Acikalin
# @license   MIT (LICENSE.txt)

import "lib/magento.gen_update_config_sql" as "update_config"


function magento.gen_config_sql_statements () {
    # Temporarily change rules and gather all statements.
    local IFS=
    statements=(
        ##
        # General stuff
        ##

        # Replace all email addresses
        "UPDATE core_config_data SET value=CONCAT(SUBSTRING_INDEX(value,'@',1),'@${BASE_DOMAIN}') WHERE value REGEXP '[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}'"

        # Replace URLs
        $(update_config "web/unsecure/base_url" "http://${BASE_DOMAIN}/" default)
        $(update_config "web/unsecure/base_link_url" "{{unsecure_base_url}}" default)
        $(update_config "web/unsecure/base_js_url" "{{unsecure_base_url}}js/" default)
        $(update_config "web/unsecure/base_skin_url" "{{unsecure_base_url}}skin/" default)
        $(update_config "web/unsecure/base_media_url" "{{unsecure_base_url}}media/" default)
        $(update_config "web/secure/base_url" "https://${BASE_DOMAIN}/" default)
        $(update_config "web/secure/base_link_url" "{{secure_base_url}}" default)
        $(update_config "web/secure/base_js_url" "{{secure_base_url}}js/" default)
        $(update_config "web/secure/base_skin_url" "{{secure_base_url}}skin/" default)
        $(update_config "web/secure/base_media_url" "{{secure_base_url}}media/" default)

        # Password lifetime
        $(update_config "admin/security/password_lifetime" "365")
        $(update_config "admin/security/password_is_forced" 0)

        # Logging
        $(update_config "dev/log/active" "1")
        $(update_config "dev/log/file" "system.log")
        $(update_config "dev/log/exception_file" "exception.log")

        # Reset environment
        "delete from core_config_data where path = 'environment';"
        "insert into core_config_data (scope, scope_id, path, value) values ('default', 0, 'environment', concat('unknown | unknown | ', now()));"
        $(update_config "dev/restrict/allow_ips" "")

        # Reset indexer status
        "UPDATE index_process SET status='pending';"

        # Reset admin user passwords
        "UPDATE admin_user SET password=md5('${MP_ANON_ADMIN_PASSWORD}');"

        ##
        #  Stuff for multiple projects
        ##

        # Don't try to send emails via smtp
        $(update_config "system/smtp/disable" 1)
        $(update_config "system/smtp/host" "localhost")
        $(update_config "system/smtp/port" 25)
        $(update_config "advancedsmtp/settings/enabled" 0)
    )
}
