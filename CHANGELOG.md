# 1.0.2 (August 26th, 2019)

Fixes:

* Dbee::Base subclasses can now support cycles to N-depth, where N is limited by the Query.  The recursion will go as far as the Query specifies it has to go.

Additions:

* Equals filter is now the default type when type is omitted.
* model can now be a string so it can be lazy evaluated at run-time instead of at script evaluation time.

# 1.0.1 (August 26th, 2019)

Fixes:

* Dbee::Base subclasses can now declare self-referential associations.  Note that it will stop the hierarchy once the cycle is detected.

Additions:

* Static constraint is now the default type when type is omitted.

# 1.0.0 (August 22nd, 2019)

Initial release.

# 1.0.0-alpha (August 18th, 2019)

Added initial implementation.

# 0.0.1 (August 18th, 2019)

Created Repo Shell
