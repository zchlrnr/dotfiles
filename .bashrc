#
# ~/.bashrc
#

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
# User created aliases
alias xclip="xclip -selection c"
alias dotfiles='/usr/bin/git --git-dir $HOME/.dotfiles/ --work-tree=$HOME'

# User created functions
rmd(){
    pandoc -o temp.html $1
    firefox temp.html
    rm temp.html
}
# This is where my list of big scary environmental variables ought live.{{{
export TUIR_BROWSER=w3m
export TUIR_EDITOR=vim
#}}}
# packages all my manga more neatly into a pdf. 
function pdfchapter { #{{{
    mogrify -format jpg *.png
    mogrify -format png *.jpg
    rm *.jpg
    convert *.png chapter.pdf
} #}}}
# puts my mdex password in my clipboard
function mdexpass { #{{{
    pass=$'de89Abq3Tp7SkBaD'
    echo $pass | xclip
} #}}}
# runs custom youtube-dl on bancamp album links
function bandcamp-dl { #{{{
    arg=$1
    var1=`pwd`
    echo $var1
    youtube-dl -o "$var1/%(title)s.%(ext)s" -x --audio-format mp3 $arg
} #}}}
# takes in user input of Webtoon Name and creates html file to read it
function webtoon2html { #{{{
    # Assume that the directory is of the form "C[0-9]{1,4} 'chaptertitle'"
    chaptername=$(pwd | rev | cut -f 1 -d'/' | rev)
    manganame=$(pwd | rev | cut -f 2 -d'/' | rev)
    FILENAME="$manganame"" ""$chaptername"".html"
    FILENAME=${FILENAME// /_}
    rm -f "$FILENAME"
    echo "<html>" >> $FILENAME
    echo "<body bgcolor=\"#000000\">" >> $FILENAME
    echo "<div id=\"container\">" >> $FILENAME
    echo "    <div id=\"floated-imgs\">" >> $FILENAME
    for filename in *.{png,jpg}; do
        echo "        <center><img src=\"$filename\"></center>" >> $FILENAME
    done
    echo "    </div>" >> $FILENAME
    echo "</div>" >> $FILENAME
    echo "</body>" >> $FILENAME
    echo "<style>" >> $FILENAME
    echo "   #img{" >> $FILENAME
    echo "      float: center;" >> $FILENAME
    echo "   }" >> $FILENAME
    echo "   #img img{" >> $FILENAME
    echo "      display: block;" >> $FILENAME
    echo "   }" >> $FILENAME
    echo "</style>" >> $FILENAME
    echo "</html>" >> $FILENAME
} #}}}
# Downscales a standardanime mkv to the 960:540 retaining subtitles
function downscale_anime { #{{{
    filename_start=$(basename -- "$1")
    filename_prefix="${filename_start%.*}"
    echo $filename_start
    echo "ffmpeg -i "\""$filename_start"\"" -vf subtitles="\""$filename_start"\"" -vf scale=960:540 "\"""$filename_prefix"""_downscaled.mkv""\""
    ffmpeg -i "$filename_start" -vf subtitles="$filename_start" -vf scale=960:540 "$filename_prefix""_downscaled.mkv"
} #}}}
# interactively tags mp3 metadata
function mid3v2i { #{{{
    location=$PWD
    artist_guess=`echo $location | rev | cut -f 2 -d "/" | rev `
    artist_guess=`echo "$artist_guess" | tr _ " "`
    album_guess=`echo $location | rev | cut -f 1 -d "/" | rev `

    echo Enter the name of the artist
    echo [If it\'s $artist_guess"," leave blank]
    read artist_in
    if [ ""="$artist_in" ]
    then
        artist=$artist_guess
    else
        artist=$artist_in
    fi

    echo Enter the name of the album
    echo [If it\'s $album_guess"," leave blank]
    read album_in
    if [ ""="$album_in" ]
    then
        album=$album_guess
    else
        album=$album_in
    fi

    echo Enter the name of the song
    songname_guess=`echo $1 | cut -f 1 -d "."`
    echo [If it\'s $songname_guess"," leave blank]
    read songname_in
    if [ ""="$songname_in" ]
    then 
        songname=$songname_guess
    else
        songname=$songname_in
    fi

    echo Enter in the track number fraction
    echo Ought have the form number"/"bigger number
    read track_number_fraction

    # renaming song if it needs to be renamed
    newsongname="$songname"".mp3"
    if [ "$1" = "$newsongname" ]
    then
        echo renaming song
    else
        mv $1 $newsongname
    fi

    mid3v2 -a "$artist" -A "$album" -t "$songname" -T "$track_number_fraction" "$songname"".mp3"

} #}}}
# try to search for a wikipedia page and then put it in a file called wikiquery
function wikisearcher { #{{{
    a="$*"
    b=${a// /+}
    req="https://en.wikipedia.org/wiki/api/php?action=opensearch&format=json&search=$b"
    w3m -dump "$req" > data.html
    searchline=$(head -n 3 data.html | tail -n 1)
    echo $searchline
    if [[ "$searchline" = "Search results" ]]; then
        echo "This is indeed a search line"
        echo "You were not specific enough. See data.html for better information."
        return
    fi
    mv data.html wikiquery.html 
} #}}}
# Download songs in an album, and tag them with mid3v2
function aquiresongs { #{{{
    numberofsongs=$(wc -l songlist.txt | cut -f 1 -d " ")
    counter=0
   while IFS= read -r line; do
       echo $line
       counter=$((counter+1))
       mkdir temp
       cd temp
       albumname=$(echo $PWD | rev | cut -f 2 -d'/' | rev)
       albumname=${albumname//_/ }
       artistname=$(echo $PWD | rev | cut -f 3 -d'/' | rev)
       artistname=${artistname//_/ }
       # Want to tell if my songlist line has the term "/|\" in it.
       # If it does, then will store songname as thing before the pattern, 
       # and the query as everything after it
       if [[ $line == *"/|\\"* ]]; then
           songname=$(echo $line | cut -f 1 -d"/")
           searchterm=$(echo $line | rev | cut -f 1 -d'\' | rev)
       else
           songname=$line
           searchterm="$artistname"" ""$line"
       fi
       echo $searchterm
       youtube-dl -x --audio-format mp3 ytsearch:"$searchterm"
       mv *mp3 "$songname"".mp3"
       mid3v2 -a "$artistname" -A "$albumname" -t "$songname" -T "$counter""/""$numberofsongs" *mp3
       mv *mp3 ..
       cd ..
       rm -r temp
   done < songlist.txt
} #}}}
# Open the next manga chapter in firefox
function nextchapter { #{{{
    # get current chapter number
    current_folder=$(echo $PWD | rev | cut -f 1 -d'/' | rev)
    current_number=$(echo $PWD | rev | cut -f 1 -d'/' | rev | egrep -o '[0-9]+|[0-9]+\.[0-9]+')
    cd ..
    current_index=$(ls -d */ | grep -n "$current_number" | cut -f 1 -d':' | head -n 1)
    next_directory=$(ls -d */ | head -n $((current_index+1)) | tail -n 1)
    cd "$next_directory"
    webtoon2html
    firefox *html
} #}}}
