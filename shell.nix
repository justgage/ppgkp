# This file just makes it easy to always use the same version of
# elixir & erlang. I used to use asdf, but this has caused me
# less problems, although it is a bit harder to write this config file

{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  inherit (lib) optional optionals;

  # 👇 This if the version of erlang & elixir I'm using
  elixir = beam.packages.erlangR21.elixir_1_9;
  nodejs = nodejs-10_x;
in

mkShell {
  buildInputs = [ elixir nodejs git ]
    ++ optional stdenv.isLinux inotify-tools # For file_system on Linux.
    ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      # For file_system on macOS.
      CoreFoundation
      CoreServices
    ]);

    # Put the PostgreSQL databases in the project diretory.
    shellHook = ''
      alias phx="source .env; iex -S mix phx.server"
      source .env
    '';
}
