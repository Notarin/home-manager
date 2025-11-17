# nix repl alias
#
# This is a script which wraps `nix repl` to provide `pkgs`, and `lib` for QOL when no other args are provided.
# If the user is *just* running `nix repl` with no args, there is a good chance they want a quick and easy repl with the basics ready.
def --wrapped main [...args: string]: nothing -> nothing {
    let arg_count: int = ($args | length);
    if ($arg_count == 0) {
        let qol_values: string = "rec {pkgs = import <nixpkgs> {};lib=pkgs.lib;}";
        nix repl --expr $qol_values;
    } else {
        # Running the nix repl with the user provided args.
        nix repl ...$args;
    };
}