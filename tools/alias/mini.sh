# when using Git Bash and without the whole dev_wp project, use this instead

alias g="git"
alias gp="git push"
alias gl="git pull"
alias gcl="git clone"
alias gst="git status"
alias gulc="git reset --soft HEAD~1"
alias glo="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias ghm="cd \"\$(git rev-parse --show-toplevel)\""

alias ..="cd .."

alias cfn='basename `pwd` | clip'
alias ccp='echo `pwd` | clip'