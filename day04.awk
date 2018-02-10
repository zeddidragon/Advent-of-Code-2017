{
  n += step
  cmd="echo -n " seed n " | md5sum"
  cmd | getline
  close(cmd)
  print $1
}
/^00000/ {
  printf "Part 1: %i (%s)\n", n, $1
  exit
}
