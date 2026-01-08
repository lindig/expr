
# 0.7.0

* Better documentation of the eval.mli interface.

* Previously only float values could be bound to names in an
  environemnt. Now a name can bind any of float, boolean, or string
  values. This is a breaking change.

# 0.6.0

* 00311cd Now strings can be parsed and compared as well

* 2ab92b9 The lib/ part was not properly declared as public

* e623aa4 Fix expr != [expr, expr] evaluation. Evaluation of this
  boolean expression was wrong.

* a6f23a9 Explain how to use with Cmdliner


# 0.5.1

* Initial Opam release
