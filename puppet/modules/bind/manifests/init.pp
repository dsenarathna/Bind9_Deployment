# Class: bind
#
# This class installs Bind
#
# Parameters:
#
# Actions:
#   - Install Bind
#   - Manage Bind service
#
# Requires:
#
# Sample Usage:
#
class bind {
  include bind::revzone
  include bind::server
  include bind::zone
}
