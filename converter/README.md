# Converting 101

## 1. Turn the video into a sequence of .png files

### Warning! This will spam the folder you are in right now
`ffmpeg -i input.mp4 frame%05d.png`

## 2. Put converted files into the `pics` folder
not there? create it.

## 3. Convert
Create `pics_lua` folder for the output

`npm i` to install dependencies

`node .\convert-8bit.js`
or
`node .\convert-1bit.js`

I used node 20 but i think node 16 is fine