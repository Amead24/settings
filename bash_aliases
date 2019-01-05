alias pip=pip3
alias python=python3
alias tmux="tmux -2"

alias kc=kubectl

# kc get
alias kcg='kubectl get'
alias kcgpd='kubectl get pods -o wide'
alias kcgdp='kubectl get deployments -o wide'
alias kcgsv='kubectl get services -o wide'
alias kcgjn='kubectl get jobs -o wide'

alias kcgns='kubectl get namespaces -o wide'
alias kcgnd='kubectl get nodes -o wide'

alias kcgv='kubectl get pv -o wide'

alias cc='-o=\"custom-columns=:.metadata.name\"'

# kc describe
alias kcd='kubectl describe'
alias kcdd='kubectl describe deployment'
alias kcdp='kubectl describe pod'
