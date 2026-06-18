{
  symlinkJoin,
  neovim-unwrapped,
  makeWrapper,
  runCommandLocal,
  vimPlugins,
  lib,
  src,
  # Lua
  lua-language-server,
  stylua,
  selene,
  # Nix
  nixd,
  nixfmt,
  statix,
  deadnix,
}:
let
  packageName = "neovim-shnzhn";

  runtimeDeps = [
    # Lua
    lua-language-server
    stylua
    selene
    # Nix
    nixd
    nixfmt
    statix
    deadnix
  ];

  startPlugins = [
    vimPlugins.telescope-nvim
    vimPlugins.telescope-fzf-native-nvim
    vimPlugins.nvim-treesitter-textobjects
    vimPlugins.plenary-nvim
    vimPlugins.nvim-treesitter.withAllGrammars
    vimPlugins.nvim-autopairs
    vimPlugins.nvim-ts-autotag
    vimPlugins.nvim-cmp
    vimPlugins.cmp-nvim-lsp
    vimPlugins.cmp-nvim-lsp-signature-help
    vimPlugins.cmp-buffer
    vimPlugins.cmp-path
    vimPlugins.cmp-nvim-lua
    vimPlugins.cmp_luasnip
    vimPlugins.cmp-cmdline
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
    vimPlugins.markdown-preview-nvim
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
    vimPlugins.conform-nvim
    vimPlugins.nvim-lint
    vimPlugins.opencode-nvim
  ];

  foldPlugins = builtins.foldl' (
    acc: next:
    acc
    ++ [
      next
    ]
    ++ (foldPlugins (next.dependencies or [ ]))
  ) [ ];

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
  packpath = runCommandLocal "packpath" { } ''
    mkdir -p $out/pack/${packageName}/{start,opt}

    ${lib.concatMapStringsSep "\n" (
      plugin: "ln -vsfT ${plugin} $out/pack/${packageName}/start/${lib.getName plugin}"
    ) startPluginsWithDeps}
  '';
in
symlinkJoin {
  name = "neovim-shnzhn";
  paths = [ neovim-unwrapped ];
  meta.mainProgram = "nvim";
  # Build-time-only dependency providing `wrapProgram`.
  nativeBuildInputs = [ makeWrapper ];

  # wrapProgram moves the real binary to .nvim-wrapped and drops in a
  # shell script that injects flags before any user-supplied args:
  postBuild = ''
    wrapProgram $out/bin/nvim \
      --add-flags '-u' \
      --add-flags '${src}/init.lua' \
      --add-flags '--cmd' \
      --add-flags "'set packpath^=${packpath} | set runtimepath^=${packpath},${src}'" \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} \
      --set-default NVIM_APPNAME nvim-shnzhn
  '';

  # Expose the packpath derivation on the final package without
  # affecting the build. Handy for inspection:
  #   nix build .#neovim-shnzhn.packpath && ls -l result/pack/*/start
  passthru = {
    inherit packpath;
  };
}
