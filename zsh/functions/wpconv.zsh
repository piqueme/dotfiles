# small utility for converting all webp images - usually I don't have a viewer
wpconv() {
  folder=$1
  [ ! -d "$folder" ] && echo "Directory for webp conversion does not exist."
  for f in "$folder"/**/*.webp; do
    ffmpeg -i $f ${f%.webp}-w.jpg
    rm $f
    [ ! -f  ${f%.webp}.jpg ] && mv ${f%.webp}-w.jpg ${f%.webp}.jpg
  done
}
