export BLOG_ROOT=~/dev/projects/ryan.lahfa.xyz
export BLOG_POST_TEMPLATE=~/dev/projects/ryan.lahfa.xyz/src/.post.template.md
export BLOG_POSTS_SRC=~/dev/projects/ryan.lahfa.xyz/src/posts

# TODO: show draft status, updated_at, created_at
function vlist() {
  find $BLOG_POSTS_SRC -type f -name "*.md" -print0 | xargs -0 basename -a | cut -d "-" -f4- | cut -d "." -f1
}

function vopen() {
  vchoice=$(vlist | percol --query "$1" --auto-match)
  vpost "$vchoice"
}

function vpost()
{
  local existing_target=$(find $BLOG_POSTS_SRC -type f -name "*-$1.md" | head -1)
  local target=${existing_target:-$BLOG_POSTS_SRC/$(date +"%Y-%m-%d")-$1.md}
  local original=$BLOG_POST_TEMPLATE
  local new=true
  if [ ! -f $target ]; then
   green "Importing from template, a new blog post."
   cp $BLOG_POST_TEMPLATE $target
  else
   original=$(mktemp)
   new=false
   cp $target $original
  fi
  vim $target
  if diff $original $target>/dev/null; then
    yellow "No changes."
    if [ "$new" = true ]; then
      red "New post, therefore, deleted."
      rm $target # No changes in a new post, therefore, no blog post.
    fi
  else
    green "Updated frontmatter for the post."
    yq e -i --front-matter=process ".updated=\"$(date -Iseconds)\"" $target
  fi

  if [ "$new" = false ]; then
   rm $original
  fi
}

function bdy()
{
  pushd $BLOG_ROOT
  nix run . build && nix run . deploy
  popd
}
