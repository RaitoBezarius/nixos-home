{ config, pkgs, lib, ... }:
let
  tree-sitter-lean4 = pkgs.callPackage <nixpkgs/pkgs/development/tools/parsing/tree-sitter/grammar.nix> {} {
    language = "lean";
    version = "2021-08-13";
    source = pkgs.fetchFromGitHub {
      owner = "Julian";
      repo = "tree-sitter-lean";
      rev = "511a1f9430c809aaa2e73f94a958637f0b7eb50a";
      sha256 = "sha256-JG0QPtEi33MNZrIJoevrJ3W8xEs7sHdtWczZIM3vk64=";
    };
  };
  lean-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "lean-nvim";
    buildPhase = ":";
    src = pkgs.fetchFromGitHub {
      owner = "Julian";
      repo = "lean.nvim";
      rev = "11ea68c6741ad86344a0a9b2e7cf0451470c7d91";
      sha256 = "sha256-ONs9yfjuVLFfmc3gaFBSh33WYetV3675rIaOkBYE97E=";
    };
  };
in
{
  programs.neovim = {
    enable = true;
    withPython3 = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      lean-nvim

      # LSP
      nvim-lspconfig
      plenary-nvim

      # Treesitter
      (nvim-treesitter.withPlugins (ps: with ps; [
        tree-sitter-nix
        tree-sitter-python
        tree-sitter-lean4
      ]))
      nvim-treesitter-textobjects

      vim-scriptease
      vim-lastplace
      vim-nix
      vim-yaml
      coc-rust-analyzer
      rust-vim
      zig-vim
      ctrlp
      coc-snippets
      vim-pandoc
      vim-pandoc-syntax
      coc-nvim
      coc-pyright
      semshi
      oceanic-next
      editorconfig-vim
      vim-python-pep8-indent
    ];
    extraPackages = with pkgs; [
      (python3.withPackages (ps: with ps; [
        black
        flake8
        isort
      ]))
      rust-analyzer
    ];
    extraPython3Packages = (ps: with ps; [

    ]);
    extraConfig = ''
      " your custom vimrc
      set nocompatible
      set backspace=indent,eol,start
      set nospell
      set clipboard+=unnamedplus
      colorscheme OceanicNext

      " Use <C-l> for trigger snippet expand.
      imap <C-l> <Plug>(coc-snippets-expand)

      " Use <C-j> for select text for visual placeholder of snippet.
      vmap <C-j> <Plug>(coc-snippets-select)

      " Use <C-j> for jump to next placeholder, it's default of coc.nvim
      let g:coc_snippet_next = '<c-j>'

      " Use <C-k> for jump to previous placeholder, it's default of coc.nvim
      let g:coc_snippet_prev = '<c-k>'

      " Use <C-j> for both expand and jump (make expand higher priority.)
      imap <C-j> <Plug>(coc-snippets-expand-jump)

      " Use <leader>x for convert visual selected code to snippet
      xmap <leader>x  <Plug>(coc-convert-snippet)

      " For pandoc
      let g:pandoc#modules#disabled = ["spell"]

      lua<<EOF
        ${builtins.readFile /home/raito/dotfiles/nvim/lua/lean.lua}
      EOF
    '';
  };

  xdg.configFile."nvim/coc-settings.json".text = builtins.readFile /home/raito/dotfiles/coc-settings.json;
}
