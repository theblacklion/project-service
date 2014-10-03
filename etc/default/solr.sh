var.default SOLR_INIT_SCRIPT "${SERVICE_ROOT_DIR}/scripts/jetty-no-daemon"
var.default SOLR_HOME "${BASE_DIR}/solr"
var.default SOLR_HOST "${BASE_DOMAIN}"
var.default SOLR_PORT 9002
var.default SOLR_PID "${PID_DIR}/solr"
var.default SOLR_LOGS "${LOG_DIR}/solr"
var.default SOLR_DOWNLOAD_URL "http://archive.apache.org/dist/lucene/solr/3.6.2/apache-solr-3.6.2.tgz"
# var.default SOLR_DOWNLOAD_URL "http://archive.apache.org/dist/lucene/solr/4.9.1/solr-4.9.1.tgz"