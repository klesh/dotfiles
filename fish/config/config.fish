set -gx EDITOR vim
set -gx PGDATA /usr/local/var/postgres
set -gx LESS "-SRXF"
set -gx LS_COLORS 'ow=34;42;40'
set -gx nvm_mirror http://npm.taobao.org/mirrors/node

function append-path-if-exists
  if test -e $argv
    set -gx PATH $argv $PATH
  end
end

function source-file-if-exists
  if test -e $argv
    source $argv
  end
end

source-file-if-exists /usr/share/autojump/autojump.fish
source-file-if-exists /usr/local/share/autojump/autojump.fish
append-path-if-exists ~/.local/bin
append-path-if-exists ~/Programs/bin
append-path-if-exists ~/.yarn/bin
source-file-if-exists ~/.cargo/env
append-path-if-exists /usr/local/bin
#/usr/bin/xmodmap /home/klesh/.Xmodmap

if which pip 1>/dev/null 2>/dev/null; and pip show virtualfish > /dev/null 2>/dev/null
  eval (python -m virtualfish auto_activation)
end

# pronounce a English word
function dp
  set play afplay
  if not which $play 2>/dev/null
    set play ffplay -nodisp -autoexit
  end
  wget -O /tmp/sound.mp3 "http://dict.youdao.com/dictvoice?audio=$argv[1]&type=1">/dev/null 2>/dev/null
  and eval $play /tmp/sound.mp3 1>/dev/null 2>/dev/null
end

# print current datetime as in plain format which could be use a filename etc
function dt
  date "+%Y%m%d-%H%M%S"
end

function d
  set word $argv
  set escaped_word (string escape --style url "$word")
  curl -SsL "http://cn.bing.com/dict/search?q=$escaped_word" |\
	grep -Eo '<meta name="description" content="(.+) " ?/>' |\
	sed -E 's/<meta name="description" content="必应词典为您提供.+的释义，(.+)" ?\/>/\1/' |\
	sed -E 's/(.*)(，)(.*)/\1 \3/' | awk -v WORD=$word '{
		c=0;
		print WORD;
		for(i=1;i<=NF;i++) {
			if(match($i, "^[a-z]+\\.|网络释义：$") != 0) {
				if(c==0) printf "\n";
				printf "\n";
				c++;
			}
			printf "%s ",$i;
		}
		printf "\n";
	}' 2>/dev/null
end

function clean-taobao-link
  echo "$argv" | sed 's/^\(.*\)?\(.*&\)\?\(id=[^&]\+\).*$/\1?\3/g' | xsel -sb
end

# for WSL
function sync-ssh-config
  # sshconfig has a restricted file permission requirement which normally hard to
  # be met on Window (i.e., syncing your config by Nextcloud on drive D).
  # this function pour contents of files within ~/.ssh/config.d to ~/.ssh/config
  if test -d ~/.ssh/config.d
    rm -rf ~/.ssh/config
    for cfg in (ls ~/.ssh/config.d)
      cat ~/.ssh/config.d/$cfg >> ~/.ssh/config
    end
    chmod 600 ~/.ssh/config
  end
end

function swap-caps-esc
  setxkbmap -option caps:swapescape
end

function caps-to-grave
  xmodmap -e "clear Lock"
  xmodmap -e "keycode 66 = grave asciitilde"
end

function show-colors
  bash -c '(x=`tput op` y=`printf %76s`;for i in {0..256};do o=00$i;echo -e ${o:${#o}-3:3} `tput setaf $i;tput setab $i`${y// /=}$x;done)'
end

# auto startx
if test -z "$DISPLAY" -a -n "$XDG_VTNR" -a "$XDG_VTNR" -eq "1" -a -z "$STARTED"
  set -gx STARTED true
  startx
end

alias k=kubectl
alias kcc="k config get-contexts"
alias kcu="k config use-context"
alias kgd="k get deployment"
alias ked="k edit deployment"
alias kgp="k get pod -o 'custom-columns=NAME:.metadata.name,IMG:.spec.containers[*].image,STATUS:.status.phase'"
alias kl="k logs -f --all-containers"
alias issh='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'
alias iscp='scp -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'


source-file-if-exists ~/.profile.fish
