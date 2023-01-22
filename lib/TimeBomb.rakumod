use v6.c;

#
# Copyright © 2023 Joelle Maslak
# All Rights Reserved - See License
#

class X::TimeBomb::Expired is Exception {
    has Routine:D $.routine is required;
    has Date:D    $.until   is required;
    has Str:D     $.type    is required;

    method message() {
        "Routine {$!routine.name} will not {$!type} after {$!until}";
    }
}

module TimeBomb {
    multi sub trait_mod:<is>(Routine $r, :$compile-until) is export {
        my $expire = Date.new($compile-until);
        if $expire ≤ Date.today {
            X::TimeBomb::Expired.new(:routine($r), :until($expire), :type<compile>).throw;
        }
    }

    multi sub trait_mod:<is>(Routine $r, :$run-until) is export {
        $r.wrap: sub (|args) {
            my $expire = Date.new($run-until);
            if $expire ≤ Date.today {
                X::TimeBomb::Expired.new(:routine($r), :until($expire), :type<execute>).throw;
            }
            my $ret := callsame;
            return $ret;
        }
    }
}

=begin pod

=head1 NAME

TimeBomb - Trait to provide forced deprecation of Raku Code

=head1 SYNOPSIS

  use TimeBomb

  sub foo() is compile-until<2032-01-19> { … }
  sub bar() is run-until<2032-01-19> { … }


=head1 DESCRIPTION

This module provides two traits, C<compile-until> and C<run-until>, which
do what they say and keep a routine from compiling or running after the
date passed into the module.

This is intended to be used for marking code that will be retired on a
given date, to prevent use of that code after that date.  It is not intended
to be used to guarantee future employment!

=head1 TRAITS

=head2 compile-until

  sub foo() is compile-until<2032-01-19> { … }

The <compile-until> trait blocks compilation of a block after a given
date.  This can be used to ensure that code is replaced before a gvien
date.  It only impacts compile-time processing of the code, so code that
is, for instance, pre-compiled will continue to run.  This check also
will not slow down execution, as nothing is left in the routine's code
path once compiled.

=head2 run-until

  sub foo() is run-until<2032-01-19> { … }

The <run-until> trait is used to block execution of a routine after a
given date.  This can be used to ensure that code is replaced before a
given date.  It does not impact compilation of the code, only runtime.
It does have a minor performance impact as this check is executed each
time the code is executed.

=head1 EXCEPTION

The exception thrown by C<compile-until> and C<run-until> is of the
type C<X::TimeBomb::Expired>.  This contains three attributes:

=head2 Routine:D routine

The routine that the trait is applied onto is stored in this attribute.

=head2 Date:D until

The date at which the C<compile-until> or C<run-until> trait begins to
throw exceptions is stored here.

=head2 Str:D type

This contains the type of instruction, which is set by these traits as
either "compile" (from C<compile-until>) or "execute" (from C<run-until>).

=head1 AUTHOR

Joelle Maslak <jmaslak@antelope.net>

=head1 COPYRIGHT AND LICENSE

Copyright © 2023 Joelle Maslak

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

