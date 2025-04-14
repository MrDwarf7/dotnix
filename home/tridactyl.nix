{
  config,
  lib,
  # pkgs,
  ...
}: {
  options = {
    home.tridactyl.enable = lib.mkEnableOption "Enable tridactyl config to be generated";
  };

  config = lib.mkIf config.home.tridactyl.enable {
    home.file = {
      ".tridactyl/.tridactyl".enable = true;
      ".tridactyl".text = ''
        " For syntax highlighting see https://github.com/tridactyl/vim-tridactyl
        " vim: set filetype=tridactyl

        " nvim: setfiletype=vim
        " nvim: setfiletype=tridactyl

        " Reset ALL settings to this only the base of tridactyl itself is in the mem, then load this file
        sanitise trydactyllocal trydactylsync

        " General Settings
        set update.lastchecktime 1734005772482
        set update.nag true
        set update.nagwait 7
        set update.lastnaggedversion 1.14.0
        set update.checkintervalsecs 86400
        set configversion 2.0
        " Only good themes really are:
        " default | dark | midnight | quake | quakelight | shydactyl
        " NOTE  --shydactyl | midnight place the commandline in centre, others are
        " bottom
        " quake | quakelight is top of screen
        "
        set theme midnight
        set hintfiltermode simple

        set findcase insensitive
        " Time in MS
        set findhighlighttimeout 10000
        set smoothscroll true

        " No longer do weird tablose + tabprev
        unbind d
        unbind D
        " No longer use p as direct paste for searching - use ctrl for it
        unbind p

        " URL Binds
        bindurl ^https://github.com gi hint -Vc .AppHeader-searchButton

        bindurl www.google.com gi composite focusinput -l ; text.end_of_line
        bindurl ^https://web.whatsapp.com f hint -c [tabindex]:not(.two)>div,a
        bindurl ^https://web.whatsapp.com F hint -bc [tabindex]:not(.two)>div,a

        " Very generic binds
        bind <Esc> nohlsearch

        " Binds
        bind ;C composite hint_focus; !s xdotool key Menu
        bind <C-6> buffer #
        bind <A-p> pin
        bind <A-m> mute toggle
        bind <F1> help
        bind o fillcmdline open
        bind O current_url open
        bind w fillcmdline winopen
        bind W current_url winopen

        bind ]] followpage next
        bind [[ followpage prev
        bind [c urlincrement -1
        bind ]c urlincrement 1
        bind <C-x> urlincrement -1
        bind <C-a> urlincrement 1

        " Remove the default of p to open a search with clip, and use ctrl-p instead
        bind <C-p> clipboard open

        bind yy clipboard yank
        bind ys clipboard yankshort
        bind yq text2qr --timeout 5
        bind yc clipboard yankcanon
        bind ym clipboard yankmd
        bind yo clipboard yankorg
        bind yt clipboard yanktitle
        " Add bind for yankurl // Duplicate tab
        bind yi tabduplicate

        " GoTo L --- GoTo Last --- Tab
        bind gl buffer #

        bind gh home
        bind gH home true
        bind gk tabduplicate
        bind p clipboard open
        bind P clipboard tabopen

        " Scrolling
        " default scroll is 10, way too much
        bind j scrollline 4
        bind k scrollline -4

        " Small scrolls
        bind <C-e> scrollline 2
        bind <C-y> scrollline -2

        bind h scrollpx -50
        bind l scrollpx 50
        bind G scrollto 100
        bind gg scrollto 0
        bind <C-u> scrollpage -0.5
        bind <C-d> scrollpage 0.5
        bind <C-f> scrollpage 1
        bind <C-b> scrollpage -1
        bind <C-v> nmode ignore 1 mode normal
        bind $ scrollto 100 x
        bind ^ scrollto 0 x
        bind H back
        bind L forward
        bind <C-o> jumpprev
        bind <C-i> jumpnext
        " bind d tabclose
        " bind D composite tabprev; tabclose #

        " Tabs
        " Vertical tabs are organized backwards
        bind K tabprev
        bind J tabnext
        bind x tabclose

        bind gx0 tabclosealltoleft
        bind gx$ tabclosealltoright
        bind << tabmove -1
        bind >> tabmove +1
        bind u undo
        bind U undo window
        bind r reload
        bind R reloadhard
        " CURRENTLY ENTIRELY UNBOUND
        " bind x stop
        bind gi focusinput -l
        bind g? rot13
        bind g! jumble
        bind g; changelistjump -1
        " bind K tabprev
        " bind J tabnext
        bind gt tabnext_gt
        bind gT tabprev
        bind g^ tabfirst
        bind g0 tabfirst
        bind g$ tablast
        bind ga tabaudio
        bind gr reader --old
        bind gu urlparent
        bind gU urlroot
        bind gf viewsource

        " Searching stuff
        bind / fillcmdline find
        bind ? fillcmdline find -?

        " Searching scroll
        bind n findnext 1
        bind N findnext -1


        " Tabs - Commandline calls
        bind t fillcmdline tabopen
        bind T current_url tabopen
        bind b fillcmdline tab
        bind B fillcmdline taball


        bind : fillcmdline_notrail
        bind s fillcmdline open search
        bind S fillcmdline tabopen search
        bind M gobble 1 quickmark
        bind ZZ qall
        bind f hint

        bind F hint -b
        bind gF hint -qb
        bind ;i hint -i
        bind ;b hint -b
        bind ;o hint
        bind ;I hint -I
        bind ;k hint -k
        bind ;K hint -K
        bind ;y hint -y
        bind ;Y hint -cF img i => tri.excmds.yankimage(tri.urlutils.getAbsoluteURL(i.src))
        bind ;p hint -p
        bind ;h hint -h
        bind v hint -h
        bind ;P hint -P

        bind ;r hint -r
        bind ;s hint -s
        bind ;S hint -S
        bind ;a hint -a
        bind ;A hint -A
        bind ;; hint -; *
        bind ;# hint -#
        bind ;v hint -W mpvsafe
        bind ;V hint -V
        bind ;w hint -w
        bind ;t hint -W tabopen
        bind ;O hint -W fillcmdline_notrail open
        bind ;W hint -W fillcmdline_notrail winopen
        bind ;T hint -W fillcmdline_notrail tabopen
        bind ;d hint -W tabopen --discard
        bind ;gd hint -qW tabopen --discard
        bind ;z hint -z
        bind ;m hint -JFc img i => tri.excmds.open('https://lens.google.com/uploadbyurl?url='+i.src)
        bind ;M hint -JFc img i => tri.excmds.tabopen('https://lens.google.com/uploadbyurl?url='+i.src)
        bind ;gi hint -qi
        bind ;gI hint -qI
        bind ;gk hint -qk
        bind ;gy hint -qy
        bind ;gp hint -qp
        bind ;gP hint -qP
        bind ;gr hint -qr
        bind ;gs hint -qs
        bind ;gS hint -qS
        bind ;ga hint -qa
        bind ;gA hint -qA
        bind ;g; hint -q;
        bind ;g# hint -q#
        bind ;gv hint -qW mpvsafe
        bind ;gw hint -qw
        bind ;gb hint -qb
        bind ;gF hint -qb
        bind ;gf hint -q

        bind <S-Insert> mode ignore
        bind <AC-Escape> mode ignore
        bind <AC-`> mode ignore
        bind <S-Escape> mode ignore
        bind <Escape> composite mode normal ; hidecmdline
        bind <C-[> composite mode normal ; hidecmdline
        bind a current_url bmark
        bind A bmark
        bind zi zoom 0.1 true
        bind zo zoom -0.1 true
        bind zm zoom 0.5 true
        bind zr zoom -0.5 true
        bind zM zoom 0.5 true
        bind zR zoom -0.5 true
        bind zz zoom 1
        bind zI zoom 3
        bind zO zoom 0.3
        bind . repeat
        bind <AS-ArrowUp><AS-ArrowUp><AS-ArrowDown><AS-ArrowDown><AS-ArrowLeft><AS-ArrowRight><AS-ArrowLeft><AS-ArrowRight>ba open https://www.youtube.com/watch?v=M3iOROuTuMA
        bind m gobble 1 markadd

        " Fix jumping to marks
        bind ' gobble 1 markjump

        bind --mode=visual ^ js document.getSelection().modify("extend","backward","lineboundary")
        bind --mode=visual H js document.getSelection().modify("extend","backward","lineboundary")

        bind --mode=visual $ js document.getSelection().modify("extend","forward","lineboundary")
        bind --mode=visual L js document.getSelection().modify("extend","forward","lineboundary")

        " Subconfig Settings
        seturl www.google.com followpagepatterns.next Next
        seturl www.google.com followpagepatterns.prev Previous

        " To ignore a site etc.
        autocmd FullscreenEnter www\.youtube\.com.* mode ignore
        autocmd DocStart www\.monkeytype\.com.* mode ignore
      '';
    };
  };
}
