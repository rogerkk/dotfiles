alias g='git'
alias gst='git status'
alias gcm='git commit'
alias gco='git checkout'
alias gpl='git pl'
alias grm='git rm'
alias gad='git add'
alias gpu='git push'

# Alias Github "hub" command as git
eval "$(hub alias -s)"

# "hub" commands
alias gpr='gh pr create' 
alias gci='gh run list --user rogerkk --limit 10 --branch `git branch --show-current`'




