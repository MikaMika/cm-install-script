#!/usr/bin/env sh

main() {
	[ "$1" ] || { time sh "$0" 1; return; }
	TXT=kb.txt
	TBL=mpq/rez/stat_txt.tbl
	YML=../Starcraft/cosmonarchy.yml
	SED=kb.sed
	TMP=kb.tmp
	MPQ=temp.mpq
	if [ ! -f "$TXT" ]
	then
		{
			grid true
			echo "# Config file for Cosmonarchy KeyBinder"
			echo "# "
			echo "# Lines starting with # are ignored."
			echo "# To assign a new key, remove # then change the first character."
			echo "# "
			export_config < "$TBL"
		} > "$TXT"
		echo "Created new custom keybinds: '$TXT'"
		echo "Open that file with a text editor and modify the first character"
		echo " then launch this script again to import the keys into the game."
	else
		grid false
		import_config
		echo "If you see any error, try launching the script again."
		echo "If you want to re-enable Grid and/or start over, then"
		echo " delete '$TXT' and launch this script again."
	fi
}

grid() {
	old=false
	new=${1:-true}
	$new || old=true
	tr '\n\r' '\1\2' < "$YML" > "$YML.tmp"
	sed -E "s/(grid-hotkeys:.. *enabled: *)$old/\1 $new/" "$YML.tmp" -i
	sed -E "s/(extended-control-groups: *)$old/\1 $new/" "$YML.tmp" -i
	tr '\1\2' '\n\r' < "$YML.tmp" > "$YML"
	rm "$YML.tmp"
	echo "Grid enabled: $new"
}

export_config() {
	cat -A | grep "\^@.^.^D[a-zA-Z '']*^A(^C.^A)" -o |
	sed 's/\^.\|\$//g;s/^.\(.*\)(\(.\))/#\2\t\1/;' |
	LC_ALL=C sort -u -t"$(printf '\t')" -k2,2
}

import_config() {
	echo 'Importing...'
	make_sedfile < "$TXT" > "$SED"
	apply_sedfile < "$TBL" > "$TMP"
	rm "$SED"
	patch_mpq
	rm "$TMP"
	echo 'Import complete.'
}

make_sedfile() {
	grep -v '^#' |
	sed -E 's/^(.)[ \t]*(.*)/\1--\2++\1/;s/^a/a/I;s/^b/b/I;s/^c/c/I;s/^d/d/I;
	s/^e/e/I;s/^f/f/I;s/^g/g/I;s/^h/h/I;s/^i/i/I;s/^j/j/I;s/^k/k/I;s/^l/l/I;
	s/^m/m/I;s/^n/n/I;s/^o/o/I;s/^p/p/I;s/^q/q/I;s/^r/r/I;s/^s/s/I;s/^t/t/I;
	s/^u/u/I;s/^v/v/I;s/^w/w/I;s/^x/x/I;s/^y/y/I;s/^z/z/I;' |
	xxd -p | tr -d '\n' | sed 's/0a/\n/g' |
	sed -E 's/2d2d/..04/;s/2b2b/(20)*012803/;s@.*@s/\0/\0/g@;s/..\.\./..(../;
	s@../@)../@;s@\/(..)\.\..*(....)@/\1\\1\2@'
}

apply_sedfile() {
	xxd -p |
	tr -d '\n' |
	sed -Ef "$SED" |
	xxd -r -p
}

patch_mpq() {
	if find_offset
	then
		echo 'Patching...'
		dd if="$TMP" of="$MPQ" bs=1 seek="$offset" conv=notrunc 2>/dev/null
	else echo "Failed: Could not locate $TBL inside $MPQ"
	fi
}

find_offset() {
	offset=
	i=0
	for method in grep strings xxd;
	do
		i=$((i+1))
		echo "Search Method $i: $method" >&2
		offset=$(search_$method) 2>/dev/null;
		[ -n "$offset" ] && [ "$offset" -gt 0 ] && return;
		false
	done
}

find_offset2() { # Unused alternative method, with while loop
	i=1
	offset=
	while [ -z "$offset" ] || [ "$offset" -le 0 ]
	do
		case $i in
			1) echo "Search Method $i: grep" && offset=$(search_grep) 2>/dev/null;;
			2) echo "Search Method $i: strings" && offset=$(search_strings) 2>/dev/null;;
			3) echo "Search Method $i: xxd" && offset=$(search_xxd) 2>/dev/null;;
			*) return 1;;
		esac
		i=$((i+1))
	done
}

search_grep() {
	xline=$(head -c 30 "$TBL")
	xline=$(grep -Fobam1 "$xline" "$MPQ" | cut -d: -f1)
	echo "$xline"
}

search_strings() {
	xline=$(strings -t d -n 50 "$TBL" | head -n1 | sed 's/^ *//')
	yline=$(echo "$xline" | cut -d' ' -f2-)
	yline=$(strings -t d -n 50 "$MPQ" | grep -Fm1 "$yline" | sed 's/^ *\([0-9]*\) .*/\1/')
	xline=$(echo "$xline" | cut -d' ' -f1)
	xline=$((yline-xline))
	echo "$xline"
}

search_xxd() {
	xline=$(xxd -c 128 -p "$TBL" | head -n1)
	yline=$(xxd -c 256 -p "$MPQ" | grep -nm1 "$xline")
	# If yline fails then 128c were cut by the end of the 256c line.
	# To avoid this, stagger the file by 128c
	if [ ! "$yline" ]
	then yline=$(xxd -s 128 -c 256 -p "$MPQ" | grep -nm1 "$xline")
	fi
	zline=$(echo "$yline" | cut -d':' -f2- | sed "s/$xline.*//" | wc -c)
	zline=$((zline/2))
	xline=$(echo "$yline" | cut -d':' -f1)
	xline=$((xline*256-256+zline))
	echo "$xline"
}

main "$@"
