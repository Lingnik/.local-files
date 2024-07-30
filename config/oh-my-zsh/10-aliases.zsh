########################################################################################################################
echo -n "\ue615 ${${(%):-%N}//$HOME/~} \uf251" && timing_ns=$(/opt/homebrew/bin/gdate +%s%3N)
echo -n "\t0 $((($(/opt/homebrew/bin/gdate +%s%3N) - timing_ns)))ms" && timing_ns=$(/opt/homebrew/bin/gdate +%s%3N)
########################################################################################################################

# git
export PROJECT_HOME=$HOME/git/
alias gs='git status'

# tmux
bindkey -s ^s "tmux-sessionizer\n"
alias tls="tmux list-sessions"
alias ta="tmux attach -t"

# vim
alias vim="nvim"
alias vi="nvim"
alias vimdiff="nvim -d"
alias v="nvim"

# gpg
function encrypt() {
        output=~/"${1}".$(date +%s).enc
        gpg --encrypt --armor --output ${output} -r 0x11CD218F63C9B8F0 "${1}" && echo "${1} -> ${output}"
}
function decrypt() {
        output=$(echo "${1}" | rev | cut -c16- | rev)
        gpg --decrypt --output ${output} "${1}" && echo "${1} -> ${output}"
}
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# grep
alias grep='grep --exclude-dir=target'
alias lgrep='grep -l'
function vgrep() {
        vim -p $(grep -l "$1" ${@})
}


########################################################################################################################
echo "\tX $((($(/opt/homebrew/bin/gdate +%s%3N) - timing_ns)))ms \uf253"
# DO NOT ADD MORE LINES
########################################################################################################################
