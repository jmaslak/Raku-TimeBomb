NAME
====

TimeBomb - Trait to provide forced deprecation of Raku Code

SYNOPSIS
========

    use TimeBomb

    sub foo() is compile-until<2032-01-19> { … }
    sub bar() is run-until<2032-01-19> { … }

DESCRIPTION
===========

This module provides two traits, `compile-until` and `run-until`, which do what they say and keep a routine from compiling or running after the date passed into the module.

This is intended to be used for marking code that will be retired on a given date, to prevent use of that code after that date. It is not intended to be used to guarantee future employment!

TRAITS
======

compile-until
-------------

    sub foo() is compile-until<2032-01-19> { … }

The <compile-until> trait blocks compilation of a block after a given date. This can be used to ensure that code is replaced before a gvien date. It only impacts compile-time processing of the code, so code that is, for instance, pre-compiled will continue to run. This check also will not slow down execution, as nothing is left in the routine's code path once compiled.

run-until
---------

    sub foo() is run-until<2032-01-19> { … }

The <run-until> trait is used to block execution of a routine after a given date. This can be used to ensure that code is replaced before a given date. It does not impact compilation of the code, only runtime. It does have a minor performance impact as this check is executed each time the code is executed.

EXCEPTION
=========

The exception thrown by `compile-until` and `run-until` is of the type `X::TimeBomb::Expired`. This contains three attributes:

Routine:D routine
-----------------

The routine that the trait is applied onto is stored in this attribute.

Date:D until
------------

The date at which the `compile-until` or `run-until` trait begins to throw exceptions is stored here.

Str:D type
----------

This contains the type of instruction, which is set by these traits as either "compile" (from `compile-until`) or "execute" (from `run-until`).

AUTHOR
======

Joelle Maslak <jmaslak@antelope.net>

COPYRIGHT AND LICENSE
=====================

Copyright © 2023 Joelle Maslak

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

