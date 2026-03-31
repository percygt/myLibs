{
  description = "myLibs";
  inputs.nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
  outputs =
    { nixpkgs-lib, ... }:
    let
      inherit (nixpkgs-lib) lib;
    in
    rec {
      collectNixFiles =
        path:
        let
          nixFiles = lib.fileset.toList (
            lib.fileset.fileFilter (file: file.hasExt "nix" && !(lib.hasPrefix "_" file.name)) path
          );
          pathStr = toString path;
          hasUnderscoreDir =
            file:
            lib.any (lib.hasPrefix "_") (
              lib.splitString "/" (lib.removePrefix (pathStr + "/") (toString file))
            );
        in
        builtins.filter (file: !(hasUnderscoreDir file)) nixFiles;

      importTree = path: {
        imports = collectNixFiles path;
      };
    };
}
