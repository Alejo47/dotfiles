export ZSH="/home/alejo/.oh-my-zsh" # WARNING: YOU SHOULD PROBABLY CHANGE THIS LINE

ZSH_THEME="robbyrussell"

HYPHEN_INSENSITIVE="true"

DISABLE_UPDATE_PROMPT="true"

plugins=(
	git
	themes
)

source $ZSH/oh-my-zsh.sh

# COMMAND NOT FOUND SUGGESTIONS

source /etc/zsh_command_not_found
export EDITOR='vim'
export PATH="$PATH:$HOME/.local/bin"

# LOAD APT-VIM

export PATH="$PATH:$HOME/.vimpkg/bin"

# LOAD GOLANG

export PATH="$PATH:/usr/local/go/bin"

# LOAD RVM

[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm"

export PATH="$PATH:/usr/share/rvm/bin"

# CUSTOM ALIASES/FUNCITONS

docker-test() {
	if [[ $1 ]]; then
		docker-compose -f test_local.yml "$@" || docker-compose -f test.yml "$@"
	else
    docker-compose -f test_local.yml run --rm --service-ports web || docker-compose -f test.yml run --rm --service-ports web
	fi
}

docker-dev() {
	if [[ $1 ]]; then
		docker-compose -f development.yml "$@"
	else
		docker-compose -f development.yml run --rm --service-ports web
	fi
}

docker-bash() {
	if [[ $1 ]]; then
		local container=`docker ps --format="{{ .Names }}" --filter name=$1 | egrep "web" | head -1`
	else 
		local container=`docker ps --format="{{ .Names }}" --filter name=${PWD##*/} | egrep "web" | head -1`
	fi

	if [[ -z $container ]]; then
		echo "No containers found"
		return 
	fi

	docker exec -it $container bash
}

docker-redis() {
	if [[ $1 ]]; then
		local container=`docker ps --format="{{ .Names }}" --filter name=$1 | egrep "redis" | head -1`
	else 
		local container=`docker ps --format="{{ .Names }}" --filter name=${PWD##*/} | egrep "redis" | head -1`
	fi

	if [[ -z $container ]]; then
		echo "No containers found"
		return 
	fi

	docker exec -it $container bash
}

docker-db() {
	if [[ $1 ]]; then
		local container=`docker ps --format="{{ .Names }}" --filter name=$1 | egrep "db" | head -1`
	else 
		local container=`docker ps --format="{{ .Names }}" --filter name=${PWD##*/} | egrep "db" | head -1`
	fi

	if [[ -z $container ]]; then
		echo "No containers found"
		return 
	fi

	docker exec -it $container bash
}

alias ddev="docker-dev" # DOCKER RUN WEB SERVICE WITH development.yml
alias dtest="docker-test" # DOCKER RUN WEB SERVICE WITH test_local.yml OR test.yml AS FALLBACK
alias dsta="docker stop $(docker ps -aq)" # STOPS ALL CONTAINERS
alias drma="docker rm $(docker stop $(docker ps -aq))" # REMOVES ALL CONTAINERS
alias dsh="docker-bash"  # DOCKER EXEC INTO WEB CONTAINER
alias dredis="docker-redis" # DOCKER EXEC INTO REDIS CONTAINER
alias ddb="docker-db" # DOCKER EXEC INTO DB CONTAINER
alias json-pp="python3 -m json.tool" # PRETTY PRINT JSON OUTPUT
alias ncdu="ncdu --color=dark --confirm-quit -2" # FANCY ncdu
alias curl-t="curl -so /dev/null -w '\n%{time_connect}\n%{time_starttransfer}\n%{time_total}\n'" # Pint times for a cURL request
