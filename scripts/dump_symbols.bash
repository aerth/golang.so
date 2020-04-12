file=${1:-golang.so}
nm --dynamic --defined-only --extern-only -A -l $file |\
  grep /tmp/go-build |\
  grep -v Cfunc | grep -v C2func |\
  awk '{print $3}'
