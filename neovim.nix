{ config, pkgs, lib, ... }:
let
  /*tree-sitter-lean4 = pkgs.callPackage <nixpkgs/pkgs/development/tools/parsing/tree-sitter/grammar.nix> {} {
    language = "lean";
    version = "2021-08-13";
    source = pkgs.fetchFromGitHub {
      owner = "Julian";
      repo = "tree-sitter-lean";
      rev = "511a1f9430c809aaa2e73f94a958637f0b7eb50a";
      sha256 = "sha256-JG0QPtEi33MNZrIJoevrJ3W8xEs7sHdtWczZIM3vk64=";
    };
  };*/
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
        tree-sitter-svelte
        # tree-sitter-lean4
      ]))
      #nvim-treesitter-textobjects

      coc-prettier
      coc-json
      vim-polyglot

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
      coc-tsserver
      semshi
      oceanic-next
      editorconfig-vim
      vim-python-pep8-indent
      vim-cue

      vim-docbk
      vim-docbk-snippets
    ];
    extraPackages = with pkgs; [
      rust-analyzer
      nodePackages.svelte-language-server
      nodePackages.prettier
      xclip # For Xorg
      wl-clipboard # For Wayland
    ];
    extraPython3Packages = (ps: with ps; [
      black
      flake8
      isort
    ]);
    extraConfig = ''
      " Classical options
      set nocompatible
      set backspace=indent,eol,start
      set nospell
      set hidden
      set clipboard+=unnamedplus
      set expandtab
      colorscheme OceanicNext

      " Some servers have issues with backup files, see #649.
      set nobackup
      set nowritebackup

      " Give more space for displaying messages.
      set cmdheight=2

      " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
      " delays and poor user experience.
      set updatetime=300

      " Don't pass messages to |ins-completion-menu|.
      set shortmess+=c

      " Always show the signcolumn, otherwise it would shift the text each time
      " diagnostics appear/become resolved.
      if has("nvim-0.5.0") || has("patch-8.1.1564")
        " Recently vim can merge signcolumn and number column into one
        set signcolumn=number
      else
        set signcolumn=yes
      endif

      " <c-space> autocompletes
      inoremap <silent><expr> <c-space> coc#refresh()

      let mapleader = ","
      " toggle line numbers
      nnoremap <silent> <leader>l :set number! number?<CR>
      " remove highlighting
      nmap <leader>n :nohlsearch<CR>

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

      " GoTo code navigation.
      nmap <silent> gd <Plug>(coc-definition)
      nmap <silent> gy <Plug>(coc-type-definition)
      nmap <silent> gi <Plug>(coc-implementation)
      nmap <silent> gr <Plug>(coc-references)

      " Use K to show documentation in preview window.
      nnoremap <silent> K :call <SID>show_documentation()<CR>

      function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
          execute 'h '.expand('<cword>')
        elseif (coc#rpc#ready())
          call CocActionAsync('doHover')
        else
          execute '!' . &keywordprg . " " . expand('<cword>')
        endif
      endfunction

      " Highlight the symbol and its references when holding the cursor.
      autocmd CursorHold * silent call CocActionAsync('highlight')

      " Symbol renaming.
      nmap <leader>rn <Plug>(coc-rename)

      " Formatting selected code.
      xmap <leader>f  <Plug>(coc-format-selected)
      nmap <leader>f  <Plug>(coc-format-selected)

      " For pandoc
      let g:pandoc#modules#disabled = ["spell"]
      let g:pandoc#command#autoexec_command = "Pandoc! pdf"
      let g:pandoc#command#autoexec_on_writes = 1

      " For prettier
      let g:prettier#quickfix_enabled = 0
      let g:prettier#autoformat_require_pragma = 0
      command! -nargs=0 Prettier :CocCommand prettier.formatFile
      vmap <leader>f  <Plug>(coc-format-selected)
      nmap <leader>f  <Plug>(coc-format-selected)

      " For ctrlp
      if executable('rg')
        set grepprg=rg\ --color=never
        let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
        let g:ctrlp_use_caching = 0
      else
        let g:ctrlp_clear_cache_on_exit = 0
        let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn|node_modules)$'
      endif

      lua<<EOF
        ${builtins.readFile /home/raito/dotfiles/nvim/lua/lean.lua}
      EOF
    '';
  };

  xdg.configFile."nvim/coc-settings.json".text = builtins.readFile /home/raito/dotfiles/coc-settings.json;
}
