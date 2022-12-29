{ config, pkgs, lib, ... }:
let
  tree-sitter-lean4 = pkgs.callPackage <nixpkgs/pkgs/development/tools/parsing/tree-sitter/grammar.nix> {} {
    language = "lean4";
    version = "2022-08-23";
    source = pkgs.fetchFromGitHub {
      owner = "Julian";
      repo = "tree-sitter-lean";
      rev = "50945b4f7bde98d70ffca850c4e136ce053934df";
      sha256 = "sha256-yrxjynqNpWwF50fAnbf6SNcoLqzZC5cdZCWAZg2zNfs=";
    };
  };
  lspPlugins = with pkgs.vimPlugins; [
    nvim-lspconfig
    fidget-nvim
    nlsp-settings-nvim
  ];
  autocompletePlugins = with pkgs.vimPlugins; [
    nvim-cmp
    cmp-nvim-lsp
    luasnip
    cmp_luasnip
  ];
  treesitterPlugins = with pkgs.vimPlugins; [
    (nvim-treesitter.withPlugins (ps: with ps; [
        tree-sitter-nix
        tree-sitter-python
        tree-sitter-svelte
        tree-sitter-lean4
      ]))
    nvim-treesitter-textobjects
  ];
  gitPlugins = with pkgs.vimPlugins; [
    vim-fugitive
    vim-rhubarb
    gitsigns-nvim
  ];
  generalPlugins = with pkgs.vimPlugins; gitPlugins ++ [
    plenary-nvim

    # Status line with Lua
    lualine-nvim
    # Indentation guide on blank line
    indent-blankline-nvim
    # Auto detect tabstop & shiftwidth
    vim-sleuth

    # Fuzzy finder
    telescope-nvim

    vim-polyglot
    vim-scriptease
    vim-lastplace

    vim-nix
    rust-vim
    zig-vim
    vim-pandoc
    vim-pandoc-syntax
    editorconfig-vim
    vim-cue
    vim-docbk
    vim-docbk-snippets

    ctrlp
  ];
  cocPlugins = with pkgs.vimPlugins; [
    coc-prettier
    coc-json
    coc-rust-analyzer
    coc-snippets
    coc-nvim
    coc-pyright
    coc-tsserver
  ];
  pythonPlugins = with pkgs.vimPlugins; [
    semshi
    vim-python-pep8-indent
  ];
  themes = with pkgs.vimPlugins; [
    oceanic-next
    tokyonight-nvim
  ];
in
{
  programs.neovim = {
    enable = true;
    withPython3 = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = generalPlugins
    ++ lspPlugins
    ++ autocompletePlugins
    ++ treesitterPlugins
    # ++ cocPlugins
    ++ pythonPlugins
    ++ themes;
    extraPackages = with pkgs; [
      gcc
      zig
      rust-analyzer
      nodePackages.svelte-language-server
      nodePackages.prettier
      xclip # For Xorg
      wl-clipboard # For Wayland
      nil
    ];
    extraPython3Packages = (ps: with ps; [
      black
      flake8
      isort
    ]);
    extraConfig = ''
      lua<<EOF
        ${builtins.readFile ./init.lua}
      EOF
    '';
  };

  xdg.configFile."nvim/coc-settings.json".text = builtins.readFile ../dotfiles/coc-settings.json;
}
