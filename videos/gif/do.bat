ffmpeg -i ../initial_random.mp4 -y -vf scale=384:240,setsar=1:1 -t 4 temp.mp4
ffmpeg -i temp.mp4 -y -filter:v "crop=204:200:90:20" initial_random.gif

ffmpeg -i ../cheat_3.mp4 -y -vf scale=384:240,setsar=1:1 -ss 24 -t 4 temp.mp4
ffmpeg -i temp.mp4 -y -filter:v "crop=204:200:90:20" cheat_3.gif
