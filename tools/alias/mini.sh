# when using Git Bash and without the whole dev_wp project, use this instead

alias g="git"
alias gp="git push"
alias gl="git pull"
alias gcl="git clone"
alias gst="git status"
alias gulc="git reset --soft HEAD~1"
alias glo="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias ghm="cd \"\$(git rev-parse --show-toplevel)\""

alias drma='docker rm $(docker ps -aq) --force'
alias drmdn='docker rm $(docker ps -aq -f status=exited -f status=created -f status=dead -f status=paused) --force'
alias drmd='docker rmi $(docker images -f "dangling=true" -q)'
alias dpsa="docker ps -a"
alias dpsadn="docker ps -a --filter \"status=exited\" --filter \"status=created\" --filter \"status=dead\" --filter \"status=paused\""

alias dils="docker images"
alias dirm="docker rmi"
alias drm="docker rm"
alias dlo="docker logs"

alias ..="cd .."

alias cfn='basename `pwd` | clip'
alias ccp='echo `pwd` | clip'