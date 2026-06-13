# neovim.nix
#
# A callPackage-style function that produces a fully self-contained Neovim:
#   stock nvim binary + store-pinned init.lua + plugin packpath, all hermetic.
#
# It deliberately does NOT use wrapNeovim/neovimUtils from nixpkgs — it
# re-implements the minimal subset (packpath construction + wrapper) so the
# whole mechanism stays visible and hackable.
{
  # Builder that merges store paths into one output via symlinks.
  symlinkJoin,
  # Neovim without any nixpkgs wrapper magic applied.
  neovim-unwrapped,
  # Provides the `wrapProgram` shell function used in postBuild.
  makeWrapper,
  # Like runCommand, but forces a local build (no remote builders /
  # substitution) — appropriate for trivial symlink shuffling.
  runCommandLocal,
  # The nixpkgs vim/neovim plugin set.
  vimPlugins,
  lib,
}: let
  # Arbitrary label for the Neovim package directory. Neovim's native
  # package system (:h packages) expects the layout
  #   <packpath>/pack/<name>/{start,opt}/<plugin>
  # where <name> is purely cosmetic.
  packageName = "neovim-shnzhn";

  # The plugins you actually ask for. Anything under pack/*/start/ is
  # loaded automatically at startup (vs opt/, which needs :packadd).
  #
  # Not all plugins that are here require are matched with a .lua
  # file on the "plugins" folder. The only ones that have a matching
  # .lua file are the one that must have a "setup" call or some options set
  startPlugins = [
    vimPlugins.telescope-nvim
    vimPlugins.nvim-treesitter-textobjects
    vimPlugins.plenary-nvim
    vimPlugins.nvim-treesitter.withAllGrammars
    vimPlugins.nvim-autopairs
    vimPlugins.nvim-ts-autotag
    vimPlugins.nvim-cmp
    vimPlugins.nvim-dap
    vimPlugins.nvim-dap-go
    vimPlugins.nvim-dap-python
    vimPlugins.nvim-dap-disasm
    vimPlugins.nvim-dap-ui
    vimPlugins.diffview-nvim
    vimPlugins.dropbar-nvim
    vimPlugins.git-conflict-nvim
    vimPlugins.gitsigns-nvim
    vimPlugins.hardtime-nvim
    vimPlugins.image-nvim
    vimPlugins.img-clip-nvim
    vimPlugins.indent-blankline-nvim
    vimPlugins.nvim-lspconfig
    vimPlugins.lualine-nvim
    vimPlugins.luasnip
    #missing mapper
    vimPlugins.markdown-preview-nvim
    #mason maybe not needed
    vimPlugins.nabla-nvim
    vimPlugins.neogen
    vimPlugins.no-neck-pain-nvim
    vimPlugins.nvim-highlight-colors
    vimPlugins.nvterm
    vimPlugins.persistence-nvim
    vimPlugins.nvim-surround
    vimPlugins.telescope-file-browser-nvim
    vimPlugins.trouble-nvim
    vimPlugins.which-key-nvim
  ];

  # Transitive-dependency flattener.
  #
  # `builtins.foldl' f init` is given only two of its three arguments, so
  # foldPlugins is itself a function: list-of-plugins -> flat-list.
  #
  # For each plugin `next` it appends:
  #   * the plugin itself, and
  #   * the recursive flattening of `next.dependencies`
  #     (`or []` covers plugins that don't declare any).
  #
  # Caveats (fine in practice): no cycle detection (plugin deps form a
  # DAG in nixpkgs), and shared deps appear multiple times — handled by
  # lib.unique below rather than a visited-set during the fold.
  foldPlugins = builtins.foldl' (
    acc: next:
      acc
      ++ [
        next
      ]
      ++ (foldPlugins (next.dependencies or []))
  ) [];

  # The deduplicated transitive closure of startPlugins.
  startPluginsWithDeps = lib.unique (foldPlugins startPlugins);

  # A derivation whose output is a valid Neovim packpath:
  #
  #   $out/pack/neovim-shnzhn/start/telescope.nvim -> /nix/store/...-telescope...
  #   $out/pack/neovim-shnzhn/start/plenary.nvim   -> /nix/store/...-plenary...
  #   $out/pack/neovim-shnzhn/opt/                    (empty)
  #
  # concatMapStringsSep generates one `ln` shell line per plugin:
  #   * ${plugin} coerces the derivation to its store path
  #   * lib.getName strips the version suffix so the symlink gets a clean
  #     name (telescope.nvim, not telescope.nvim-2024-xx-xx)
  #   * ln flags: -v verbose, -s symbolic, -f force,
  #     -T treat dest as the link itself (never descend into a dir)
  packpath = runCommandLocal "packpath" {} ''
    mkdir -p $out/pack/${packageName}/{start,opt}

    ${
      lib.concatMapStringsSep
      "\n"
      (plugin: "ln -vsfT ${plugin} $out/pack/${packageName}/start/${lib.getName plugin}")
      startPluginsWithDeps
    }
  '';
in
  # symlinkJoin over a single path is effectively a cheap "copy" of
  # neovim-unwrapped that we're allowed to mutate in postBuild.
  symlinkJoin {
    name = "neovim-shnzhn";
    paths = [neovim-unwrapped];
    meta.mainProgram = "nvim";
    # Build-time-only dependency providing `wrapProgram`.
    nativeBuildInputs = [makeWrapper];

    # wrapProgram moves the real binary to .nvim-wrapped and drops in a
    # shell script that injects flags before any user-supplied args:
    #
    #   -u <store-path-to-init.lua>
    #       Use OUR init file instead of ~/.config/nvim/init.lua.
    #       ${./init.lua} copies the file sitting next to this .nix file
    #       into the store and bakes the resulting path in — this is what
    #       makes the config reproducible.
    #
    #   --cmd 'set packpath^=... | set runtimepath^=...'
    #       --cmd runs an Ex command BEFORE any config is sourced.
    #       ^= prepends, so our generated packpath wins in both plugin
    #       discovery (packpath) and runtime file lookup (runtimepath).
    #       The nested "'...'" quoting keeps the |-containing command a
    #       single shell word inside the wrapper script.
    #
    #   NVIM_APPNAME=nvim-shnzhn (default only — user can still override)
    #       Isolates state/cache/data dirs (~/.local/share/nvim-shnzhn,
    #       ~/.local/state/nvim-shnzhn, ...) from any stock nvim install.
    postBuild = ''
      wrapProgram $out/bin/nvim \
        --add-flags '-u' \
        --add-flags './init.lua' \
        --add-flags '--cmd' \
        --add-flags "'set packpath^=${packpath} | set runtimepath^=${packpath}'" \
        --set-default NVIM_APPNAME nvim-shnzhn
    '';

    # Expose the packpath derivation on the final package without
    # affecting the build. Handy for inspection:
    #   nix build .#neovim-shnzhn.packpath && ls -l result/pack/*/start
    passthru = {
      inherit packpath;
    };
  }
