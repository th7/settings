if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PGHOST=localhost

source ~/bash-scripts/git.sh

confirm () {
    read -r -p "${1:-Are you sure? [Y/n]} " response
    case $response in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

sinatra() {
    if (($# >= 3))
    then
        echo "too many arguments"
        return
    fi

    FORMERDIR=$(pwd)
    cd ~/Downloads

    if (($# == 2))
    then
        if [ ! -f "$2" ]
        then
            echo "$2 not found in Downloads"
            cd $FORMERDIR
            return
        fi
        cp $2 $FORMERDIR
        cd $FORMERDIR
        unzip -qq $2 -d $1
        rm $2
        cd $1
        git init -q
        git add .
        git commit -qm 'create skeleton'
        return
    fi

    if (($# == 1))
    then
        if [ ! -f "sinatra_skeleton.zip" ]
        then
            echo "sinatra_skeleton.zip not found in Downloads"
            cd $FORMERDIR
            return
        fi
        cp sinatra_skeleton.zip $FORMERDIR
        cd $FORMERDIR
        unzip -qq sinatra_skeleton.zip -d $1
        rm sinatra_skeleton.zip
        cd $1
    else
        cp sinatra_skeleton.zip $FORMERDIR
        cd $FORMERDIR
        unzip sinatra_skeleton.zip
        rm sinatra_skeleton.zip
    fi

    git init -q
    git add .
    git commit -qm 'create skeleton'
}

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

ironmine() {
    DIR="/home/tyler/$1"
    shift
    if [ $1 == "logs" ]
    then
        CMD="tail -f log/production.log"
    else
        CMD="$@"
    fi
    ssh tylerhartland.no-ip.biz "cd $DIR && $CMD"
}

export PS1="\W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "

alias fuckit="confirm && rake db:drop && rake db:create && rake db:migrate && rake db:seed"
alias be="bundle exec"

alias sms="ruby ~/ruby-scripts/sms/run.rb"
