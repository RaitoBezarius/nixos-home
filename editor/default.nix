{ config, pkgs, lib, ... }:
let
  tree-sitter-lean4 = pkgs.callPackage <nixpkgs/pkgs/development/tools/parsing/tree-sitter/grammar.nix> {} {
    language = "lean4";
    version = "2022-08-23";
    src = pkgs.fetchFromGitHub {
      owner = "Julian";
      repo = "tree-sitter-lean";
      rev = "50945b4f7bde98d70ffca850c4e136ce053934df";
      sha256 = "sha256-yrxjynqNpWwF50fAnbf6SNcoLqzZC5cdZCWAZg2zNfs=";
    };
  };
  noir-lang-vim = pkgs.vimUtils.buildVimPlugin {
    name = "noir-lang-syntax";
    src = pkgs.fetchFromGitHub {
      owner = "Louis-Amas";
      repo = "noir-vim-support";
      rev = "1ca1ecb639dd0aa7385d50afa3969572fa7f2a7d";
      sha256 = "sha256-Ao7jCvvKp92xcUGdxRfAOwP7K6In8HuOZbjg29oi+Tk=";
    };
  };
  lspPlugins = with pkgs.vimPlugins; [
    nvim-lspconfig
    fidget-nvim
    nlsp-settings-nvim
    lean-nvim
    Coqtail
    go-nvim
    rustaceanvim
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
        tree-sitter-c
        tree-sitter-lua
        tree-sitter-go
        # tree-sitter-lean4
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
    noir-lang-vim
    vim-ledger
    vim-pandoc
    vim-pandoc-syntax
    editorconfig-vim
    vim-cue
    vim-docbk
    vim-docbk-snippets
    typst-vim

    # REPL for Lua and VimScript
    neorepl-nvim

    vimwiki
    taskwiki
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
    # semshi
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
      pyright
      nodePackages.svelte-language-server
      nodePackages.typescript-language-server
      nodePackages.prettier
      ocamlPackages.ocaml-lsp
      # fstar
      tinymist
      typstfmt
      xclip # For Xorg
      wl-clipboard # For Wayland
      nil
      elan # for Lean
      hledger # For plaintext accounting
      gopls # For Go
    ];
    extraPython3Packages = (ps: with ps; [
      black
      flake8
      isort
      six
      tasklib
    ]);
    extraConfig = ''
      lua<<EOF
        ${builtins.readFile ./init.lua}
      EOF
    '';
  };

  xdg.configFile."nvim/coc-settings.json".text = builtins.readFile ../dotfiles/coc-settings.json;
}
