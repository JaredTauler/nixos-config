xrandr --current | awk '
/^Screen/ { next }
/ connected/ {
    output = $1
    config[output]["mode"] = "default"
    config[output]["position"] = ""
    if ($3 == "primary") {
        config[output]["primary"] = "--primary"
    }
    if (match($0, /[0-9]+x[0-9]+\+[0-9]+\+[0-9]+/)) {
        config[output]["mode"] = substr($0, RSTART, RLENGTH)
    }
    if (match($0, /right-of|left-of|above|below|same-as/)) {
        config[output]["position"] = substr($0, RSTART, RLENGTH)
    }
}
END {
    for (output in config) {
        print "xrandr --output " output, \
              config[output]["primary"], \
              "--mode " config[output]["mode"], \
              (config[output]["position"] ? "--" config[output]["position"] " " : "") \
    }
}'
