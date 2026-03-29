{
  description = "myLibs";

  inputs.nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";

  outputs =
    { nixpkgs-lib, ... }:
    let
      inherit (nixpkgs-lib) lib;
    in
    {
      import-tree = path: {
        imports = lib.fileset.toList (
          lib.fileset.fileFilter (file: file.hasExt "nix" && !(lib.hasPrefix "_" file.name)) path
        );
      };
    };
}
