#!/usr/bin/env sh

main() {
	TXT=kb.txt
	TBL=mpq/rez/stat_txt.tbl
	YML=../Starcraft/cosmonarchy.yml
	SED=kb.sed
	TMP=kb.tmp
	MPQ=temp.mpq
	if [ ! -f "$TXT" ]
	then
		grid true
		export_config < "$TBL" > "$TXT"
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
	sed 's/\^.\|\$//g;s/^.\(.*\)(\(.\))/\2\t\1/;' |
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
	if grep -qsbm1 . "$MPQ" 2>/dev/null
	then
		echo 'Search Method: Grep'
		xline=$(head -c 30 "$TBL")
		xline=$(grep -Fobam1 "$xline" "$MPQ" | cut -d: -f1)
	else
		echo 'Search Method: Strings'
		xline=$(strings -t d -n 50 "$TBL" | head -n1 | sed 's/^ *//')
		yline=$(echo "$xline" | cut -d' ' -f2-)
		yline=$(strings -t d -n 50 "$MPQ" | grep -Fm1 "$yline" | sed 's/^ *\([0-9]*\) .*/\1/')
		xline=$(echo "$xline" | cut -d' ' -f1)
		xline=$((yline-xline))
	fi
	echo 'Patching...'
	dd if="$TMP" of="$MPQ" bs=1 seek="$xline" conv=notrunc 2>/dev/null
}

main "$@"
