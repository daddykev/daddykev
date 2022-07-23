#
# A simple bash script to make a 15 second video flyer for sharing on social media.
#
# Notes:
#   - ffmpeg and ImageMagick required
#

# convert artist JPEGs to fixed size

convert artist1.jpg -resize 1080x1920! artist1-up.jpg
convert artist2.jpg -resize 1080x1920! artist2-up.jpg
convert artist3.jpg -resize 1080x1920! artist3-up.jpg

# create 2- and 4-second clips of the flyer image

ffmpeg -loop 1 -t 2 -i flyer.jpg  -r 30 -pix_fmt yuv420p -vcodec libx264 flyer-2s.mp4
ffmpeg -loop 1 -t 4 -i flyer.jpg  -r 30 -pix_fmt yuv420p -vcodec libx264 flyer-4s.mp4

# create 4-second zoompan videos of the artist images

ffmpeg -i artist1.jpg -filter_complex "zoompan=z='zoom+0.001':d=4*30:s=1080x1920" -r 30 -t 4 -pix_fmt yuv420p -c:v libx264 artist1.mp4
ffmpeg -i artist2.jpg -filter_complex "zoompan=z='zoom+0.001':d=4*30:s=1080x1920" -r 30 -t 4 -pix_fmt yuv420p -c:v libx264 artist2.mp4
ffmpeg -i artist3.jpg -filter_complex "zoompan=z='zoom+0.001':d=4*30:s=1080x1920" -r 30 -t 4 -pix_fmt yuv420p -c:v libx264 artist3.mp4

# create 15-second video

ffmpeg \
-i flyer-2s.mp4 \
-i artist1.mp4 \
-i artist2.mp4 \
-i artist3.mp4 \
-i flyer-4s.mp4 \
-filter_complex \
"[0][1]xfade=transition=vertopen:duration=0.5:offset=1.5[f0]; \
[f0][2]xfade=transition=smoothleft:duration=0.5:offset=5[f1]; \
[f1][3]xfade=transition=smoothright:duration=0.5:offset=8.5[f2]; \
[f2][4]xfade=transition=hblur:duration=0.5:offset=11[f3]" \
-map "[f3]" -r 30 -pix_fmt yuv420p -vcodec libx264 output-swipe-custom.mp4

rm flyer-2s.mp4
rm flyer-4s.mp4
rm artist1.mp4
rm artist2.mp4
rm artist3.mp4
