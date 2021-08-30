# navigation

case "$OSTYPE" in
    msys*) alias open="start" ;;
    linux*) alias open="xdg-open" ;;
esac


alias ...="../.."
alias ....="../../.."

# version control

alias agent="eval $(ssh-agent -s)"
# alias github="ssh-add [path-to-private-key]"
