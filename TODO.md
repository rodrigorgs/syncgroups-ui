# TODO

* Autocomplete people's names
* Implement login using LDAP
* Improve layout (logout link, navigation, aesthetics)
* Page to show a user and allow manager to add/remove the user to groups
  * Page to search user
* Use flash to inform user about login/logout
* Logging to syslog (using Lumberjack)
* Admin should see all groups
* Create tests for main web application attacks, e.g.:
  * Cross Site Request Forgery
  * Cross Site Scripting
  * Directory Traversal
  * Session Hijacking
  * IP Spoofing

# References

How to secure a Sinatra application?

* http://blog.fil.vasilak.is/blog/2014/02/08/securing-sinatra-micro-framework/
* http://stackoverflow.com/questions/11337630/preventing-session-fixation-in-ruby-sinatra
* see gem: https://github.com/rkh/rack-protection

Tools for assessing web app vulnerabilities:

* <http://www.arachni-scanner.com/>
* <https://www.owasp.org/index.php/Appendix_A:_Testing_Tools>