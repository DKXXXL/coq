Installing From Sources
=======================

To install and use Coq, we recommend relying on [the Coq
platform](https://github.com/coq/platform/) or on a package manager
(e.g. opam or Nix).

See https://coq.inria.fr/download and
https://github.com/coq/coq/wiki#coq-installation to learn more.

If you need to build Coq from sources manually (e.g. to
contribute to Coq or to write a Coq package), the remainder of this
file explains how to do so.

Build Requirements
------------------

To compile Coq yourself, you need:

- [OCaml](https://ocaml.org/) (version >= 4.09.0)
  (This version of Coq has been tested up to OCaml 4.13.0)

- The [Dune OCaml build system](https://github.com/ocaml/dune/) >= 2.5.1

- The [ZArith library](https://github.com/ocaml/Zarith) >= 1.10

- The [findlib](http://projects.camlcity.org/projects/findlib.html) library (version >= 1.8.0)

- a C compiler

- an IEEE-754 compliant architecture with rounding to nearest
  ties to even as default rounding mode (most architectures
  should work nowadays)

- for CoqIDE, the
  [lablgtk3-sourceview3](https://github.com/garrigue/lablgtk) library
  (version >= 3.1.2), and the corresponding GTK 3.x libraries, as
  of today (gtk+3 >= 3.18 and gtksourceview3 >= 3.18)

- [optional] GNU Make (version >= 3.81)

Primitive floating-point numbers require IEEE-754 compliance
(`Require Import Floats`). Common sources of incompatibility
are checked at configure time, preventing compilation. In the
unlikely event an incompatibility remains undetected, using `Floats`
would enable proving `False` on this architecture.

Note that OCaml dependencies (`zarith` and `lablgtk3-sourceview3` at
this moment) must be properly registered with `findlib/ocamlfind`
since Coq's build system uses `findlib` to locate them.

Debian / Ubuntu users can get the necessary system packages for
CoqIDE with:

    $ sudo apt-get install libgtksourceview-3.0-dev

Opam (https://opam.ocaml.org/) is recommended to install OCaml and
the corresponding packages.

    $ opam switch create coq --packages="ocaml-variants.4.12.0+options,ocaml-option-flambda"
    $ eval $(opam env)
    $ opam install dune ocamlfind zarith lablgtk3-sourceview3

should get you a reasonable OCaml environment to compile Coq. See the
OPAM documentation for more help.

Nix users can also get all the required dependencies by running:

    $ nix-shell

Advanced users may want to experiment with the OCaml Flambda
compiler as way to improve the performance of Coq. In order to
profit from Flambda, a special build of the OCaml compiler that has
the Flambda optimizer enabled must be installed. For OPAM users,
this amounts to installing a compiler switch ending in `+flambda`,
such as `4.12.1+flambda`. For other users, YMMV. Once `ocamlopt -config`
reports that Flambda is available, some further optimization options
can be used; see the entry about `flambda options` in the build guide
for more details.

Choice of Build and Installation Procedure
------------------------------------------

There are two partially overlapping infrastructures available to build
Coq. They are available through `Makefile.make` (legacy / hybrid
build) and `Makefile.dune` (full Dune build).

You can use the `COQ_USE_DUNE` environment variable to change the one
to use by default. This is useful for Coq development, where we
recommend to rely mainly on `Makefile.dune`. Note that mixing the two
systems is not perfectly supported and may lead to confusing behavior.

In both cases, the OCaml parts are built using
[Dune](https://github.com/ocaml/dune). The main difference between the
two systems is how the `.vo` files are built.

In the case of `Makefile.make`, `.vo` files are built with a legacy
Makefile, similar to what `coq_makefile` would do. In the case of
`Makefile.dune`, `.vo` files are built with Dune, thanks to its
recently-added, and still experimental, Coq mode.

See the documentation for the two infrastructures:

- [Legacy build](dev/doc/INSTALL.make.md)
- [Full Dune build](dev/doc/build-system.dune.md)

See also [`dev/doc/README.md`](dev/doc/README.md).

Run-time dependencies of native compilation
-------------------------------------------

The OCaml compiler and findlib are build-time dependencies, but also
run-time dependencies if you wish to use the native compiler.

OCaml toolchain advisory
------------------------

When loading plugins or `vo` files, you should make sure that these
were compiled with the same OCaml setup (version, flags,
dependencies...) as Coq.  Distribution of pre-compiled plugins and
`.vo` files is only possible if users are guaranteed to have the same
Coq version compiled with the same OCaml toolchain.  An OCaml setup
mismatch is the most probable cause for an `Error while loading ...:
implementation mismatch on ...`.

coq_environment.txt
-------------------
Coq binaries which honor environment variables, such as `COQLIB`, can
be seeded values for these variables by placing a text file named
`coq_environment.txt` next to them. The file can contain assignments
like `COQLIB="some path"`, that is a variable name followed by `=` and
a string that follows OCaml's escaping conventions. This feature can be
used by installers of binary package to make Coq aware of its installation
path.
