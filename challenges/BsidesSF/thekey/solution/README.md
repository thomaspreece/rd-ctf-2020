This is just a keyboard usb pcap, with one big twist: it uses some vim commands!

Some examples:
* vbU to uppercase the preceding string
* vi{U to uppercase stuff inside the braces
* A / i for insertions
* hjkl to move around
* ...etc

See: https://blog.stayontarget.org/2019/03/decoding-mixed-case-usb-keystrokes-from.html
Extracting packets using filter `((usb.transfer_type == 0x01) && (frame.len == 72)) && !(usb.capdata == 00:00:00:00:00:00:00:00)` on wireshark. File->Export File Dissections -> CSV. Save as pcap.csv.

`cat pcap.csv | cut -d "," -f 8 | cut -d "\"" -f 2 | grep -vE "Leftover Capture Data" > hexoutput.txt`

Run `python3 decode.py hexoutput.txt`

Get `viim[space]flaag.ttxt[Enter]iTthe[space]flaag[space]is[space]ctf[esc]vbUuA{[my_favoritte_editor_is_vim}[esc]hhhhhhhhhhhhhhhhhhhau[esc]vi{U[esc]:;wq[Enter][tab]`

Run it through vim to get a garbled mess with the flag in
