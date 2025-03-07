#!/usr/bin/env bash

set -e

# fiat-crypto job sets up the sources
if [ "$DOWNLOAD_ONLY" ]; then exit 0; fi

ci_dir="$(dirname "$0")"
. "${ci_dir}/ci-common.sh"

# we explicitly pass OCAMLFIND so that we pick up the opam
# (non-flambda one) rather than the one used to build coq
make_args=(EXTERNAL_REWRITER=1 EXTERNAL_COQPRIME=1 OCAMLFIND=ocamlfind)

( cd "${CI_BUILD_DIR}/fiat_crypto"
  make "${make_args[@]}" standalone-ocaml lite-generated-files
)
