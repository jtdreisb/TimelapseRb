#! /usr/bin/env ruby

# Hi my name is Jason Dreisbach. I wrote this. Have fun!
# If you want to email me your cool timelapses at jtdreisb@gmail.com

puts "Please enter the following parameters"

print "Name: "
@name = STDIN.readline.chomp 
print "Soundtrack(compressed): "
@music = STDIN.readline.chomp
print "fps(cam): "
@rate = STDIN.readline.chomp
print "fps(video): "
@fps = STDIN.readline.chomp
print "Time(hh:mm:ss): "
@time = STDIN.readline.chomp
print "Wait: "
@wait = STDIN.readline.chomp


# make a picture directory
system("rm -rf pics")
system("mkdir pics")

#Use the streamer command to generate a series of jpg images in the current dir 
#Examples:
#  capture a single frame:
#    streamer -o foobar.ppm

#  capture ten frames, two per second:
#    streamer -t 10 -r 2 -o foobar00.jpeg

#  record 30 seconds stereo sound:
#    streamer -t 0:30 -O soundtrack.wav -F stereo

#  record a quicktime movie with sound:
#    streamer -t 0:30 -o movie.mov -f jpeg -F mono16

#  build mpeg movies using mjpegtools + compressed avi file:
#    streamer -t 0:30 -s 352x240 -r 24 -o movie.avi -f mjpeg -F stereo
#    lav2wav +p movie.avi | mp2enc -o audio.mp2
#    lav2yuv +p movie.avi | mpeg2enc -o video.m1v
#    mplex audio.mp2 video.m1v -o movie.mpg

#  build mpeg movies using mjpegtools + raw, uncompressed video:
#    streamer -t 0:30 -s 352x240 -r 24 -o video.yuv -O audio.wav -F stereo
#    mp2enc -o audio.mp2 < audio.wav
#    mpeg2enc -o video.m1v < video.yuv
#    mplex audio.mp2 video.m1v -o movie.mpg

# Streamer automatically increments the 0's so you might need to add more depending on how fast/long you timelapse is
@streamerCMD = "streamer -t " +@time + "-r " + @rate +" -w "+ @wait +" -o  pics/"+ @name + "00000.jpeg"
system(@streamerCMD)
sleep(2)

# When that is done Mencoder will turn it into an avi movie

#mencoder mf://*.jpeg  w=800:h=600:fps=25:type=jpg
#mencoder mf://*.jpeg on:fps=25:type=jpeg -ovc lavc -lavcopts vcodec=mjpeg -o BearValley.avi

@mencoderCMD = "mencoder mf://pics/*.jpeg on:fps="+@fps+ ":type=jpeg -ovc lavc -lavcopts vcodec=mjpeg -o ns_" +@name+".avi"
system(@mencoderCMD)
sleep(2)
# Now we have a video but it has no sound...    yet
#mencoder source.avi -o destination.avi -ovc copy -oac mp3lame -audiofile file.wav (for uncompressed files)
#mencoder source.avi -o destination.avi -ovc copy -oac copy -audiofile file.mp3 (for compressed files) 

@soundCMD ="mencoder ns_"+ @name +".avi -o "+ @name +".avi -ovc copy -oac copy -audiofile "+@music
system(@soundCMD)



